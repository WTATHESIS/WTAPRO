
clear all

load rSim.mat

WeaponNum = 8;     % 武器数量
TargetNum = 6;      % 目标数量

GenerationSize = 100;       % 种群代数
PopSize = 1000;      % 种群数量

OperatorSize = 500;    % 执行操作算子次数

%   生成目标权值向量和杀伤概率矩阵
MaxKillPro = [ 0.75 ; 0.78 ; 0.81 ; 0.84 ; 0.87 ; 0.9 ; 0.93 ; 0.96 ];        % 每个武器的最大杀伤概率
MaxKillRange = [ 48000 ; 46000 ; 44000; 42000 ; 40000 ; 38000 ; 36000 ; 34000 ];     % 每个武器的最大杀伤距离
BellWidth = [ 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ];       % Bell Width
RMax = 62000;       % 战场环境最大距离
RMin = 30000;       % 战场环境最小距离

CrossoverPro = 0.8;     % 交叉概率
MutationPro = 0.2;      % 变异概率

%%%%% 仿真结果
rSimSize = size(rSim);
SimTimes = rSimSize(1);     % 仿真次数
GATime = zeros(1,SimTimes);    % 计算时间
GAFitness = zeros(1,SimTimes);   % 仿真适应度结果

for ST = 1 : SimTimes      % 仿真次数
    
    PopFitness = zeros(GenerationSize,1);   % 种群适应度矩阵
    
    GenerationBestFitness = zeros( GenerationSize , 1 );    % 历代最优个体适应度
    GenerationBestIndividual = zeros( GenerationSize , WeaponNum );     % 历代最优个体
    
    GlobalBestFitness = ones( GenerationSize , 1 );      % 全局最优适应度
    GlobalBestIndividual = zeros( GenerationSize , WeaponNum );      % 全局最优个体
    
    OffSpringSet = zeros(OperatorSize*2,WeaponNum);
    GoodGene = zeros(1,WeaponNum);      %  优秀基因位
    
    r = rSim(ST,:);
    [ r ] = RangeSort( r , TargetNum );     % 将输入按照目标权值升序排列
    [ TargetWeight, KillPro ] = WTAIntialization( MaxKillPro, MaxKillRange, BellWidth, RMax, r, TargetNum, WeaponNum );     % 生成目标权值向量和杀伤概率矩阵
    
    tic;    % 计时器开始
    
    PopSet = PopInitialize( PopSize , WeaponNum , TargetNum );      % 初始种群变量
    
    %   计算种群适应度
    for i = 1 : PopSize
        PopFitness(i,1) = FitnessCompute( PopSet(i,:) , WeaponNum , TargetNum , TargetWeight , KillPro );
    end
    
    for GenerationTimes = 1 : GenerationSize     % 代数循环
        
        OffSpringSet = [];      % SelectedIndividual群个体适应度
        %   交叉变异生成子种群
        for i = 1 : OperatorSize
            GoodGene = GoodGeneGenerate( TargetWeight , KillPro , WeaponNum , TargetNum );
            ParentIndividual1 = TournamentSelect( PopSet , PopFitness , PopSize ,WeaponNum );
            ParentIndividual2 = TournamentSelect( PopSet , PopFitness , PopSize ,WeaponNum );
            if rand <= CrossoverPro
                [tempChildIndividual1,tempChildIndividual2]  = EXOperator( ParentIndividual1 , ParentIndividual2 , WeaponNum , GoodGene );
                [ MidChildIndividual1 ] = EugenicsOperator( tempChildIndividual1 , TargetWeight , KillPro , WeaponNum , TargetNum );
                [ MidChildIndividual2 ] = EugenicsOperator( tempChildIndividual2 , TargetWeight , KillPro , WeaponNum , TargetNum );
            else
                MidChildIndividual1 = ParentIndividual1;
                MidChildIndividual2 = ParentIndividual2;
            end
            if rand <= MutationPro
                [ MidChildIndividual1 ] = MutationOperator( MidChildIndividual1 , WeaponNum , TargetNum );
                [ ChildIndividual1 ] = EugenicsOperator( MidChildIndividual1 , TargetWeight , KillPro , WeaponNum , TargetNum );
            else
                ChildIndividual1 = MidChildIndividual1;
            end
            if rand <= MutationPro
                [ MidChildIndividual2 ] = MutationOperator( MidChildIndividual2 , WeaponNum , TargetNum );
                [ ChildIndividual2 ] = EugenicsOperator( MidChildIndividual2 , TargetWeight , KillPro , WeaponNum , TargetNum );
            else
                ChildIndividual2 = MidChildIndividual2;
            end
            OffSpringSet((i-1)*2+1,:) = ChildIndividual1;
            OffSpringSet(i*2,:) = ChildIndividual2;
        end
        
        OffSpringSize = size(OffSpringSet);     % 提取子种群大小
        OffSpringFitness = zeros(OffSpringSize(1),1);   % 子种群适应度
        %   混合父种群和子种群，计算大种群适应度
        for i = 1 : OffSpringSize(1)
            OffSpringFitness(i,1) = FitnessCompute( OffSpringSet(i,:) , WeaponNum , TargetNum , TargetWeight , KillPro );
        end
        tempNextPopSet = [ PopSet ; OffSpringSet ];
        tempNextPopSize = PopSize + OffSpringSize(1);
        tempNextPopFitness = [ PopFitness ; OffSpringFitness ];
        
        %   对大种群进行适应度降序排序
        [ SequencedNextPopSet , SequencedNextPopFitness ] = PopSequence( tempNextPopSet , tempNextPopFitness , tempNextPopSize );
        
        %   在大种群中选取等于父种群规模的最优个体，形成下一代个体
        NextPopSet = SequencedNextPopSet( 1:PopSize , : );
        NextPopFitness = SequencedNextPopFitness( 1:PopSize , 1 );
        
        %   提取下一代个体中的最优适应度和最优个体
        GenerationBestFitness( GenerationTimes , 1 ) = NextPopFitness(1,1);
        GenerationBestIndividual( GenerationTimes , : ) = NextPopSet(1,:);
        
        %   更新全局最优适应度和最优个体
        if GenerationBestFitness( GenerationTimes , 1 ) < GlobalBestFitness( GenerationTimes , 1 )
            GlobalBestFitness( GenerationTimes , 1 ) = GenerationBestFitness( GenerationTimes , 1 );
            GlobalBestIndividual( GenerationTimes , : ) = GenerationBestIndividual( GenerationTimes , : );
        end
        
        %   循环更新
        PopSet = NextPopSet;
        PopFitness = NextPopFitness;
        
        fprintf('Time:%d  Generation:%d\n',ST,GenerationTimes);
    end
    
    %%%%% 保存仿真结果数据
    GAFitness(1,ST) = GlobalBestFitness(GenerationSize,1);
    
    toc;    % 计时器结束
    GATime( 1 , ST ) = toc;  % 保存计算时间
    
end

save GAFitness.mat GAFitness
save GATime.mat GATime





