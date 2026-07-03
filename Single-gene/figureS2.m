% Examine the dependence of landscape on proliferation rate \beta and the
% remove rate \kappa
function figureS2()
%var_beta();
var_kappa();
end

function var_beta()
global par D1 F1
path = 'output/figureS2/beta/';

Bs = load(strcat(path,'barbeta_to_use'));
n = size(Bs,1);


Flag = 2;
Control();
parameter();

for k=1:n
    k
    par.betabar = Bs(k);
    F1 = F_tilde_function();
    D1 = D_tilde_function();
    initialf = 'Initf/f0-2.dat';
    f0 = Initializationf(initialf);
    [Ff, Fq, Fqsum, FRf] = Solve_Equation(Flag, f0);

    dlmwrite(strcat(path, 'md-',num2str(Flag),'-f-',num2str(k),'.dat'), Ff,    ' ');
    dlmwrite(strcat(path, 'md-',num2str(Flag),'-Q-',num2str(k),'.dat'), Fq,    ' ');
    dlmwrite(strcat(path, 'md-',num2str(Flag),'-Qsum-',num2str(k),'.dat'), Fqsum, ' ');
    dlmwrite(strcat(path, 'md-',num2str(Flag),'-Rf-',num2str(k),'.dat'), FRf,   ' ');
end

end

function var_kappa()
global par D1 F1
path = 'output/figureS2/kappa/';

Bs = load(strcat(path,'kappa0_to_use'));
n = size(Bs,1);


Flag = 2;
Control();
parameter();

for k=1:n
    k
    par.kappa0 = Bs(k);
    F1 = F_tilde_function();
    D1 = D_tilde_function();
    initialf = 'Initf/f0-2.dat';
    f0 = Initializationf(initialf);
    [Ff, Fq, Fqsum, FRf] = Solve_Equation(Flag, f0);

    dlmwrite(strcat(path, 'md-',num2str(Flag),'-f-',num2str(k),'.dat'), Ff,    ' ');
    dlmwrite(strcat(path, 'md-',num2str(Flag),'-Q-',num2str(k),'.dat'), Fq,    ' ');
    dlmwrite(strcat(path, 'md-',num2str(Flag),'-Qsum-',num2str(k),'.dat'), Fqsum, ' ');
    dlmwrite(strcat(path, 'md-',num2str(Flag),'-Rf-',num2str(k),'.dat'), FRf,   ' ');
end

end