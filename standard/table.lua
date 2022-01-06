-- @requirements: MetatableBuilder
-- @author: xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";

return setmetatable({}, MetatableBuilder.new().immutable().index({
    remove = function(param, key)
        assert(type(param) == "table", "first param is not a table!");
        local keyType = type(key);
        if keyType == "number" or keyType == "nil" then
            return table.remove(param, key);
        else
            local result = table[key]
            if result ~= nil then
                table[key] = nil;
                return result;
            end
        end
    end,

    -- official libs
    concat = table.concat,
    insert = table.insert,
    move = table.move,
    pack = table.pack,
    sort = table.sort,
    unpack = table.unpack
}).build());
