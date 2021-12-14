-- @requirements：MetatableBuilder, StreamInstance
-- @author: xpecya
local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";
local StreamInstance = require "aul.stream.StreamInstance";

local __type = "Stream";

return setmetatable({}, MetatableBuilder.new().immutable().index({
    of = function(...)
        local inputTable = {...};
        local length = #inputTable;
        local result;
        if length <= 1 then
            result = StreamInstance(...);
        else
            result = StreamInstance(inputTable);
        end
        return result;
    end,

    empty = function()
        return StreamInstance();
    end,

    concat = function(a, b)
        assert(type(a) == "table" and a.__type == __type);
        assert(type(b) == "table" and b.__type == __type);
        local aData = a.__data;
        local bData = b.__data;
        for _, v in ipairs(bData) do
            table.insert(aData, v);
        end
        return a;
    end
}).build());
