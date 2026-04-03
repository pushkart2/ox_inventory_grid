if not lib then return end

local Inventory = require 'modules.inventory.server'
local Items = require 'modules.items.server'
local clothingConfig = require 'modules.clothing.shared'

local clothing_items_config = clothingConfig.clothing_items
local registered_clothing_stashes = {}
local players_configuring = {}
local players_renaming = {}
local players_change_face = {}
local players_change_tattoo = {}

-----------------------------------------------------------------------------------------------
-- Utility functions
-----------------------------------------------------------------------------------------------

local function findByKey(t, k, s)
    for i = 1, #t do
        local o = t[i]
        if o[k] == s then return o end
    end
    return nil
end

local function getPlayerCid(src)
    local player = exports.qbx_core:GetPlayer(src)
    if not player then return false end

    return player.PlayerData.citizenid
end

-----------------------------------------------------------------------------------------------
-- DB migrations
-----------------------------------------------------------------------------------------------

MySQL.query([[
    CREATE TABLE IF NOT EXISTS `player_face_features` (
        `player_id` VARCHAR(50) NOT NULL PRIMARY KEY,
        `face_data` LONGTEXT NOT NULL CHECK (JSON_VALID(`face_data`))
    );
]], {}, function()
    lib.print.info('Initializing Table: player_face_features')
end)

MySQL.query([[
    CREATE TABLE IF NOT EXISTS `player_tattoo_features` (
        `player_id` VARCHAR(50) NOT NULL PRIMARY KEY,
        `tattoo_data` LONGTEXT NOT NULL CHECK (JSON_VALID(`tattoo_data`))
    );
]], {}, function()
    lib.print.info('Initializing Table: player_tattoo_features')
end)

MySQL.ready(function()
    local hasColumn = MySQL.query.await([[
        SHOW COLUMNS FROM players LIKE 'appearance_data';
    ]])
    if hasColumn and #hasColumn > 0 then
        return
    end

    MySQL.prepare.await([[
        ALTER TABLE
            players
        ADD
            COLUMN appearance_data TEXT NOT NULL DEFAULT "[]";
    ]])
end)

-----------------------------------------------------------------------------------------------
-- DB helper functions
-----------------------------------------------------------------------------------------------

local INSERT_PLAYER_FACE_FEATURES = [[
    INSERT INTO `player_face_features` (player_id, face_data)
    VALUES (?, ?) RETURNING player_id
]]
local function createPlayerFaceFeatures(cid, json_string)
    local id = MySQL.insert.await(INSERT_PLAYER_FACE_FEATURES, {
        cid,
        json_string
    })
    return id or false
end

local UPDATE_PLAYER_FACE_FEATURES = [[
    UPDATE `player_face_features`
    SET face_data = ?
    WHERE player_id = ?
]]
local function updatePlayerFaceFeatures(cid, json_string)
    local results = MySQL.query.await(UPDATE_PLAYER_FACE_FEATURES, { json_string, cid })
    return results?.changedRows > 0 or false
end

local FIND_PLAYER_FACE_FEATURES_BY_PLAYER_ID = [[
    SELECT * FROM `player_face_features` WHERE player_id = ? LIMIT 1
]]
local function findPlayerFaceFeaturesByPlayerId(cid)
    local results = MySQL.query.await(FIND_PLAYER_FACE_FEATURES_BY_PLAYER_ID, { cid })
    return results[1] or false
end

local INSERT_PLAYER_TATTOO_FEATURES = [[
    INSERT INTO `player_tattoo_features` (player_id, tattoo_data)
    VALUES (?, ?) RETURNING player_id
]]
local function createPlayerTattooFeatures(cid, json_string)
    local id = MySQL.insert.await(INSERT_PLAYER_TATTOO_FEATURES, {
        cid,
        json_string
    })
    return id or false
end

local UPDATE_PLAYER_TATTOO_FEATURES = [[
    UPDATE `player_tattoo_features`
    SET tattoo_data = ?
    WHERE player_id = ?
]]
local function updatePlayerTattooFeatures(cid, json_string)
    local results = MySQL.query.await(UPDATE_PLAYER_TATTOO_FEATURES, { json_string, cid })
    return results?.changedRows > 0 or false
