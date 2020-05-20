-- @requirement => MetatableBuilder, Optional
-- @author xpecya
require "MetatableBuilder";
require "Optional";

Cache = {};

-- add a prefix before get or set data
-- so new data will not mask the functions
local prefix = "__";

local function get(cacheObject, key)
    assert(key ~= nil, "key is nil!");
    return Optional.new(cacheObject[prefix .. key]);
end

-- only return nil when defaultValue is nil
local function getOrDefault(cacheObject, key, defaultValue) 
    local result;
    get(cacheObject, key).ifPresent(function(data) 
        result = data;
    end).orElse(function() 
        result = defaultValue;
    end);
    return result;
end

local function set(cacheObject, key, value)
    assert(key ~= nil, "key is nil!");
    assert(value ~= nil, "value is nil!");
    cacheObject[prefix .. key] = value;
end

local function computeIfAbsent(cacheObject, key, supplier) 
    local result;
    get(cacheObject, key).ifPresent(function(data)
        result = data;
    end).orElse(function() 
        assert(type(supplier) == "function", "supplier is not a function!");
        result = supplier();
        assert(result ~= nil, "supplier supplied nil value!");
        set(cacheObject, key, result);
    end);
    return result;
end

-- remove the data of the key and return the former data
local function remove(cacheObject, key) 
    assert(key ~= nil, "key is nil!");
    local value;
    get(cacheObject, key).ifPresent(function(data) 
        cacheObject[prefix .. key] = nil;
    end).orElse(function() 
        print("key is not in the cache");
    end);
    return value;
end

function Cache.new()
    local cacheObject = {};
    setmetatable(cacheObject, MetatableBuilder.new().immutable().index({
        get = get,
        getOrDefault = getOrDefault,
        computeIfAbsent = computeIfAbsent,
        set = set,
        remove = remove
    }).mode("kv").build());
    return cacheObject;
end

return Cache;
