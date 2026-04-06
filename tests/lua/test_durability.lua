-- Tests for durability functions
local testDir = debug.getinfo(1, 'S').source:match('@?(.*[/\\])')
local Durability = dofile(testDir .. 'extracted/durability.lua')

describe('CalculateDurabilityAfterStack', function()
    it('should average equal counts', function()
        local from = { count = 1, metadata = { durability = 80 } }
        local to = { count = 1, metadata = { durability = 60 } }
        local result = Durability.CalculateDurabilityAfterStack(from, to)
        expect(result).toBeCloseTo(70, 0.01)
    end)

    it('should compute weighted average', function()
        local from = { count = 3, metadata = { durability = 90 } }
        local to = { count = 1, metadata = { durability = 50 } }
        -- (90*3 + 50*1) / 4 = 320/4 = 80
        local result = Durability.CalculateDurabilityAfterStack(from, to)
        expect(result).toBeCloseTo(80, 0.01)
    end)

    it('should clamp negative durability to zero', function()
        local from = { count = 1, metadata = { durability = -10 } }
        local to = { count = 1, metadata = { durability = 50 } }
        -- durFrom clamped to 0: (0*1 + 50*1) / 2 = 25
        local result = Durability.CalculateDurabilityAfterStack(from, to)
        expect(result).toBeCloseTo(25, 0.01)
    end)

    it('should handle degrade-based durability (timestamps > 100)', function()
        local now = os.time()
        local degrade = 10 -- 10 minutes
        -- Set durability to timestamps in the future
        local durFrom = now + (degrade * 60) -- 100% remaining
        local durTo = now + (degrade * 60) / 2 -- 50% remaining

        local from = { count = 1, metadata = { durability = durFrom, degrade = degrade } }
        local to = { count = 1, metadata = { durability = durTo, degrade = degrade } }

        local result = Durability.CalculateDurabilityAfterStack(from, to)
        -- Average of 100% and 50% = 75%, convert back to timestamp
        -- Should be close to now + 0.75 * degrade * 60
        local expected = math.floor(now + (75 * (degrade * 60)) / 100 + 0.5)
        expect(result).toBeCloseTo(expected, 1)
    end)
end)

describe('canStackDurability', function()
    it('should return true and averaged durability when metadata matches', function()
        local from = { count = 1, metadata = { durability = 80, label = 'Test' } }
        local to = { count = 1, metadata = { durability = 60, label = 'Test' } }
        local canStack, dur = Durability.canStackDurability(from, to)
        expect(canStack).toBe(true)
        expect(dur).toBeCloseTo(70, 0.01)
    end)

    it('should return false when source has no durability', function()
        local from = { count = 1, metadata = { label = 'Test' } }
        local to = { count = 1, metadata = { durability = 60, label = 'Test' } }
        local canStack = Durability.canStackDurability(from, to)
        expect(canStack).toBe(false)
    end)

    it('should return false when target has no durability', function()
        local from = { count = 1, metadata = { durability = 80, label = 'Test' } }
        local to = { count = 1, metadata = { label = 'Test' } }
        local canStack = Durability.canStackDurability(from, to)
        expect(canStack).toBe(false)
    end)

    it('should return false when other metadata differs', function()
        local from = { count = 1, metadata = { durability = 80, label = 'A' } }
        local to = { count = 1, metadata = { durability = 60, label = 'B' } }
        local canStack = Durability.canStackDurability(from, to)
        expect(canStack).toBe(false)
    end)
end)
