-- IngredientHunter
-- ESO Alchemy Recipe Browser & Ingredient Tracker
---------------------------------------------------------

local ADDON_NAME = "IngredientHunter"
IngredientHunter = {}
local IH = IngredientHunter

local BAGS_TO_SCAN = { BAG_BACKPACK, BAG_BANK, BAG_SUBSCRIBER_BANK, BAG_VIRTUAL }

-- Saved variables defaults
local SV_DEFAULTS = {
    posX = nil,
    posY = nil,
    trackerPosX = nil,
    trackerPosY = nil,
    trackerVisible = false,
    trackerRecipeIndex = nil,
    trackerComboIndex = 1,
    selectedSolventType = "potion",
    selectedSolventIndex = nil,
    lastRecipeIndex = nil,
}

-- State
IH.sv = nil
IH.inventoryCache = {}
IH.recipeRows = {}
IH.ingredientRows = {}
IH.selectedRecipe = nil
IH.selectedCombo = 1
IH.reagentLookup = {}   -- name -> reagent data
IH.filteredRecipes = {}  -- indices into Data.recipes that match current filter
IH.trackerRows = {}      -- tracker widget ingredient rows
IH.trackerRecipe = nil   -- tracked recipe index
IH.trackerCombo = 1      -- tracked combo index
IH.controlId = 0         -- unique control name counter
IH.recipeListBuilt = false

---------------------------------------------------------
-- Utility
---------------------------------------------------------

local function HexColor(hex)
    local r = tonumber(hex:sub(1,2), 16) / 255
    local g = tonumber(hex:sub(3,4), 16) / 255
    local b = tonumber(hex:sub(5,6), 16) / 255
    return r, g, b, 1
end

local function UniqueName(prefix)
    IH.controlId = IH.controlId + 1
    return prefix .. IH.controlId
end

---------------------------------------------------------
-- Inventory Scanning
---------------------------------------------------------

function IH:ScanInventory()
    self.inventoryCache = {}
    for _, bagId in ipairs(BAGS_TO_SCAN) do
        local slots = GetBagSize(bagId)
        for slot = 0, slots - 1 do
            local itemId = GetItemId(bagId, slot)
            if itemId and itemId > 0 then
                local stack, maxStack = GetSlotStackSize(bagId, slot)
                if not self.inventoryCache[itemId] then
                    self.inventoryCache[itemId] = { backpack = 0, bank = 0, craftBag = 0, total = 0 }
                end
                local entry = self.inventoryCache[itemId]
                if bagId == BAG_BACKPACK then
                    entry.backpack = entry.backpack + stack
                elseif bagId == BAG_VIRTUAL then
                    entry.craftBag = entry.craftBag + stack
                else
                    entry.bank = entry.bank + stack
                end
                entry.total = entry.total + stack
            end
        end
    end
end

function IH:GetItemCount(itemId)
    if self.inventoryCache[itemId] then
        return self.inventoryCache[itemId]
    end
    return { backpack = 0, bank = 0, craftBag = 0, total = 0 }
end

function IH:UpdateSingleSlot(bagId, slotIndex)
    -- Re-scan full inventory for simplicity; slot-level updates are tricky with stacks
    self:ScanInventory()
    if self.selectedRecipe then
        self:RefreshIngredientPanel()
    end
    -- Also refresh tracker widget if visible
    if self.trackerRecipe and not IngredientHunterTracker:IsHidden() then
        self:RefreshTracker()
    end
end

---------------------------------------------------------
-- Reagent Lookup
---------------------------------------------------------

function IH:BuildReagentLookup()
    self.reagentLookup = {}
    for _, reagent in ipairs(IngredientHunter_Data.reagents) do
        self.reagentLookup[reagent.name] = reagent
    end
end

---------------------------------------------------------
-- Solvent Helpers
---------------------------------------------------------

function IH:GetSolventsForType(solventType)
    local result = {}
    for _, s in ipairs(IngredientHunter_Data.solvents) do
        if s.type == solventType then
            table.insert(result, s)
        end
    end
    return result
