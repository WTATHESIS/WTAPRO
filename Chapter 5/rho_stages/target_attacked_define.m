function [maxtarind,maxassind] = target_attacked_define(tarnum,weatarsta,tarasseff)
%TARGET_ATTACKED_DEFINE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
temp = tarasseff;
for i = 1 : tarnum
    if all(weatarsta(:,i)==0)
        temp(i,:) = 0;
    end
end
[maxtarind,maxassind] = find(temp==max(max(temp)));    % ȷ��������Ŀ��
end

