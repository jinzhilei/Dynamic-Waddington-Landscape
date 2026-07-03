function RunR_full()
global F1 D1

%% Initialized model simulation
Flag = 2;
Control();
parameter();
F1 = F_tilde_function();
D1 = D_tilde_function();
initialf = 'Initf/f0-1.dat';
f0 = Initializationf(initialf);
%% End of initialization

[Ff, Fq, Fqsum, FRf] = Solve_Equation(Flag, f0);

path = 'output/R2/';
dlmwrite(strcat(path, 'md-',num2str(Flag),'-f.dat'), Ff,    ' ');
dlmwrite(strcat(path, 'md-',num2str(Flag),'-Q.dat'), Fq,    ' ');
dlmwrite(strcat(path, 'md-',num2str(Flag),'-Qsum.dat'), Fqsum, ' ');
dlmwrite(strcat(path, 'md-',num2str(Flag),'-Rf.dat'), FRf,   ' ');

end