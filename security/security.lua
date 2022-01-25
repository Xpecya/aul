-- @requirements: MetatableBuilder
-- @author: xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";
local Tea = require "aul.security.tea";

return setmetatable({}, MetatableBuilder.new().immutable().index({
    tea = Tea
}).build());
