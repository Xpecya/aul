-- @requirements: MetatableBuilder, Stream
-- @author: xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";
local Stream = require "aul.stream.Stream"

return setmetatable({}, MetatableBuilder.new().immutable().index({
    new = function(...)
        local queue = {};
        local data = { ... };
        local headIndex = 1;
        local tailIndex = #data;

        local function queueNext(_, index)
            local localIndex = index + headIndex;
            if localIndex > tailIndex then
                return nil;
            end
            return index + 1, data[localIndex];
        end

        local function queuePairs()
            return queueNext, nil, 0;
        end

        return setmetatable(queue, MetatableBuilder.new().immutable().index({
            push = function(item)
                assert(item ~= nil, "input is nil!");
                table.insert(data, item);
                tailIndex = tailIndex + 1;
            end,
            pop = function()
                local result = data[headIndex];
                if headIndex <= tailIndex then
                    headIndex = headIndex + 1;
                else
                    -- 初始化
                    data = {};
                    headIndex = 1;
                    tailIndex = 0;
                end
                return result;
            end,
            stream = function()
                return Stream.of(queue);
            end
        }).pairs(queuePairs).ipairs(queuePairs).build());
    end
}).build());
