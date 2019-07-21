function bisect(f, a, b, tol)
    println("a = ", a, " b = ", b, " tol = ", tol)
    c = 0.0

    while (b - a) / 2 > tol
        c = (b + a) / 2
        if f(c) == 0
            return c
        end

        if f(a) * f(c) < 0
            b = c
        else
            a = c
        end
    end

    c = (b + a) / 2
    return c
end
