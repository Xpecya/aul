-- @requirements: MetatableBuilder
-- @author: xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";

local Tea = require "aul.security.tea";
local Xtea = require "aul.security.xtea";
local XXtea = require "aul.security.xxtea";

return setmetatable({}, MetatableBuilder.new().immutable().index({
    tea = Tea,
    xtea = Xtea,
    xxtea = XXtea
}).build());
