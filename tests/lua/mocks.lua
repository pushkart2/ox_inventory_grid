-- Mock globals used by extracted modules

-- lib.table.deepclone: recursive clone
lib = lib or {}
lib.table = lib.table or {}

function lib.table.deepclone(t)
    if type(t) ~= 'table' then return t end
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = lib.table.deepclone(v)
    end
    return setmetatable(copy, getmetatable(t))
end

-- table.clone: shallow clone
if not table.clone then
    function table.clone(t)
        if type(t) ~= 'table' then return t end
        local copy = {}
        for k, v in pairs(t) do
            copy[k] = v
        end
        return copy
    end
end

-- table.matches: deep equality check
if not table.matches then
    function table.matches(a, b)
        if type(a) ~= type(b) then return false end
        if type(a) ~= 'table' then return a == b end
        for k, v in pairs(a) do
            if not table.matches(v, b[k]) then return false end
        end
        for k, v in pairs(b) do
            if a[k] == nil then return false end
        end
        return true
    end
end

-- math.round
if not math.round then
    function math.round(n)
        return math.floor(n + 0.5)
    end
end

-- shared config
shared = shared or {}
shared.slotratio = 1
shared.gridwidth = 10
shared.gridheight = 7

-- client.imagepath mock
client = client or {}
client.imagepath = 'https://cdn.example.com/images'

-- Mock Items function (returns item definitions by name)
-- Tests can override MockItemDB before calling functions
MockItemDB = MockItemDB or {}

function MockItems(name)
    return MockItemDB[name]
end
