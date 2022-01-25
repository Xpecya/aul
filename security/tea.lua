---@warning: Only Available On Lua 5.3+
---@requirements: MetatableBuilder
---@author: Xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";

local function checkParams(data, key, round, delta)
    assert(type(data) == "table" and type(data[1]) == "number" and type(data[2]) == "number", "data must be a table with two number!");
    assert(type(key) == "table" and type(key[1]) == "number" and type(key[2]) == "number" and type(key[3]) == "number" and type(key[4]) == "number",
            "key must be a table with four numbers!");
    if type(round) ~= "number" then
        round = 32;
    end
    if type(delta) ~= "number" then
        delta = 0x9e3779b9;
    end
    return data, key, round, delta;
end

return setmetatable({}, MetatableBuilder.new().immutable().index({
    encrypt = function(data, key, round, delta)
        data, key, round, delta = checkParams(data, key, round, delta);
        local data1 = data[1];
        local data2 = data[2];
        local key1 = key[1];
        local key2 = key[2];
        local key3 = key[3];
        local key4 = key[4];
        local sum = 0;
        for _ = 1, round do
            sum = sum + delta;
            data1 = data1 + (((data2 << 4) + key1) ~ (data2 + sum) ~ ((data2 >> 5) + key2));
            data2 = data2 + (((data1 << 4) + key3) ~ (data1 + sum) ~ ((data1 >> 5) + key4));
        end
        data[1] = data1;
        data[2] = data2;
    end,
    decrypt = function(data, key, delta, round)
        data, key, round, delta = checkParams(data, key, round, delta);
        local data1 = data[1];
        local data2 = data[2];
        local key1 = key[1];
        local key2 = key[2];
        local key3 = key[3];
        local key4 = key[4];
        local sum = delta * 32;
        for _ = 1, round do
            data2 = data2 - (((data1 << 4) + key3) ~ (data1 + sum) ~ ((data1 >> 5) + key4));
            data1 = data1 - (((data2 << 4) + key1) ~ (data2 + sum) ~ ((data2 >> 5) + key2));
            sum = sum - delta;
        end
        data[1] = data1;
        data[2] = data2;
    end
}).build());
