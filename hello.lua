print ("bonjour")

function fibo (n)
    if n == 0 then
        return 1
    end
    if n == 1 then
        return 1
    end
    return fibo (n-1) + fibo (n-2)
end

--print ("result",fibo(4))

