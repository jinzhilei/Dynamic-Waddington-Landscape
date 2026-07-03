
function ff1=Integrate(f)
global MD

ff1  = MD.dx * (sum(f) - (1/2)*(f(1)+f(end)));

end