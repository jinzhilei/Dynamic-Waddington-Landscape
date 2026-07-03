function y = beta(Q)
global par MD
y = zeros(MD.n+1, MD.n+1);
for i = 1:MD.n+1
    x1 = (i-1)*MD.dx;
    for j = 1:MD.n+1
        x2 = (j-1)*MD.dx;
        y(i,j) = par.betabar ...
            * par.K_beta^par.n_beta / (par.K_beta^par.n_beta + abs(x1-x2)^par.n_beta) ...
            * par.Theta_beta^par.m_beta / (par.Theta_beta^par.m_beta + Q^par.m_beta);
    end
end
end
