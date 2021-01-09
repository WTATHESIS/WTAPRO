function [] = TargetTrajectoryPlot(targetNumber,targetState,XT,YT,ZT,FAI,CIT,magnifyMultiple)
%TARGETTRAJECTORYPLOT 此处显示有关此函数的摘要
%   此处显示详细说明

for targetIndex = 1 : targetNumber
    if ~isempty(XT{targetIndex,1})
        plot3(XT{targetIndex,1},YT{targetIndex,1},ZT{targetIndex,1},'b');
        hold on
        if targetState(1,targetIndex) == 1
            TargetPlot(magnifyMultiple,XT{targetIndex,1}(1,end),YT{targetIndex,1}(1,end),ZT{targetIndex,1}(1,end),FAI{targetIndex,1}(1,end),CIT{targetIndex,1}(1,end),0,'blue');
        else
            TargetPlot(magnifyMultiple,XT{targetIndex,1}(1,end),YT{targetIndex,1}(1,end),ZT{targetIndex,1}(1,end),FAI{targetIndex,1}(1,end),CIT{targetIndex,1}(1,end),0,'black');
        end
    end
end
end

