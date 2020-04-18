function out  = activationFunction(a)
    if(a <= -2)
        out = 0;
    elseif(a >= 2)
        out = 1;
    else 
        out = a/4 + 0.5;
    end
end

