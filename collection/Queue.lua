-- @requirements: MetatableBuilder, Stream
-- @author: xpecya

local MetatableBuilder = require "MetatableBuilder";
local Stream = require "Stream"
local function new() 
    local node = {};
    local last = node;
    local length = 0;

    local queue = {};

    local function add(element)
        if length == 0 then
            node.value = element;
        else
            local next = {};
            next.value = element;
            last.next = next;
            last = next;
        end
        length = length + 1;
    end
    
    local function remove()
        local result;
        if length == 1 then 
            result = node.value;
            node.value = nil;
        else 
            result = node.value;
            node = node.next;
        end
        length = length - 1;
        return result;
    end
    
    local function head() 
        return last.value;
    end
    
    local function tail() 
        return node.value;
    end
    
    local function getLength()
        return length;
    end

    local function iterator() 
        local index = 0;
        local current = node;
        return setmetatable({}, MetatableBuilder.new().immutable().index({
            hasNext = function() 
                return index < length;
            end,
            next = function() 
                local result = current.value;
                index = index + 1;
                current = current.next;
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
        return Stream.of(queue);
    end

    return setmetatable(queue, MetatableBuilder.new().immutable().index({
        add = add,
        remove = remove,
        head = head,
        tail = tail,
        iterator = iterator,
        stream = stream
    }).len(getLength).pairs(pairs).ipairs(ipairs).build());
end

return setmetatable({}, MetatableBuilder.new().immutable().index({
    new = new
}).build());
