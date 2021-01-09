function [ SubProblem ] = SubProblemCreate( PopSize , NeighborNum )
%CREATESUBPROBLEM 此处显示有关此函数的摘要
%   此处显示详细说明

empty_SubProblem.Lambda=[];
empty_SubProblem.Neighbor=[];

SubProblem=repmat(empty_SubProblem,PopSize,1);

for i = 1 : PopSize
    
    SubProblem(i).Lambda = [ (i-1)/(PopSize-1) , (PopSize-i)/(PopSize-1) ];
    
    if i == 1
        SubProblem(i).Neighbor = [i+1:i+NeighborNum];
    elseif i > 1 && i < NeighborNum/2 + 1
        DownNeighbor = [ 1 : i-1 ];
        UpNeighbor = [ i+1 : NeighborNum+1 ];
        SubProblem(i).Neighbor = [ DownNeighbor , UpNeighbor ];
    elseif i >= NeighborNum/2 + 1 && i < PopSize - NeighborNum/2
        DownNeighbor = [ i-NeighborNum/2 : i-1 ];
        UpNeighbor = [ i+1 : i+NeighborNum/2 ];
        SubProblem(i).Neighbor = [ DownNeighbor , UpNeighbor ];
    else
        DownNeighbor = [ PopSize - NeighborNum : i-1 ];
        UpNeighbor = [ i+1 : PopSize ];
        SubProblem(i).Neighbor = [ DownNeighbor , UpNeighbor ];
    end
    
end

end