end

local FIND_PLAYER_TATTOO_FEATURES_BY_PLAYER_ID = [[
    SELECT * FROM `player_tattoo_features` WHERE player_id = ? LIMIT 1
]]
local function findPlayerTatooFeaturesByPlayerId(cid)
    local results = MySQL.query.await(FIND_PLAYER_TATTOO_FEATURES_BY_PLAYER_ID, { cid })
    return results[1] or false
end

-----------------------------------------------------------------------------------------------
-- Stash configuration
-----------------------------------------------------------------------------------------------

local stash_config_template = {
    id = "ply_%s_clothing_stash",
    label = "Clothing",
    slots = 14,
    weight = 10000,
    owner = "%s"
}

local function registerClothingStash(src, checkExisting)
    local cid = getPlayerCid(src)
    if not cid then return false end

    local stash_id = string.format(stash_config_template.id, cid)
    if checkExisting and registered_clothing_stashes[src] then
        return stash_id
    end

    exports.ox_inventory:RegisterStash(
        stash_id,
        stash_config_template.label,
        stash_config_template.slots,
        stash_config_template.weight,
        string.format(stash_config_template.owner, cid)
    )

    -- Set grid dimensions on the stash inventory object
    local stash_inv = Inventory({ id = stash_id, owner = cid })
    if stash_inv then
        stash_inv.gridWidth = 2
        stash_inv.gridHeight = 7
    end

    return stash_id
end

-----------------------------------------------------------------------------------------------
-- Player clothes helpers
-----------------------------------------------------------------------------------------------

local function getPlayerClothes(src)
    local cid = getPlayerCid(src)
    if not cid then
        lib.print.error("no player cid")
        return false
    end

    local playerEntity = GetPlayerPed(src)
    if not playerEntity or not DoesEntityExist(playerEntity) then
        lib.print.error("no player entity, failed to set appearance")
        return false
    end

    local gender = GetEntityModel(playerEntity) == `mp_f_freemode_01` and "female" or "male"
    local stash_id = string.format(stash_config_template.id, cid)
    local clothes = {}
    for _, config in pairs(clothing_items_config) do
        local slot_data = Inventory.GetSlot({
            id = stash_id, owner = cid
        }, config.allowed_slot)
        clothes[#clothes + 1] = {
            slot = config.allowed_slot,
            type = config.component,
            texture = slot_data?.metadata?.texture or config.defaults[gender].texture,
            drawable = slot_data?.metadata?.drawable or config.defaults[gender].drawable,
        }
    end

    return clothes
end
exports("getPlayerClothes", getPlayerClothes)

local function getPlayerClothesByType(src, type)
    local cid = getPlayerCid(src)
    if not cid then
        lib.print.error("no player cid")
        return false
    end

    local playerEntity = GetPlayerPed(src)
    if not playerEntity or not DoesEntityExist(playerEntity) then
        lib.print.error("no player entity, failed to set appearance")
        return false
    end

    local gender = GetEntityModel(playerEntity) == `mp_f_freemode_01` and "female" or "male"
    local stash_id = string.format(stash_config_template.id, cid)
    local clothes = {}
    for _, config in pairs(clothing_items_config) do
        local slot_data = Inventory.GetSlot({
            id = stash_id, owner = cid
        }, config.allowed_slot)
        if config.component == type then
            clothes = {
                slot = config.allowed_slot,
                type = config.component,
                texture = slot_data?.metadata?.texture or config.defaults[gender].texture,
                drawable = slot_data?.metadata?.drawable or config.defaults[gender].drawable,
            }
            break
        end
    end

    return clothes
end
exports("getPlayerClothesByType", getPlayerClothesByType)

-----------------------------------------------------------------------------------------------
-- Equip clothing item helper
-----------------------------------------------------------------------------------------------

