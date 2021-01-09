
clear all

load W20T12rSim.mat

WeaponNum = 20;     % ��������
TargetNum = 12;      % Ŀ������

GenerationSize = 100;       % ��Ⱥ����
PopSize = 1000;      % ��Ⱥ����

OperatorSize = PopSize/2;    % ִ�в������Ӵ���

%   ����Ŀ��Ȩֵ������ɱ�˸��ʾ���
MaxKillPro = [ 0.57 : 0.02 : 0.95 ];        % ÿ�����������ɱ�˸���
MaxKillRange = [ 50000 : -1000 : 31000 ];       % ÿ�����������ɱ�˾���
BellWidth = 20000 .* ones(1,WeaponNum);     % Bell Width
RMax = 62000;       % ս������������
RMin = 30000;       % ս��������С����

CrossoverPro = 0.8;     % �������
MutationPro = 0.4;      % �������

%%%%% ������
W20T12rSimSize = size(W20T12rSim);
SimTimes = W20T12rSimSize(1);     % �������
GATime = zeros(1,SimTimes);    % ����ʱ��
GAFitness = zeros(1,SimTimes);   % ������Ӧ�Ƚ��

for ST = 1 : SimTimes      % �������
    
    PopFitness = zeros(GenerationSize,1);   % ��Ⱥ��Ӧ�Ⱦ���
    
    GenerationBestFitness = zeros( GenerationSize , 1 );    % �������Ÿ�����Ӧ��
    GenerationBestIndividual = zeros( GenerationSize , WeaponNum );     % �������Ÿ���
    
    GlobalBestFitness = ones( GenerationSize , 1 );      % ȫ��������Ӧ��
    GlobalBestIndividual = zeros( GenerationSize , WeaponNum );      % ȫ�����Ÿ���
    
    OffSpringSet = zeros(OperatorSize*2,WeaponNum);
    GoodGene = zeros(1,WeaponNum);      %  �������λ
    
    r = W20T12rSim(ST,:);
    [ r ] = RangeSort( r , TargetNum );     % �����밴��Ŀ��Ȩֵ��������
    [ TargetWeight, KillPro ] = WTAIntialization( MaxKillPro, MaxKillRange, BellWidth, RMax, r, TargetNum, WeaponNum );     % ����Ŀ��Ȩֵ������ɱ�˸��ʾ���
    
    tic;    % ��ʱ����ʼ
    
    PopSet = PopInitialize( PopSize , WeaponNum , TargetNum );      % ��ʼ��Ⱥ����
    
    %   ������Ⱥ��Ӧ��
    for i = 1 : PopSize
        PopFitness(i,1) = FitnessCompute( PopSet(i,:) , WeaponNum , TargetNum , TargetWeight , KillPro );
    end
    
    for GenerationTimes = 1 : GenerationSize     % ����ѭ��
        
        OffSpringSet = [];      % SelectedIndividualȺ������Ӧ��
        %   ���������������Ⱥ
        for i = 1 : OperatorSize
            GoodGene = GoodGeneGenerate( TargetWeight , KillPro , WeaponNum , TargetNum );
            ParentIndividual1 = TournamentSelect( PopSet , PopFitness , PopSize ,WeaponNum );
            ParentIndividual2 = TournamentSelect( PopSet , PopFitness , PopSize ,WeaponNum );
            if rand <= CrossoverPro
                [MidChildIndividual1,MidChildIndividual2]  = EXOperator( ParentIndividual1 , ParentIndividual2 , WeaponNum , GoodGene ); 
            else
                MidChildIndividual1 = ParentIndividual1;
                MidChildIndividual2 = ParentIndividual2;
            end
            if rand <= MutationPro
                [ ChildIndividual1 ] = MutationOperator( MidChildIndividual1 , WeaponNum , TargetNum );
            else
                ChildIndividual1 = MidChildIndividual1;
            end
            if rand <= MutationPro
                [ ChildIndividual2 ] = MutationOperator( MidChildIndividual2 , WeaponNum , TargetNum );
            else
                ChildIndividual2 = MidChildIndividual2;
            end
            OffSpringSet((i-1)*2+1,:) = ChildIndividual1;
            OffSpringSet(i*2,:) = ChildIndividual2;
        end
        
        OffSpringSize = size(OffSpringSet);     % ��ȡ����Ⱥ��С
        OffSpringFitness = zeros(OffSpringSize(1),1);   % ����Ⱥ��Ӧ��
        %   ��ϸ���Ⱥ������Ⱥ���������Ⱥ��Ӧ��
        for i = 1 : OffSpringSize(1)
            OffSpringFitness(i,1) = FitnessCompute( OffSpringSet(i,:) , WeaponNum , TargetNum , TargetWeight , KillPro );
        end
        tempNextPopSet = [ PopSet ; OffSpringSet ];
        tempNextPopSize = PopSize + OffSpringSize(1);
        tempNextPopFitness = [ PopFitness ; OffSpringFitness ];
        
        %   �Դ���Ⱥ������Ӧ�Ƚ�������
        [ SequencedNextPopSet , SequencedNextPopFitness ] = PopSequence( tempNextPopSet , tempNextPopFitness , tempNextPopSize );
        
        %   �ڴ���Ⱥ��ѡȡ���ڸ���Ⱥ��ģ�����Ÿ��壬�γ���һ������
        NextPopSet = SequencedNextPopSet( 1:PopSize , : );
        NextPopFitness = SequencedNextPopFitness( 1:PopSize , 1 );
        
        %   ��ȡ��һ�������е�������Ӧ�Ⱥ����Ÿ���
        GenerationBestFitness( GenerationTimes , 1 ) = NextPopFitness(1,1);
        GenerationBestIndividual( GenerationTimes , : ) = NextPopSet(1,:);
        
        %   ����ȫ��������Ӧ�Ⱥ����Ÿ���
        if GenerationBestFitness( GenerationTimes , 1 ) < GlobalBestFitness( GenerationTimes , 1 )
            GlobalBestFitness( GenerationTimes , 1 ) = GenerationBestFitness( GenerationTimes , 1 );
            GlobalBestIndividual( GenerationTimes , : ) = GenerationBestIndividual( GenerationTimes , : );
        end
        
        %   ѭ������
        PopSet = NextPopSet;
        PopFitness = NextPopFitness;
        
        fprintf('Time:%d  Generation:%d\n',ST,GenerationTimes);
    end
    
    %%%%% �������������
    GAFitness(1,ST) = GlobalBestFitness(GenerationSize,1);
    
    toc;    % ��ʱ������
    GATime( 1 , ST ) = toc;  % �������ʱ��
    
end

GAClassicFitness = GAFitness;
GAClassicTime = GATime;

save GAClassicFitness.mat GAClassicFitness
save GAClassicTime.mat GAClassicTime
%save GAFitness.mat GAFitness
%save GATime.mat GATime




