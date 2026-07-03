function A=CN()
global  MD D1 F1
r1 = MD.dt/(MD.dx^2); % 稳定性条件中的比值
r2 = 2*r1; % 稳定性条件中的比值
m = MD.n+1 -2;
A = zeros(m,m);
for i=1:m
    %对角线下方元素
    if(i>1)
       A(i,i-1)=-r1*D1(i);
    end
    %对角线元素 
     A(i,i)=1+r2*D1(i+1);
    %对角线上方元素
    if(i<m)
     A(i,i+1)=-r1*D1(i+2);
    end
end
A(1,1)=(1+r2*D1(2))-(r1*D1(1)*D1(2))/(D1(1)+MD.dx*F1(1));
A(m,m)=(1+r2*D1(MD.n))-(r1*D1(MD.n+1)*D1(MD.n))/(D1(MD.n+1)-MD.dx*F1(MD.n+1));
end