local function equiptClothingItem(src, item_name, metadata, from_slot, to_slot)
    local cid = getPlayerCid(src)
    if not cid then
        lib.print.error("no player cid")
        return false
    end

    local stash_id = string.format("ply_%s_clothing_stash", cid)
    local stash_obj = { id = stash_id, owner = cid }

    local slot_data = Inventory.GetSlot(stash_obj, to_slot)
    if slot_data?.metadata then
        lib.notify(src, {
            title = "Clothing",
            description = "You are already wearing something else...",
            type = "error"
        })
        return false
    end

    if not Inventory.RemoveItem(src, item_name, 1, metadata, from_slot) then
        lib.print.error("could not remove clothing item from player, not automatically moving to clothing stash")
        return false
    end

    if not Inventory.AddItem(
            stash_obj
            , item_name, 1, metadata, to_slot) then
        lib.print.error("could not add clothing to clothing stash item from player, ply source: ", src)
        return false
    end
    return true
end

-----------------------------------------------------------------------------------------------
-- Set item metadata for clothing (from illenium-appearance)
-----------------------------------------------------------------------------------------------

local function setItemMetaForClothing(src,
                                      item_name,
                                      components,
                                      key,
                                      component_id,
                                      take_slot,
                                      send_slot)
    local data = findByKey(components, key, component_id)
    if not data then
        lib.print.error("no data from illenium-appearance", components)
        players_configuring[src] = nil
        return false, false
    end

    local metadata = {
        drawable = data.drawable,
        texture = data.texture
    }
    Inventory.SetMetadata(src, take_slot, metadata)
    local equipt = equiptClothingItem(
        src,
        item_name,
        metadata,
        take_slot,
        send_slot
    )
    return true, equipt
end

-----------------------------------------------------------------------------------------------
-- Item use handlers
-----------------------------------------------------------------------------------------------

local function wearClothing(event, item, inventory, slot, data)
    local item_name = item.name
    local clothing_item_config = clothing_items_config[item_name]
    if not clothing_item_config then return false end

    local ply_source = inventory.player.source
    local cid = getPlayerCid(ply_source)
    if not cid then return false end

    local from_slot_data = Inventory.GetSlot(ply_source, slot)
    if not from_slot_data then return false end

    local metadata = from_slot_data.metadata or {}
    if metadata?.drawable == nil and metadata?.texture == nil then
        players_configuring[ply_source] = {
            clothing_item_config = clothing_item_config,
            item_name = item_name,
            slot = slot
        }
        TriggerClientEvent("ox_inventory:clothing:start_configuring",
            ply_source,
            clothing_item_config.type,
            clothing_item_config.component,
            clothing_item_config.component_id,
            {}
        )
        return true
        -- player starts configuring
    end

    local to_slot = clothing_item_config.allowed_slot
    local equipt = equiptClothingItem(
        ply_source,
        item_name,
        metadata,
        slot,
        to_slot
    )
    if not equipt then return false end

    local components = {}
    local props = {}
    for _, config in pairs(clothing_items_config) do
        if config.allowed_slot == to_slot then
            if config.type == "component" then
                components[#components + 1] = {
                    component_id = config.component_id,
                    texture = metadata.texture,
                    drawable = metadata.drawable,
                }
            else
                props[#props + 1] = {
                    prop_id = config.prop_id,
                    texture = metadata.texture,
                    drawable = metadata.drawable,
                }
            end
        end
    end

    TriggerClientEvent("ox_inventory:clothing:set_appearance", ply_source, components, props)
    return true
end
exports('wearClothing', wearClothing)

-----------------------------------------------------------------------------------------------
-- Surgery kit
-----------------------------------------------------------------------------------------------

local function useSurgeryKit(event, item, inventory, slot, data)
    local ply_source = inventory.player.source
    local cid = getPlayerCid(ply_source)
    if not cid then return false end

    local from_slot_data = Inventory.GetSlot(ply_source, slot)
    if not from_slot_data then return false end

    players_change_face[ply_source] = {
        slot = slot,
        cid = cid
    }
    TriggerClientEvent("ox_inventory:clothing:start_surgery",
        ply_source
    )
    return false
end
exports('useSurgeryKit', useSurgeryKit)

-----------------------------------------------------------------------------------------------
-- Tattoo kit
-----------------------------------------------------------------------------------------------

