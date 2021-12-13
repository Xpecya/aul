# Stream

Stream api allows you control your array data in another way<br />

to create a Stream instance:

    local Stream = require "Stream";

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

Here are functions for stream instance: <br />

# Middle Function

the middle function means that this function will NOT execute directly<br />
it will be executed only if you call the collecing function<br />
you may use several middle functions as needed<br />
<br />
middle functions are: map, filter, distinct, flatMap, limit, peek, skip, sort

# Collecting Function

the collecting function is the function which ends the stream and collecte the result as needed<br />
all middle functions will be executed by the order you call them<br />
the Collecting function can only be executed once and the result is no longer a stream object<br />
<br />
collecting functions are: toTable, toArray, count, forEach, reduce

# toArray

toArray function will return the Stream result as an array-table:

    Stream.of(1, 2, 3, 4, 5).toArray(); -- {1, 2, 3, 4, 5}

nothing is updated in this example. Let's see other functions

# Map

map function allows you convert each item in the stream to another item

    -- Stream.of(1, 2, 3, 4, 5)
    stream.map(function(item) 
        return item + 1;
    end).toArray(); -- {2, 3, 4, 5, 6}

after the collecting function toArray is called, the map function is executed and each item plus 1<br />

of course you can change the type of the item:

    -- Stream.of(1, 2, 3, 4, 5)
    stream.map(function(item) 
        return tostring(item);
    end).toArray(); -- {"1", "2", "3", "4", "5"}

if you call several map functions at one time:

    -- Stream.of(1, 2, 3, 4, 5)
    stream.map(function(item) 
        return item + 1;
    end).map(function(item) 
        return tostring(item);
    end).toArray(); -- {"2", "3", "4", "5", "6"}

the map functions will be executed by the order you call them<br />
so firstly each item + 1, then convert every number to string<br />
and the result is as shown

# Filter

filter function allows you choose the data you need:

    -- Stream.of(1, 2, 3, 4, 5)
    stream.filter(function(item) 
        return item > 3;
    end).toArray(); -- {4, 5}

you may call other middle functions first then filter the data:

    -- Stream.of(1, 2, 3, 4, 5)
    stream.map(function(item) 
        return item + 1;
    end).filter(function(item) 
        return item > 3
    end).toArray(); -- {4, 5, 6}

or filter the data first then map them to another one:

    -- Stream.of(1, 2, 3, 4, 5)
    stream.filter(function(item) 
        return item > 3;
    end).map(function(item) 
        return item + 1;
    end).toArray(); -- {5, 6}

# distinct

    -- Stream.of(1, 1, 2, 2, 3, 3)
    stream.distinct().toArray(); -- {1, 2, 3}

distinct function use == to compare the data so __eq function in metatable is available

# flatMap

flatMap function will unpack the Stream to elements:

    -- Stream.of(1, 2, 3, 4, 5)
    stream.flatMap(function(item) 
        return Stream.of(item);
    end).map(function(item) 
        return item + 1;
    end).toArray(); -- {2, 3, 4, 5, 6}

the consuming function need to return a stream object and then the flatMap function will unpack the data in the stream and do other middle functions<br />
flatMap function is useful in dealing with other streams:

    -- Stream.of({1, 2, 3}, {4, 5, 6}, {7, 8, 9})
    stream.flatMap(function(item) 
        return Stream.of(item)
    end).toArray(); -- {1, 2, 3, 4, 5, 6, 7 ,8 ,9}

you would write much more codes to concat these together in other ways

# Limit

limit function only returns the sub array:

    -- Stream.of(1, 2, 3, 4, 5)
    stream.limit(2).toArray(); -- {1, 2}

useful when doing paging operations

# Skip

skip function will skip the data which you don't need:

    -- Stream.of(1, 2, 3, 4, 5)
    stream.skip(2).toArray(); -- {3, 4, 5}

useful when doing paging operations

# Peek

peek function lets you access the data without modification:

    -- Stream.of(1, 2, 3, 4, 5)
    stream.map(function(item) 
        return item + 1;
    end).peek(function(item) 
        print(item) -- print 2 3 4 5 6 by order
    end).filter(function(item) 
        return item > 3
    end).peek(function(item) 
        print(item) -- print 4 5 by order
    end).toArray() -- {4, 5}

peek function is useful when logging and caching

# Sort

sort function uses table.sort() function to sort the data in the particular order:

    -- Stream.of(1, 5, 2, 4, 3)
    stream.sort().toArray(); -- {1, 2, 3, 4, 5}

of course you can specify your own comparator function just like when you are using table.sort():

    -- Stream.of(1, 5, 2, 4, 3)
    stream.sort(function(a, b) 
        return a > b;
    end).toArray(); -- {5, 4, 3, 2, 1}

as you know, table.sort is not stable, so stream.sort is also not stable<br />
will only be stable when Lua offically update their sort function LOL

# toTable

toTable function, as mentioned before, is a collecting function<br />
it will collect the data with key-value pairs:

    -- Stream.of(1, 2, 3, 4, 5)
    stream.toTable(function(item) 
        return "value" .. item;
    end, function(item) 
        return item;
    end) -- {"value1" = 1, "value2" = 2, "value3" = 3, "value4" = 4, "value5" = 5}

toTable function has two args. the first function generator the key and the second function generate the value

# Count

count function will count the number of items in the stream:

    -- Stream.of(1, 2, 3, 4, 5)
    stream.count(); -- 5
    stream.filter(function(item) 
        return item > 3
    end).count(); -- 2

# forEach

forEach function iterates the data in the stream<br />
just like peek, but peek is a middle function while forEach is a collecting function:

    -- Stream.of(1, 2, 3, 4, 5)
    stream.map(function(item) 
        return item + 1;
    end).peek(function(item) 
        print(item) -- print 1 2 3 4 5 by order
    end).filter(function(item) 
        return item > 3
    end).forEach(function(item) 
        print(item) -- print 4 5 by order
    end)

notice that as a middle function, peek function will not execute immediately, yet forEach, as a collecting function, always do

# Reduce

reduce function accepts two elements in the stream and reduce them into one element, and the returned one element becomes the first arg in the coming reduce call:

    -- Stream.of(1, 2, 3, 4, 5)
    stream.reduce(function(a, b) 
        return a + b;
    end) -- 15

reduce function firstly add 1 and 2, then we get 3, then 3 becomes the first arg of reduce and 4, as the coming next element, becomes the second arg<br />
so reduce will add 3 and 3, and we get 6, then add 6 and 4, then we get 10, then add 10 and 5 and we get the final result 15 