end

function IH:GetHighestSolvent(solventType)
    local solvents = self:GetSolventsForType(solventType)
    if #solvents > 0 then
        return solvents[#solvents]  -- last one is highest tier
    end
    return nil
end

---------------------------------------------------------
-- UI: Recipe List (Left Panel)
---------------------------------------------------------

function IH:BuildRecipeList()
    local data = IngredientHunter_Data.recipes
    local scrollChild = IngredientHunterWindowLeftPanelScrollScrollChild
    if not scrollChild then return end

    -- Clear old rows
    for _, row in ipairs(self.recipeRows) do
        row:SetHidden(true)
        row:SetParent(GuiRoot)
    end
    self.recipeRows = {}

    for i, recipe in ipairs(data) do
        local row = CreateControlFromVirtual(UniqueName("IH_RR_"), scrollChild, "IngredientHunter_RecipeRow")
        local nameLabel = row:GetNamedChild("Name")
        nameLabel:SetText(recipe.name)

        -- Type indicator color
        if recipe.solventType == "poison" then
            nameLabel:SetColor(HexColor("CC6666"))
        else
            nameLabel:SetColor(HexColor("DDDDDD"))
        end

        row:SetAnchor(TOPLEFT, scrollChild, TOPLEFT, 0, (i - 1) * 28)

        row:SetHandler("OnMouseEnter", function(control)
            local hl = control:GetNamedChild("Highlight")
            if hl then hl:SetHidden(false) end
        end)

        row:SetHandler("OnMouseExit", function(control)
            local hl = control:GetNamedChild("Highlight")
            if hl then hl:SetHidden(true) end
        end)

        local recipeIndex = i
        row:SetHandler("OnMouseUp", function(control, mouseButton, upInside)
            if upInside and mouseButton == MOUSE_BUTTON_INDEX_LEFT then
                IH:SelectRecipe(recipeIndex)
            end
        end)

        self.recipeRows[i] = row
    end

    -- Resize scroll child
    scrollChild:SetHeight(#data * 28)
    self.filteredRecipes = {}
    for i = 1, #data do
        table.insert(self.filteredRecipes, i)
    end
    self.recipeListBuilt = true
end

function IH:FilterRecipes(searchText)
    searchText = searchText:lower()
    local data = IngredientHunter_Data.recipes
    local scrollChild = IngredientHunterWindowLeftPanelScrollScrollChild
    self.filteredRecipes = {}
    local visibleCount = 0

    for i, recipe in ipairs(data) do
        local row = self.recipeRows[i]
        if row then
            local match = searchText == "" or recipe.name:lower():find(searchText, 1, true)
            row:SetHidden(not match)
            if match then
                row:ClearAnchors()
                row:SetAnchor(TOPLEFT, scrollChild, TOPLEFT, 0, visibleCount * 28)
                visibleCount = visibleCount + 1
                table.insert(self.filteredRecipes, i)
            end
        end
    end

    scrollChild:SetHeight(visibleCount * 28)
end

---------------------------------------------------------
-- UI: Ingredient Panel (Right Panel)
---------------------------------------------------------

function IH:ClearIngredientRows()
    for _, row in ipairs(self.ingredientRows) do
        row:SetHidden(true)
        row:SetParent(GuiRoot)
    end
    self.ingredientRows = {}
end

function IH:SelectRecipe(index)
    local recipe = IngredientHunter_Data.recipes[index]
    if not recipe then return end

    self.selectedRecipe = index
    self.selectedCombo = 1
    self.sv.lastRecipeIndex = index

    -- Highlight selected row
    for i, row in ipairs(self.recipeRows) do
        local hl = row:GetNamedChild("Highlight")
        if hl then
            if i == index then
                hl:SetHidden(false)
                hl:SetCenterColor(HexColor("C89B3C40"))
            else
                hl:SetHidden(true)
                hl:SetCenterColor(HexColor("C89B3C20"))
            end
        end
    end

    self:RefreshIngredientPanel()
end

function IH:RefreshIngredientPanel()
    local recipe = IngredientHunter_Data.recipes[self.selectedRecipe]
    if not recipe then return end

    -- Recipe name
    local nameLabel = IngredientHunterWindowRightPanelRecipeName
    nameLabel:SetText(recipe.name)

    -- Effects
    local effectsLabel = IngredientHunterWindowRightPanelEffects
    effectsLabel:SetText("Effects: " .. table.concat(recipe.effects, ", "))

    -- Solvent
    local solventLabel = IngredientHunterWindowRightPanelSolvent
    local solvent = self:GetHighestSolvent(recipe.solventType)
    if solvent then
        local counts = self:GetItemCount(solvent.itemId)
        local colorTag = counts.total > 0 and "|c4ADE80" or "|cFF4444"
        solventLabel:SetText(string.format("Solvent: %s  %s(%d)|r", solvent.name, colorTag, counts.total))
    else
        solventLabel:SetText("Solvent: ?")
    end

    -- Combo label
    local comboLabel = IngredientHunterWindowRightPanelComboLabel
    local numCombos = #recipe.reagentSets
    if numCombos > 1 then
        comboLabel:SetText(string.format("Combination %d / %d  (click arrows or ingredients to browse)", self.selectedCombo, numCombos))
    else
        comboLabel:SetText("")
    end

    -- Clear old ingredient rows
    self:ClearIngredientRows()

    -- Show all unique reagents for the selected combo
    local combo = recipe.reagentSets[self.selectedCombo]
    if not combo then return end

    local scrollChild = IngredientHunterWindowRightPanelIngredientScrollScrollChild
    local yOffset = 0

    -- Combo navigation buttons (if multiple combos)
    if numCombos > 1 then
        self:CreateComboNav(scrollChild, yOffset, numCombos)
        yOffset = yOffset + 32
    end

    -- Reagent rows for current combo
    for i, reagentName in ipairs(combo) do
        local reagent = self.reagentLookup[reagentName]
        if reagent then
            local row = self:CreateIngredientRow(scrollChild, i, reagent, yOffset)
            yOffset = yOffset + 36
        end
    end

    -- Show all valid combos summary below
    yOffset = yOffset + 10
    if numCombos > 1 then
        local allCombosLabel = CreateControl(UniqueName("IH_AC_"), scrollChild, CT_LABEL)
        allCombosLabel:SetFont("ZoFontGameSmall")
        allCombosLabel:SetColor(HexColor("666666"))
        allCombosLabel:SetText("--- All valid combinations ---")
        allCombosLabel:SetAnchor(TOPLEFT, scrollChild, TOPLEFT, 4, yOffset)
        allCombosLabel:SetDimensions(360, 18)
        table.insert(self.ingredientRows, allCombosLabel)
        yOffset = yOffset + 22

        for ci, c in ipairs(recipe.reagentSets) do
            local prefix = (ci == self.selectedCombo) and "|cC89B3C> " or "  "
            local suffix = (ci == self.selectedCombo) and "|r" or ""
            local comboText = prefix .. table.concat(c, " + ") .. suffix

            local label = CreateControl(UniqueName("IH_CL_"), scrollChild, CT_LABEL)
            label:SetFont("ZoFontGameSmall")
            label:SetColor(HexColor("AAAAAA"))
            label:SetText(comboText)
            label:SetAnchor(TOPLEFT, scrollChild, TOPLEFT, 4, yOffset)
            label:SetDimensions(360, 18)
            label:SetMouseEnabled(true)

            local comboIndex = ci
            label:SetHandler("OnMouseUp", function(control, mouseButton, upInside)
                if upInside and mouseButton == MOUSE_BUTTON_INDEX_LEFT then
                    IH.selectedCombo = comboIndex
                    IH:RefreshIngredientPanel()
                end
            end)
            label:SetHandler("OnMouseEnter", function(control)
                control:SetColor(HexColor("FFFFFF"))
            end)
            label:SetHandler("OnMouseExit", function(control)
                control:SetColor(HexColor("AAAAAA"))
            end)

            table.insert(self.ingredientRows, label)
            yOffset = yOffset + 20
        end
    end

    scrollChild:SetHeight(yOffset + 20)
end

function IH:CreateComboNav(scrollChild, yOffset, numCombos)
    -- Previous button
    local prevBtn = CreateControl(UniqueName("IH_PB_"), scrollChild, CT_LABEL)
    prevBtn:SetFont("ZoFontGameBold")
    prevBtn:SetColor(HexColor("C89B3C"))
    prevBtn:SetText("<< Prev")
    prevBtn:SetAnchor(TOPLEFT, scrollChild, TOPLEFT, 4, yOffset)
    prevBtn:SetDimensions(80, 28)
    prevBtn:SetMouseEnabled(true)
    prevBtn:SetHandler("OnMouseUp", function(_, mouseButton, upInside)
        if upInside and mouseButton == MOUSE_BUTTON_INDEX_LEFT then
            IH.selectedCombo = IH.selectedCombo - 1
            if IH.selectedCombo < 1 then IH.selectedCombo = numCombos end
            IH:RefreshIngredientPanel()
        end
    end)
    prevBtn:SetHandler("OnMouseEnter", function(c) c:SetColor(HexColor("FFFFFF")) end)
    prevBtn:SetHandler("OnMouseExit", function(c) c:SetColor(HexColor("C89B3C")) end)
    table.insert(self.ingredientRows, prevBtn)

    -- Next button
    local nextBtn = CreateControl(UniqueName("IH_NB_"), scrollChild, CT_LABEL)
    nextBtn:SetFont("ZoFontGameBold")
    nextBtn:SetColor(HexColor("C89B3C"))
    nextBtn:SetText("Next >>")
    nextBtn:SetAnchor(TOPLEFT, scrollChild, TOPLEFT, 100, yOffset)
    nextBtn:SetDimensions(80, 28)
    nextBtn:SetMouseEnabled(true)
    nextBtn:SetHandler("OnMouseUp", function(_, mouseButton, upInside)
        if upInside and mouseButton == MOUSE_BUTTON_INDEX_LEFT then
            IH.selectedCombo = IH.selectedCombo + 1
            if IH.selectedCombo > numCombos then IH.selectedCombo = 1 end
            IH:RefreshIngredientPanel()
        end
    end)
    nextBtn:SetHandler("OnMouseEnter", function(c) c:SetColor(HexColor("FFFFFF")) end)
    nextBtn:SetHandler("OnMouseExit", function(c) c:SetColor(HexColor("C89B3C")) end)
    table.insert(self.ingredientRows, nextBtn)
end

function IH:CreateIngredientRow(scrollChild, index, reagent, yOffset)
    local row = CreateControlFromVirtual(UniqueName("IH_IR_"), scrollChild, "IngredientHunter_IngredientRow")
    row:ClearAnchors()
    row:SetAnchor(TOPLEFT, scrollChild, TOPLEFT, 0, yOffset)

    -- Icon
    local icon = row:GetNamedChild("Icon")
    if reagent.icon and reagent.icon ~= "" then
        icon:SetTexture(reagent.icon)
    end

    -- Name
    local nameLabel = row:GetNamedChild("Name")
    nameLabel:SetText(reagent.name)

    -- Count
    local countLabel = row:GetNamedChild("Count")
    local counts = self:GetItemCount(reagent.itemId)

    local countText
    if counts.craftBag > 0 then
        countText = string.format("%d bag | %d bank | %d craft", counts.backpack, counts.bank, counts.craftBag)
    else
        countText = string.format("%d bag | %d bank", counts.backpack, counts.bank)
    end

    countLabel:SetText(string.format("%s (|c%s%d|r)", countText,
        counts.total > 0 and "4ADE80" or "FF4444",
        counts.total))

    -- Color the name based on availability
    if counts.total > 0 then
        nameLabel:SetColor(HexColor("DDDDDD"))
    else
        nameLabel:SetColor(HexColor("FF6666"))
    end

    table.insert(self.ingredientRows, row)
    return row
end

---------------------------------------------------------
-- Window Management
---------------------------------------------------------

function IH.ToggleWindow()
    local window = IngredientHunterWindow
    if window then
        window:SetHidden(not window:IsHidden())
        if not window:IsHidden() then
            IH:ScanInventory()
            if not IH.recipeListBuilt then
                IH:BuildRecipeList()
            end
            if IH.selectedRecipe then
                IH:RefreshIngredientPanel()
            end
        end
    end
end

function IH.OnWindowMoveStop()
    local window = IngredientHunterWindow
    if window and IH.sv then
        local _, _, _, _, offsetX, offsetY = window:GetAnchor(0)
        IH.sv.posX = offsetX
        IH.sv.posY = offsetY
    end
end

function IH:RestorePosition()
    local window = IngredientHunterWindow
    if window and self.sv and self.sv.posX and self.sv.posY then
        window:ClearAnchors()
        window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, self.sv.posX, self.sv.posY)
    end
end

---------------------------------------------------------
-- Search
---------------------------------------------------------

function IH.OnSearchTextChanged()
    local searchBox = IngredientHunterWindowSearchBox
    if searchBox then
        local text = searchBox:GetText() or ""
        IH:FilterRecipes(text)
    end
end

---------------------------------------------------------
-- Tracker Widget
---------------------------------------------------------

function IH.TrackSelectedRecipe()
    if not IH.selectedRecipe then
        d("|cC89B3C[Ingredient Hunter]|r Select a recipe first!")
        return
    end
    IH.trackerRecipe = IH.selectedRecipe
    IH.trackerCombo = IH.selectedCombo
    IH.sv.trackerRecipeIndex = IH.trackerRecipe
    IH.sv.trackerComboIndex = IH.trackerCombo
    IH.sv.trackerVisible = true
    IH:RefreshTracker()
    IngredientHunterTracker:SetHidden(false)
end

function IH.HideTracker()
    IngredientHunterTracker:SetHidden(true)
    IH.sv.trackerVisible = false
end

function IH.OnTrackerMoveStop()
    local tracker = IngredientHunterTracker
    if tracker and IH.sv then
        local _, _, _, _, offsetX, offsetY = tracker:GetAnchor(0)
        IH.sv.trackerPosX = offsetX
        IH.sv.trackerPosY = offsetY
    end
end

function IH:RestoreTrackerPosition()
    local tracker = IngredientHunterTracker
    if tracker and self.sv and self.sv.trackerPosX and self.sv.trackerPosY then
        tracker:ClearAnchors()
        tracker:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, self.sv.trackerPosX, self.sv.trackerPosY)
    end
