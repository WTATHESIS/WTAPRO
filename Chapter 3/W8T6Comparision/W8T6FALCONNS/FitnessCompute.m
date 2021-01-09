function [ SingleTargetFitness , ObjectFitness ] = FitnessCompute( DecisionVector , WeaponNum , TargetNum , TargetWeight , KillPro )
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
ObjectFitness = 0;
SingleTargetFitness = zeros(1,TargetNum);
for i = 1 : TargetNum
    SingleTargetFitness(1,i) = TargetWeight(1,i);
    for j = 1 : WeaponNum
        SingleTargetFitness(1,i) = SingleTargetFitness(1,i) * ( 1-KillPro(j,i) ) .^ DecisionMatrix(j,i) ;
    end
    ObjectFitness = ObjectFitness + SingleTargetFitness(1,i);
end

end

