function [ PopSet ] = PopInitialize( PopSize , WeaponNum , TargetNum )
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%   �������ܣ���Ⱥ��ʼ��
%   �����
%   PopSize����Ⱥ��С
%   WeaponNum����������
%   TargetNum��Ŀ������
%   �����
%   PopSet����Ⱥ����

PopSet = zeros( PopSize , WeaponNum );
for i =1 : PopSize
    for j = 1 : WeaponNum
        PopSet( i , j ) = randi( TargetNum );
    end
end

end

