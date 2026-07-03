
%
% The function to initialize the state.
%

function f=Initializationf(initialf)
global MD D1 F1


f = load(initialf, ' ');

%%%%%%%%%%%%%%%%%%%%%
f(1) = (D1(2)*f(2))/(MD.dx*F1(1)+D1(1));
f(end) = (D1(MD.n)*f(MD.n))/(D1(MD.n+1)-MD.dx*F1(MD.n+1));

f=f/(Integrate(f));
end