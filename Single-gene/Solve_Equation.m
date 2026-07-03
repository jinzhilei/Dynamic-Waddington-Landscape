function [Ff, Fq, Fqsum, FRf] = Solve_Equation(Flag, f0)
global par MD tau_index F1 D1 Laplace_A fkappa p0

p0 = p();           % The inheritance function

Laplace_A = CN();

fkappa = mykappa(Flag);
tau_index = floor(par.tau/MD.dt); % The index for the delays
Qdelay = zeros(tau_index+1, MD.n+1);
fdelay = zeros(tau_index+1, MD.n+1);

% Pre-define the valuables used for simulation
f = f0;    % Initialize the system.
Q = par.Qsum0*f;
t = 0;

for i=1:tau_index+1
    Qdelay(i,1:MD.n+1)=Q(1:MD.n+1);   % Initialized the delays
    fdelay(i,1:MD.n+1)=f(1:MD.n+1);
end

% 预分配输出矩阵
m = floor((MD.T/MD.dt)/MD.ntpr) + 1; % Extra row for the final steady-state output.
Ff    = zeros(m, MD.n+2);     % [t, f]
Fq    = zeros(m, MD.n+2);     % [t, Q]
Fqsum = zeros(m, 3);          % [t, Qsum, Error]
FRf   = zeros(m, MD.n+2);     % [t, Rf]

step = 1;
k = 1;

Ff(k,1)    = t;  Ff(k,2:end)    = f;
Fq(k,1)    = t;  Fq(k,2:end)    = Q;
Fqsum(k,1) = t;  Fqsum(k,2)  = par.Qsum0; Fqsum(k, 3) = 100;

previousOutputF = -1.0*f;  % Initialize previousOutputF to store the f from the previous output time.

for t = MD.dt:MD.dt:MD.T
    if Flag == 3
        ftau = FindDelay(fdelay, tau_index, MD.n+1);
        [f, Rf] = fsolve_Update(f, 1, 1, ftau, Flag);
        Q = f;
        Qsum = Integrate(Q);
        for i = 1:tau_index
            fdelay(i,1:MD.n+1) = fdelay(i+1,1:MD.n+1);
        end
        fdelay(tau_index+1,1:MD.n+1) = f(1:MD.n+1);
    else
        [f, Rf, Q, Qdelay] = One_Step_Update(f, Q, Qdelay, Flag);
        Qsum = Integrate(Q);
    end

    % Output the results
    if mod(step, MD.ntpr) == 0
        steadyError = max(abs(f - previousOutputF));
        k = k+1;
        Ff(k,1)    = t;  Ff(k,2:end)    = f;
        Fq(k,1)    = t;  Fq(k,2:end)    = Q;
        Fqsum(k,1) = t;  Fqsum(k,2)  = Qsum; Fqsum(k, 3) = steadyError;
        FRf(k,1)   = t;  FRf(k,2:end)   = Rf;

        if (MD.stopMode == 1)  &&  (steadyError < MD.steadyTolerance) % Determine if we need to stop the simulation by f-error
            break;
        end
    end

    previousOutputF = f;
    step=step + 1;
end

Ff = Ff(1:k, :); % Remove unused preallocated rows.
Fq = Fq(1:k, :);
Fqsum = Fqsum(1:k, :);
FRf = FRf(1:k, :);

end