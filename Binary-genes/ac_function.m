function acf = ac_function()
global MD r1
acf = zeros(1,MD.n+1);

for i = 1:MD.n+1
    x1 = (i-1)*MD.dx;
    acf(i) = r1*D_tilde(x1);

end

end