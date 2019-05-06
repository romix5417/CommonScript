a = os.clock()

s = 1

for i = 1,100000000 do
    s = s * i
end

b = os.clock()

print(b-a)
