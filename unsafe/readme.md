## Unsafe is EXTREMELY DANGEROUS!

This part is really important, so I need to make sure everything's clear.<br />
The following content will be written in Chinese<br />
Please read it with Google translation if needed<br />
Sorry for the inconvenience<br />

好了，封印解除，开始说中文。<br />
这个包，如名所述，包含了许多不安全的内容。<br />
其核心设计目的，在于暴露一些，很有用但没有直接暴露在用户态的lua C api<br />
之所以没有暴露，当然就是因为，这些东西，确实可能把你的电脑<b>搞炸</b>。<br />
Take Care and Let's get started<br />

在正式开始介绍api之前，讲一下编译的问题:<br />
unsafe包含一个很薄的c语言层<br />
所以如果要使用，需要首先编译一下<br />

    gcc -shared -fPIC -o internal.so aul/unsafe/unsafe.c

然后把这个文件拷贝到你的lua_path能找到的地方<br />
aul内部查找这个文件的路径为: aul.unsafe.unsafe.internal<br />
后续会做一个makefile 或者Cmake来处理这个问题<br />
什么时候有时间的吧<br />

然后说api<br />

首先，创建一个Unsafe实例是很简单的：

    local I_know_what_I_am_doing_and_it_is_fxxking_safe = require "aul.unsafe.Unsafe";

创建一个Unsafe实例本身并不会导致什么不安全的事情发生，本质上就是创建了一个table和一个对应的metatable，所以你可以放心创建。<br />
但是我建议你在整个生命周期中只创建一个，然后复用这一个<br />
因为创建多个也没什么用<br />
这是一个无状态的对象<br />

下面开始，所有的内容，都是<b>不安全</b>的<br />

1. 获取当前的state => getState


    local state = I_know_what_I_am_doing_and_it_is_fxxking_safe.getState();

这个方法返回的是当前lua进程对应的lua_State结构体的指针，是一个light userdata<br />
这个指针一方面你可以在后续的方法中使用，同时拿着这个指针其实可以直接进行一些更骚的操作了<br />
比如获取，甚至改变这个结构体内部部分数据的内容<br />
但这些更骚的东西的封装我不打算做。<br />
一来，unsafe这个包的目的就在于，单纯的暴露lua的标准c api, 而查看乃至魔改state结构体数据可不包含在标准api之中<br />
二来，这个操作实在是太危险了。我可不希望你们把自己的电脑搞炸了然后给我提issue<br />
因此这部分是不会有的，我只给你们暴露一个light userdata 剩下的你们看着办<br />

2. 检查当前lua栈的容量 => checkStack


    -- 要检查的容量
    local size = 1024;
    local result = I_know_what_I_am_doing_and_it_is_fxxking_safe.checkStack(size);

这个方法是lua_checkstack的封装，作用也和checkstack一致，查看当前栈是否还有用户指定的容量<br />
返回值是boolean类型，返回true表示容量还够，false表示已经不够了<br />
容量不足的时候，当你使用了size量的内存，会触发lua栈的自动扩容，这个东西会影响性能<br />
所以在做性能测试和性能优化的时候这个函数会很实用<br />
整个unsafe包中为数不多的，也许不那么危险的操作<br />
不想加之一，应该没有之一，就是最安全的一个<br />

3. 创建一个table => createTable

    
    -- table数组部分长度
    local narr = 10;
    -- table哈希表部分长度
    local nrec = 20;
    local newTable = I_know_what_I_am_doing_and_it_is_fxxking_safe.createTable(narr, nrec);

通过底层C api 直接创建一个拥有指定容量的table<br />
在你确信默认创建的table的容量不够，肯定会触发扩容的场合，使用这个api可以减少你table扩容的次数<br />
但是实际上，经过实测，通过{nil, nil, nil}这样创建table，比通过createTable(3)，创建的速度要更快, 内存占用也更小<br />
因此在容量小的时候还是推荐手动写nil来创建table<br />
但如果你说我需要一个1024长度的数组table 我为了不触发自动扩容我要写{nil, nil, ... nil} 这样1024个nil 那我今日也不用干别的了，这个代码看着也太冗长了<br />
那你可以用我这个api<br />
或者考虑写一个代码生成器<br />
<b>注意：这个方法可能导致爆栈</b><br />
所以前面一个api的价值就体现出来了<br />
总之，创建的时候悠着点<br />

4. 想玩什么玩什么吧 => getExtraSpace


    local extraSpace = I_know_what_I_am_doing_and_it_is_fxxking_safe.getExtraSpace();

这个方法是lua_getextraspace的封装。返回值是一个light userdata, extra space的指针。<br />
这个东西相信熟悉lua的人应该都知道，一般拿来做个缓存啊，尤其是io数据的缓存什么的<br />
当然你想玩什么花活儿也成，电脑搞炸了别给我提issue，一概不受理<br />

5. 生个崽玩玩 => createNewState


    -- 是否公开包含所有标准库 默认包含
    local includeStandardLibs = true;
    local newState = I_know_what_I_am_doing_and_it_is_fxxking_safe.createNewState(includeStandardLibs);

这个方法是luaL_newstate方法的封装，会创建一个新的lua_State，并返回这个指针，以light userdata的方式<br />
可以指定是否调用luaL_openlibs函数来让这个State包含lua标准库 默认是包含的，如果调用函数传false则不包含<br />
通过这种方式，你在lua层面也可以像服务后台一样创建虚拟机，并通过不同的虚拟机来执行不同的lua脚本<br />
就像后台服务一样<br />
<b>注意： 这个方法只创建了一个新虚拟机，没有创建新线程。所有通过新lua_State执行的命令都会在当前线程，准确来说是当前协程中进行</b><br />
创建线程不属于lua c的标准api，unsafe项目也不会包含这部分内容<br />
你可以通过coroutine.wrap等方式来让不同的state工作在不同的协程上<br />
这样做的好处（之一）在于，每一个state中添加的全局变量是不会污染其他state的<br />
当然还有更多的玩法，但是那就不在这里多说了，懂的都懂<br />

6. 执行个脚本 => doFile


    -- state使用nil的场合，调用当前state
    local state = nil;
    -- 要调用的lua脚本文件名
    local fileName = "foo.lua";
    -- 执行脚本
    I_know_what_I_am_doing_and_it_is_fxxking_safe.doFile(state, fileName);

这个方法是luaL_dofile的封装。在state为nil的场合，会直接调用标准库的dofile()<br />
但是，联系到上一个接口：

    local state = I_know_what_I_am_doing_and_it_is_fxxking_safe.createNewState();
    local fileName = "foo.lua";
    I_know_what_I_am_doing_and_it_is_fxxking_safe.doFile(state, fileName);

就可以让另一个lua state跑你指定的lua文件了。<br />
后续可能会添加dostring的封装，但是也不一定，这个可以考虑<br />

此外，在unsafe.h中，我列举了一系列我不打算做的api<br />
主要理由都是，你可以直接在lua层面很简单实现的功能，就不要用unsafe折腾<br />
未来Unsafe可能会有所扩充，但是确定不会做的依然不会做<br />
已经明确讲了的，就不要发issue问我xxx能不能做 问就是不能<br />

That's all!<br />
Have fun!<br />
Be careful<br />
