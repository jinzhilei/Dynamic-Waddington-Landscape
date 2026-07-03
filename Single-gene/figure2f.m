function figure2f()
global F1 D1

path = 'output/figure2f/';

Control();
parameter();
F1 = F_tilde_function();
D1 = D_tilde_function();

ini={'left','right'};
for Flag = 0:2
    for k=1:2
        [Flag k]
        initialf = strcat('Initf/f1-2_',char(ini(k)),'.dat');
        f0 = Initializationf(initialf);
    
        [Ff, Fq, Fqsum, FRf] = Solve_Equation(Flag, f0);
    
        dlmwrite(strcat(path, 'md-',num2str(Flag),'-f-',char(ini(k)),'.dat'), Ff,    ' ');
        dlmwrite(strcat(path, 'md-',num2str(Flag),'-Q-',char(ini(k)),'.dat'), Fq,    ' ');
        dlmwrite(strcat(path, 'md-',num2str(Flag),'-Qsum-',char(ini(k)),'.dat'), Fqsum, ' ');
        dlmwrite(strcat(path, 'md-',num2str(Flag),'-Rf-',char(ini(k)),'.dat'), FRf,   ' ');
    end
end
end