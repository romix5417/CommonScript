--exstart=os.clock()
--print(exstart)

local tbl={}

local function create_random()
    print("create random")
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    for i=1,1024 do
        tbl[i]=math.random(1,100)
    end
end

create_random()

redis.call('set', KEYS[1], tbl)

--exend=os.clock()
--print(exend)