end

function IH:ClearTrackerRows()
    for _, row in ipairs(self.trackerRows) do
        row:SetHidden(true)
        row:SetParent(GuiRoot)
    end
    self.trackerRows = {}
end

function IH:RefreshTracker()
    if not self.trackerRecipe then return end
    local recipe = IngredientHunter_Data.recipes[self.trackerRecipe]
    if not recipe then return end

    local tracker = IngredientHunterTracker

    -- Title
    local title = tracker:GetNamedChild("Title")
    title:SetText(recipe.name)

    -- Solvent
    local solventLabel = tracker:GetNamedChild("Solvent")
    local solvent = self:GetHighestSolvent(recipe.solventType)
    if solvent then
        local counts = self:GetItemCount(solvent.itemId)
        local colorTag = counts.total > 0 and "|c4ADE80" or "|cFF4444"
        solventLabel:SetText(string.format("%s: %s%d|r", solvent.name, colorTag, counts.total))
    end

    -- Clear old rows
    self:ClearTrackerRows()

    -- Get combo
    local combo = recipe.reagentSets[self.trackerCombo]
    if not combo then
        combo = recipe.reagentSets[1]
        self.trackerCombo = 1
    end

    local listControl = tracker:GetNamedChild("List")
    local yOffset = 0

    for i, reagentName in ipairs(combo) do
        local reagent = self.reagentLookup[reagentName]
        if reagent then
            local row = CreateControl(UniqueName("IH_TR_"), listControl, CT_CONTROL)
            row:SetDimensions(250, 24)
            row:SetAnchor(TOPLEFT, listControl, TOPLEFT, 0, yOffset)

            -- Icon
            local icon = CreateControl(UniqueName("IH_TI_"), row, CT_TEXTURE)
            icon:SetDimensions(20, 20)
            icon:SetAnchor(LEFT, row, LEFT, 2, 0)
            if reagent.icon and reagent.icon ~= "" then
                icon:SetTexture(reagent.icon)
            end

            -- Name
            local nameLabel = CreateControl(UniqueName("IH_TN_"), row, CT_LABEL)
            nameLabel:SetFont("ZoFontGameSmall")
            nameLabel:SetDimensions(130, 20)
            nameLabel:SetAnchor(LEFT, icon, RIGHT, 4, 0)

            -- Count
            local countLabel = CreateControl(UniqueName("IH_TC_"), row, CT_LABEL)
            countLabel:SetFont("ZoFontGameSmall")
            countLabel:SetDimensions(80, 20)
            countLabel:SetAnchor(RIGHT, row, RIGHT, -2, 0)
            countLabel:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

            local counts = self:GetItemCount(reagent.itemId)
            nameLabel:SetText(reagent.name)

            if counts.total > 0 then
                nameLabel:SetColor(HexColor("DDDDDD"))
                countLabel:SetColor(HexColor("4ADE80"))
                countLabel:SetText(tostring(counts.total))
            else
                nameLabel:SetColor(HexColor("FF6666"))
                countLabel:SetColor(HexColor("FF4444"))
                countLabel:SetText("0")
            end

            table.insert(self.trackerRows, row)
            yOffset = yOffset + 24
        end
    end

    -- Resize tracker height to fit content
    local totalHeight = 42 + yOffset + 8  -- title area + rows + padding
    tracker:SetHeight(totalHeight)
