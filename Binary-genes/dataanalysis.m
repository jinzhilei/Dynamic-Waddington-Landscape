function dataanalysis()
global MD
Control();
% total_time = 10000;  % 总时间
% step = 1000;           % 实际保存步长
total_time = 5000;  % 总时间
step = 200;           % 实际保存步长
total_steps=total_time/MD.dt;
num = total_steps/step + 1; % 计算实际文件数量

file_namesf = cell(1, num);
file_namesQ = cell(1, num);

for k = 1:num
    time_step = (k-1) * step;
    file_namesf{k} = sprintf('output_2/output_2_f/ft%d.dat', time_step);
    file_namesQ{k} = sprintf('output_2/output_2_Q/Qt%d.dat', time_step);    
end

figure(1);
clf();
for i = 1:20
    j = 100*i;
    subplot(4,5,i)
    f = load(file_namesf{j});
    [x1, x2] = ndgrid(MD.xmin:MD.dx:MD.xmax,MD.xmin:MD.dx:MD.xmax);  % 生成网格
    surf(x1, x2, f);  % 绘制三维表面图
    xlabel('X1');
    ylabel('X2');
    zlabel('f');
    title(['Surface Plot of f (File ' num2str(j) ')']);
end
errors = zeros(1, num-1);
for i =1:num-1
    f1 = load(file_namesf{i});
    f2 = load(file_namesf{i+1});
    error = norm(f2-f1, 'fro');
    errors(i) = error;
end
figure(2);
clf();
time_points = (1:num-1) * step*MD.dt;
semilogy(time_points, errors, '-b', 'LineWidth', 2);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14); 
xlabel('t', 'FontName', 'Times New Roman', 'FontSize', 16);
ylabel('Error of f', 'FontName', 'Times New Roman', 'FontSize', 16);

figure(3);
clf();
for i = 1:20
    j = 5*i;
    subplot(4,5,i)
    Q = load(file_namesQ{j});
    [x1, x2] = ndgrid(MD.xmin:MD.dx:MD.xmax,MD.xmin:MD.dx:MD.xmax);  % 生成网格
    surf(x1, x2, Q);  % 绘制三维表面图
    xlabel('X1');
    ylabel('X2');
    zlabel('Q');
    title(['Surface Plot of Q (File ' num2str(j) ')']);
end
errorsQ = zeros(1, num-1);
for i =1:num-1
    Q1 = load(file_namesQ{i});
    Q2 = load(file_namesQ{i+1});
    errorQ = norm(Q2-Q1, 'fro');
    errorsQ(i) = errorQ;
end
figure(4);
clf();
time_pointsQ = (1:num-1) * step*MD.dt;
semilogy(time_pointsQ, errorsQ, '-b','LineWidth', 2); % 以对数尺度绘制误差
set(gca,'FontName','Times New Roman','FontSize',14);
xlabel('t','FontName','Times New Roman','FontSize',16);
ylabel('Error of Q','FontName','Times New Roman','FontSize',16);

file_nameQsum=sprintf('output_2/output_2_Qsum/md-Qsum.dat');
Qsum=load(file_nameQsum);
figure(5);
clf();
plot(Qsum(:,1),Qsum(:,2),'b','LineWidth', 2);
xlabel('t','FontName','Times New Roman','FontSize',16);
ylabel('Total number of cells Q','FontName','Times New Roman','FontSize',16);

end
