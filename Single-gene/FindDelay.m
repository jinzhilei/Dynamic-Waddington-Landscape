% The function to find the delay of Qdelay with delay tau
function ft=FindDelay(fdelay, tau, n)
global tau_index

Td=tau_index+1;
ft=zeros(1, n);
for i=1:n
    ft(i)=fdelay(Td-tau,i);
end
end
