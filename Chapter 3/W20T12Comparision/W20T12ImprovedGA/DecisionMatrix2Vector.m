function [ DecisionVector ] = DecisionMatrix2Vector( DecisionMatrix , WeaponNum , TargetNum )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
DecisionVector = zeros(1,WeaponNum);
for i = 1 : WeaponNum
    for j = 1 : TargetNum
        if DecisionMatrix(i,j) == 1
            DecisionVector(1,i) = j;
        end
    end
end

end

