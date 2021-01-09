function [ ElitePop , EliteNum ] = EffectPopInitial( WeaponNum , Pop , PopSize , PopNum , EffectSize )
%ELITEPOP 此处显示有关此函数的摘要
%   此处显示详细说明

%EliteNum = PopNum;
%EliteNum = zeros(1,WeaponNum);

%% 按照Constraint排序
for i = 1 : WeaponNum
    if PopNum(1,i) ~= 0
        for j = 1 : PopNum(1,i)-1
            for k = 1 : PopNum(1,i)-j
                if Pop{k,i}.Constraint>Pop{k+1,i}.Constraint
                    tempVar = Pop{k,i};
                    Pop{k,i} = Pop{k+1,i};
                    Pop{k+1,i} = tempVar;
                end
                if Pop{k,i}.Constraint==0 && Pop{k+1,i}.Constraint==0 && Pop{k,i}.Fitness(1,1)>Pop{k+1,i}.Fitness(1,1)
                    tempVar = Pop{k,i};
                    Pop{k,i} = Pop{k+1,i};
                    Pop{k+1,i} = tempVar;
                end
            end
        end
    end
end

[ ElitePop , EliteNum ] = EffectSelect( WeaponNum , Pop , PopSize , EffectSize );

end