local function useTattooKit(event, item, inventory, slot, data)
    local ply_source = inventory.player.source
    local cid = getPlayerCid(ply_source)
    if not cid then return false end

    local from_slot_data = Inventory.GetSlot(ply_source, slot)
    if not from_slot_data then return false end

    players_change_tattoo[ply_source] = {
        slot = slot,
        cid = cid
    }
    TriggerClientEvent("ox_inventory:clothing:start_tattooing",
        ply_source
    )
    return false
end
exports('useTattooKit', useTattooKit)

-----------------------------------------------------------------------------------------------
-- Register Item() callbacks for clothing items, surgery_kit, tattoo_kit
-----------------------------------------------------------------------------------------------

do
    local ItemList = Items()

    -- Register all clothing items
    for item_name, _ in pairs(clothing_items_config) do
        local itemDef = ItemList[item_name]
        if itemDef and not itemDef.cb then
            itemDef.cb = wearClothing
        end
    end

    -- Register surgery_kit
    local surgeryItem = ItemList['surgery_kit']
    if surgeryItem and not surgeryItem.cb then
        surgeryItem.cb = useSurgeryKit
    end

    -- Register tattoo_kit
    local tattooItem = ItemList['tattoo_kit']
    if tattooItem and not tattooItem.cb then
        tattooItem.cb = useTattooKit
    end
end

-----------------------------------------------------------------------------------------------
-- swapItems hook (clothing stash interactions)
-----------------------------------------------------------------------------------------------
-- CreateThread(function()
--     Wait(1000)
    exports.ox_inventory:registerHook('swapItems', function(payload)
        local action = payload.action
        local from_type = payload.fromType
        local to_type = payload.toType
        local item_name = payload.fromSlot.name
        local to_slot = payload.toSlot
        local from_slot = payload.fromSlot
        local from_inv = payload.fromInventory
        local to_inv = payload.toInventory
        local src = payload.source
        -- only want to allow players to move clothing, not swap
        if action ~= "move" then return false end

        -- cant swap from stash slot to stash slot
        if from_type == "stash" and to_type == "stash" then 
            return false
        end

        if from_type == "stash" and to_type == "player" then
            -- if fromType == stash then we want to try and remove this clothing piece
            local components = {}
            local props = {}
            local stash_id, cid = from_inv:match("([^:]+):([^:]+)")

            local playerEntity = GetPlayerPed(src)
            if not playerEntity or not DoesEntityExist(playerEntity) then
                lib.print.error("no player entity, failed to set appearance")
                return false
            end

            local gender = GetEntityModel(playerEntity) == `mp_f_freemode_01` and "female" or "male"
            for _, config in pairs(clothing_items_config) do
                local slot_data = Inventory.GetSlot({
                    id = stash_id, owner = cid
                }, config.allowed_slot)
                if config.type == "component" then
                    components[#components + 1] = {
                        component_id = config.component_id,
                        texture = slot_data?.name ~= item_name and slot_data?.metadata?.texture or
                            config.defaults[gender].texture,
                        drawable = slot_data?.name ~= item_name and slot_data?.metadata?.drawable or
                            config.defaults[gender].drawable,
                    }
                else
                    props[#props + 1] = {
                        prop_id = config.prop_id,
                        texture = slot_data?.name ~= item_name and slot_data?.metadata?.texture or
                            config.defaults[gender].texture,
                        drawable = slot_data?.name ~= item_name and slot_data?.metadata?.drawable or
                            config.defaults[gender].drawable,
                    }
                end
            end

            TriggerClientEvent("ox_inventory:clothing:set_appearance", src, components, props)
            return true
        end

        if from_type == "player" and to_type == "stash" then
            TriggerClientEvent("ox_lib:notify", src, {
                title = "Clothing",
                description = "You need to use the clothing item to move it to your stash",
                type = "error"
            })
            return false
        end
    end, {
        print = true,
        inventoryFilter = {
            '^ply_[%w]+_clothing_stash',
        }
    })
-- end)

-----------------------------------------------------------------------------------------------
-- Clothing tag hook
-----------------------------------------------------------------------------------------------

