-- Tests for items shared/server functions
local testDir = debug.getinfo(1, 'S').source:match('@?(.*[/\\])')
local ItemsFuncs = dofile(testDir .. 'extracted/items_shared.lua')

describe('setImagePath', function()
    it('should return full URL as-is', function()
        local result = ItemsFuncs.setImagePath('https://example.com/item.png')
        expect(result).toBe('https://example.com/item.png')
    end)

    it('should return http URL as-is', function()
        local result = ItemsFuncs.setImagePath('http://example.com/item.png')
        expect(result).toBe('http://example.com/item.png')
    end)

    it('should prefix relative path with imagepath', function()
        local result = ItemsFuncs.setImagePath('item.png')
        expect(result).toBe('https://cdn.example.com/images/item.png')
    end)

    it('should return nil for nil input', function()
        local result = ItemsFuncs.setImagePath(nil)
        expect(result).toBeNil()
    end)
end)

describe('setItemDurability', function()
    it('should set durability to 100 when item has durability field', function()
        local item = { durability = true }
        local metadata = {}
        local result = ItemsFuncs.setItemDurability(item, metadata)
        expect(result.durability).toBe(100)
    end)

    it('should set timestamp durability and degrade for degrade items', function()
        local item = { degrade = 10 }
        local metadata = {}
        local before = os.time()
        local result = ItemsFuncs.setItemDurability(item, metadata)
        local after = os.time()

        -- durability should be a future timestamp: os.time() + 600
        expect(result.durability >= before + 600).toBeTruthy()
        expect(result.durability <= after + 600).toBeTruthy()
        expect(result.degrade).toBe(10)
    end)

    it('should not set durability when neither field exists', function()
        local item = { name = 'water' }
        local metadata = {}
        local result = ItemsFuncs.setItemDurability(item, metadata)
        expect(result.durability).toBeNil()
    end)

    it('should prefer degrade over durability when both present', function()
        local item = { degrade = 5, durability = true }
        local metadata = {}
        local result = ItemsFuncs.setItemDurability(item, metadata)
        -- degrade branch runs first, so durability is a timestamp
        expect(result.durability > 100).toBeTruthy()
        expect(result.degrade).toBe(5)
    end)
end)
