function [f, Rf, Q, Qdelay] = One_Step_Update(f, Q0, Qdelay, Flag)
global MD  tau_index

Qtau0 = FindDelay(Qdelay,tau_index,MD.n+1);
c = Integrate(Q0);
ctau = Integrate(Qtau0);

[f, Rf] = fsolve_Update(f, c, ctau, Qtau0,Flag);

if (Flag == 0)   % R0
    Q = Q0;
else
    Q = Qsolve_Update(c, Q0, Qtau0, Flag);
    % Update the Qdelay
    for i = 1:tau_index
           Qdelay(i,1:MD.n+1) = Qdelay(i+1,1:MD.n+1);
    end
    Qdelay(tau_index+1,1:MD.n+1) = Q(1:MD.n+1);
end                    

end