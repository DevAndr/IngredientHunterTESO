# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

IngredientHunter is an Elder Scrolls Online (ESO) addon written in Lua. It provides an in-game alchemy recipe browser and ingredient inventory tracker. Players can browse potion/poison recipes, see which reagents they have across bags/bank/craft bag, and pin a recipe to an always-on-screen tracker widget.

## Architecture

- **`IngredientHunter.txt`** — ESO addon manifest. Defines load order: `Data/Recipes.lua` → `IngredientHunter.xml` → `IngredientHunter.lua`. API version 101044.
- **`Data/Recipes.lua`** — Static data: solvents (by type/tier), reagents (with itemIds, icons, traits), and pre-defined recipe definitions with valid reagent combinations. Populates global `IngredientHunter_Data`.
- **`IngredientHunter.xml`** — UI layout in ESO's GuiXml format. Defines virtual templates (`IngredientHunter_RecipeRow`, `IngredientHunter_IngredientRow`), the main two-panel window (`IngredientHunterWindow`), and the tracker overlay (`IngredientHunterTracker`).
- **`IngredientHunter.lua`** — All addon logic. Single global `IngredientHunter` (aliased `IH`). Handles initialization, inventory scanning, UI construction, recipe filtering, combo navigation, tracker widget, saved variables, and event registration.

## Key Patterns

- UI controls are created programmatically via `CreateControlFromVirtual` and `CreateControl`, not declaratively. XML only defines templates and top-level containers.
- Inventory is scanned across `BAG_BACKPACK`, `BAG_BANK`, `BAG_SUBSCRIBER_BANK`, `BAG_VIRTUAL` into `inventoryCache[itemId]`.
- Saved variables use `ZO_SavedVars:NewAccountWide` with key `IngredientHunterSV`.
- Slash commands: `/ih` and `/ingredienthunter` toggle the main window.
- Recipes have multiple `reagentSets` (valid reagent combinations); the UI supports browsing between them.

## Development

There is no build step — ESO loads Lua/XML files directly. To test, place the addon folder in the ESO `AddOns` directory (`Documents/Elder Scrolls Online/live/AddOns/IngredientHunter`) and reload the UI in-game with `/reloadui`.

The load order in the manifest matters: data must load before XML templates, and XML before the main Lua file that references those controls.
