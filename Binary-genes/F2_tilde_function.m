function F2_tilde = F2_tilde_function()
global par MD
F2_tilde = zeros(MD.n+1,MD.n+1);

for i = 1:MD.n+1
   x1 = (i-1)*MD.dx;
    for j = 1:MD.n+1
       x2 = (j-1)*MD.dx;
       X11 = exp(x1) - 1;
       X22 = exp(x2) - 1;
    F2_tilde(i,j) = F2(X11,X22)/exp(x2)-par.D/exp(2*x2); 
    end
end
end

function fF2=F2(x1,x2)
global par 
fF2 = (par.a2*x2^par.n)/(par.thetaa2^par.n+x2^par.n)+(par.b2*par.thetab2^par.n)/(par.thetab2^par.n+x1^par.n)-par.k2*x2;
end

