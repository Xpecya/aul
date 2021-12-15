-- @requirements: MetatableBuilder, Stream
-- @author: xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";
local Stream = require "aul.stream.Stream"

local function new() 
    local node = {};
    local last = node;
    local length = 0;

    local stack = {};

    local function push(element)
        if length == 0 then
            node.value = element;
        else
            local next = {};
            next.value = element;
            next.last = last;
            last = next;
        end
        length = length + 1;
    end
    
    local function pull()
        local result;
        if length == 1 then 
            result = node.value;
            node.value = nil;
        else 
            result = last.value;
            last = last.last;
        end
        length = length - 1;
        return result;
    end
    
    local function head() 
        return last.value;
    end
    
    local function getLength()
        return length;
    end

    local function iterator() 
        local index = 0;
        local current = last;
        return setmetatable({}, MetatableBuilder.new().immutable().index({
            hasNext = function() 
                return index < length;
            end,
            next = function() 
                local result = current.value;
                index = index + 1;
                current = current.last;
                return result;
            end
        }).build());
    end

    local function next(iterator, index) 
        if iterator.hasNext() then
            return index + 1, iterator.next();
        end
        return nil;
    end
    
    local function ipairs(input) 
        local iterator = input.iterator();
        return next, iterator, 0;
    end
    
    local function pairs(input) 
        return ipairs(input);
    end

    local function stream() 
        return Stream.of(stack);
    end

    return setmetatable(stack, MetatableBuilder.new().immutable().index({
        push = push,
        pull = pull,
        head = head,
        iterator = iterator,
        stream = stream
    }).len(getLength).pairs(pairs).ipairs(ipairs).build());
end

return setmetatable({}, MetatableBuilder.new().immutable().index({
    new = new
}).build());
