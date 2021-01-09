function [ Fitness , TargetSurvive ] = TargetKillProCompute( WeaponNum , TargetNum , TargetWeight , KillPro , DecisionMatrix )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%   �������ܣ�����ĳ��������WTA�����Ŀ�꺯��ֵ
%   ���룺
%   DecisionMatrix�����߾���
%   WeaponNum: ������
%   TargetNum��Ŀ����
%   TargetWeight��Ŀ��Ȩֵ
%   KillPro��ɱ�˸��ʾ���
%   �����
%   ObjectiveFitness��Ŀ�꺯��ֵ
TargetSurvive = ones(1,TargetNum);
Fitness = 0;
for i = 1 : TargetNum
    SingleTargetFitness = TargetWeight(1,i);
    for j = 1 : WeaponNum
        SingleTargetFitness = SingleTargetFitness * ( 1-KillPro(j,i) ) .^ DecisionMatrix(j,i) ;
    end
    TargetSurvive(1,i) = SingleTargetFitness / TargetWeight(1,i);
    Fitness = Fitness + SingleTargetFitness;
end

end

