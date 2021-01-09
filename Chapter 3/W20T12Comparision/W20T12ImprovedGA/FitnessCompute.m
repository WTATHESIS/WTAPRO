function [ ObjectiveFitness ] = FitnessCompute( DecisionVector , WeaponNum , TargetNum , TargetWeight , KillPro )
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

DecisionMatrix = DecisionVector2Matrix( DecisionVector , WeaponNum , TargetNum );
ObjectiveFitness = 0;
for i = 1 : TargetNum
    SingleTargetFitness = TargetWeight(1,i);
    for j = 1 : WeaponNum
        SingleTargetFitness = SingleTargetFitness * ( 1-KillPro(j,i) ) .^ DecisionMatrix(j,i) ;
    end
    ObjectiveFitness = ObjectiveFitness + SingleTargetFitness;
end

end

