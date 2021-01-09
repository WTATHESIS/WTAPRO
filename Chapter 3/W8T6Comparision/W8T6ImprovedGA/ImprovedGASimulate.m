
clear all

load rSim.mat

WeaponNum = 8;     % ��������
TargetNum = 6;      % Ŀ������

GenerationSize = 100;       % ��Ⱥ����
PopSize = 1000;      % ��Ⱥ����

OperatorSize = 500;    % ִ�в������Ӵ���

%   ����Ŀ��Ȩֵ������ɱ�˸��ʾ���
MaxKillPro = [ 0.75 ; 0.78 ; 0.81 ; 0.84 ; 0.87 ; 0.9 ; 0.93 ; 0.96 ];        % ÿ�����������ɱ�˸���
MaxKillRange = [ 48000 ; 46000 ; 44000; 42000 ; 40000 ; 38000 ; 36000 ; 34000 ];     % ÿ�����������ɱ�˾���
BellWidth = [ 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ];       % Bell Width
RMax = 62000;       % ս������������
RMin = 30000;       % ս��������С����

CrossoverPro = 0.8;     % �������
MutationPro = 0.2;      % �������

%%%%% ������
rSimSize = size(rSim);
SimTimes = rSimSize(1);     % �������
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
    
    r = rSim(ST,:);
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

save GAFitness.mat GAFitness
save GATime.mat GATime





