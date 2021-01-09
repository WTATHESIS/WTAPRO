function [ OptDecisionVector , OptObjectiveFitness ] = Enumeration( WeaponNum , TargetNum , TargetWeight , KillPro )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

OptObjectiveFitness = 100;
OptDecisionVector = zeros(1,WeaponNum);

for d1 = 1 : TargetNum
    for d2 = 1 : TargetNum
        for d3 = 1 : TargetNum
            for d4 = 1 : TargetNum
                for d5 = 1 : TargetNum
                    for d6 = 1 : TargetNum
                        for d7 = 1 : TargetNum
                            for d8 = 1 : TargetNum
                                    
                                        DecisionVector = [ d1 d2 d3 d4 d5 d6 d7 d8 ];
                                        
                                        [ ObjectiveFitness ] = FitnessCompute( DecisionVector , WeaponNum , TargetNum , TargetWeight , KillPro );     % 决策矩阵对应的目标函数值
                                        %%%%% 将决策向量转化为决策矩阵
                                        DecisionMatrix = zeros( WeaponNum , TargetNum );
                                        for i = 1 : WeaponNum
                                            DecisionMatrix( i , DecisionVector(i) ) = 1;
                                        end
                                        
                                        
                                        %%%%% 计算适应度
                                        ObjectiveFitness = 0;
                                        for i = 1 : TargetNum
                                            SingleTargetFitness = TargetWeight(1,i);
                                            for j = 1 : WeaponNum
                                                SingleTargetFitness = SingleTargetFitness * ( 1-KillPro(j,i) ) .^ DecisionMatrix(j,i) ;
                                            end
                                            ObjectiveFitness = ObjectiveFitness + SingleTargetFitness;
                                        end
                                        
                                        if ObjectiveFitness < OptObjectiveFitness
                                            OptDecisionVector = DecisionVector;
                                            OptObjectiveFitness = ObjectiveFitness;
                                        end

                            end
                        end
                    end
                end
            end
        end
    end
end

end

