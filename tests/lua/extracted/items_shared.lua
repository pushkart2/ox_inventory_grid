-- Extracted from modules/items/shared.lua and modules/items/server.lua
-- setImagePath and setItemDurability

local M = {}

function M.setImagePath(path)
    if path then
        return path:match('^[%w]+://') and path or ('%s/%s'):format(client.imagepath, path)
    end
end

function M.setItemDurability(item, metadata)
    local degrade = item.degrade

    if degrade then
        metadata.durability = os.time() + (degrade * 60)
        metadata.degrade = degrade
    elseif item.durability then
        metadata.durability = 100
    end

    return metadata
end

return M
