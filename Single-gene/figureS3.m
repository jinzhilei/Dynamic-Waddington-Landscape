% Examine the dependence of landscape on the inheritance kernel
function figureS3()
global par D1 F1 MD
path = 'output/figureS3/';

psi0 = [0.1, 0.4, 0.1];
psi1 = [1.4, 1.0, 0.8];

Flag = 2;
Control();

ini={'left','right'};
for loop=1:1
    parameter();
    par.pssi0 = psi0(loop);
    par.pssi1 = psi1(loop);
    F1 = F_tilde_function();
    D1 = D_tilde_function();
    MD.T=500;
    MD.stopMode = 0; 
    for k=1:2
        [loop k]
        initialf = strcat('Initf/f1-2_',char(ini(k)),'.dat');
        f0 = Initializationf(initialf);
        [Ff, Fq, Fqsum, FRf] = Solve_Equation(Flag, f0);

        dlmwrite(strcat(path, 'md-',num2str(loop),'-f-',num2str(k),'.dat'), Ff,    ' ');
        dlmwrite(strcat(path, 'md-',num2str(loop),'-Q-',num2str(k),'.dat'), Fq,    ' ');
        dlmwrite(strcat(path, 'md-',num2str(loop),'-Qsum-',num2str(k),'.dat'), Fqsum, ' ');
        dlmwrite(strcat(path, 'md-',num2str(loop),'-Rf-',num2str(k),'.dat'), FRf,   ' ');
        end
end

end

