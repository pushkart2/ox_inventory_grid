-- Tests for GridUtils
local testDir = debug.getinfo(1, 'S').source:match('@?(.*[/\\])')
local GridUtils = dofile(testDir .. 'extracted/gridutils.lua')

-- Helper: build an empty grid
local function emptyGrid(w, h)
    local grid = {}
    for y = 0, h - 1 do
        grid[y] = {}
        for x = 0, w - 1 do
            grid[y][x] = false
        end
    end
    return grid
end

-- CanPlace tests
describe('GridUtils.CanPlace', function()
    it('should fit a 1x1 item in empty grid', function()
        local grid = emptyGrid(5, 5)
        expect(GridUtils.CanPlace(grid, 5, 5, 0, 0, 1, 1)).toBe(true)
    end)

    it('should reject out of bounds placement', function()
        local grid = emptyGrid(5, 5)
        expect(GridUtils.CanPlace(grid, 5, 5, 4, 4, 2, 2)).toBe(false)
    end)

    it('should reject negative coordinates', function()
        local grid = emptyGrid(5, 5)
        expect(GridUtils.CanPlace(grid, 5, 5, -1, 0, 1, 1)).toBe(false)
    end)

    it('should reject occupied cell', function()
        local grid = emptyGrid(5, 5)
        grid[0][0] = 1 -- occupied by slot 1
        expect(GridUtils.CanPlace(grid, 5, 5, 0, 0, 1, 1)).toBe(false)
    end)

    it('should allow placement adjacent to occupied cell', function()
        local grid = emptyGrid(5, 5)
        grid[0][0] = 1
        expect(GridUtils.CanPlace(grid, 5, 5, 1, 0, 1, 1)).toBe(true)
    end)
end)

-- FindFirstFit tests
describe('GridUtils.FindFirstFit', function()
    it('should find position in empty grid', function()
        local grid = emptyGrid(5, 5)
        local x, y, rotated = GridUtils.FindFirstFit(grid, 5, 5, 1, 1)
        expect(x).toBe(0)
        expect(y).toBe(0)
        expect(rotated).toBe(false)
    end)

    it('should find position after occupied cells', function()
        local grid = emptyGrid(5, 5)
        grid[0][0] = 1
        grid[0][1] = 1
        local x, y, rotated = GridUtils.FindFirstFit(grid, 5, 5, 2, 1)
        expect(x).toBe(2)
        expect(y).toBe(0)
        expect(rotated).toBe(false)
    end)

    it('should wrap to next row', function()
        local grid = emptyGrid(3, 3)
        -- fill entire first row
        grid[0][0] = 1
        grid[0][1] = 1
        grid[0][2] = 1
        local x, y, rotated = GridUtils.FindFirstFit(grid, 3, 3, 2, 1)
        expect(x).toBe(0)
        expect(y).toBe(1)
        expect(rotated).toBe(false)
    end)

    it('should try rotation when normal does not fit', function()
        local grid = emptyGrid(3, 5)
        -- Block columns 0-1 in rows 0-3 so a 3w x 1h won't fit in rows 0-3
        for y = 0, 3 do
            grid[y][0] = 1
            grid[y][1] = 1
        end
        -- Only row 4 has space: 3 columns free, but only 1 row left
        -- A 1w x 3h item can't fit normally (needs 3 rows from row 4), but rotated (3w x 1h) can fit at row 4
        local x, y, rotated = GridUtils.FindFirstFit(grid, 3, 5, 1, 3)
        expect(x).toBe(0)
        expect(y).toBe(4)
        expect(rotated).toBe(true)
    end)

    it('should return nil when no space', function()
        local grid = emptyGrid(2, 2)
        grid[0][0] = 1
        grid[0][1] = 1
        grid[1][0] = 1
        grid[1][1] = 1
        local result = GridUtils.FindFirstFit(grid, 2, 2, 1, 1)
        expect(result).toBeNil()
    end)
end)

