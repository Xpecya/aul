-- @requirements: Metatable, Queue
-- @author: xpeyca
local MetatableBuilder = require "MetatableBuilder";
local Queue = require "Queue";

local __type = "Stream";

local function doMap(data, consumer) 
    local result = {};
    for _, v in ipairs(data) do
        table.insert(result, consumer(v));
    end
    return result;
end

local function doFilter(data, consumer) 
    local result = {};
    for _, v in ipairs(data) do
        local check = consumer(v);
        if check ~= false and check ~= nil then 
            table.insert(result, v);
        end
    end
    return result;
end

local function doDistinct(data) 
    local result = {};
    for _, dataInstance in ipairs(data) do
        local check = true;
        for __, resultInstance in ipairs(result) do
            if resultInstance == dataInstance then 
                check = false;
                break;
            end
        end
        if check then 
            table.insert(result, dataInstance);
        end
    end
    return result;
end

local function doFlatMap(data, consumer) 
    local result = {};
    for _, v in ipairs(data) do
        local stream = consumer(v);
        assert(stream.__type == __type);
        for __, value in ipairs(stream.__data) do
            table.insert(result, value);
        end
    end
    return result;
end

local function doLimit(data, size) 
    local result = {};
    for i, v in ipairs(data) do
        if size < i then break end;
        table.insert(result, v);
    end
    return result;
end

local function doPeek(data, consumer) 
    for _, v in ipairs(data) do
        consumer(v);
    end
end

local function doSkip(data, size) 
    local result = {};
    for i, v in ipairs(data) do
        if i > size then 
            table.insert(result, v);
        end
    end
    return result;
end

local function doSort(data, consumer) 
    table.sort(data, consumer);
    return data;
end

local function doActions(data, actions) 
    local queueIterator = actions.iterator();
    while (queueIterator.hasNext()) do 
        local action = queueIterator.next();
        local name = action.name;
        if (name == "map") then data = doMap(data, action.action);
        elseif (name == "filter") then data = doFilter(data, action.action);
        elseif (name == "distinct") then data = doDistinct(data);
        elseif (name == "flatMap") then data = doFlatMap(data, action.action);
        elseif (name == "limit") then data = doLimit(data, action.size);
        elseif (name == "peek") then doPeek(data, action.action);
        elseif (name == "skip") then data = doSkip(data, action.size);
        elseif (name == "sort") then data = doSort(data, action.action);
        end
    end
    return data;
end

local function newSingle(value)
    local data;
    if value == nil then 
        data = {};
    elseif type(value) == "table" then
        if value.__type == __type then 
            data = value.__data;
        else
            data = value;
        end
    else 
        data = {};
        data[1] = value;
    end

    local result = {};
    local actions = Queue.new();

    local function map(consumer)
        actions.add({
            name = "map",
            action = consumer
        });
        return result;
    end
    
    local function filter(consumer)
        actions.add({
            name = "filter",
            action = consumer
        });
        return result;
    end
    
    local function toTable(keyGenerator, valueGenerator)
        local data = doActions(data, actions);
        local result = {};
        for _, v in ipairs(data) do
            result[keyGenerator(v)] = valueGenerator(v);
        end
        return result;
    end
    
    local function toArray()
        return doActions(data, actions);
    end
    
    local function count()
        local data = doActions(data, actions);
        return #data;
    end
    
    local function distinct()
        actions.add({
            name = "distinct"
        });
        return result;
    end
    
    local function flatMap(consumer)
        actions.add({
            name = "flatMap",
            action = consumer
        });
        return result;
    end
    
    local function forEach(consumer)
        local data = doActions(data, actions);
        for _, v in ipairs(data) do
            consumer(v);
        end
    end
    
    local function limit(size)
        actions.add({
            name = "limit",
            size = size
        });
        return result;
    end
    
    local function peek(consumer)
        actions.add({
            name = "peek",
            action = consumer
        });
        return result;
    end
    
    local function reduce(consumer)
        local data = doActions(data, actions);
        local last = nil;
        for _, v in ipairs(data) do
            if last ~= nil then
                last = consumer(last, v);
            else 
                last = v;
            end
        end
        return last;
    end
    
    local function skip(size)
        actions.add({
            name = "skip",
            size = size
        });
        return result;
    end
    
    local function sort(consumer)
        actions.add({
            name = "sort",
            action = consumer
        });
        return result;
    end
    
    return setmetatable(result, MetatableBuilder.new().immutable().index({
        map = map,
        toTable = toTable,
        toArray = toArray,
        filter = filter,
        count = count,
        distinct = distinct,
        flatMap = flatMap,
        forEach = forEach,
        limit = limit,
        peek = peek,
        reduce = reduce,
        skip = skip,
        sort = sort,

        -- internal using only!
        __type = __type,
        __data = data
    }).build());
end

local function new(...) 
    local inputTable = {...};
    local length = #inputTable;
    local result;
    if length <= 1 then 
        result = newSingle(...);
    else 
        result = newSingle(inputTable);
    end
    return result;
end

local function empty() 
    return newSingle();
end

local function of(...) 
    return new(...)
end

local function concat(a, b)
    assert(type(a) == "table" and stream.__type == __type);
    assert(type(b) == "table" and stream.__type == __type);
    local aData = a.__data;
    local bData = b.__data;
    for _, v in ipairs(bData) do
        table.insert(aData, v);
    end
    return a;
end

return setmetatable({}, MetatableBuilder.new().immutable().index({
    empty = empty,
    of = of,
    concat = concat
}).build());
