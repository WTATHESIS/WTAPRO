function [ DecisionMatrix ] = DecisionVector2Matrix( DecisionVector , WeaponNum , TargetNum )
%UNTITLED5 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%   �������ܣ�����������ת��Ϊ���߾���
%   ���룺
%   DecisionVector����������
%   WeaponNum����������
%   TargetNum��Ŀ������
%   �����
%   DecisionMatrix�����߾���

DecisionMatrix = zeros( WeaponNum , TargetNum );
for i = 1 : WeaponNum
        DecisionMatrix( i , DecisionVector(i) ) = 1; 
end

end

