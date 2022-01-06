-- @requirements: MetatableBuilder
-- @author: xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";

local function localPrintf(template, ...)
    local data = string.format(template, ...);
    io.stdout:write(data);
end

return setmetatable({}, MetatableBuilder.new().immutable().index({
    printf = localPrintf,
    global = function()
        printf = localPrintf
    end
}).build());
