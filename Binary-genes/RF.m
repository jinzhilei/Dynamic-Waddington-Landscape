function Rf=RF(ctau,Qtau,Qsum,f,C,fkappa)
 global MD gamma p1 p2
I1 = zeros(MD.n+1,MD.n+1);
% g3 = f; 
b = beta(ctau);
b1 = beta(C);
% Int3 = Integrate(g3);%积分结果应该是1
r = b.*Qtau;
m1 = 2*exp(-gamma)/Qsum;
m2 = f.*(b1+fkappa);%m2=g4
Int2 = Integrate(r);
I2 = m1*Int2.*f;
I3 = m2;
for i = 1:MD.n+1
    for j = 1:MD.n+1
        p1_i = squeeze(p1(i,:,:));
        p2_j = squeeze(p2(j,:,:));
        g1 = r.*p1_i.*p2_j;
        I1(i,j)=m1.*Integrate(g1);
    end
end
Int4=Integrate(m2);
I4=f.*Int4;
Rf=I1-I2-I3+I4;
end

