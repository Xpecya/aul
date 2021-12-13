# Collections
<br />
Here are some useful collections<br />
<br />

# Queue: FIFO List
To create a new Queue Object:
    
    local Queue = require "Queue";
    local queueInstance = Queue.new();

To add an element to this queue:
    
    queueInstance.add(element);

To remove the first element from this queue:
    
    local removedElement = queueInstance.remove();

Notice that the remove function will return the removed element

To get the first element in the queue without removing:
    
    local head = queueInstance.head();

To get the last element in the queue:

    local tail = queueInstance.tail();

Notice that both head and tail functions are NOT returning the copy so any updates of the returned element will modify the element in the queue instance!

To iterate the queue, use iterator function:

    local iterator = queueInstance.iterator();
    while (iterator.hasNext()) do 
        local element = iterator.next();
        -- do something with the element
    end

also pairs and ipairs is supported:

    queueInstance.add("a");
    queueInstance.add("b");
    queueInstance.add("c");
    for k, v in pairs(queueInstance) do 
        print(k .. ":" .. v);
    end
    -- 1:a
    -- 2:b
    -- 3:c
    for k, v in ipairs(queueInstance) do 
        print(k .. ":" .. v);
    end
    -- 1:a
    -- 2:b
    -- 3:c

use #queueInstance to get the length of the queue:

    queueInstance.add("foo");
    queueInstance.add("bar");
    print(#queueInstance); -- 2

convert queue to Stream:

    queueInstance.stream();

For details in Stream see stream/readme.md

# Stack: FILO List

To create a new Stack Object:
    
    local Stack = require "Stack";
    local stackInstance = Stack.new();

To push an element into this stack:
    
    stackInstance.push(element);

To pull the first element out of this stack:
    
    local pulledElement = stackInstance.pull();

To get the first element in the stack without pulling:
    
    local head = stackInstance.head();

Notice the head will NOT return the copy so any updates of the returned element will modify the element in the stack instance!

To iterate the stack, use iterator function:

    local iterator = stackInstance.iterator();
    while (iterator.hasNext()) do 
        local element = iterator.next();
        -- do something with the element
    end

also pairs and ipairs is supported:

    stackInstance.push("a");
    stackInstance.push("b");
    stackInstance.push("c");
    for k, v in pairs(stackInstance) do 
        print(k .. ":" .. v);
    end
    -- 1:a
    -- 2:b
    -- 3:c
    for k, v in ipairs(stackInstance) do 
        print(k .. ":" .. v);
    end
    -- 1:a
    -- 2:b
    -- 3:c

use #stackInstance to get the length of the queue:

    stackInstance.push("foo");
    stackInstance.push("bar");
    print(#stackInstance); -- 2

convert stack to Stream:

    stackInstance.stream();

For details in Stream see stream/readme.md
