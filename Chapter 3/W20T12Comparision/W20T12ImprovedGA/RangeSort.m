function [ r ] = RangeSort( r , TargetNum )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% ���룺TargetWeight��Ŀ��Ȩֵ������δ����
%       KillPro��Ŀ��ɱ�˸��ʣ�δ����
%       TargetNum��Ŀ������
% �����TargetWeight��Ŀ��Ȩֵ����������
%       KillPro��Ŀ�����ϸ��ʣ���Ӧ������Ŀ��Ȩֵ��
for i = 1 : TargetNum-1
    for j = 1 : TargetNum-i
        if r(j) > r(j+1)
            tempr = r(j);
            r(j) = r(j+1);
            r(j+1) = tempr;
        end
    end
end

end

