%
% The function to set up the model parameters
% Set the parameter Flag for different applications 
%

function parameter()
global par

par.Qsum0 = 1000;

par.zzeta0=60;
par.pssi0=0.1;
par.pssi1=1.4;
par.s=4;
par.a=0.75;

par.mu=2.4*10^(-2);
par.tau=2;

par.g0 = 0.5;
par.g1 = 4.2;
par.D  = 0.1;
par.k1 = 2.0;
par.k2 = 1.25;

% par.g0=0.2;
% par.g1=4.2;
% par.D=0.5;
% par.k1=2;
% par.k2=1.2;



par.kappa0 =0.02;
par.b1 = 4;

par.betabar=0.8;
par.theta=1e6;
par.n=1;
par.m=4;
par.K=0.7;        

par.gamma = par.mu*par.tau;
end