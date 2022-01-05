-- @requirements: MetatableBuilder
-- @author: xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";
local UnsafeInternal = require "aul.unsafe.internal";

local function getState()
    return UnsafeInternal.unsafe_get_state();
end

return setmetatable({}, MetatableBuilder.new().immutable().index({
    getState = getState,
    checkStack = function(size)
        assert(type(size) == "number", "input param " .. size .. " is not a number!");
        return UnsafeInternal.unsafe_check_stack(size);
    end,
    createTable = function(narr, nrec)
        if narr == nil then
            narr = 0;
        elseif type(narr) ~= "number" then
            error("narr " .. narr .. " is not a number!");
        end
        if nrec == nil then
            nrec = 0;
        elseif type(nrec) ~= "number" then
            error("nrec " .. nrec .. " is not a number!");
        end
        return UnsafeInternal.unsafe_create_table(narr, nrec);
    end,
    getExtraSpace = function()
        return UnsafeInternal.unsafe_get_extra_space();
    end,
    createNewState = function()
        return UnsafeInternal.unsafe_create_new_state();
    end,
    doFile = function(state, fileName)
        if state == nil then
            dofile(fileName);
        end
        return UnsafeInternal.unsafe_do_file(state, fileName);
    end
}).build());
