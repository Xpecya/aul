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
so you don't need to worry about things like "I've already run the isPresent check, and it returns true, yet it still throws an error when I call the getValue function cuz someone changed the value in other coroutine. Damn it!"<br />
One more thing: There is <b>NOT</b> a single function that may return nil in the whole AUL project.<br />
I've already checked every function, and change the result to Optional if neccesory, whether the author is me or not.<br />
Have fun in this "No-Nil-World"<br />

<b>Nil很危险!</b><br />
<b>Nil很危险!</b><br />
<b>Nil很危险!</b><br />
<br />
重要的事情说三遍<br />
空指针导致的异常每天都在发生<br />
这并不是说nil是个不好的设计, 但这导致我们写代码的时候必须保持一万个小心<br />
我们不得不经常写大量的入参校验代码,如上方第一个代码块儿所示<br />
但俗话说的好,智者千虑必有一失<br />
(更何况菜鸡如我,虑不怎么虑,天天加班写bug嘤嘤嘤)<br />
万一你忘了校验 然后别人入参也一不小心 传了个空...<br />
你就又要通宵改bug了<br />
人艰不拆555555555555<br />
<br />
鉴于此, 为了创造一个没有空指针的世界 我们有了Optional<br />
(其实这个是从java里面抄的哈哈哈哈哈)<br />
(其实我主业是写java的哈哈哈哈哈)<br />
(惊不惊喜? 意不意外? 刺不刺激?)<br />
利用Optional 我们就可以创造一个没有任何空指针的世界了!!!<br />
欢呼吧!!!!<br />
<br />
用法和用例上面都有,我懒得再写一份了(就是这么懒 啦啦啦啦啦)<br />
要强调的是, optional的data是不可变的 唯一设置data的方式就是构造函数<br />
因此你不用担心说, 你在自己的协程里做过非空校验(isPresent方法)但是搞不好数据被别的协程改了然后回到你自己的协程又GG的问题<br />
此外 在整个AUL项目中 所有的函数都<b>不</b>会直接返回nil<br />
我仔细检查过这里面的所有方法 包括我写的和别人写的<br />
享受这个没有nil的世界吧<br />
