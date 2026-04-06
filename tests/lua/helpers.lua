-- Test framework helpers
local Helpers = {}

local totalPassed = 0
local totalFailed = 0
local results = {}

local currentDescribe = ''
local currentIt = ''

function Helpers.describe(name, fn)
    currentDescribe = name
    fn()
    currentDescribe = ''
end

function Helpers.it(name, fn)
    currentIt = name
    local ok, err = pcall(fn)
    local label = currentDescribe .. ' > ' .. name
    if ok then
        totalPassed = totalPassed + 1
        results[#results + 1] = { label = label, passed = true }
    else
        totalFailed = totalFailed + 1
        results[#results + 1] = { label = label, passed = false, error = tostring(err) }
    end
    currentIt = ''
end

function Helpers.expect(val)
    local matchers = {}

    function matchers.toBe(expected)
        if val ~= expected then
            error(('Expected %s to be %s'):format(tostring(val), tostring(expected)), 2)
        end
    end

    function matchers.toBeNil()
        if val ~= nil then
            error(('Expected nil but got %s'):format(tostring(val)), 2)
        end
    end

    function matchers.toBeTruthy()
        if not val then
            error(('Expected truthy but got %s'):format(tostring(val)), 2)
        end
    end

    function matchers.toBeFalsy()
        if val then
            error(('Expected falsy but got %s'):format(tostring(val)), 2)
        end
    end

    function matchers.toBeCloseTo(expected, precision)
        precision = precision or 0.01
        if math.abs(val - expected) > precision then
            error(('Expected %s to be close to %s (within %s)'):format(tostring(val), tostring(expected), tostring(precision)), 2)
        end
    end

    function matchers.toEqual(expected)
        local function deepEqual(a, b)
            if type(a) ~= type(b) then return false end
            if type(a) ~= 'table' then return a == b end
            for k, v in pairs(a) do
                if not deepEqual(v, b[k]) then return false end
            end
            for k, v in pairs(b) do
                if a[k] == nil then return false end
            end
            return true
        end
        if not deepEqual(val, expected) then
            error(('Expected tables to be deeply equal'), 2)
        end
    end

    return matchers
end

function Helpers.printResults()
    print('\n========== TEST RESULTS ==========')
    for _, r in ipairs(results) do
        if r.passed then
            print('  PASS: ' .. r.label)
        else
            print('  FAIL: ' .. r.label)
            print('        ' .. r.error)
        end
    end
    print(('================================='))
    print(('  Passed: %d  Failed: %d  Total: %d'):format(totalPassed, totalFailed, totalPassed + totalFailed))
    print('==================================\n')

    if totalFailed > 0 then
        os.exit(1)
    end
end

return Helpers
