function [ OptimalDecisionVector , OptimalShift , ShiftCost , OptimalCycle , OptimalCycleCost ] = ImproveGraphSearch( DecisionVector , SingleTargetFitness , PathLength , WeaponNum , TargetNum , KillPro )
%IMPROVEGRAPHSEARCH 此处显示有关此函数的摘要
%   此处显示详细说明

OptimalShift = [];
ShiftCost = 0;
OptimalCycle = [];
OptimalCycleCost = 0;
OptimalDecisionVector = DecisionVector;

TreeNode = zeros(TargetNum,WeaponNum);      % 每个目标树的武器节点集合
TreeNodeCount = zeros(TargetNum,1);     % 每个目标树的武器节点数量
%%%%% 生成每个目标树的武器节点集合
for i = 1 : WeaponNum
    NodeCount = OptimalDecisionVector(1,i);
    TreeNodeCount(NodeCount,1) = TreeNodeCount(NodeCount,1) + 1;
    TreeNode(NodeCount,TreeNodeCount(NodeCount,1)) = i;
end

for i = 1 : TargetNum
    for m = 1 : TreeNodeCount(i,1)
        for j = 1 : TargetNum
            if i ~= j
                if TreeNode(i,m) ~= 0
                    LoseWeapon = SingleTargetFitness(1,i) / ( 1 - KillPro(TreeNode(i,m),i) ) - SingleTargetFitness(1,i);
                    GainWeapon = SingleTargetFitness(1,j) * ( 1 - KillPro(TreeNode(i,m),j) ) - SingleTargetFitness(1,j);
                    SumWeapon = LoseWeapon + GainWeapon;
                    if SumWeapon < 0
                        ShiftCost = ShiftCost + SumWeapon;
                        SingleShift = [TreeNode(i,m) , i , j];
                        OptimalShift = [OptimalShift;SingleShift];
                        OptimalDecisionVector(1,TreeNode(i,m)) = j; 
                        
                        TreeNodeCount(j,1) = TreeNodeCount(j,1) + 1;
                        TreeNode(j,TreeNodeCount(j,1)) = TreeNode(i,m); 
                        if m < TreeNodeCount(i,1)
                            for n = m : TreeNodeCount(i,1)-1
                                TreeNode(i,n) = TreeNode(i,n+1);
                            end
                        else
                            TreeNode(i,m) = 0;
                        end
                        TreeNodeCount(i,1) = TreeNodeCount(i,1) - 1;
                        
                        SingleTargetFitness(1,i) = SingleTargetFitness(1,i) + LoseWeapon;
                        SingleTargetFitness(1,j) = SingleTargetFitness(1,j) + GainWeapon;
                    end
                end
            end
        end
    end
end

PathSet = [];
PathSetofTree = [];
for i = 1 : TargetNum
    for j = 1 : TargetNum
        if i ~= j
            for m = 1 : TreeNodeCount(i,1)
                for n = 1 : TreeNodeCount(j,1)
                    if KillPro(TreeNode(i,m),j) > KillPro(TreeNode(j,n),j)
                        SinglePath = [ TreeNode(i,m) , TreeNode(j,n) ];
                        PathSet = [ PathSet ; SinglePath ];
                        SinglePathofTree = [ i , j ];
                        PathSetofTree = [ PathSetofTree ; SinglePathofTree ];
                    end
                end
            end
        end
    end
end

PathStep = 2;
while ( PathStep <= PathLength )
    
    if PathStep > 2
        PathSet = NewPathSet;
        PathSetofTree = NewPathSetofTree;
    end
    NewPathSet = [];
    NewPathSetofTree = [];
    
    while ~isempty(PathSet)
        
        %%%%%%%%%%%%%% 提取发生序列向量
        PathVector = PathSet(1,:);
        PathSet(1,:) = [];
        PathVectorofTree = PathSetofTree(1,:);
        PathSetofTree(1,:) = [];
        %PathCost = PathCostCompute( PathVector , PathVectorofTree , KillPro , Fitness );
        
        %%%%%%%%%%%%% 计算最优交叉环
        CycleCost = CycleCostCompute( PathVector , PathVectorofTree , PathStep , KillPro , SingleTargetFitness );
        if CycleCost < OptimalCycleCost
            OptimalCycle = PathVector;
            OptimalCycleCost = CycleCost;
        end
        
        if PathStep == PathLength
            continue;
        end
        %%%%%%%%%%%%%% 交叉换长度+1
        for i = 1 : TargetNum
            if ~ismember(i,PathVectorofTree)
                for j = 1 : TreeNodeCount(i,1)
                    NewPathVector = [ PathVector , TreeNode(i,j) ];
                    NewPathVectorofTree = [ PathVectorofTree , i ];
                    NewPathCost = PathCostCompute( NewPathVector , NewPathVectorofTree , PathStep , KillPro , SingleTargetFitness );
                    if NewPathCost < 0
                        if ~isempty(NewPathSetofTree)
                            [ExistPathVector,ExistPathVectorIndex] = ismember(NewPathVectorofTree,NewPathSetofTree,'rows');
                            if ExistPathVector == 0
                                NewPathSet = [ NewPathSet ; NewPathVector ];
                                NewPathSetofTree = [ NewPathSetofTree ; NewPathVectorofTree ];
                            else
                                PreNewPathCost =  PathCostCompute( NewPathSet(ExistPathVectorIndex,:) , NewPathSetofTree(ExistPathVectorIndex,:) , PathStep , KillPro , SingleTargetFitness );
                                if NewPathCost < PreNewPathCost
                                    NewPathSet(ExistPathVectorIndex,:) = NewPathVector;
                                    NewPathSetofTree(ExistPathVectorIndex,:) = NewPathVectorofTree;
                                end
                            end
                        else
                            NewPathSet = [ NewPathSet;NewPathVector ];
                            NewPathSetofTree = [NewPathSetofTree;NewPathVectorofTree];
                        end
                    end
                end
            end
        end
        
    end
    
    PathStep = PathStep + 1;
    
end

if ~isempty(OptimalCycle)
    %%%%%%%%%%% 更新OptimalDecisionVector
    OptimalCycleSize = size(OptimalCycle);
    OptimalCycleLength = OptimalCycleSize(1,2);
    FirstDecision = OptimalDecisionVector(1,OptimalCycle(1,1));
    for i = 1 : OptimalCycleLength - 1
        OptimalDecisionVector(1,OptimalCycle(1,i)) = OptimalDecisionVector(1,OptimalCycle(1,i+1));
    end
    OptimalDecisionVector(1,OptimalCycle(1,OptimalCycleLength)) = FirstDecision;
end

end

