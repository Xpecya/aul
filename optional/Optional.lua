-- @requirement => MetatableBuilder
-- @author => xpecya
return {
    new = function(data) 
        local result = {};

        local getValue;
        local ifPresent;
        local orElse;
        if data == nil then
            getValue = function() 
                error("value is nil!"); 
            end
            ifPresent = function() 
                return result; 
            end
            orElse = function (nilHandler)
                nilHandler();
            end
        else
            getValue = function() 
                return data; 
            end
            ifPresent = function(consumer) 
                consumer(data);
                return result;
            end
            orElse = function() end
        end

        local MetatableBuilder = require "MetatableBuilder";
        setmetatable(result, MetatableBuilder.new().immutable().index({
            isPresent = function() 
                return data ~= nil;
            end, 
            ifPresent = ifPresent, 
            orElse = orElse, 
            getValue = getValue
        }).newindex(function()
            print("Optional object is immutable!");    
        end).build());
        return result;
    end
}
