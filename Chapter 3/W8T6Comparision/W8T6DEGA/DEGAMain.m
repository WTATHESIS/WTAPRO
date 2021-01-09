
load rSim.mat

n = 8;
m = 6;

%   生成目标权值向量和杀伤概率矩阵
MaxKillPro = [ 0.72 ; 0.75 ; 0.78 ; 0.81 ; 0.84 ; 0.87 ; 0.9 ; 0.93 ; 0.96 ; 0.99 ];        % 每个武器的最大杀伤概率
%MaxKillPro = 0.7 + ( 0.99 - 0.7 ) * rand(1,WeaponNum);
MaxKillRange = [ 50000 ; 48000 ; 46000 ; 44000; 42000 ; 40000 ; 38000 ; 36000 ; 34000; 32000 ];     % 每个武器的最大杀伤距离
%MaxKillRange = 30000 + ( 60000 - 30000 ) * rand(1,WeaponNum);
BellWidth = [ 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000];       % Bell Width
%BellWidth = 20000 * rand(1,WeaponNum);
RMax = 60000;       % 战场环境最大距离
RMin = 30000;       % 战场环境最小距离

rSimSize = size(rSim);
SimTimes = rSimSize(1);     % 仿真次数
DEGAFitness = zeros(SimTimes,1);
DEGATime = zeros(SimTimes,1);

for i = 1:SimTimes
    i
    r = rSim(i,:);
    [ v, p ] = WTAIntialization( MaxKillPro, MaxKillRange, BellWidth, RMax, r, m, n );     % 生成目标权值向量和杀伤概率矩阵
    
    t1 = clock;
    
    options.no_dimension = n*m;
    ret_val = differentialEvolution2(options,v,p);
    best_vector = quantize_x(reshape(ret_val.best_vector,n,m),v,n,m);
    t2 = clock;

    DEGAFitness(i,1) = wta_loss(best_vector,v,p);
    DEGATime(i,1) = etime(t2,t1);
end

save DEGAFitness.mat DEGAFitness
save DEGATime.mat DEGATime