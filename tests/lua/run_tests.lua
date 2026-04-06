-- Test runner: loads helpers, mocks, then all test files

local testDir = debug.getinfo(1, 'S').source:match('@?(.*[/\\])')
if not testDir then testDir = './' end

-- Load mocks first (sets up globals)
dofile(testDir .. 'mocks.lua')

-- Load helpers
local helpers = dofile(testDir .. 'helpers.lua')

-- Make helpers available globally for test files
describe = helpers.describe
it = helpers.it
expect = helpers.expect

-- Run all test files
dofile(testDir .. 'test_gridutils.lua')
dofile(testDir .. 'test_durability.lua')
dofile(testDir .. 'test_inventory_ops.lua')
dofile(testDir .. 'test_items.lua')

-- Print final results
helpers.printResults()
