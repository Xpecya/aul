-- @requirement => MetatableBuilder
-- @author => xpecya
Optional = {};

-- create a new Optional object
-- @param data => the data that may be null
-- @return => Optional object
function Optional.new(data) 
    local result = {};

    local getValue;
    local ifPresnet;
    local orElse;
    if data == nil then
        getValue = function() 
            error("value is nil!"); 
        end
        ifPresnet = function() 
            return result; 
        end
        orElse = function (nilHandler)
            nilHandler();
        end
    else
        getValue = function() 
            return data; 
        end
        ifPresnet = function(consumer) 
            consumer(data);
            return result;
        end
        orElse = function() end
    end

    local MetatableBuilder = require "MetatableBuilder";
    setmetatable(result, MetatableBuilder.new().immutable().index({
        isPresent = function() 
            return data ~= nil;
        end, ifPresnet = ifPresnet, orElse = orElse, getValue = getValue
    }).newindex(function() end).build());
    return result;
end

return Optional;
