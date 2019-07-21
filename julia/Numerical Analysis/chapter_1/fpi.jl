function fpi(f, x0, k)
    x = zeros(k+1)
    x[1] = x0
    for i = 1:k
        x[i+1] = f(x[i])
    end

    return x[k+1]
end
