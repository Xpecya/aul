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
    getValueTest(nilOptional);
    ifPresentTest(nilOptional);

    local notNilData = {};
    local notNilOptional = Optional.new(notNilData);
    getValueTest(notNilOptional);
    ifPresentTest(notNilOptional);
end

OptionalSample();
