function I=GQ(ctau,Qtau)
global MD gamma p1 p2 
I = zeros(MD.n+1,MD.n+1);
b = beta(ctau);
r = b.*Qtau;
m = 2*exp(-gamma);

for i = 1:MD.n+1
    for j = 1:MD.n+1
        p1_i = squeeze(p1(i,:,:));
        p2_j = squeeze(p2(j,:,:));
        g1 = r.*(p1_i.*p2_j);
        I(i,j)=m.*Integrate(g1);
    end
end

end

