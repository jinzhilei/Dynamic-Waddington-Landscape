function f = Initializationf(f0)
global MD
% load('ode_solution.mat','f');  
% f=load('ft20000.dat'); %3st
% f=load('ft3400.dat'); %2st

f = f0 / Integrate(f0);
end