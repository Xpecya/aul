-- @requirements: MetatableBuilder
-- @author: xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";
local internal = require "aul.standard.internal";

return setmetatable({}, MetatableBuilder.new().immutable().index({
    printf = internal.printf,
    global = function()
        printf = internal.printf
    end
}).build());
