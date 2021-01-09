
load rSim.mat

n = 8;
m = 6;

%   ����Ŀ��Ȩֵ������ɱ�˸��ʾ���
MaxKillPro = [ 0.72 ; 0.75 ; 0.78 ; 0.81 ; 0.84 ; 0.87 ; 0.9 ; 0.93 ; 0.96 ; 0.99 ];        % ÿ�����������ɱ�˸���
%MaxKillPro = 0.7 + ( 0.99 - 0.7 ) * rand(1,WeaponNum);
MaxKillRange = [ 50000 ; 48000 ; 46000 ; 44000; 42000 ; 40000 ; 38000 ; 36000 ; 34000; 32000 ];     % ÿ�����������ɱ�˾���
%MaxKillRange = 30000 + ( 60000 - 30000 ) * rand(1,WeaponNum);
BellWidth = [ 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000];       % Bell Width
%BellWidth = 20000 * rand(1,WeaponNum);
RMax = 60000;       % ս������������
RMin = 30000;       % ս��������С����

rSimSize = size(rSim);
SimTimes = rSimSize(1);     % �������
DEGAFitness = zeros(SimTimes,1);
DEGATime = zeros(SimTimes,1);

for i = 1:SimTimes
    i
    r = rSim(i,:);
    [ v, p ] = WTAIntialization( MaxKillPro, MaxKillRange, BellWidth, RMax, r, m, n );     % ����Ŀ��Ȩֵ������ɱ�˸��ʾ���
    
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