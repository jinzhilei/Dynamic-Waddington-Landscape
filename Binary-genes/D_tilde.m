function Dt = D_tilde(x)
global par 
    Dt = par.D / exp(2*x);
end

