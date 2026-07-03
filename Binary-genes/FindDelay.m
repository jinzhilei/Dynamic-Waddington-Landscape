% The function to find the delay of Qdelay with delay tau
function ft=FindDelay(fdelay, tau, n)
global Td 
ft=zeros(n,n);
for i=1:n
    for j=1:n
    ft(i,j)=fdelay(Td-tau,i,j);
    end
end
end
 