---@warning: Only Available On Lua 5.3+
---@requirements: MetatableBuilder
---@author: Xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";

local function mx(key, p, y, z, sum, e)
    return (((z >> 5 ~ y << 2) + (y >> 3 ~ z << 4)) ~ ((sum ~ y) + (key[(p & 3) ~ e + 1] ~ z)))
end
