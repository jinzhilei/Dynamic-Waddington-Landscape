function y = kappa()
global par MD

y = zeros(MD.n+1, MD.n+1);

for i = 1:MD.n+1
    x1 = (i-1) * MD.dx;

    for j = 1:MD.n+1
        x2 = (j-1) * MD.dx;

        dx12 = abs(x1 - x2);

        y(i,j) = par.kappa0 + par.kappabar * ...
            (dx12^par.n_kappa) / ...
            (par.K_kappa^par.n_kappa + dx12^par.n_kappa);
    end
end

end
