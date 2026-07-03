function RunR_star()
global F1 D1 par

path = 'output/Rstar/';

Flag = 3;
Control();
parameter();
F1 = F_tilde_function();
D1 = D_tilde_function();
initialf = 'Initf/f0-1.dat';
f0 = Initializationf(initialf);

pssi0 = [0.1, 0.9, 0.1];
pssi1 = [1.4, 1.4, 0.85];
parameter();
for k=1:3
      par.pssi0 = pssi0(k);
      par.pssi1 = pssi1(k);
      [Ff, Fq, Fqsum, FRf] = Solve_Equation(Flag, f0);
      dlmwrite(strcat(path, 'md-',num2str(Flag),'-f-',num2str(k),'.dat'), Ff,    ' ');
      dlmwrite(strcat(path, 'md-',num2str(Flag),'-Q-',num2str(k),'.dat'), Fq,    ' ');
      dlmwrite(strcat(path, 'md-',num2str(Flag),'-Qsum-',num2str(k),'.dat'), Fqsum, ' ');
      dlmwrite(strcat(path, 'md-',num2str(Flag),'-Rf-',num2str(k),'.dat'), FRf,   ' ');
end
end