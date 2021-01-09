function [targetValue,heightThreat,velocityThreat,shortCutThreat,flyTimeThreat] = TargetValueGenerate(platformPosition,targetPosition,targetNumber,targetState,thetaT,phiT,velocityT)
%TARGETVALUEGENERATE 此处显示有关此函数的摘要
%   此处显示详细说明

%% 高度威胁模型
heightState = targetPosition(:,3)>1000;
heightThreat = exp(-0.015.*heightState.*(targetPosition(:,3)/1000-1));
heightThreat = heightThreat';

%% 速度威胁模型
velocityTMa = velocityT/340;
if velocityTMa < 1
    velocityThreat = 0.2 * ones(1,targetNumber);
else
    velocityThreat = (0.8 * ( 1 - exp(-0.8*(velocityTMa-1)) ) + 0.2) * ones(1,targetNumber);
end

%% 航路捷径威胁模型
assetPosition = sum(platformPosition,1)/sum(platformPosition(:,2)~=0,1);
targetDisplace = [ cos(thetaT).*cos(phiT) sin(thetaT) cos(thetaT).*sin(phiT) ];
tempPosition = targetPosition + targetDisplace;
shortCut = zeros(1,targetNumber);
shortCutThreat = zeros(1,targetNumber);
for targetIndex = 1 : targetNumber
    shortCut(1,targetIndex) = norm( cross( tempPosition(targetIndex,:)-targetPosition(targetIndex,:) , assetPosition - targetPosition(targetIndex,:) )  ) / norm( tempPosition(targetIndex,:)-targetPosition(targetIndex,:) );
    shortCutThreat(1,targetIndex) = exp(-0.01*(shortCut(1,targetIndex)/1000)^2);
end

%% 飞临时间威胁模型
targetAssetDistance = zeros(1,targetNumber);
shortPointDistance = zeros(1,targetNumber);
for targetIndex = 1 : targetNumber
    targetAssetDistance(1,targetIndex) = norm( targetPosition(targetIndex,:) - assetPosition );
    shortPointDistance(1,targetIndex) = sqrt(targetAssetDistance(1,targetIndex)^2 - shortCut(1,targetIndex)^2);
end
shortPointTime = shortPointDistance/velocityT;
flyTimeThreat = exp( -4e-6 * shortPointTime.^2 );

targetValue = 0.25 * heightThreat + 0.25 * velocityThreat + 0.25 * shortCutThreat + 0.25 * flyTimeThreat;

targetValue = targetValue .* targetState;

end

