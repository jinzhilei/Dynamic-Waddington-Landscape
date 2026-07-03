%
% The function to define the control parameters
%

function Control()
global MD

MD.T=1000;    % The timing for total simulation
MD.dt=0.01;
MD.dx=0.03;
MD.xmax=2;
MD.xmin=0;
MD.ntpr=200; % Steps to write the output files.
MD.stopMode = 0;  % Specify the model of stoping the simulation.
                                              % 0: stop by the time MD.T
                                              % 1: stop by the f-error (MD.T large enough)
                                              % defined by MD.steadyTolerance
MD.steadyTolerance = 1e-6; % Steady-state stopping tolerance for f.
MD.n=size(MD.xmin:MD.dx:MD.xmax,2)-1; 

end
