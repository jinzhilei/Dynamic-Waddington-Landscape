function ff1 = Integrate(Q)
global MD


total_sum = sum(Q(:));  
ff1 = MD.dx^2 * total_sum;

end