-- @requirements: MetatableBuilder
-- @author: xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";
local internal = require "aul.standard.internal";

return setmetatable({}, MetatableBuilder.new().immutable().index({
    fdopen = function(fd, openType)
        assert(type(fd) == "number", "fd is not a number!");
        assert(type(openType) == "string", "open type is not a string!");
        return internal.fdopen(fd, openType);
    end
}).build())
