function [] = InitialTargetPlot(targetNumber,targetPosition,phiT,thetaT)
%INITIALTARGETPLOT 此处显示有关此函数的摘要
%   此处显示详细说明

for i = 1 : targetNumber
    TargetPlot(2000,targetPosition(i,1),targetPosition(i,2),targetPosition(i,3),phiT(i,1),pi-thetaT(i,1),0,'blue');
    text(targetPosition(i,1)+1000,targetPosition(i,2)-1000,targetPosition(i,3),num2str(i),'Color','blue');
    hold on
end

end

