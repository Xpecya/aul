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
        local sum = 0;
        for _ = 1, round do
            data1 = data1 + (((data2 << 4) ~ (data2 >> 5) + data2) ~ (sum + key[(sum & 3) + 1]));
            sum = sum + delta;
            data2 = data2 + (((data1 << 4) ~ (data1 >> 5) + data1) ~ (sum + key[((sum >> 11) & 3) + 1]));
        end
        data[1] = data1;
        data[2] = data2;
    end,
    decrypt = function(data, key, delta, round)
        data, key, round, delta = checkParams(data, key, round, delta);
        local data1 = data[1];
        local data2 = data[2];
        local sum = delta * 32;
        for _ = 1, round do
            data2 = data2 - (((data1 << 4) ~ (data1 >> 5) + data1) ~ (sum + key[((sum >> 11) & 3) + 1]));
            sum = sum - delta;
            data1 = data1 - (((data2 << 4) ~ (data2 >> 5) + data2) ~ (sum + key[(sum & 3) + 1]));
        end
        data[1] = data1;
        data[2] = data2;
    end
}).build());
