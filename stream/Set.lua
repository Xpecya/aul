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

local function remove(set, item) 
    set[resolveString(item)] = nil;
    return set;
end

local new;

local actionTable = {nil, nil, nil, nil};
local function doAction(set) 
    local newSet;

    local reduceInit = false;
    local reduceLast;
    for data, _ in set do 
        -- resolve head
        if type(data) == "string" then 
            data = string.sub(2);
        end
        for __, action in actionTable do 
            local actionName = action.name;
            local actionFunc;
            if actionName == "reduce" then
                if not reduceInit then 
                    reduceLast = data;
                    reduceInit = true;
                else 
                    actionFunc = action.func;
                    reduceLast = actionFunc(reduceLast, data);
                end
            elseif actionName == "toArray" then
                if not newSet then 
                    newSet = {nil, nil, nil, nil};
                end
                table.insert(data, newSet);
            else 
                actionFunc = action.func;
                if actionName == "toMap" then 
                    if not newSet then 
                        newSet = {nil, nil, nil, nil};
                    end
                    local key, value = actionFunc(data);
                    newSet[key] = value;
                else
                    data = actionFunc(data);
                    if data == nil then break end
                    if actionName == "filter" and data == false then break end
                end
            end
        end
        if not reduceInit then 
            if not newSet then 
                newSet = new();
            end
            newSet.add(data);
        end
    end
    local result;
    if reduceInit then 
        result = reduceLast;
    else
        result = newSet;
    end
    return result;
end

local function contains(set, item) 
    if item == nil then
        return false;
    end
    return doAction(set)[resolveString(item)];
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
        toArray = nil,
        toMap = nil
    }).newindex("set metatable is immutable").build();

new = function(table) 
    local set = {};
    setmetatable(set, setMetatable);
    if type(table) == "table" then
        set.addAll(table);
    end
    return set;
end

setMetatable.map = function(set, func)
    assert(type(func) == "function", "input is not a function!");
    table.insert(actionTable, {
        name = "map",
        func = func
    });
    return set;
end

setMetatable.filter = function(set, func) 
    assert(type(func) == "function", "input is not a function!");
    table.insert(actionTable, {
        name = "filter",
        func = func;
    });
    return set;
end

setMetatable.reduce = function(set, func) 
    assert(type(func) == "function", "input is not a function!");
    table.insert(actionTable, {
        name = "reduce",
        func = func
    });
    return doAction(set);
end

setMetatable.toArray = function(set) 
    table.insert(actionTable, {
        name = "toArray"
    });
    return doAction(set);
end

setMetatable.toMap = function(set, func) 
    assert(type(func) == "function", "input is not a function!");
    table.insert(actionTable, {
        name = "toMap",
        func = func
    });
    return doAction(set);
end

return {
    new = new
}
