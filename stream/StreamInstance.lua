-- @requirements：MetatableBuilder
-- @author: xpecya
local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";
local __type = "Stream";

local function basic(stream)
    return function()
        return stream.__data;
    end
end

local function append(stream, consumer)
    local localExecute;
    if stream.__execute == nil then
        localExecute = basic(stream);
    else
        localExecute = stream.__execute;
    end
    stream.__execute = function()
        return consumer(localExecute());
    end
end

return function(value)
    local stream = {};

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
        data = {value};
    end

    return setmetatable(stream, MetatableBuilder.new().immutable().index({
        -- middle functions
        map = function(consumer)
            append(stream, function(input)
                local result = {};
                for _, v in ipairs(input) do
                    table.insert(result, consumer(v));
                end
                return result;
            end);
            return stream;
        end,

        filter = function(consumer)
            append(stream, function(input)
                local result = {};
                for _, v in ipairs(input) do
                    local check = consumer(v);
                    if check ~= false and check ~= nil then
                        table.insert(result, v);
                    end
                end
                return result;
            end);
            return stream;
        end,

        distinct = function()
            append(stream, function(input)
                local result = {};
                for _, dataInstance in ipairs(input) do
                    local check = true;
                    for __, resultInstance in ipairs(result) do
                        if resultInstance == dataInstance then
                            check = false;
                            break
                        end
                    end
                    if check then
                        table.insert(result, dataInstance);
                    end
                end
                return result;
            end);
            return stream;
        end,

        flatMap = function(consumer)
            append(stream, function(input)
                local result = {};
                for _, v in ipairs(input) do
                    local stream = consumer(v);
                    assert(stream.__type == __type);
                    for __, value in ipairs(stream.__data) do
                        table.insert(result, value);
                    end
                end
                return result;
            end);
            return stream;
        end,

        limit = function(size)
            append(stream, function(input)
                local result = {};
                for i, v in ipairs(input) do
                    if size < i then
                        break;
                    end
                    table.insert(result, v);
                end
                return result;
            end);
            return stream;
        end,

        skip = function(size) 
            append(stream, function(input)
                local result = {};
                for i, v in ipairs(data) do
                    if i > size then 
                        table.insert(result, v);
                    end
                end
                return result;
            end);
            return stream;
        end,

        peek = function(consumer) 
            append(stream, function(input)
                for _, v in ipairs(input) do
                    consumer(v);
                end
                return input;
            end);
            return stream;
        end,

        sort = function(comparator) 
            append(stream, function(input)
                table.sort(input, comparator);
                return data;
            end);
            return stream;
        end,

        -- collecting functions
        toArray = function() 
            if stream.__execute == nil then
                return stream.__data;
            end
            return stream.__execute();
        end,

        toTable = function(keyGenerator, valueGenerator) 
            local result = {};
            for _, v in ipairs(stream.toArray()) do
                result[keyGenerator(v)] = valueGenerator(v);
            end
            return result;
        end,

        count = function() 
            return #stream.toArray();
        end,

        forEach = function(consumer) 
            for _, v in ipairs(stream.toArray()) do
                consumer(v);
            end
        end,

        reduce = function(biConsumer) 
            local last = nil;
            for _, v in ipairs(stream.toArray()) do
                if last ~= nil then
                    last = biConsumer(last, v);
                else 
                    last = v;
                end
            end
            return last;
        end, 

        -- internal fields
        __type = __type,
        __data = data
    }).build());
end