exports.ox_inventory:registerHook('swapItems', function(payload)
    local action = payload.action
    if action ~= "swap" then return true end

    local from_type = payload.fromType
    local to_type = payload.toType
    if from_type ~= "player" or to_type ~= "player" then return true end

    local from_slot = payload?.fromSlot
    local from_slot_item_name = from_slot?.name
    if from_slot_item_name ~= "clothing_tag" then return true end

    local src = payload.source
    local to_slot = payload?.toSlot
    if not src or not to_slot then return true end

    local to_slot_item_name = ""
    local has_correct_meta = false
    if type(to_slot) == "table" then
        to_slot_item_name = to_slot?.name
        has_correct_meta = to_slot?.metadata?.drawable and to_slot?.metadata?.texture and true or false
    else
        local to_slot_data = Inventory.GetSlot(src, to_slot)
        to_slot_item_name = to_slot_data?.name
        has_correct_meta = to_slot_data?.metadata?.drawable and to_slot_data?.metadata?.texture and true or false
    end
    if not to_slot_item_name or clothing_items_config[to_slot_item_name] == nil then return true end

    if not has_correct_meta then
        lib.notify(src, {
            title = "Clothing",
            description = "You need to use this clothing item first",
            type = "error"
        })
        return true
    end

    players_renaming[src] = {
        item_name = to_slot_item_name,
        to_slot_data = to_slot,
        from_slot_data = from_slot
    }
    TriggerClientEvent("ox_inventory:clothing:set_clothing_info", src)
    return false
end)

-----------------------------------------------------------------------------------------------
-- Clothing configuration callback (save from illenium-appearance)
-----------------------------------------------------------------------------------------------

lib.callback.register("ox_inventory:clothing:save_clothing_item", function(source, appearance)
    local src = source
    if not src or not players_configuring[src] then
        lib.print.warn(string.format("player %d tried to save clothing but was not configuring", src))
        return false, false
    end

    local cid = getPlayerCid(source)
    if not cid then
        lib.print.error("no player cid")
        players_configuring[src] = nil
        return false, false
    end

    local ply_config = players_configuring[src]
    if ply_config.clothing_item_config.type == "component" then
        local components = appearance.components
        local success, equipt = setItemMetaForClothing(
            src,
            ply_config.item_name,
            components,
            "component_id",
            ply_config.clothing_item_config.component_id,
            ply_config.slot,
            ply_config.clothing_item_config.allowed_slot
        )
        players_configuring[src] = nil
        return success, equipt
    else
        local props = appearance.props
        local success, equipt = setItemMetaForClothing(
            src,
            ply_config.item_name,
            props,
            "prop_id",
            ply_config.clothing_item_config.prop_id,
            ply_config.slot,
            ply_config.clothing_item_config.allowed_slot
        )
        players_configuring[src] = nil
        return success, equipt
    end
end)

RegisterNetEvent("ox_inventory:clothing:failed_configuring", function()
    local src = source
    if not src or not players_configuring[src] then
        lib.print.warn(string.format("player %d tried to fail clothing configuration but was not configuring", src))
        return
    end
    players_configuring[src] = nil
end)

-----------------------------------------------------------------------------------------------
-- Clothing tag update event
-----------------------------------------------------------------------------------------------

RegisterNetEvent("ox_inventory:clothing:update_clothing_info", function(name, description)
    local src = source
    if not src or not players_renaming[src] then
        lib.print.error(string.format("player %d tried to update clothing info without using a tag", src))
        return
    end

    local data = players_renaming[src]
    local og_item_def = Items(data.item_name)
    local metadata = {
        label = name == "" and og_item_def.label or name,
        description = description == "" and og_item_def.description or description
    }
    Inventory.SetMetadata(src, data.to_slot_data.slot,
        lib.table.merge(data.to_slot_data.metadata or {}, metadata))
    Inventory.RemoveItem(src, "clothing_tag", 1, nil, data.from_slot_data.slot)
    players_renaming[src] = nil
end)

-----------------------------------------------------------------------------------------------
-- Appearance callbacks
-----------------------------------------------------------------------------------------------

