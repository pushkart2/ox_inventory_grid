if not lib then return end

-------------------------------
-- Appearance utility functions
-------------------------------

local function setAppearance(components, props)
    exports['illenium-appearance']:setPedComponents(cache.ped, components)
    exports['illenium-appearance']:setPedProps(cache.ped, props)
end

local function setTattoos(tattoos)
    exports['illenium-appearance']:setPedTattoos(cache.ped, tattoos)
end

local function setFaceFeatures(appearance)
    exports['illenium-appearance']:setPedEyeColor(cache.ped, appearance["eyeColor"])
    exports['illenium-appearance']:setPedFaceFeatures(cache.ped, appearance["faceFeatures"])
    exports['illenium-appearance']:setPedHair(cache.ped, appearance["hair"])
    exports['illenium-appearance']:setPedHeadBlend(cache.ped, appearance["headBlend"])
    exports['illenium-appearance']:setPedHeadOverlays(cache.ped, appearance["headOverlays"])
end

-------------------------------
-- Reset clothing (re-fetch and re-apply all)
-------------------------------

local function resetClothing()
    local components, props = lib.callback.await("ox_inventory:clothing:get_appearance", false)
    if components and props then
        setAppearance(components, props)
    end

    local face_data = lib.callback.await("ox_inventory:clothing:get_face_features", false)
    if face_data and next(face_data) then
        setFaceFeatures(face_data)
    end

    local tattoo_data = lib.callback.await("ox_inventory:clothing:get_tattoo_features", false)
    if tattoo_data and next(tattoo_data) then
        setTattoos(tattoo_data["tattoos"])
    end
end

exports("resetClothing", resetClothing)

-------------------------------
-- Set / reset appearance net events
-------------------------------

RegisterNetEvent("ox_inventory:clothing:set_appearance", function(components, props)
    setAppearance(components, props)
end)

RegisterNetEvent("ox_inventory:clothing:reset_appearance", function(components, props)
    setAppearance(components, props)
end)

-------------------------------
-- Player loaded / resource start handlers
-------------------------------

local function onPlayerReady()
    Wait(2000)

    local components, props = lib.callback.await("ox_inventory:clothing:get_appearance", false)
    if components and props then
        setAppearance(components, props)
    end

    local face_data = lib.callback.await("ox_inventory:clothing:get_face_features", false)
    if face_data and next(face_data) then
        setFaceFeatures(face_data)
    end

    local tattoo_data = lib.callback.await("ox_inventory:clothing:get_tattoo_features", false)
    if tattoo_data and next(tattoo_data) then
        setTattoos(tattoo_data["tattoos"])
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    CreateThread(onPlayerReady)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    CreateThread(onPlayerReady)
end)

-- Handle clothing stash data from server openInventory hook
RegisterNetEvent('ox_inventory:setupClothing', function(data)
    if data and data.clothingInventory then
        SendNUIMessage({
            action = 'setupClothing',
            data = data
        })
    end
end)

-------------------------------
-- Clothing configuration flow
-------------------------------

RegisterNetEvent("ox_inventory:clothing:start_configuring", function(type, component, component_id, allow_list)
    local config = {}
    if type == "component" then
        config.components = true
        config.componentConfig = { [component] = true }
    else
        config.props = true
        config.propConfig = { [component] = true }
    end
    config.enableExit = true

    local components, props = lib.callback.await("ox_inventory:clothing:get_appearance", false)
    exports['illenium-appearance']:startPlayerCustomization(function(appearance)
        if appearance then
            local saved, equipt = lib.callback.await("ox_inventory:clothing:save_clothing_item", false, appearance)
            if saved and not equipt then
                setAppearance(components, props)
            end
        else
            TriggerServerEvent("ox_inventory:clothing:failed_configuring")
            setAppearance(components, props)
        end
    end, config)
end)

-------------------------------
-- Clothing tag flow
-------------------------------

RegisterNetEvent("ox_inventory:clothing:set_clothing_info", function()
    exports.ox_inventory:closeInventory()
    local input = lib.inputDialog('Name this piece of clothing', {
        { type = 'input', label = 'Clothing Name',        description = 'The custom clothing name to use',        required = true,  min = 4, max = 32 },
        { type = 'input', label = 'Clothing Description', description = 'The custom clothing description to use', required = false, min = 4, max = 64 },
    })
    if not input then
        TriggerServerEvent("ox_inventory:clothing:update_clothing_info", "", "")
        return
    end

    TriggerServerEvent("ox_inventory:clothing:update_clothing_info", input[1] or "", input[2] or "")
end)

-------------------------------
-- Surgery kit flow
-------------------------------

RegisterNetEvent("ox_inventory:clothing:start_surgery", function()
    local face_data = lib.callback.await("ox_inventory:clothing:get_face_features", false)

    local enabledAppearanceConfig = {
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        enableExit = true,
    }

    exports['illenium-appearance']:startPlayerCustomization(function(appearance)
        if appearance then
            local saved, message = lib.callback.await("ox_inventory:clothing:save_face_features", false, {
                eyeColor = appearance["eyeColor"],
                faceFeatures = appearance["faceFeatures"],
                hair = appearance["hair"],
                headBlend = appearance["headBlend"],
                headOverlays = appearance["headOverlays"],
            })
            lib.notify({
                title = "Surgery",
                description = message,
                type = saved and "success" or "error"
            })
            if saved then
                setFaceFeatures({
                    eyeColor = appearance["eyeColor"],
                    faceFeatures = appearance["faceFeatures"],
                    hair = appearance["hair"],
                    headBlend = appearance["headBlend"],
                    headOverlays = appearance["headOverlays"],
                })
            else
                if face_data then
                    setFaceFeatures(face_data)
                end
            end
        end
    end, enabledAppearanceConfig)
end)

-------------------------------
-- Tattoo kit flow
-------------------------------

RegisterNetEvent("ox_inventory:clothing:start_tattooing", function()
    local tattoo_data = lib.callback.await("ox_inventory:clothing:get_tattoo_features", false)

    local enabledAppearanceConfig = {
        tattoos = true,
        enableExit = true,
    }

    exports['illenium-appearance']:startPlayerCustomization(function(appearance)
        if appearance then
            local saved, message = lib.callback.await("ox_inventory:clothing:save_tattoo_features", false, {
                tattoos = appearance["tattoos"],
            })
            lib.notify({
                title = "Tattooing",
                description = message,
                type = saved and "success" or "error"
            })
            if saved then
                setTattoos(appearance["tattoos"])
            else
                if tattoo_data then
                    setTattoos(tattoo_data["tattoos"])
                end
            end
        end
    end, enabledAppearanceConfig)
end)

-------------------------------
-- Spawn integration callback
-------------------------------

lib.callback.register("ox_inventory:clothing:get_full_appearance", function()
    local appearance = exports['illenium-appearance']:getPedAppearance(cache.ped)
    return appearance or {}
end)
