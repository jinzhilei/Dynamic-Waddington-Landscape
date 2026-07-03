function Initializationsetting()
global MD

Control();
parameter();

A=load('Initf/dx_to_use');
m=size(A,1);
for i=1:m
    MD.dx = A(i);
    MD.n = numel(0:MD.dx:MD.xmax) - 1;

    x = 0:MD.dx:MD.xmax;
    f0 = exactSteadyState(x);
    x_split = findInternalMinimum(x, f0);
    [f_left, f_right] = splitAndNormalize(x, f0, x_split);

    dlmwrite(strcat('Initf/f0-',num2str(i),'.dat'), f0, 'delimiter', ' ');
    dlmwrite(strcat('Initf/f1-',num2str(i),'_left.dat'), f_left, 'delimiter', ' ');
    dlmwrite(strcat('Initf/f1-',num2str(i),'_right.dat'), f_right, 'delimiter', ' ');
    dlmwrite(strcat('Initf/x-',num2str(i),'_saddle_initial.dat'), x_split, 'delimiter', ' ', 'precision', '%.12f');

end
end

function f = exactSteadyState(x)
global MD

f = zeros(1, MD.n + 1);

for i = 1:MD.n + 1
    f(i) = solveForW(x(i));
end

f = f / Integrate(f);
end

function x_split = findInternalMinimum(x, f)
global MD

buffer = 5 * MD.dx;
candidate_idx = find(x > buffer & x < MD.xmax - buffer);
local_min_idx = candidate_idx( ...
    f(candidate_idx) <= f(candidate_idx - 1) & ...
    f(candidate_idx) <= f(candidate_idx + 1));

if isempty(local_min_idx)
    error('No internal minimum of f(x) was found. Please check the parameters or reduce the buffer.');
end

[~, mid_idx] = min(abs(x(local_min_idx) - MD.xmax / 2));
x_split = x(local_min_idx(mid_idx));
end

function [f_left, f_right] = splitAndNormalize(x, f0, x_split)
left_idx = x < x_split;
right_idx = x > x_split;

norm_left = trapz(x(left_idx), f0(left_idx));
norm_right = trapz(x(right_idx), f0(right_idx));

if norm_left <= 0 || norm_right <= 0
    error('The split produced an empty or non-positive branch. Please check x_split.');
end

f_left = zeros(size(f0));
f_right = zeros(size(f0));
f_left(left_idx) = f0(left_idx) / norm_left;
f_right(right_idx) = f0(right_idx) / norm_right;
end

function [W, integralValue] = solveForW(x)
integrand = @(s) F_tilde(s) ./ D_tilde(s);
integralValue = simpsons_rule(integrand, 0, x, 101);
W = exp(integralValue) / D_tilde(x);
end

function F_t = F_tilde(x)
global par

F_t = F(exp(x) - 1) / exp(x) - par.D / exp(2 * x);
end

function D_t = D_tilde(x)
global par

D_t = par.D / exp(2 * x);
end

function result = simpsons_rule(f, a, b, n)
h = (b - a) / n;
result = 0;

for i = 1:n
    x_left = a + (i - 1) * h;
    x_right = a + i * h;
    x_mid = x_left + h / 2;
    result = result + (f(x_left) + 4 * f(x_mid) + f(x_right)) * h / 6;
end
end

function fF = F(x)
global par

fF = g(x) - par.k1 .* x;
end

function fg = g(x)
global par

fg = par.g0 + par.g1 .* (x .^ 4) / (par.k2 .^ 4 + x .^ 4);
end