lib.callback.register("ox_inventory:clothing:get_appearance", function(source)
    local cid = getPlayerCid(source)
    if not cid then
        lib.print.error("no player cid")
        return false, false
    end

    local playerEntity = GetPlayerPed(source)
    if not playerEntity or not DoesEntityExist(playerEntity) then
        lib.print.error("no player entity, failed to get appearance")
        return false, false
    end

    local gender = GetEntityModel(playerEntity) == `mp_f_freemode_01` and "female" or "male"
    local stash_id = string.format(stash_config_template.id, cid)
    local components = {}
    local props = {}
    for _, config in pairs(clothing_items_config) do
        local slot_data = Inventory.GetSlot({
            id = stash_id, owner = cid
        }, config.allowed_slot)
        if config.type == "component" then
            components[#components + 1] = {
                component_id = config.component_id,
                texture = slot_data?.metadata?.texture or config.defaults[gender].texture,
                drawable = slot_data?.metadata?.drawable or config.defaults[gender].drawable,
            }
        else
            props[#props + 1] = {
                prop_id = config.prop_id,
                texture = slot_data?.metadata?.texture or config.defaults[gender].texture,
                drawable = slot_data?.metadata?.drawable or config.defaults[gender].drawable,
            }
        end
    end

    return components, props
end)

-----------------------------------------------------------------------------------------------
-- Face features callbacks
-----------------------------------------------------------------------------------------------

lib.callback.register("ox_inventory:clothing:get_face_features", function(source)
    local cid = getPlayerCid(source)
    if not cid then return {} end

    local existing_face_data = findPlayerFaceFeaturesByPlayerId(cid)
    if not existing_face_data then return {} end

    local json_object = json.decode(existing_face_data.face_data)
    return json_object or false
end)

lib.callback.register("ox_inventory:clothing:save_face_features", function(source, face_features)
    if not players_change_face[source] then
        lib.print.warn(string.format("player %d tried to save face features but was not configuring", source))
        return false, "No"
    end

    local player_change_data = players_change_face[source]
    local json_string = json.encode(face_features)

    local existing_face_data = findPlayerFaceFeaturesByPlayerId(player_change_data.cid)
    if existing_face_data then
        local updated = updatePlayerFaceFeatures(player_change_data.cid, json_string)
        if not updated then
            return false, "Surgery Failed"
        end

        Inventory.RemoveItem(source, "surgery_kit", 1, nil, player_change_data.slot)
        return true, "Surgery Completed"
    end

    createPlayerFaceFeatures(player_change_data.cid, json_string)
    Inventory.RemoveItem(source, "surgery_kit", 1, nil, player_change_data.slot)
    return true, "Surgery Completed"
end)

-----------------------------------------------------------------------------------------------
-- Tattoo features callbacks
-----------------------------------------------------------------------------------------------

lib.callback.register("ox_inventory:clothing:get_tattoo_features", function(source)
    local cid = getPlayerCid(source)
    if not cid then return {} end

    local existing_tattoo_data = findPlayerTatooFeaturesByPlayerId(cid)
    if not existing_tattoo_data then return {} end

    local json_object = json.decode(existing_tattoo_data.tattoo_data)
    return json_object or false
end)

lib.callback.register("ox_inventory:clothing:save_tattoo_features", function(source, tattoo_features)
    if not players_change_tattoo[source] then
        lib.print.warn(string.format("player %d tried to save tattoo features but was not configuring", source))
        return false, "No"
    end

    local player_change_data = players_change_tattoo[source]
    local json_string = json.encode(tattoo_features)

    local existing_tattoo_data = findPlayerTatooFeaturesByPlayerId(player_change_data.cid)
    if existing_tattoo_data then
        local updated = updatePlayerTattooFeatures(player_change_data.cid, json_string)
        if not updated then return false, "Tattooing Failed" end

        Inventory.RemoveItem(source, "tattoo_kit", 1, nil, player_change_data.slot)
        return true, "Tattooing Completed"
    end

    createPlayerTattooFeatures(player_change_data.cid, json_string)
    Inventory.RemoveItem(source, "tattoo_kit", 1, nil, player_change_data.slot)
    return true, "Tattooing Completed"
end)

-----------------------------------------------------------------------------------------------
-- Stash registration on player load/unload
-----------------------------------------------------------------------------------------------

