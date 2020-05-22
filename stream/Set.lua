-- @requirement: MetatableBuilder
-- @author: xpecya

-- in order not to mask the following functions
local function resolveString(item) 
    local head = "__";
    if type(item) == "string" then 
        item = head .. item;
    end
    return item;
end

local function add(set, item)
    assert(item ~= nil, "item cannot be nil!");
    set[resolveString(item)] = true;
    return set;
end

local function addAll(set, table) 
    assert(type(table) == "table", "input value is not a table!");
    for data, _ in pairs(table) do 
        add(set, data);
    end
    return set;
end

local function contains(set, item) 
    if item == nil then
        return false;
    end
    return set[resolveString(item)];
end

local function remove(set, item) 
    set[resolveString(item)] = nil;
    return set;
end

local MetatableBuilder = require "MetatableBuilder";
local setMetatable = MetatableBuilder.new().immutable().index({
        add = add,
        addAll = addAll,
        contains = contains,
        remove = remove,
        map = nil,
        reduce = nil,
        filter = nil,
        toArray = nil
    }).newindex().build());

local function new(table) 
    local set = {};
    local MetatableBuilder = require "MetatableBuilder";
    setmetatable(set, setMetatable);
    if type(table) == "table" then
        set.addAll(table);
    end
    return set;
end

setMetatable.map = function(set, func) 
    assert(type(func) == "function", "input is not a function!");
    
    local newSet = new();
    for value, _ in pairs(set) do
        local result = func(value);
        if result ~= nil then
            netSet.add(result);
        end
    end
    return newSet;
end

setMetatable.reduce = function(set, func) 
    assert(type(func) == "function", "input is not a function!");
    
    local newSet = new();
    local init = false;
    local last;
    for value, _ in pairs(set) do
        if init == false then 
            last = value;
            init = true;
            break;
        end
        last = func(last, value);
    end
    return last;
end

setMetatable.filter = function(set, func) 
    assert(type(func) == "function", "input is not a function!");
    
    local newSet = new();
    for value, _ in pairs(set) do
        if func(value) then 
            newSet.add(value);
        end
    end
    return newSet;
end

setMetatable.toArray = function(set) 
    -- reduce resize method call
    local resultArray = {nil, nil, nil, nil};
    local index = 1;
    for value, _ in pairs(set) do
        resultArray[index] = value;
        index = index + 1;
    end
    return resultArray;
end

return {
    new = new
}
