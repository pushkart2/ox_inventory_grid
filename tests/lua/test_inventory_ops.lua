-- Tests for inventory operations
local testDir = debug.getinfo(1, 'S').source:match('@?(.*[/\\])')
local InvOps = dofile(testDir .. 'extracted/inventory_ops.lua')

describe('Inventory.SlotWeight', function()
    it('should compute simple weight', function()
        local item = { weight = 100 }
        local slot = { count = 1 }
        local w = InvOps.SlotWeight(item, slot)
        expect(w).toBe(100)
    end)

    it('should multiply weight by count', function()
        local item = { weight = 50 }
        local slot = { count = 5 }
        local w = InvOps.SlotWeight(item, slot)
        expect(w).toBe(250)
    end)

    it('should ignore count when ignoreCount is true', function()
        local item = { weight = 50 }
        local slot = { count = 5 }
        local w = InvOps.SlotWeight(item, slot, true)
        expect(w).toBe(50)
    end)

    it('should add ammo weight', function()
        MockItemDB['ammo_pistol'] = { weight = 10 }
        local item = { weight = 200, ammoname = 'ammo_pistol' }
        local slot = { count = 1, metadata = { ammo = 12 } }
        local w = InvOps.SlotWeight(item, slot)
        -- 200 + (10 * 12) = 320
        expect(w).toBe(320)
        MockItemDB['ammo_pistol'] = nil
    end)

    it('should add component weight', function()
        MockItemDB['scope'] = { weight = 75 }
        local item = { weight = 300 }
        local slot = { count = 1, metadata = { components = { 'scope' } } }
        local w = InvOps.SlotWeight(item, slot)
        -- 300 + 75 = 375
        expect(w).toBe(375)
        MockItemDB['scope'] = nil
    end)

    it('should add metadata weight', function()
        local item = { weight = 100 }
        local slot = { count = 2, metadata = { weight = 50 } }
        local w = InvOps.SlotWeight(item, slot)
        -- (100*2) + (50*2) = 300
        expect(w).toBe(300)
    end)

    it('should add metadata weight once when ignoreCount', function()
        local item = { weight = 100 }
        local slot = { count = 2, metadata = { weight = 50 } }
        local w = InvOps.SlotWeight(item, slot, true)
        -- 100 + 50 = 150
        expect(w).toBe(150)
    end)
end)

describe('Inventory.SwapSlots', function()
    it('should swap two items between inventories', function()
        local invA = {
            items = {
                [1] = { name = 'water', slot = 1, gridX = 0, gridY = 0, gridRotated = false },
            },
            changed = false,
        }
        local invB = {
            items = {
                [2] = { name = 'bread', slot = 2, gridX = 3, gridY = 1, gridRotated = true },
            },
            changed = false,
        }

        local fromSlot, toSlot = InvOps.SwapSlots(invA, invB, 1, 2)

        -- Slots are swapped
        expect(invA.items[1].name).toBe('bread')
        expect(invB.items[2].name).toBe('water')

        -- Slot numbers updated
        expect(fromSlot.slot).toBe(2)
        expect(toSlot.slot).toBe(1)

        -- Grid positions swapped
        expect(fromSlot.gridX).toBe(3)
        expect(fromSlot.gridY).toBe(1)
        expect(toSlot.gridX).toBe(0)
        expect(toSlot.gridY).toBe(0)

        -- Changed flags set
        expect(invA.changed).toBe(true)
        expect(invB.changed).toBe(true)
    end)

    it('should handle one empty slot', function()
        local invA = {
            items = {
                [1] = { name = 'water', slot = 1, gridX = 0, gridY = 0 },
            },
            changed = false,
        }
        local invB = {
            items = {},
            changed = false,
        }

        local fromSlot, toSlot = InvOps.SwapSlots(invA, invB, 1, 3)

        -- item moved from A[1] to B[3]
        expect(invA.items[1]).toBeNil()
        expect(invB.items[3].name).toBe('water')
        expect(fromSlot.slot).toBe(3)
        expect(toSlot).toBeNil()
        expect(invA.changed).toBe(true)
        expect(invB.changed).toBe(true)
    end)
end)

describe('Inventory.CanCarryWeight', function()
    it('should return true when under max weight', function()
        local inv = { maxWeight = 1000, weight = 200 }
        local canHold, available = InvOps.CanCarryWeight(inv, 500)
        expect(canHold).toBe(true)
        expect(available).toBe(800)
    end)

    it('should return false when over max weight', function()
        local inv = { maxWeight = 1000, weight = 800 }
        local canHold, available = InvOps.CanCarryWeight(inv, 300)
        expect(canHold).toBe(false)
        expect(available).toBe(200)
    end)

    it('should return true when exactly at max weight', function()
        local inv = { maxWeight = 1000, weight = 500 }
        local canHold, available = InvOps.CanCarryWeight(inv, 500)
        expect(canHold).toBe(true)
        expect(available).toBe(500)
    end)

    it('should return nil for nil inventory', function()
        local result = InvOps.CanCarryWeight(nil, 100)
        expect(result).toBeNil()
    end)
end)