-- BuildOccupancy tests
describe('GridUtils.BuildOccupancy', function()
    it('should return empty grid for inventory with no items', function()
        local inv = { gridWidth = 3, gridHeight = 3, items = {} }
        local grid = GridUtils.BuildOccupancy(inv)
        expect(grid[0][0]).toBe(false)
        expect(grid[2][2]).toBe(false)
    end)

    it('should return empty grid for nil items', function()
        local inv = { gridWidth = 3, gridHeight = 3 }
        local grid = GridUtils.BuildOccupancy(inv)
        expect(grid[0][0]).toBe(false)
    end)

    it('should mark 1x1 item cell', function()
        MockItemDB['water'] = { width = 1, height = 1 }
        local inv = {
            gridWidth = 5, gridHeight = 5,
            items = { [1] = { name = 'water', gridX = 2, gridY = 1 } }
        }
        local grid = GridUtils.BuildOccupancy(inv)
        expect(grid[1][2]).toBe(1)
        expect(grid[0][0]).toBe(false)
        MockItemDB['water'] = nil
    end)

    it('should mark multi-cell item', function()
        MockItemDB['rifle'] = { width = 3, height = 2 }
        local inv = {
            gridWidth = 5, gridHeight = 5,
            items = { [1] = { name = 'rifle', gridX = 0, gridY = 0 } }
        }
        local grid = GridUtils.BuildOccupancy(inv)
        expect(grid[0][0]).toBe(1)
        expect(grid[0][2]).toBe(1)
        expect(grid[1][0]).toBe(1)
        expect(grid[1][2]).toBe(1)
        expect(grid[0][3]).toBe(false)
        MockItemDB['rifle'] = nil
    end)

    it('should handle rotated item (swap w/h)', function()
        MockItemDB['bat'] = { width = 1, height = 3 }
        local inv = {
            gridWidth = 5, gridHeight = 5,
            items = { [1] = { name = 'bat', gridX = 0, gridY = 0, gridRotated = true } }
        }
        local grid = GridUtils.BuildOccupancy(inv)
        -- rotated: w=3, h=1
        expect(grid[0][0]).toBe(1)
        expect(grid[0][1]).toBe(1)
        expect(grid[0][2]).toBe(1)
        expect(grid[1][0]).toBe(false) -- only 1 row tall when rotated
        MockItemDB['bat'] = nil
    end)

    it('should exclude specified slot', function()
        MockItemDB['water'] = { width = 1, height = 1 }
        local inv = {
            gridWidth = 5, gridHeight = 5,
            items = { [1] = { name = 'water', gridX = 0, gridY = 0 } }
        }
        local grid = GridUtils.BuildOccupancy(inv, 1)
        expect(grid[0][0]).toBe(false)
        MockItemDB['water'] = nil
    end)
end)

-- IsGridInventory tests
describe('GridUtils.IsGridInventory', function()
    it('should return false for shop', function()
        expect(GridUtils.IsGridInventory('shop')).toBe(false)
    end)

    it('should return false for crafting', function()
        expect(GridUtils.IsGridInventory('crafting')).toBe(false)
    end)

    it('should return true for stash', function()
        expect(GridUtils.IsGridInventory('stash')).toBe(true)
    end)

    it('should return true for drop', function()
        expect(GridUtils.IsGridInventory('drop')).toBe(true)
    end)
end)

-- GetDimensions tests
describe('GridUtils.GetDimensions', function()
    it('should return defaults for known type without slots', function()
        local w, h = GridUtils.GetDimensions('trunk')
        expect(w).toBe(8)
        expect(h).toBe(5)
    end)

    it('should return global defaults for unknown type', function()
        local w, h = GridUtils.GetDimensions('unknown_type')
        expect(w).toBe(10)
        expect(h).toBe(7)
    end)

    it('should compute height from slots for stash', function()
        local w, h = GridUtils.GetDimensions('stash', 30)
        expect(w).toBe(10)
        expect(h).toBe(3) -- ceil(30/10)*1
    end)

    it('should compute height from slots for container', function()
        local w, h = GridUtils.GetDimensions('container', 12)
        expect(w).toBe(4)
        expect(h).toBe(3) -- ceil(12/4)*1
    end)
end)
