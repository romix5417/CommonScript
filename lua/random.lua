#!/usr/bin/lua

local seed=13579

function uniform_random(a, b)
    local t

    seed = 2045 * seed + 1
    seed = seed - math.modf(seed/1048576) * 1048576
    t = seed/1048576.0
    t = a + (b-a) * t

    return t
end

for i=0, 10, 1 do
    x=uniform_random(0, 100.0)
    print(x)
end
