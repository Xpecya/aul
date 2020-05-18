# Nil is DANGEROUS!!!!
<br />
There are hundreds of thousands of errors and mistakes caused by nil<br />
It doesn't mean that nil is a wrong design, but we must take good care of the nil value<br />
which means you always have to write code like this first: <br /><br />

    if data ~= nil then
        -- do your job 
    end

Sometimes if you forget this and a nil value was sent to your function...<br />
<b> Boooooooooooooooooooooooom!!! </b> <br />
<br />
Here is another way to avoid such problem. I call it Optional<br />
(which is already a well-known design for java programmers LOL)<br />
With optional, you always return non-nil value <br />
a value that will never be nil, or a Optional value that may be nil<br />
e.g. here is a function that may return nil value: 

    function mayReturnNil() 
        local result = nil;
        return result;
    end
    
now with Optional, it can be changed into another way;

    function neverReturnNil()
        return Optional:new(mayReturnNil());
    end
    
the function neverReturnNil is safe.<br />
<br />
the api for optional:<br />
build a new Optional object:

    local optional = Optional.new(data);

check if the value is present (not nil):

    if optional.isPresent() then
        -- do your job
    end
    
get value:

    -- may cause error when value is nil
    -- always check before get
    -- or use pcall function
    -- for your safety, I suggest you do both the check and pcall LOL
    -- or use fluent api below
    local value = optional.getValue();
    
get the value with a callback function, and resolve nil data with a errorHandling function:

    optional.ifPresent(function (data) 
        -- do you job with the data
    end).orElse(function () 
        -- resolve the nil value
    end)

notice that the value in the optional object is immutable<br />
there is no setter function for this object<br />
the only way to set the value is the constructor function<br />
so you don't need to worry about things like "I've already run the isPresent check, and it returns true, yet it still throws an error when I call the getValue function"
