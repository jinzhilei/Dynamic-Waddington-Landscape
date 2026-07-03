function [f, Rf] = fsolve_Update(f,c,ctau,Qtau, Flag)
global MD F1 D1 Laplace_A fkappa p0 par

if (Flag == 0)
    Rf = zeros(1,MD.n+1);
elseif (Flag == 1)
    I1 = G1(f, ctau, Qtau,Flag);
    Rf = (2/c)*I1;
elseif (Flag == 2)
    I1 = G1(f, ctau, Qtau,Flag);
    I2 = G2(f, c, fkappa, Flag);
    Rf = (2/c)*I1 - f.*I2;
elseif (Flag == 3)
    ftau = Qtau;
    g0 = MD.dx*ftau*p0' - (MD.dx/2)*(ftau(1)*p0(:,1)' + ftau(MD.n+1)*p0(:,MD.n+1)');
    Rf = 2*par.betabar*exp(-par.gamma).*(g0 - f);
end

C = zeros(1, MD.n+1);
for i = 2:MD.n
    if F1(i) > 0
        C(i) = (f(i)*F1(i) - f(i-1)*F1(i-1))/MD.dx;
    else
        C(i) = (f(i+1)*F1(i+1) - f(i)*F1(i))/MD.dx;
    end
end


b1 = MD.dt*C(2:end-1);
b2 = MD.dt*Rf(2:end-1);
b = f(2:end-1)- b1+b2;

f_new = Laplace_A\b';
f(2:end-1) = f_new;
f(1) = (D1(2)*f(2))/(MD.dx*F1(1)+D1(1));
f(end) = (D1(MD.n)*f(MD.n))/(D1(MD.n+1)-MD.dx*F1(MD.n+1));
if any(f < 0)
    neg_idx = find(f < 0);
    warning('存在 %d 个负值点，最小值 = %.6e', length(neg_idx), min(f));
end
f = f/(Integrate(f));
end

function I1=G1(f,ctau,Qtau,Flag)
global MD p0 par

I1 = zeros(1,MD.n+1);
g11 = zeros(1,MD.n+1);
b = mybeta(ctau,Flag);
for i=1:MD.n+1
    for j=1:MD.n+1
        g1 = p0(i,j)' - f(i);
        g11(j) = b(j)*Qtau(j)*exp(-par.gamma)*g1;
    end
    I1(i) = MD.dx *sum(g11)-(MD.dx/2)*(g11(1)+g11(end));
end
end

function I2=G2(f, c, fkappa, Flag)
global  MD 
I2 = zeros(1,MD.n+1);
g2 = zeros(1,MD.n+1);
b = mybeta(c,Flag);
for i=1:MD.n+1
    for j = 1:MD.n+1
        g2(j)= f(j)*(b(j)+fkappa(j));
    end
    I2(i)=(b(i)+fkappa(i))*Integrate(f)-Integrate(g2);
end
end
