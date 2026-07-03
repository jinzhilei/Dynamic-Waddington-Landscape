function y=mybeta(Q,Flag)

global par MD

if (Flag == 0)   % R0
    y = zeros(1,MD.n+1);
elseif (Flag == 1) % Rbar
    b0 = par.betabar*ones(1,MD.n+1);
    y=par.theta^par.n/(par.theta^par.n + Q^par.n).*b0;
elseif (Flag == 2)  % Rfull
    b0 = zeros(1,MD.n+1);
    for i=1:MD.n+1
        x = (i-1)*MD.dx;
        b0(i)=par.betabar*par.K^par.m/(par.K^par.m + x^par.m);
    end
    y=par.theta^par.n/(par.theta^par.n + Q^par.n).*b0;
end

end