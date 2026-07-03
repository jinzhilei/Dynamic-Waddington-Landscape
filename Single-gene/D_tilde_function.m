function D_tilde = D_tilde_function()
global par MD
D_tilde = zeros(1,MD.n+1);
for i = 1:MD.n+1
    x=(i-1)*MD.dx;
    D_tilde(i)= par.D / exp(2*x);
end
end
