function Solve_Equation(Flag,f0,baseOutputDir)
global par     % The structure variable for model parameters
global MD      % Control variables.
global F_tilde_1 F_tilde_2 r1 r2 gamma Lambda a c p1 p2 Td


p();
load('p1.mat','p1');
load('p2.mat','p2');
F_tilde_1 = F1_tilde_function();
F_tilde_2 = F2_tilde_function();
gamma = par.mu*par.tau;
r1 = MD.dt/(MD.dx^2);
r2 = MD.dt/(2*MD.dx);
Lambda  = Lambda_function();
a = ac_function();
c = ac_function();


t = 0;
fkappa = kappa();
tau_index=floor(par.tau/MD.dt); % The index for the delays
Td=floor(par.tau/MD.dt)+1;
Qdelay=zeros(Td,MD.n+1,MD.n+1);

% Pre-define the valuables used for simulation
f = Initializationf(f0);    % Initialize the system.
Q = par.Qsum0*f;
Qsum1 = Integrate(Q);
Rf1 =zeros(MD.n+1,MD.n+1);

for i=1:Td
    Qdelay(i,1:MD.n+1,1:MD.n+1)=Q(1:MD.n+1,1:MD.n+1);   % Initialized the delays
end

if ~exist(baseOutputDir, 'dir')
    mkdir(baseOutputDir);
end

dirF    = fullfile(baseOutputDir, 'f');
dirRf   = fullfile(baseOutputDir, 'Rf');
dirQ    = fullfile(baseOutputDir, 'Q');

if ~exist(dirF, 'dir')
    mkdir(dirF);
end
if ~exist(dirRf, 'dir')
    mkdir(dirRf);
end
if ~exist(dirQ, 'dir')
    mkdir(dirQ);
end

fpQsum = fopen(fullfile(baseOutputDir, 'md-Qsum.dat'), 'w');

k=0;

fprintf(fpQsum,'%d %.4f %.4f\n',k, t, Qsum1);
dlmwrite(fullfile(dirF,  ['ft',  num2str(k), '.dat']), f);
dlmwrite(fullfile(dirRf, ['Rft', num2str(k), '.dat']), Rf1);
dlmwrite(fullfile(dirQ,  ['Qt',  num2str(k), '.dat']), Q);

% 计算速度的最大绝对值
max_F1 = max(abs(F_tilde_1(:)));
max_F2 = max(abs(F_tilde_2(:)));

% 对流项稳定条件判断
if max_F1 > 0 && max_F2 > 0
    convective_dt = min(MD.dx/max_F1, MD.dx/max_F2);
    if MD.dt < convective_dt
        fprintf('满足对流项稳定条件 (%.3e < %.3e)\n', MD.dt, convective_dt);
    else
        fprintf('【警告】不满足对流项稳定条件 (%.3e >= %.3e)\n', MD.dt, convective_dt);
    end
elseif max_F1 == 0 && max_F2 == 0
    fprintf('无对流项，跳过对流条件检查\n');
else
    % 使用 MATLAB 的 if-else 替代三元操作符
    if max_F1 > 0
        valid_dt = MD.dx / max_F1;
    else
        valid_dt = MD.dx / max_F2;
    end
    
    if MD.dt < valid_dt
        fprintf('满足对流项稳定条件 (%.3e < %.3e)\n', MD.dt, valid_dt);
    else
        fprintf('【警告】不满足对流项稳定条件 (%.3e >= %.3e)\n', MD.dt, valid_dt);
    end
end

% 扩散项精度条件判断
if par.D > 0
    diffusive_dt = (MD.dx)^2/(2*par.D);
    if MD.dt < diffusive_dt
        fprintf('满足扩散项精度条件 (%.3e < %.3e)\n', MD.dt, diffusive_dt);
    else
        fprintf('【注意】不满足扩散项精度条件 (%.3e >= %.3e)\n', MD.dt, diffusive_dt);
    end
else
    fprintf('扩散系数为零，跳过扩散条件检查\n');
end
step=1;
previousOutputF = [];
for t = MD.dt:MD.dt:MD.T
    
    C = Integrate(Q);
    fbeta = beta(C);
    f0 = -1.0 * Q.*(fbeta + fkappa);
    Qtau = FindDelay(Qdelay,tau_index,MD.n+1);
    ctau = Integrate(Qtau);
    I = GQ(ctau,Qtau);
    Q = Q + (f0+I)*MD.dt;
    
    Qsum = Integrate(Q);
    
    %         if ( (betabar> 0 && Qsum >= 1e-6) || (betabar == 0) )
    Rf = RF(ctau,Qtau,Qsum,f,C,fkappa);
    f = One_Step_Update(f,Rf);
    
    % Update the Qdelay
    for i = 1:Td-1
        Qdelay(i,1:MD.n+1,1:MD.n+1) = Qdelay(i+1,1:MD.n+1,1:MD.n+1);
    end
    Qdelay(Td,1:MD.n+1,1:MD.n+1) = Q(1:MD.n+1,1:MD.n+1);
    
    % Output the results
    if (mod(step,MD.ntpr)==0)
        k = k+1;
        fprintf(fpQsum,'%d %.4f %.4f\n',k, t, Qsum);
        dlmwrite(fullfile(dirF,  ['ft',  num2str(k), '.dat']), f);
        dlmwrite(fullfile(dirRf, ['Rft', num2str(k), '.dat']), Rf);
        dlmwrite(fullfile(dirQ,  ['Qt',  num2str(k), '.dat']), Q);


        if (MD.stopMode == 1) && (~isempty(previousOutputF))
            steadyError = norm(f - previousOutputF, 'fro');
            if steadyError < MD.steadyTolerance
                fprintf('Flag=%d reached steady state at t=%.4g, output f error=%.3e\n', ...
                    Flag, t, steadyError);
                break;
            end
        end

        previousOutputF = f;
    end
    step=step + 1;
    %         end
end
fclose(fpQsum);

end