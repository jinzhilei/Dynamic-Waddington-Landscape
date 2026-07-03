function dataanalysis()

for Flag = 3
for l = 1
    Ff = load_output(Flag,l,'f');
    Fq = load_output(Flag,l,'Q');
    FRf = load_output(Flag,l,'Rf');
    Fqsum = load_output(Flag,l,'Qsum');

    fprintf('Loaded Flag=%d, l=%d\n', Flag, l);
    fprintf('f:    %d x %d\n', size(Ff,1), size(Ff,2));
    fprintf('Q:    %d x %d\n', size(Fq,1), size(Fq,2));
    fprintf('Rf:   %d x %d\n', size(FRf,1), size(FRf,2));
    fprintf('Qsum: %d x %d\n', size(Fqsum,1), size(Fqsum,2));

    base_fig = (l-1)*10;

    plot_profiles(base_fig + 1,Ff,'f(t,x)');
    plot_error(base_fig + 2,Ff,'Error of f');

    plot_profiles(base_fig + 3,Fq,'Q(t,x)');
    plot_error(base_fig + 4,Fq,'Error of Q');

    plot_profiles(base_fig + 5,FRf,'Rf(t,x)');
    plot_error(base_fig + 6,FRf,'Error of Rf');

    figure(base_fig + 7);
    clf();
    plot(Fqsum(:,1),Fqsum(:,2),'b','LineWidth',2);
    set(gca,'FontName','Times New Roman','FontSize',14);
    xlabel('t','FontName','Times New Roman','FontSize',16);
    ylabel('Total number of cells Q','FontName','Times New Roman','FontSize',16);
    title('Qsum');
end
end

end

function A=load_output(Flag,l,name)
filename=sprintf('output/md-%d-%s-%d.dat', Flag, name, l);
if exist(filename,'file')
    A=load(filename);
    return;
end

legacy_filename=sprintf('output/md-%s%d.dat', name, l);
if exist(legacy_filename,'file')
    A=load(legacy_filename);
    return;
end

older_filename=sprintf('output/md%s-%d.dat', name, l);
if exist(older_filename,'file')
    A=load(older_filename);
    return;
end

error('Cannot find %s data file. Expected %s, %s, or %s.', name, filename, legacy_filename, older_filename);
end

function plot_profiles(fig_id,A,y_label)
figure(fig_id);
clf();

nplots = min(20,size(A,1));
plot_idx = round(linspace(1,size(A,1),nplots));
for i=1:nplots
    j=plot_idx(i);
    subplot(4,5,i);
    plot(A(j,2:end),'LineWidth',1);
    xlabel('x');
    ylabel(y_label);
    title(strcat('t=',num2str(A(j,1))));
end
end

function plot_error(fig_id,A,y_label)
figure(fig_id);
clf();

nsteps = size(A,1)-1;
if nsteps < 1
    warning('Not enough rows to compute %s.', y_label);
    return;
end

Z=zeros(nsteps,2);
for i=1:nsteps
    Z(i,1)=A(i,1);
    Z(i,2)=max(abs(A(i+1,2:end)-A(i,2:end)));
end

semilogy(Z(:,1),Z(:,2),'-b','LineWidth',2);
set(gca,'FontName','Times New Roman','FontSize',14);
xlabel('t','FontName','Times New Roman','FontSize',16);
ylabel(y_label,'FontName','Times New Roman','FontSize',16);
fprintf('%s: %.2e to %.2e\n', y_label, min(Z(:,2)), max(Z(:,2)));
end