end

---------------------------------------------------------
-- Initialization
---------------------------------------------------------

function IH:Initialize()
    -- Saved variables
    self.sv = ZO_SavedVars:NewAccountWide("IngredientHunterSV", 1, nil, SV_DEFAULTS)

    -- Build lookups
    self:BuildReagentLookup()

    -- Restore position
    self:RestorePosition()

    -- Scan inventory
    self:ScanInventory()

    -- Build recipe list
    self:BuildRecipeList()

    -- Restore last selected recipe
    if self.sv.lastRecipeIndex then
        self:SelectRecipe(self.sv.lastRecipeIndex)
    end

    -- Restore tracker
    self:RestoreTrackerPosition()
    if self.sv.trackerRecipeIndex then
        self.trackerRecipe = self.sv.trackerRecipeIndex
        self.trackerCombo = self.sv.trackerComboIndex or 1
        self:RefreshTracker()
        if self.sv.trackerVisible then
            IngredientHunterTracker:SetHidden(false)
        end
    end

    -- Register events
    EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, function(_, bagId, slotIndex)
        IH:UpdateSingleSlot(bagId, slotIndex)
    end)

    -- Register slash command
    SLASH_COMMANDS["/ih"] = function()
        IH.ToggleWindow()
    end
    SLASH_COMMANDS["/ingredienthunter"] = function()
        IH.ToggleWindow()
    end

    -- Register keybinding (optional, via bindings.xml)

    d("|cC89B3C[Ingredient Hunter]|r Loaded. Use |c4ADE80/ih|r to toggle window.")
end

-- Addon loaded event
EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, function(_, addonName)
    if addonName ~= ADDON_NAME then return end
    EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
    IH:Initialize()
end)
