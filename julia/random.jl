#!/usr/bin/julia


function uniform_random(a, b, seed)
    local t

    seed = 2045 * seed + 1
    #println("seed1:", seed)
    seed = seed - ( seed / 1048576) * 1048576
    #println("seed2:", seed)
    t = seed/1048576.0
    t = a + (b-a) * t

    return t
end

seed=13579

for i=1:10

    #println("seed:",seed)

    x=uniform_random(0, 1.0, seed)
    print(x,'\n')
end
