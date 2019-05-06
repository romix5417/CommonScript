#!/usr/bin/lua

local coxpt = setmetatable({}, { __mode = "kv" })

local tl_meta = {
    __index = function(self, key)

        print("__index key:", key)

		local t = rawget(self, coxpt[coroutine.running()] or coroutine.running() or 0)

		return t and t[key]
    end,

    __newindex = function(self, key, value)
        print("__newindex key:", key, value)
        return {}
    end
}


function threadcal(tbl)
    return setmetatable (tbl or {}, tl_meta)
end

context = threadcal()

print(type(context))
local ctx = context

c = ctx.tree

print(c)
print(not c)
