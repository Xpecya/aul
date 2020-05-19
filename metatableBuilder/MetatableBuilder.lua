-- @requirement => none
-- @author => xpecya
MetatableBuilder = {}

local function getOrDefault(table, key, defaultValue)
    local value = table[key];
    if value == nil then value = defaultValue end
    return value;
end

local function functionBuilder(param, metatable, builder)
    local head = "__";
    return param, function (input)
        assert(input, "input is nil!");
        metatable[head .. param] = input;
        return builder;
    end
end

-- create a new MetatableBuilder Object
-- @param config => if you already have a metatable model and all you need to do is just add a few new features
--                  then you can reuse your model by sending it to the function as config
-- @return => MetatableBuilder Object
function MetatableBuilder.new(config)
    local builder = {};
    local metatable = {};

    -- math meta methods
    local add;
    local sub;
    local mul;
    local div;
    local mod;
    local pow;
    local unum;
    local idiv;

    -- binary meta methods
    local band;
    local bor;
    local bxor;
    local bnot;
    local shl;
    local shr;

    -- string meta methods
    local concat;
    local len;
    local tostring;

    -- comparation meta methods
    local eq;
    local le;
    local lt;

    -- index meta methods
    local index;
    local newindex;

    -- function meta method
    local call;

    -- gc meta method
    local gc;

    -- metatable meta method
    local metatableMethod;

    -- weak table meta method
    local mode;

    -- iterator meta method
    local pairs;
    local ipairs;

    local immutableString = "the metatable is immutable";
    if type(config) == "table" then
        add = getOrDefault(config, functionBuilder("add", metatable, builder));
        sub = getOrDefault(config, functionBuilder("sub", metatable, builder));
        mul = getOrDefault(config, functionBuilder("mul", metatable, builder));
        div = getOrDefault(config, functionBuilder("div", metatable, builder));
        mod = getOrDefault(config, functionBuilder("mod", metatable, builder));
        pow = getOrDefault(config, functionBuilder("pow", metatable, builder));
        unum = getOrDefault(config, functionBuilder("unum", metatable, builder));
        idiv = getOrDefault(config, functionBuilder("idiv", metatable, builder));
        band = getOrDefault(config, functionBuilder("band", metatable, builder));
        bor = getOrDefault(config, functionBuilder("bor", metatable, builder));
        bxor = getOrDefault(config, functionBuilder("bxor", metatable, builder));
        bnot = getOrDefault(config, functionBuilder("bnot", metatable, builder));
        shl = getOrDefault(config, functionBuilder("shl", metatable, builder));
        shr = getOrDefault(config, functionBuilder("shr", metatable, builder));
        concat = getOrDefault(config, functionBuilder("concat", metatable, builder));
        len = getOrDefault(config, functionBuilder("len", metatable, builder));
        tostring = getOrDefault(config, functionBuilder("tostring", metatable, builder));
        eq = getOrDefault(config, functionBuilder("eq", metatable, builder));
        lt = getOrDefault(config, functionBuilder("lt", metatable, builder));
        le = getOrDefault(config, functionBuilder("le", metatable, builder));
        index = getOrDefault(config, functionBuilder("index", metatable, builder));
        newindex = getOrDefault(config, functionBuilder("newindex", metatable, builder));
        call = getOrDefault(config, functionBuilder("call", metatable, builder));
        gc = getOrDefault(config, functionBuilder("gc", metatable, builder));
        metatableMethod = getOrDefault(config, "metatable", function(input)
            assert(input, "input is nil!");
            metatable.__metatable = immutableString;
            return builder;
        end);
        mode = getOrDefault(config, functionBuilder("mode", metatable, builder));
        pairs = getOrDefault(config, functionBuilder("pairs", metatable, builder));
        ipairs = getOrDefault(config, functionBuilder("ipairs", metatable, builder));
    end

    setmetatable(builder, {__metatable = immutableString, __index = {
        add = add, sub = sub, mul = mul, div = div, mod = mod, pow = pow,
        unum = unum, idiv = idiv, band = band, bor = bor, bxor = bxor,
        bnot = bnot, shl = shl, shr = shr, concat = concat, len = len,
        tostring = tostring, eq = eq, lt = lt, le = le, index = index, newindex = newindex,
        call = call, gc = gc, immutable = metatableMethod, mode = mode, pairs = pairs,
        ipairs = ipairs, build = function() return metatable; end
    }, __newindex = function()
        print("MetatableBuilder Object is immutable");
    end});
    return builder;
end

return MetatableBuilder;
