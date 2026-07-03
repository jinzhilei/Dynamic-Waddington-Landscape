%
% The function to set up the model parameters
% Set the parameter Flag for different applications 
%

function parameter()
global par


par.Qsum0 = 1000;

par.alpha10=0.16;
par.s1=6;
par.alpha11=0.46;
par.alpha12=1.07;

par.alpha20=0.16;
par.s2=6;
par.alpha21=1.07;
par.alpha22=0.46;

par.pssi110=0.64;
par.pssi111=0.22;
par.s11=2;
par.a11=0.22;

par.pssi120=0.20;
par.pssi121=0.18;
par.s12=8;
par.a12=0.64;

par.zzeta110=10.38;
par.zzeta111=20.46;
par.sz11=4;
par.az11=0.38;

par.zzeta120=2.95;
par.zzeta121=0.15;
par.sz12=4;
par.az12=0.42;

%二维基因调控网络中的参数
par.a1=1;
par.a2=1;
par.b1=1;
par.b2=1;
par.k1=1;
par.k2=1;
par.n=4;
par.thetaa1=0.5;
par.thetab1=0.5;
par.thetaa2=0.5;
par.thetab2=0.5;
par.D=0.02;
%Kappa
par.kappa0 = 0.03;
par.kappabar = 0.7;
par.K_kappa = 0.7;
par.n_kappa = 2;

%beta
par.betabar = 1;
par.K_beta = 0.4;
par.n_beta = 2;
par.m_beta = 3;
par.Theta_beta =1e6;


par.mu=0.024;
par.tau=4;

        
end