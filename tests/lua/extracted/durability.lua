-- Extracted from modules/inventory/server.lua
-- CalculateDurabilityAfterStack and canStackDurability

local M = {}

function M.CalculateDurabilityAfterStack(fromData, toData)
    local durFrom = fromData.metadata.durability
    local durTo = toData.metadata.durability

    if durFrom <= 100 and durTo <= 100 then
        if durFrom < 0 then durFrom = 0 end
        if durTo < 0 then durTo = 0 end
        return ((durFrom * fromData.count) + (durTo * toData.count)) / (fromData.count + toData.count)
    else
        -- Degrade-based durability (timestamp values > 100)
        durFrom = ((durFrom - os.time()) / (fromData.metadata.degrade * 60)) * 100
        durTo = ((durTo - os.time()) / (toData.metadata.degrade * 60)) * 100
        if durFrom < 0 then durFrom = 0 end
        if durTo < 0 then durTo = 0 end

        local durability = ((durFrom * fromData.count) + (durTo * toData.count)) / (fromData.count + toData.count)
        return math.floor(os.time() + (durability * (fromData.metadata.degrade * 60)) / 100 + 0.5)
    end
end

function M.canStackDurability(fromData, toData)
    if not fromData.metadata.durability or not toData.metadata.durability then return false end

    local metaFrom = lib.table.deepclone(fromData.metadata)
    metaFrom.durability = nil
    local metaTo = lib.table.deepclone(toData.metadata)
    metaTo.durability = nil

    if table.matches(metaFrom, metaTo) then
        return true, M.CalculateDurabilityAfterStack(fromData, toData)
    end

    return false
end

return M
