% The two-dimensional gene regulatory network without self-activation (i.e., Flag = 1, 2) has two steady states; the initial values are in ft3400.dat.
% The two-dimensional gene regulatory network with self-activation (i.e., Flag = 3, 4) has three steady states; the initial values are in ft20000.dat.
% For the proliferation operator R[f] = 0, set par.kappa0 = 0; par.kappabar = 0; par.betabar = 0.

function main()

tic

global par

Control();          % Set the simulation controls;
parameter();
Flag  = 2;
switch Flag
    case 1  % No self-activation, no proliferation: two steady states, R[f] = 0.
        par.a1=0;
        par.a2=0; 
        par.kappa0 = 0;
        par.kappabar=0;
        par.betabar = 0;
        f0 = load('ft3400.dat');
        Solve_Equation(Flag,f0);  
    case 2 % No self-activation, with proliferation: two steady states.
        par.a1=0;
        par.a2=0;
        par.betabar = 5;
        f0 = load('ft3400.dat');
        Solve_Equation(Flag,f0);    
    case 3 % Self-activation, no proliferation: three steady states, R[f] = 0.
        par.kappa0 = 0;
        par.kappabar=0;
        par.betabar = 0;
        f0 = load('ft20000.dat');
        Solve_Equation(Flag,f0);  
    case 4 % Self-activation, with proliferation: three steady states.
        f0 = load('ft20000.dat');
        Solve_Equation(Flag,f0);  
end

toc
end



