-- @requirement => none
-- @author => xpecya
MetatableBuilder = {}

local function functionBuilder(param, metatable, builder)
    local head = "__";
    return function (input)
        assert(input, "input is nil!");
        metatable[head .. param] = input;
        return builder;
    end
end

local function getOrDefault(config, key, metatable, builder)
    local value = config[key];
    if value == nil then
        value = functionBuilder(key, metatable, builder);
    end
    return value;
end

-- create a new MetatableBuilder Object
-- @param config => if you already have a metatable model and all you need to do is just add a few new features
--                  then you can reuse your model by sending it to the function as config
-- @return => MetatableBuilder Object
function MetatableBuilder.new(config)
    local builder = {};
    local immutableString = "the metatable is immutable";
    local resultTable = {}
    local builderMetatable = {
        __metatable = immutableString,
        __newindex = function()
            print("this table is immutable");
        end
    }
    setmetatable(builder, builderMetatable);
    local builderMetatableIndex = {};
    builderMetatable.__index = builderMetatableIndex;
    local keywords = {
        -- math meta methods
        "add",  --> +
        "sub",  --> -
        "mul",  --> *
        "div",  --> /
        "mod",  --> %
        "pow",  --> ^
        "unum", --> -
        "idiv", --> //

        -- binary meta methods
        "band", --> &
        "bor",  --> |
        "bxor", --> ~
        "bnot", --> ~
        "shl",  --> <<
        "shr",  --> >>

        -- string meta methods
        "concat",   --> ..
        "len",      --> #
        "tostring", --> tostring

        -- comparation meta methods
        "eq", --> ==
        "le", --> <=
        "lt", --> <

        -- index meta methods
        "index",
        "newindex",

        -- function meta method
        "call",

        -- gc meta method
        "gc",

        -- weak table meta method
        "mode",

        -- iterator meta method
        "pairs",
        "ipairs",

        -- metatable
        "metatable"
    };

    for _, value in ipairs(keywords) do
        builderMetatableIndex[value] = getOrDefault(config, value, resultTable, builder);
    end

    function builderMetatableIndex:immutable()
        return self.metatable(immutableString);
    end

    return builder;
end

return MetatableBuilder;
