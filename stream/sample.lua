-- samples for Stream
-- same as that in aul/stream/readme.md
-- 
-- @requirements：Stream
-- @author: xpecya

local Stream = require "aul.stream.Stream";

local function test(stream) 
    for k, v in pairs(stream) do
        print(k .. ":" .. v);
    end
end

--------------CREATE STREAM INSTANCE--------------

-- create an empty Stream
local emtpyStream = Stream.empty();

-- create a stream with given value
local valueStream = Stream.of(1, 2, 3, 4, 5);

-- create a Stream with a given table
-- Stream only cares about data found from ipairs function
local existedTable = {};
local tableStream = Stream.of(existedTable);

-- create a Stream with another Stream
local existedStream = Stream.empty();
local anotherStream = Stream.of(existedStream);

-- concat two existing stream
local streamA = Stream.of({1});
local streamB = Stream.of({2});
local concatStream = Stream.concat(streamA, streamB); -- same as Stream.of({1, 2})

--------------TOARRAY FUNCTION--------------

local stream = Stream.of(1, 2, 3, 4, 5);
stream.toArray(); -- {1, 2, 3, 4, 5}

--------------MAP FUNCTION--------------

local stream = Stream.of(1, 2, 3, 4, 5);
stream.map(function(item) 
    return item + 1;
end).toArray() -- {2, 3, 4, 5, 6}

local stream = Stream.of(1, 2, 3, 4, 5);
stream.map(function(item) 
    return tostring(item);
end).toArray(); -- {"1", "2", "3", "4", "5"}

local stream = Stream.of(1, 2, 3, 4, 5);
stream.map(function(item) 
    return item + 1;
end).map(function(item) 
    return tostring(item);
end).toArray(); -- {"2", "3", "4", "5", "6"}

--------------FILTER FUNCTION--------------

local stream = Stream.of(1, 2, 3, 4, 5);
stream.filter(function(item) 
    return item > 3;
end).toArray(); -- {4, 5}

local stream = Stream.of(1, 2, 3, 4, 5);
stream.map(function(item) 
    return item + 1;
end).filter(function(item) 
    return item > 3
end).toArray(); -- {4, 5, 6}

local stream = Stream.of(1, 2, 3, 4, 5);
stream.filter(function(item) 
    return item > 3;
end).map(function(item) 
    return item + 1;
end).toArray(); -- {5, 6}

--------------DISTINCT FUNCTION--------------

local stream = Stream.of(1, 1, 2, 2, 3, 3)
stream.distinct().toArray(); -- {1, 2, 3}

--------------FLATMAP FUNCTION--------------

local stream = Stream.of(1, 2, 3, 4, 5);
stream.flatMap(function(item) 
    return Stream.of(item);
end).map(function(item) 
    return item + 1;
end).toArray(); -- {2, 3, 4, 5, 6}

local stream = Stream.of({1, 2, 3}, {4, 5, 6}, {7, 8, 9})
stream.flatMap(function(item) 
    return Stream.of(item)
end).toArray(); -- {1, 2, 3, 4, 5, 6, 7 ,8 ,9}

--------------LIMIT FUNCTION--------------

local stream = Stream.of(1, 2, 3, 4, 5);
stream.limit(2).toArray(); -- {1, 2}

--------------SKIP FUNCTION--------------

local stream = Stream.of(1, 2, 3, 4, 5);
stream.skip(2).toArray(); -- {3, 4, 5}

--------------PEEK FUNCTION--------------

local stream = Stream.of(1, 2, 3, 4, 5);
stream.map(function(item) 
    return item + 1;
end).peek(function(item) 
    print(item) -- print 2 3 4 5 6 by order
end).filter(function(item) 
    return item > 3
end).peek(function(item) 
    print(item) -- print 4 5 6 by order
end).toArray() -- {4, 5, 6}

--------------SORT FUNCTION--------------

local stream = Stream.of(1, 5, 2, 4, 3)
stream.sort().toArray(); -- {1, 2, 3, 4, 5}

local stream = Stream.of(1, 5, 2, 4, 3)
stream.sort(function(a, b) 
    return a > b;
end).toArray(); -- {5, 4, 3, 2, 1}

--------------TOTABLE FUNCTION--------------

local stream = Stream.of(1, 2, 3, 4, 5);
stream.toTable(function(item) 
    return "value" .. item;
end, function(item) 
    return item;
end); -- {"value1" = 1, "value2" = 2, "value3" = 3, "value4" = 4, "value5" = 5}

--------------COUNT FUNCTION--------------

local stream = Stream.of(1, 2, 3, 4, 5);
stream.count(); -- 5
stream.filter(function(item) 
    return item > 3
end).count(); -- 2

--------------FOREACH FUNCTION--------------

local stream = Stream.of(1, 2, 3, 4, 5);
stream.map(function(item) 
    return item + 1;
end).peek(function(item) 
    print(item) -- print 2 3 4 5 6 by order
end).filter(function(item) 
    return item > 3
end).forEach(function(item) 
    print(item) -- print 4 5 6 by order
end)

--------------REDUCE FUNCTION--------------

local stream = Stream.of(1, 2, 3, 4, 5);
stream.reduce(function(a, b) 
    return a + b;
end) -- 15
