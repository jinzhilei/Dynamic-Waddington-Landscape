%
% The function to define the control parameters
%

function Control()
global MD
MD.T=2000;    % The timing for total simulation
MD.dt=0.01;
MD.dx=0.005;
MD.xmax=1.4;
MD.ntpr=100;                       % Steps to write the outpu files.
MD.n=size(0:MD.dx:MD.xmax,2)-1;  % MD.n = n
MD.stopMode = 1;              % Specify the model of stoping the simulation. 
                                              % 0: stop by the time MD.T
                                              % 1: stop by the f-error (MD.T large enough)
                                              % defined by MD.steadyTolerance 
MD.steadyTolerance = 1e-6;  
end





