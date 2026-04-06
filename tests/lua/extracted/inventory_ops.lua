-- Extracted from modules/inventory/server.lua
-- SlotWeight, SwapSlots, CanCarryWeight

local Items = MockItems

local Inventory = {}

function Inventory.SlotWeight(item, slot, ignoreCount)
    local weight = ignoreCount and item.weight or item.weight * (slot.count or 1)

    if not slot.metadata then slot.metadata = {} end

    if item.ammoname and slot.metadata.ammo then
        local ammoItem = Items(item.ammoname)
        local ammoWeight = ammoItem and ammoItem.weight or nil

        if ammoWeight then
            weight = weight + (ammoWeight * slot.metadata.ammo)
        end
    end

    -- WEAPON_PETROLCAN hash replaced with number
    if item.hash == 2694352099 then
        slot.metadata.weight = 15000 * (slot.metadata.ammo / 100)
    end

    if slot.metadata.components then
        for i = #slot.metadata.components, 1, -1 do
            local compItem = Items(slot.metadata.components[i])
            local componentWeight = compItem and compItem.weight or nil

            if componentWeight then
                weight = weight + componentWeight
            end
        end
    end

    if slot.metadata.weight then
        weight = weight + (ignoreCount and slot.metadata.weight or (slot.metadata.weight * (slot.count or 1)))
    end

    return weight
end

function Inventory.SwapSlots(fromInventory, toInventory, slot1, slot2)
    local fromSlot = fromInventory.items[slot1] and table.clone(fromInventory.items[slot1]) or nil
    local toSlot = toInventory.items[slot2] and table.clone(toInventory.items[slot2]) or nil

    if fromSlot then fromSlot.slot = slot2 end
    if toSlot then toSlot.slot = slot1 end

    if fromSlot and toSlot then
        local fgx, fgy, fgr = fromSlot.gridX, fromSlot.gridY, fromSlot.gridRotated
        fromSlot.gridX, fromSlot.gridY, fromSlot.gridRotated = toSlot.gridX, toSlot.gridY, toSlot.gridRotated
        toSlot.gridX, toSlot.gridY, toSlot.gridRotated = fgx, fgy, fgr
    end

    fromInventory.items[slot1], toInventory.items[slot2] = toSlot, fromSlot
    fromInventory.changed, toInventory.changed = true, true

    return fromSlot, toSlot
end

function Inventory.CanCarryWeight(inv, weight)
    if not inv then return end

    local availableWeight = inv.maxWeight - inv.weight
    local canHold = availableWeight >= weight
    return canHold, availableWeight
end

return Inventory
