function f1 = One_Step_Update(f,Rf)
global MD a c Lambda F_tilde_1 F_tilde_2 par

% 安全检查初始值
if any(isnan(f(:))) || any(isinf(f(:)))
    error('第k层变量f包含NaN/Inf，无法进行时间步更新');
end
[D1, D2] = D_vectors();


f = apply_no_flux_bc(f, D1, D2);

C1 = zeros(MD.n+1, MD.n+1);
C2 = zeros(MD.n+1, MD.n+1);

for i = 2:MD.n
    for j = 2:MD.n
        % x1方向
        if F_tilde_1(i,j)>0
            C1(i,j) = (f(i,j)*F_tilde_1(i,j)-f(i-1,j)*F_tilde_1(i-1,j))/MD.dx;
        else
            C1(i,j) = (f(i+1,j)*F_tilde_1(i+1,j)-f(i,j)*F_tilde_1(i,j))/MD.dx;
        end    
        % x2方向
        if F_tilde_2(i,j)>0
            C2(i,j) = (f(i,j)*F_tilde_2(i,j)-f(i,j-1)*F_tilde_2(i,j-1))/MD.dx;
        else
            C2(i,j) = (f(i,j+1)*F_tilde_2(i,j+1)-f(i,j)*F_tilde_2(i,j))/MD.dx;
        end
    end
end

b1 = MD.dt*C1;
b2 = MD.dt*C2;
if par.betabar==0
    b3 = 0;
else
    b3 = MD.dt*Rf;
end
b = f-b1-b2+b3;

%初始化迭代变量
x = f;

x = apply_no_flux_bc(x, D1, D2);

tol = 1e-6;
max_iter = 1000;

% 红黑排序Gauss-Seidel迭代
for iter = 1:max_iter
    max_diff = 0;
    % 第一遍：红点更新 (i+j为偶数)
    for i = 2:MD.n
        for j = 2:MD.n
             if mod(i+j,2) == 0  % 红点条件               
                z = (a(i+1)*x(i+1,j)+c(j+1)*x(i,j+1)+a(i-1)*x(i-1,j)+c(j-1)*x(i,j-1)+b(i,j))/Lambda(i,j);
                % 记录旧值并更新
                old_val = x(i,j);
                x(i,j) = z;  % 直接使用新值
                max_diff = max(max_diff, abs(x(i,j) - old_val));
                
            end
        end
    end

    % 第二遍：黑点 (i+j为奇数)
   for i = 2:MD.n
        for j = 2:MD.n
            if mod(i+j,2) == 1  % 黑点条件
                 z = (a(i+1)*x(i+1,j)+c(j+1)*x(i,j+1)+a(i-1)*x(i-1,j)+c(j-1)*x(i,j-1)+b(i,j))/Lambda(i,j);
                
                % 记录旧值并更新
                old_val = x(i,j);
                x(i,j) = z;  % 直接使用新值
                max_diff = max(max_diff, abs(x(i,j) - old_val));
            end
        end
   end

x = apply_no_flux_bc(x, D1, D2);
   
   % 增强收敛检测 (相对误差)
    rel_diff = max_diff / (max(1, max(abs(x(:)))));
    if rel_diff < tol
%        fprintf('收敛于 %d 次迭代, 相对误差 %.2e\n', iter, rel_diff);
        break;
    end
    
   
end

if iter == max_iter
    warning('未在%d次迭代内收敛, 最终误差=%.2e', max_iter, max_diff);
end

% 负值检测（忽略极小的舍入误差）
neg_threshold = -1e-20;  % 只关心比这更负的值
if any(x(:) < neg_threshold)
    neg_idx = find(x(:) < neg_threshold);
    warning('存在 %d 个负值点，最小值 = %.6e', length(neg_idx), min(x(:)));
end


% 归一化
integral_val = Integrate(x);
if integral_val < 1e-10
    warning('积分值过小 (%.3e)，使用上一时间步值', integral_val);
    f1 = f;  % 回退到安全值
else
    f1 = x / integral_val;
end

end



function u = apply_no_flux_bc(u, D1, D2)
global MD F_tilde_1 F_tilde_2

% ---- 四条边（不含角点）----
j = 2:MD.n;
denL = D1(1) + MD.dx .* F_tilde_1(1,j);      % x1=0
denR = D1(MD.n+1) - MD.dx .* F_tilde_1(MD.n+1, j);      % x1=L
u(1,j) = (D1(2).* u(2,j))./denL;
u(MD.n+1,j) = (D1(MD.n) .* u(MD.n,j))./denR;

i = 2:MD.n;
denB = D2(1) + MD.dx.*F_tilde_2(i, 1);           % x2=0
denT = D2(MD.n+1) - MD.dx .* F_tilde_2(i, MD.n+1);      % x2=L
u(i,1) = (D2(2).*u(i,2))./denB;
u(i,MD.n+1) = (D2(MD.n).*u(i, MD.n))./denT;

% ---- 四角点：两条边界公式各算一次再平均 ----
% (1,1)
den11_x1 = D1(1) + MD.dx * F_tilde_1(1,1);
den11_x2 = D2(1) + MD.dx * F_tilde_2(1,1);
u11_x1   = (D1(2) * u(2,1)) / den11_x1;
u11_x2   = (D2(2) * u(1,2)) / den11_x2;
u(1,1)   = 0.5*(u11_x1 + u11_x2);

% (1,MD.n+1)
den1N_x1 = D1(1)      + MD.dx * F_tilde_1(1,MD.n+1);
den1N_x2 = D2(MD.n+1) - MD.dx * F_tilde_2(1,MD.n+1);
u1N_x1   = (D1(2)    * u(2,MD.n+1)) / den1N_x1;
u1N_x2   = (D2(MD.n) * u(1,MD.n))   / den1N_x2;
u(1,MD.n+1) = 0.5*(u1N_x1 + u1N_x2);

% (MD.n+1,1)
denN1_x1 = D1(MD.n+1) - MD.dx * F_tilde_1(MD.n+1,1);
denN1_x2 = D2(1)      + MD.dx * F_tilde_2(MD.n+1,1);
uN1_x1   = (D1(MD.n) * u(MD.n,1))/ denN1_x1;
uN1_x2   = (D2(2)* u(MD.n+1,2))/ denN1_x2;
u(MD.n+1,1) = 0.5*(uN1_x1 + uN1_x2);

% (MD.n+1,MD.n+1)
denNN_x1 = D1(MD.n+1) - MD.dx * F_tilde_1(MD.n+1,MD.n+1);
denNN_x2 = D2(MD.n+1) - MD.dx * F_tilde_2(MD.n+1,MD.n+1);
uNN_x1   = (D1(MD.n) * u(MD.n,MD.n+1))/ denNN_x1;
uNN_x2   = (D2(MD.n) * u(MD.n+1,MD.n))/ denNN_x2;
u(MD.n+1,MD.n+1) = 0.5*(uNN_x1 + uNN_x2);

end


function [D1, D2] = D_vectors()
global MD
D1 = zeros(1, MD.n+1);
D2 = zeros(1, MD.n+1);
for i = 1:MD.n+1
    x1 = (i-1)*MD.dx;
    D1(i) = D_tilde(x1);
    D2(i) = D_tilde(x1);
end
end
