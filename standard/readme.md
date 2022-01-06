## Enhanced Standard Libs

Standard provides some enhanced features for lua.<br />

## Printf

Lua only provides print function, so it is often needed to call string.format() first in order to print something complex<br />
Now with printf function:

    local standard = require "aul.standard.standard";
    local template = "foo = %s\r\n";
    standard.printf(template, "bar"); -- print 'foo = bar\r\n'

just like that in C. <br />
printf function will call string.format() function first, then call io.stdout:write() to print it<br />
Additionally, you can configure the function in standard.lua globally:

    require("aul.standard.standard").global();
    local template = "foo = %s\r\n";
    printf(template, "bar"); -- print 'foo = bar\r\n'

The global function needs to be called only once.<br />
And the printf function will then be configured in the global table.<br />
Nothing in standard.lua will shadow the Lua official lib<br />
It's safe. And also optional.<br />

## Enhanced table.remove() function

Table.remove() function in Lua can only remove the data in table array.<br />
If you try:

    local test = {
        foo = "bar"
    };
    table.remove(test, "bar");

Then an error will be thrown: bad argument #2 to 'remove' (number expected, got string)<br />
In the Enhanced version:

    -- It is safe. All official functions all supported
    local table = require "aul.standard.table";
    local test = {
        foo = "bar"
    };
    table.remove(test, "foo"); -- return "bar"
    print(test.foo); -- print nil

Besides, not only string values are available:

    local test = {};
    local keyFunction = function() 
        print("hello world");
    end
    test[keyFunction] = 10;
    table.remove(test, keyFunction); -- return 10;
    print(test[keyFunction]); -- print nil

The second param can be <b>ANYTHING</b>.<br />
If the second param is a number or nil then official table.remove() function will be used.<br />
Otherwise it is considered as the key of the given hash table<br />
And remove the value of this key, then return the value<br />
