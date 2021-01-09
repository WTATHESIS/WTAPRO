function [ tempPop , tempPopNum ] = EffectSelect( WeaponNum , Pop , PopSize , EffectSize )
%RESIZE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

tempPop = cell(PopSize,WeaponNum);
tempPopSize = 0;
SubIndex = ones(1,WeaponNum);

while (tempPopSize<EffectSize)
    
    tempF = cell(1,WeaponNum);
    for k = 1 : WeaponNum
        tempF{1,k} = Pop{SubIndex(1,k),k};
    end
    
    for i = WeaponNum : -1 : 1
        
        if isempty(tempF{1,i})
            continue;
        end
        NDFlag = 1;
        for j = i-1 : -1 : 1
            if ~isempty(tempF{1,j}) && tempF{1,i}.Fitness(1,1) > tempF{1,j}.Fitness(1,1) && tempF{1,i}.Constraint > tempF{1,j}.Constraint
                NDFlag = 0;
                break;
            end
        end
        if NDFlag == 1
            tempPop{SubIndex(1,i),i} = tempF{1,i};
            SubIndex(1,i) = SubIndex(1,i) + 1;
            tempPopSize = tempPopSize + 1;
            if tempPopSize == EffectSize
                break;
            end
        end
        
    end
    
end

%Pop = tempPop;
tempPopNum = SubIndex - ones(1,WeaponNum);

end

