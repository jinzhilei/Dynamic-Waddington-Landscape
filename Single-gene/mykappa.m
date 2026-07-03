function y=mykappa(Flag)
global MD par


if (Flag == 0)   % R0
    y = zeros(1,MD.n+1);
elseif (Flag == 1) % Rbar
    y = par.kappa0*ones(1,MD.n+1);
elseif (Flag == 2)  % Rfull
    y = zeros(1,MD.n+1);
    for i = 1:MD.n+1
        x = (i-1)*MD.dx;
        y(i) = par.kappa0*(1/(1+(par.b1*x)));
    end
elseif (Flag == 3)  % constant beta0
    y = zeros(1,MD.n+1);
end

end



