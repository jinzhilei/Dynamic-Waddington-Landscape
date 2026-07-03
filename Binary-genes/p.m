function p()
global MD
p1=zeros(MD.n+1,MD.n+1,MD.n+1);
p2=zeros(MD.n+1,MD.n+1,MD.n+1);
intp1=zeros(MD.n+1,MD.n+1);
intp2=zeros(MD.n+1,MD.n+1);
n=MD.n+1;
for i=1:n
    x1 = (i-1)*MD.dx;
    x2 = (i-1)*MD.dx;
    for k=1:n
        y1 = (k-1)*MD.dx;
        for l=1:n
            y2 = (l-1)*MD.dx;
            a11 = zzeta11(y1);
            b11 = pssi11(y1)/zzeta11(y1);
            a12 = zzeta12(y1);
            b12 = pssi12(y1)/zzeta12(y1);
            a21 = zzeta11(y2);
            b21 = pssi11(y2)/zzeta11(y2);
            a22 = zzeta12(y2);
            b22 = pssi12(y2)/zzeta12(y2);
            p1(i,k,l) = alpha1(y1,y2)*gampdf(x1,a11,b11)+(1-alpha1(y1,y2))*gampdf(x1,a12,b12);
            p2(i,k,l) = alpha2(y1,y2)*gampdf(x2,a21,b21)+(1-alpha2(y1,y2))*gampdf(x2,a22,b22);
        end
    end
end

for k = 1:n
    for l = 1:n
        intp1(k,l) = trapz(p1(:,k,l)) * MD.dx;  % 使用矩形法则进行数值积分
        p1(:,k,l) = p1(:,k,l)/intp1(k,l);
    end
end

save('p1.mat', 'p1');

for k = 1:n
    for l = 1:n
        intp2(k,l) = trapz(p2(:,k,l)) * MD.dx;  % 使用矩形法则进行数值积分
        p2(:,k,l) = p2(:,k,l)/intp2(k,l);
    end
end
% p2 = p2./intp1;
save('p2.mat', 'p2');


end
function m=zzeta11(x)
global par
m=par.zzeta110+par.zzeta111*power(x,par.sz11)/(power(par.az11,par.sz11) + power(x,par.sz11));
end
function m=zzeta12(x)
global par
m=par.zzeta120+par.zzeta121*power(x,par.sz11)/(power(par.az12,par.sz12) + power(x,par.sz12));
end
function z=pssi11(x)
global par
z=par.pssi110 + par.pssi111 *power(x,par.s11)/(power(par.a11,par.s11) + power(x,par.s11));
end
function z=pssi12(x)
global par
z=par.pssi120 + par.pssi121 *power(x,par.s12)/(power(par.a12,par.s12) + power(x,par.s12));
end

function n=alpha1(y1,y2)
global par
n=par.alpha10 + (power(y1,par.s1)/(power(par.alpha11,par.s1)+power(y1,par.s1)))*(1/(power(par.alpha12,par.s1)+power(y2,par.s1)));
end
function n=alpha2(y1,y2)
global par
n=par.alpha20 + (1/(power(par.alpha21,par.s2)+power(y1,par.s2)))*(power(y2,par.s2)/(power(par.alpha22,par.s2)+power(y2,par.s2)));
end