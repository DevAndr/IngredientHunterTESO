IngredientHunter_Data = {}

-- Solvents by level tier
IngredientHunter_Data.solvents = {
    -- Potions
    { name = "Natural Water",           itemId = 30157,  level = "3-9",      type = "potion" },
    { name = "Clear Water",             itemId = 30158,  level = "10-19",    type = "potion" },
    { name = "Pristine Water",          itemId = 30159,  level = "20-29",    type = "potion" },
    { name = "Cleansed Water",          itemId = 30160,  level = "30-39",    type = "potion" },
    { name = "Filtered Water",          itemId = 30161,  level = "40-49",    type = "potion" },
    { name = "Purified Water",          itemId = 30162,  level = "VR1-4",    type = "potion" },
    { name = "Cloud Mist",              itemId = 30163,  level = "VR5-9",    type = "potion" },
    { name = "Star Dew",               itemId = 30164,  level = "VR10-15",  type = "potion" },
    { name = "Lorkhan's Tears",         itemId = 64501,  level = "CP150+",   type = "potion" },
    -- Poisons
    { name = "Grease",                  itemId = 75357,  level = "3-9",      type = "poison" },
    { name = "Ichor",                   itemId = 75358,  level = "10-19",    type = "poison" },
    { name = "Slime",                   itemId = 75359,  level = "20-29",    type = "poison" },
    { name = "Gall",                    itemId = 75360,  level = "30-39",    type = "poison" },
    { name = "Terebinthine",            itemId = 75361,  level = "40-49",    type = "poison" },
    { name = "Pitch-Bile",              itemId = 75362,  level = "VR1-4",    type = "poison" },
    { name = "Tarblack",                itemId = 75363,  level = "VR5-9",    type = "poison" },
    { name = "Night Oil",               itemId = 75364,  level = "VR10-15",  type = "poison" },
    { name = "Alkahest",                itemId = 75365,  level = "CP150+",   type = "poison" },
}

-- All reagents with their 4 traits
IngredientHunter_Data.reagents = {
    { name = "Blessed Thistle",     itemId = 30156, icon = "/esoui/art/icons/crafting_alchemy_blessed_thistle.dds",     traits = { "Restore Stamina", "Ravage Health", "Speed", "Ravage Stamina" } },
    { name = "Blue Entoloma",       itemId = 30148, icon = "/esoui/art/icons/crafting_alchemy_blue_entoloma.dds",       traits = { "Ravage Magicka", "Restore Health", "Invisible", "Ravage Health" } },
    { name = "Bugloss",             itemId = 30149, icon = "/esoui/art/icons/crafting_alchemy_bugloss.dds",             traits = { "Restore Health", "Lower Spell Resist", "Restore Magicka", "Unstoppable" } },
    { name = "Columbine",           itemId = 30164, icon = "/esoui/art/icons/crafting_alchemy_columbine.dds",           traits = { "Restore Health", "Restore Magicka", "Restore Stamina", "Unstoppable" } },
    { name = "Corn Flower",         itemId = 30152, icon = "/esoui/art/icons/crafting_alchemy_corn_flower.dds",         traits = { "Restore Magicka", "Ravage Health", "Spell Damage", "Detection" } },
    { name = "Dragonthorn",         itemId = 30153, icon = "/esoui/art/icons/crafting_alchemy_dragonthorn.dds",         traits = { "Weapon Damage", "Restore Stamina", "Weapon Crit", "Lower Weapon Resist" } },
    { name = "Emetic Russula",      itemId = 30155, icon = "/esoui/art/icons/crafting_alchemy_emetic_russula.dds",      traits = { "Ravage Health", "Ravage Magicka", "Ravage Stamina", "Stun" } },
    { name = "Imp Stool",           itemId = 30154, icon = "/esoui/art/icons/crafting_alchemy_imp_stool.dds",           traits = { "Lower Weapon Resist", "Ravage Stamina", "Ravage Health", "Lower Spell Resist" } },
    { name = "Lady's Smock",        itemId = 30157, icon = "/esoui/art/icons/crafting_alchemy_ladys_smock.dds",         traits = { "Restore Magicka", "Spell Damage", "Spell Crit", "Lower Spell Resist" } },
    { name = "Luminous Russula",    itemId = 30162, icon = "/esoui/art/icons/crafting_alchemy_luminous_russula.dds",    traits = { "Ravage Stamina", "Lower Weapon Resist", "Restore Health", "Ravage Health" } },
    { name = "Mountain Flower",     itemId = 30163, icon = "/esoui/art/icons/crafting_alchemy_mountain_flower.dds",     traits = { "Restore Health", "Lower Weapon Resist", "Restore Stamina", "Weapon Damage" } },
    { name = "Namira's Rot",        itemId = 30165, icon = "/esoui/art/icons/crafting_alchemy_namiras_rot.dds",         traits = { "Spell Crit", "Speed", "Invisible", "Unstoppable" } },
    { name = "Nirnroot",            itemId = 30166, icon = "/esoui/art/icons/crafting_alchemy_nirnroot.dds",            traits = { "Ravage Health", "Lower Spell Resist", "Speed", "Invisible" } },
    { name = "Stinkhorn",           itemId = 30167, icon = "/esoui/art/icons/crafting_alchemy_stinkhorn.dds",           traits = { "Ravage Health", "Restore Stamina", "Lower Weapon Resist", "Ravage Stamina" } },
    { name = "Violet Coprinus",     itemId = 30168, icon = "/esoui/art/icons/crafting_alchemy_violet_coprinus.dds",     traits = { "Lower Spell Resist", "Restore Health", "Ravage Magicka", "Ravage Stamina" } },
    { name = "Water Hyacinth",      itemId = 30169, icon = "/esoui/art/icons/crafting_alchemy_water_hyacinth.dds",      traits = { "Restore Health", "Weapon Crit", "Spell Crit", "Restore Magicka" } },
    { name = "White Cap",           itemId = 30170, icon = "/esoui/art/icons/crafting_alchemy_white_cap.dds",           traits = { "Lower Spell Resist", "Ravage Magicka", "Restore Stamina", "Detection" } },
    { name = "Wormwood",            itemId = 30171, icon = "/esoui/art/icons/crafting_alchemy_wormwood.dds",            traits = { "Weapon Damage", "Reduce Speed", "Ravage Stamina", "Detection" } },
    { name = "Lorkhan's Tears",     itemId = 64501, icon = "/esoui/art/icons/crafting_alchemy_lorkhans_tears.dds",      traits = {} }, -- solvent, not reagent
    { name = "Clam Gall",           itemId = 139020, icon = "/esoui/art/icons/crafting_alchemy_clam_gall.dds",          traits = { "Unstoppable", "Restore Health", "Spell Damage", "Lower Spell Resist" } },
    { name = "Mudcrab Chitin",      itemId = 139019, icon = "/esoui/art/icons/crafting_alchemy_mudcrab_chitin.dds",     traits = { "Lower Weapon Resist", "Restore Stamina", "Weapon Damage", "Stun" } },
    { name = "Spider Egg",          itemId = 139021, icon = "/esoui/art/icons/crafting_alchemy_spider_egg.dds",         traits = { "Invisible", "Reduce Speed", "Stun", "Restore Magicka" } },
    { name = "Scrib Jelly",         itemId = 139018, icon = "/esoui/art/icons/crafting_alchemy_scrib_jelly.dds",        traits = { "Ravage Magicka", "Speed", "Restore Stamina", "Weapon Crit" } },
}

