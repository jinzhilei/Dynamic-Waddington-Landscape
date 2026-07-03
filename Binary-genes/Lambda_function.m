function Lf = Lambda_function()
global MD r1
Lf = zeros(MD.n+1,MD.n+1);

for i = 1:MD.n+1
   x1 = (i-1)*MD.dx;
    for j = 1:MD.n+1
       x2 = (j-1)*MD.dx;
    Lf(i,j) = 1+2*r1*D_tilde(x1)+2*r1*D_tilde(x2); 

    end
end

