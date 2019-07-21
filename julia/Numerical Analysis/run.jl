include("./chapter_1/bisect.jl")
include("./chapter_1/fpi.jl")


f(x::Float64) = x^3-9

x = f(2.0)
println(x)

xc = bisect(f, 2.0, 3.0, 0.000005)
println("xc = ", xc)

f(x::Float64) = x + cos(x) -sin(x)
xc_fpi = fpi(f, 0, 20)

println("xc_fpi = ", xc_fpi)
