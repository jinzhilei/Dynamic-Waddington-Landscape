function Q = Qsolve_Update(c, Q0, Qtau0, Flag)
global MD p0 par fkappa

fbeta = mybeta(c, Flag);
f0 = -1.0 * Q0.*(fbeta + fkappa);
ctau = Integrate(Qtau0);
gi = 2*(mybeta(ctau, Flag).*Qtau0)*exp(-par.gamma); % The coefficient 2*exp(-mu*tau) * beta(c_tau,y) * Q(t-tau, y)
g0 = MD.dx *gi * p0'-(MD.dx/2)*(gi(1)*p0(:,1)' + gi(MD.n+1)*p0(:,MD.n+1)');
Q = Q0 + (f0+g0)*MD.dt;
end