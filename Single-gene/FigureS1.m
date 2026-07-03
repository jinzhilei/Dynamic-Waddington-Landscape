function FigureS1()
global MD D1 F1

Flag = 0;
Control();
parameter();
MD.T = 5000;
MD.stopMode = 1;
DX = load('Initf/dx_to_use');
m = size(DX,1);
path = 'output/figureS1/';
for k=1:m
    k
    MD.dx = DX(k);
    x = 0:MD.dx:MD.xmax;
    MD.n=size(0:MD.dx:MD.xmax,2)-1;
    F1 = F_tilde_function();
    D1 = D_tilde_function();
    f0 = ones(size(x));
    f0 = f0/(Integrate(f0));
    [Ff, Fq, Fqsum, FRf] = Solve_Equation(Flag, f0);
    dlmwrite(strcat(path, 'md-',num2str(Flag),'-f-',num2str(k),'.dat'), Ff,    ' ');
    dlmwrite(strcat(path, 'md-',num2str(Flag),'-Q-',num2str(k),'.dat'), Fq,    ' ');
    dlmwrite(strcat(path, 'md-',num2str(Flag),'-Qsum-',num2str(k),'.dat'), Fqsum, ' ');
    dlmwrite(strcat(path, 'md-',num2str(Flag),'-Rf-',num2str(k),'.dat'), FRf,   ' ');
end
end