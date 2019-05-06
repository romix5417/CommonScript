#!/usr/bin/lua

local coroutine = require("coroutine")

local co = coroutine.create(
    function()
        for i = 1, 10 do
            print("times:", i, "hello world!")
            local context = coroutine.running()
            print(context,type(context))
            coroutine.yeild(i)

        end
    end
)

print(co, type(co))
print(coroutine.status(co))
result = coroutine.resume(co)
print(coroutine.status(co), result)