-- Pre-defined popular recipes with valid reagent combinations
IngredientHunter_Data.recipes = {
    -- =====================
    -- POTIONS
    -- =====================
    {
        name = "Restore Health",
        effects = { "Restore Health" },
        solventType = "potion",
        reagentSets = {
            { "Blue Entoloma", "Bugloss" },
            { "Blue Entoloma", "Columbine" },
            { "Blue Entoloma", "Mountain Flower" },
            { "Blue Entoloma", "Water Hyacinth" },
            { "Bugloss", "Columbine" },
            { "Bugloss", "Mountain Flower" },
            { "Bugloss", "Water Hyacinth" },
            { "Columbine", "Mountain Flower" },
            { "Columbine", "Water Hyacinth" },
            { "Mountain Flower", "Water Hyacinth" },
        },
    },
    {
        name = "Restore Magicka",
        effects = { "Restore Magicka" },
        solventType = "potion",
        reagentSets = {
            { "Bugloss", "Columbine" },
            { "Bugloss", "Lady's Smock" },
            { "Bugloss", "Water Hyacinth" },
            { "Columbine", "Corn Flower" },
            { "Columbine", "Lady's Smock" },
            { "Corn Flower", "Lady's Smock" },
            { "Corn Flower", "Water Hyacinth" },
            { "Lady's Smock", "Water Hyacinth" },
        },
    },
    {
        name = "Restore Stamina",
        effects = { "Restore Stamina" },
        solventType = "potion",
        reagentSets = {
            { "Blessed Thistle", "Columbine" },
            { "Blessed Thistle", "Dragonthorn" },
            { "Blessed Thistle", "Mountain Flower" },
            { "Columbine", "Dragonthorn" },
            { "Columbine", "Mountain Flower" },
            { "Dragonthorn", "Mountain Flower" },
        },
    },
    {
        name = "Essence of Health (Tri-Stat)",
        effects = { "Restore Health", "Restore Magicka", "Restore Stamina" },
        solventType = "potion",
        reagentSets = {
            { "Bugloss", "Columbine", "Mountain Flower" },
            { "Bugloss", "Columbine", "Dragonthorn" },
        },
    },
    {
        name = "Spell Power Potion",
        effects = { "Spell Damage", "Spell Crit", "Restore Magicka" },
        solventType = "potion",
        reagentSets = {
            { "Lady's Smock", "Water Hyacinth", "Corn Flower" },
        },
    },
    {
        name = "Weapon Power Potion",
        effects = { "Weapon Damage", "Weapon Crit", "Restore Stamina" },
        solventType = "potion",
        reagentSets = {
            { "Blessed Thistle", "Dragonthorn", "Wormwood" },
        },
    },
    {
        name = "Essence of Spell Power",
        effects = { "Spell Damage", "Spell Crit" },
        solventType = "potion",
        reagentSets = {
            { "Lady's Smock", "Water Hyacinth" },
            { "Lady's Smock", "Namira's Rot" },
        },
    },
    {
        name = "Essence of Weapon Power",
        effects = { "Weapon Damage", "Weapon Crit" },
        solventType = "potion",
        reagentSets = {
            { "Dragonthorn", "Wormwood" },
        },
    },
    {
        name = "Invisibility Potion",
        effects = { "Invisible", "Speed" },
        solventType = "potion",
        reagentSets = {
            { "Blessed Thistle", "Namira's Rot" },
            { "Nirnroot", "Namira's Rot" },
            { "Blue Entoloma", "Namira's Rot" },
        },
    },
    {
        name = "Immovability Potion",
        effects = { "Unstoppable", "Restore Health" },
        solventType = "potion",
        reagentSets = {
            { "Bugloss", "Columbine" },
            { "Bugloss", "Namira's Rot" },
            { "Columbine", "Namira's Rot" },
            { "Clam Gall", "Columbine" },
            { "Clam Gall", "Bugloss" },
        },
    },
    {
        name = "Detection Potion",
        effects = { "Detection" },
        solventType = "potion",
        reagentSets = {
            { "Corn Flower", "Wormwood" },
            { "Corn Flower", "White Cap" },
            { "Wormwood", "White Cap" },
        },
    },
    {
        name = "Speed Potion",
        effects = { "Speed", "Restore Stamina" },
        solventType = "potion",
        reagentSets = {
            { "Blessed Thistle", "Namira's Rot" },
            { "Blessed Thistle", "Scrib Jelly" },
        },
    },
    -- =====================
    -- POISONS
    -- =====================
    {
        name = "Ravage Health Poison",
        effects = { "Ravage Health" },
        solventType = "poison",
        reagentSets = {
            { "Blue Entoloma", "Emetic Russula" },
            { "Blue Entoloma", "Imp Stool" },
            { "Blue Entoloma", "Nirnroot" },
            { "Blue Entoloma", "Stinkhorn" },
            { "Blessed Thistle", "Emetic Russula" },
            { "Corn Flower", "Emetic Russula" },
            { "Emetic Russula", "Imp Stool" },
            { "Emetic Russula", "Nirnroot" },
            { "Emetic Russula", "Stinkhorn" },
            { "Imp Stool", "Nirnroot" },
            { "Imp Stool", "Stinkhorn" },
            { "Luminous Russula", "Nirnroot" },
            { "Luminous Russula", "Stinkhorn" },
            { "Nirnroot", "Stinkhorn" },
        },
    },
    {
        name = "Ravage Magicka Poison",
        effects = { "Ravage Magicka" },
        solventType = "poison",
        reagentSets = {
            { "Blue Entoloma", "Emetic Russula" },
            { "Blue Entoloma", "White Cap" },
            { "Blue Entoloma", "Violet Coprinus" },
            { "Emetic Russula", "White Cap" },
            { "Emetic Russula", "Violet Coprinus" },
            { "Scrib Jelly", "White Cap" },
            { "Scrib Jelly", "Violet Coprinus" },
            { "White Cap", "Violet Coprinus" },
        },
    },
    {
        name = "Ravage Stamina Poison",
        effects = { "Ravage Stamina" },
        solventType = "poison",
        reagentSets = {
            { "Emetic Russula", "Luminous Russula" },
            { "Emetic Russula", "Stinkhorn" },
            { "Emetic Russula", "Violet Coprinus" },
            { "Imp Stool", "Luminous Russula" },
            { "Luminous Russula", "Violet Coprinus" },
            { "Blessed Thistle", "Emetic Russula" },
        },
    },
    {
        name = "Drain Health Poison",
        effects = { "Ravage Health", "Restore Health" },
        solventType = "poison",
        reagentSets = {
            { "Blue Entoloma", "Luminous Russula" },
            { "Blue Entoloma", "Violet Coprinus" },
        },
    },
    {
        name = "Vulnerability Poison (Lower Spell Resist)",
        effects = { "Lower Spell Resist", "Ravage Health" },
        solventType = "poison",
        reagentSets = {
            { "Imp Stool", "Nirnroot" },
            { "Imp Stool", "Violet Coprinus" },
            { "Violet Coprinus", "Nirnroot" },
        },
    },
    {
        name = "Vulnerability Poison (Lower Weapon Resist)",
        effects = { "Lower Weapon Resist", "Ravage Health" },
        solventType = "poison",
        reagentSets = {
            { "Imp Stool", "Stinkhorn" },
            { "Imp Stool", "Luminous Russula" },
            { "Luminous Russula", "Stinkhorn" },
        },
    },
    {
        name = "Stun Poison",
        effects = { "Stun", "Ravage Health" },
        solventType = "poison",
        reagentSets = {
            { "Emetic Russula", "Mudcrab Chitin" },
            { "Emetic Russula", "Spider Egg" },
        },
    },
}
