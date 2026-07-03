function F_tilde = F_tilde_function()
global par MD
F_tilde = zeros(1,MD.n+1);

for i = 1:MD.n+1
    x=(i-1)*MD.dx;
    F_tilde(i) = F(exp(x) - 1) / exp(x) -par.D / exp(2*x) ; 
end
end

function fF=F(x)
global par 
fF = g(x)-par.k1*x;
end

function fg=g(x)
global par 
   fg = par.g0+par.g1*(x^4)/(par.k2^4+x^4);
end

