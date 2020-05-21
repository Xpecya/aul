local function getValueTest(optional) 
    local status, errorMessage = pcall(optional.getValue);
    if status then
        print(string.format("optional.getValue method invoke success! data = %s", errorMessage));
    else 
        print(string.format("optional.getValue method invoke failed! errorMessage = %s", errorMessage));
    end
end

local function ifPresentTest(optional) 
    optional.ifPresent(print).orElse(function()
        print("optional's data is nil!");
    end);
end

local function OptionalSample() 
    local Optional = require "Optional";

    local nilData = nil;
    local nilOptional = Optional.new(nilData);
    -- print: optional.getValue method invoke failed! errorMessage = /usr/lib/lua/5.3/Optional.lua:12: value is nil!
    getValueTest(nilOptional);
    -- print: optional's data is nil!
    ifPresentTest(nilOptional);

    local notNilData = {};
    local notNilOptional = Optional.new(notNilData);
    -- print: optional.getValue method invoke success! data = table: 0x558746c62090
    getValueTest(notNilOptional);
    -- print: table: 0x558746c62090
    ifPresentTest(notNilOptional);
end

OptionalSample();