lib.callback.register("ox_inventory:clothing:open_clothing_stash", function(source)
    local stash_id = registerClothingStash(source, true)
    if not stash_id then return false end
    registered_clothing_stashes[stash_id] = true

    exports.ox_inventory:forceOpenInventory(source, "stash", stash_id)
    return true
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    local stash_id = registerClothingStash(src, false)
    if not stash_id then return end

    registered_clothing_stashes[stash_id] = true
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(source)
    local cid = getPlayerCid(source)
    if not cid then return false end

    local stash_id = string.format(stash_config_template.id, cid)
    registered_clothing_stashes[stash_id] = false
end)

-----------------------------------------------------------------------------------------------
-- Spawn integration - appearance cache
-----------------------------------------------------------------------------------------------

local playerAppearanceCache = {}
local cachedTimesSinceStart = 0

local function getPlayerAppearance(id)
    local query = [[
        SELECT appearance_data FROM players
        WHERE citizenid = ?
    ]]

    return MySQL.scalar.await(query, {
        id
    }) or false
end

local function updatePlayerAppearance(id, appearance)
    local query = [[
        UPDATE players
        SET appearance_data = ?
        WHERE citizenid = ?
    ]]

    return MySQL.query.await(query, {
        appearance,
        id
    }) or false
end

lib.callback.register('ox_inventory:clothing:get_full_player_appearance', function(source, citizenId)
    local data = getPlayerAppearance(citizenId)
    return data and json.decode(data) or false
end)

CreateThread(function()
    while true do
        local cachedCount = 0
        for _, playerId in ipairs(GetPlayers()) do
            pcall(function()
                local src = tonumber(playerId)
                if not src then goto continue end

                local player = exports.qbx_core:GetPlayer(src)
                if not player then goto continue end

                local fullAppearance = lib.callback.await("ox_inventory:clothing:get_full_appearance", src)
                if not fullAppearance then goto continue end

                playerAppearanceCache[src] = {
                    citizenId = player.PlayerData.citizenid,
                    data = fullAppearance
                }
                cachedCount = cachedCount + 1

                ::continue::
            end)
        end

        if cachedCount > 0 and cachedTimesSinceStart % 3 == 0 then
            lib.print.info(("Cached %s players appearances"):format(cachedCount))
        end

        cachedTimesSinceStart = cachedTimesSinceStart + 1
        Wait(20000)
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    src = tonumber(src)

    local fullAppearance = playerAppearanceCache[src] or false
    if not fullAppearance then return end

    local citizenId = fullAppearance?.citizenId
    local appearanceData = fullAppearance?.data

    if not citizenId or not appearanceData then return end

    updatePlayerAppearance(citizenId, json.encode(appearanceData))
    playerAppearanceCache[src] = nil
end)

-----------------------------------------------------------------------------------------------
-- Clothing data for UI (callback for client to fetch clothing stash contents)
-----------------------------------------------------------------------------------------------

lib.callback.register('ox_inventory:clothing:getClothingForUI', function(source)
    local cid = getPlayerCid(source)
    if not cid then return nil end

    local stash_id = string.format(stash_config_template.id, cid)

    -- Ensure stash is registered
    registerClothingStash(source, true)

    local stash_inv = Inventory({ id = stash_id, owner = cid })
    if not stash_inv then return nil end

    -- Mark the clothing stash as open so the player can interact with it
    local playerInv = Inventory(source)
    if playerInv then
        if not playerInv.openList then playerInv.openList = {} end
        playerInv.openList[stash_inv.id] = true
        stash_inv.openedBy = stash_inv.openedBy or {}
        stash_inv.openedBy[source] = true
    end

    local clothingItems = {}
    for i = 1, stash_config_template.slots do
        local slot_data = stash_inv.items and stash_inv.items[i] or nil
        if slot_data then
            clothingItems[i] = slot_data
        end
    end

    return {
        id = stash_inv.id,
        label = stash_config_template.label,
        type = 'stash',
        slots = stash_config_template.slots,
        weight = stash_inv.weight or 0,
        maxWeight = stash_config_template.weight,
        items = clothingItems,
        gridWidth = 2,
        gridHeight = 7,
    }
end)
