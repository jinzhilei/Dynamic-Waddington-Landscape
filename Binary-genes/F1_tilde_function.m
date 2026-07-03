function F1_tilde = F1_tilde_function()
global par MD
F1_tilde = zeros(MD.n+1,MD.n+1);

for i = 1:MD.n+1
    x1 = (i-1)*MD.dx;
    for j = 1:MD.n+1
        x2 = (j-1)*MD.dx;
        X11 = exp(x1) - 1;
        X22 = exp(x2) - 1;
        F1_tilde(i,j) = F1(X11,X22)/exp(x1)-par.D/exp(2*x1);
    end
end

end

function fF1=F1(x1,x2)
global par
fF1 = (par.a1*x1^par.n)/(par.thetaa1^par.n+x1^par.n)+(par.b1*par.thetab1^par.n)/(par.thetab1^par.n+x2^par.n)-par.k1*x1;
end

