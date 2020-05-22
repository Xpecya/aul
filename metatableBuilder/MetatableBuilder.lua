-- @requirement => none
-- @author => xpecya

local function getOrDefault(config, key, metatable, builder)
    local head = "__";

    local value;
    if config ~= nil then 
        value = config[key];
        if value == nil then
            value = config[head .. key];
        end
    end
    if value == nil then 
        value = function(input) 
            assert(input ~= nil, "input is nil!");
            metatable[head .. key] = input;
            return builder;
        end
    end

    return value;
end

-- create a new MetatableBuilder Object
-- @param config => if you already have a metatable model and all you need to do is just add a few new features
--                  then you can reuse your model by sending it to the function as config
-- @return => MetatableBuilder Object
local function new(config)
    local builder = {};
    local immutableString = "the metatable is immutable";
    local resultTable = {};

    local function metatable() 
        return getOrDefault(config, "metatable", resultTable, builder);
    end
    local function immutable() 
        return metatable()(immutableString);
    end
    local builderMetatableIndex = {
        -- math meta methods
        add = getOrDefault(config, "add", resultTable, builder),   --> +
        sub = getOrDefault(config, "sub", resultTable, builder),   --> -
        mul = getOrDefault(config, "mul", resultTable, builder),   --> *
        div = getOrDefault(config, "div", resultTable, builder),   --> /
        mod = getOrDefault(config, "mod", resultTable, builder),   --> %
        pow = getOrDefault(config, "pow", resultTable, builder),   --> ^
        unm = getOrDefault(config, "unm", resultTable, builder), --> -
        idiv = getOrDefault(config, "idiv", resultTable, builder), --> //

        -- binary meta methods
        band = getOrDefault(config, "band", resultTable, builder), --> &
        bor = getOrDefault(config, "bor", resultTable, builder),   --> |
        bxor = getOrDefault(config, "bxor", resultTable, builder), --> ~
        bnot = getOrDefault(config, "bnot", resultTable, builder), --> ~
        shl = getOrDefault(config, "shl", resultTable, builder),   --> <<
        shr = getOrDefault(config, "shr", resultTable, builder),   --> >>

        -- string meta methods
        concat = getOrDefault(config, "concat", resultTable, builder),     --> ..
        len = getOrDefault(config, "len", resultTable, builder),           --> #
        tostring = getOrDefault(config, "tostring", resultTable, builder), --> tostring

        -- comparation meta methods
        eq = getOrDefault(config, "eq", resultTable, builder), --> ==
        le = getOrDefault(config, "le", resultTable, builder), --> <=
        lt = getOrDefault(config, "lt", resultTable, builder), --> <

        -- index meta methods
        index = getOrDefault(config, "index", resultTable, builder),
        newindex = getOrDefault(config, "newindex", resultTable, builder),

        -- function meta method
        call = getOrDefault(config, "call", resultTable, builder),

        -- gc meta method
        gc = getOrDefault(config, "gc", resultTable, builder),

        -- weak table meta method
        mode = getOrDefault(config, "mode", resultTable, builder),

        -- iterator meta method
        pairs = getOrDefault(config, "pairs", resultTable, builder),
        ipairs = getOrDefault(config, "ipairs", resultTable, builder),

        -- metatable
        metatable = metatable,
        immutable = immutable,
        build = function() 
            return resultTable;
        end
    };

    setmetatable(builder, {
        __metatable = immutableString,
        __newindex = function()
            print("this table is immutable");
        end,
        __index = builderMetatableIndex
    });
    return builder;
end

return {
    new = new
};
