-- @requirements: MetatableBuilder
-- @author: xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";

return setmetatable({}, MetatableBuilder.new().immutable().index({
    printf = function(template, ...)
        local data = string.format(template, ...);
        io.stdout:write(data);
    end
}).build());
