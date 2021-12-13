# METATABLE IS EXTREMELY FXXKING POWERFUL!!!!!!
<br />
This is a helper utility in building metatables<br />
with FLUENT APIS<br />
To Use this, you need to get a new builder instance first:<br /><br />

    local MetatableBuilder = require "MetatableBuilder";
    local builderInstance = MetatableBuilder.new();

Then set the properties you need for this metatable:<br /><br />

    // set metatable for a table instance
    setmetatable({}, builderInstance
        .immutable() // which means this table is immutable
        .index(function (table, index) 
            if index == "foo" then 
                return "bar";
            end
            return nil;
        end) // set table.foo = "bar"
        .build() // build the metatable
    );

MetatableBuilder supports <b>ALL</b> metatable features<br />
You may find more supported features in the source code<br />
AUL use this builder EVERYWHERE<br />
This Builder is really FXXKING USEFUL!<br />
Please have a try! Hope you enjoy it
