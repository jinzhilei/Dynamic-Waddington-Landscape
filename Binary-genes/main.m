% The two-dimensional gene regulatory network without self-activation (i.e., Flag = 1, 2) has two steady states; the initial values are in ft3400.dat.
% The two-dimensional gene regulatory network with self-activation (i.e., Flag = 3, 4) has three steady states; the initial values are in ft20000.dat.
% For the proliferation operator R[f] = 0, set par.kappa0 = 0; par.kappabar = 0; par.betabar = 0.

function main(Flag)

%Flag = 0: The model without self-activation
%Flag = 1: The gene circuit with self-activation

tic

global par

Control();          % Set the simulation controls;
parameter();

Bs=load('barbeta_to_use');
m=size(Bs,1);
switch Flag 
    case 0  % No self-activation, no proliferation: two steady states, R[f] = 0.
        par.a1=0;
        par.a2=0; 
        f0 = load('ft3400.dat');
    case 1  % Self-activation, no proliferation: three steady states, R[f] = 0.
        f0 = load('ft20000.dat');
end
for k=1:1
    [Flag k]
    if k==1
        par.kappa0 = 0;
        par.kappabar=0;
        par.betabar = 0;
    else
        par.betabar = Bs(k);
    end
    baseOutputDir = strcat('output/',num2str(Flag),'-',num2str(k));
    Solve_Equation(Flag,f0,baseOutputDir);    
end

toc
end



