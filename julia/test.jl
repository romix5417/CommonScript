#!/usr/bin/julia

a = time()

s = 1
for i=1:100000000
    global s*=i
end

b = time();

print(b-a)
print("\n")
