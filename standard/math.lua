-- @requirements: MetatableBuilder
-- @author: xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";

local function localGCD(a, b)
    if a == 0 then
        return b;
    end
    if b == 0 or a == b then
        return a;
    end
    if a > b then
        return localGCD(a % b, b);
    else
        return localGCD(a, b % a);
    end
end

local function gcd(a, b)
    assert(type(a) == "number" and type(b) == "number", "input params must be numbers");
    return localGCD(a, b);
end

local function lcm(a, b)
    assert(type(a) == "number" and type(b) == "number", "input params must be numbers");
    return a / gcd(a, b) * b;
end

local metatableIndex = {
    global = function()
        math.gcd = gcd;
        math.lcm = lcm;
    end,
    gcd = gcd,
    lcm = lcm
};
for i, v in pairs(math) do
    metatableIndex[i] = v;
end
return setmetatable({}, MetatableBuilder.new().index(metatableIndex).build(), math);
