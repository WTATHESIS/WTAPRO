function [ Neighbor ] = NeighborIndex( WeaponNum )
%NEIGHBORINDEX �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

Neighbor = cell(1,WeaponNum);
for i = 1 : WeaponNum
    if i == 1
        Neighbor{1,1} = [1,2,3];
    elseif i == WeaponNum
        Neighbor{1,WeaponNum} = [WeaponNum-2,WeaponNum-1,WeaponNum];
    else
        Neighbor{1,i} = [i-1,i,i+1];
    end
end

end

