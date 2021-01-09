
popsize = [10:10:100];
diffnum = [1:1:10];

[x,y] = meshgrid(popsize,diffnum);

%% 生存资源价值百分比
z = NaN(10,10);
for i = 1 : 10
    for j = 1 : 10
        load(['nav',num2str(i*10),'_',num2str(j),'.mat']);
        z(i,j) = nav(end,1);
    end
end

%% 决策阶段数
z = NaN(10,10);
for i = 1 : 10
    for j = 1 : 10
        load(['stage',num2str(i*10),'_',num2str(j),'.mat']);
        z(i,j) = stage;
    end
end

%% 计算时间
z = NaN(10,10);
for i = 1 : 10
    for j = 1 : 10
        load(['time',num2str(i*10),'_',num2str(j),'.mat']);
        z(i,j) = time/10;
    end
end

%% 任务完成度
z = NaN(10,10);
for i = 1 : 10
    for j = 1 : 10
        load(['victory',num2str(i*10),'_',num2str(j),'.mat']);
        z(i,j) = victory;
    end
end
