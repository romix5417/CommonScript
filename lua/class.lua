#!/usr/bin/lua

local function _instantiate(class, ...)
    local inst = setmetatable({}, {__index = class})

    if inst.__init__ then
        inst:__init__(...)
    end

    return inst
end

function class(base)
    return setmetatable({},{
        __call  = _instantiate,
        __index = base
    })
end


car=class()

function car.__init__(self, wheel, door)
    self.wheel = wheel
    self.door = door
end

local bus = car(4, 4)


print(car,type(car))
print(bus.wheel, bus.door)
