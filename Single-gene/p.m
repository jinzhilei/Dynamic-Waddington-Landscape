function p0=p()
global MD
p0=zeros(MD.n+1,MD.n+1);
p=zeros(MD.n+1,MD.n+1);
% when eta is near zero

for i=1:MD.n+1
    x = (i-1)*MD.dx;
    for j=1:MD.n+1
        y = (j-1)*MD.dx;
        a=zzeta(y);
        b=pssi(y)/zzeta(y);
        p(i,j)=gampdf(x,a,b);
    end
end

for i=1:MD.n+1
    z=trapz(p(:,i)) * MD.dx;
    p0(:,i)=p(:,i)/z;
end

end

function z=pssi(x)
global par
z=par.pssi0 + par.pssi1 *power(x,par.s)/(power(par.a,par.s) + power(x,par.s));
end

function m=zzeta(x)
global par
m=par.zzeta0;
end