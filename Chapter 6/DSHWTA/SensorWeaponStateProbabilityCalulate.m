function [sensorDetectProbability,weaponLaunchState,weaponKillProbability,timeGo_tGo] = SensorWeaponStateProbabilityCalulate(platformPosition,platformState,platformNumber,sensorNumber,weaponNumber,targetPosition,targetNumber,thetaM,thetaT,velocityM,velocityT,weaponState,targetState,shortWeaponRange,longWeaponRange,probabilityPeak,probabilityWeight,sensorMaxRange,sensorCoefficient,guidanceCoefficient)
%KILLPROBABILITYCALULATE 此处显示有关此函数的摘要
%   此处显示详细说明

distance_r = NaN(platformNumber,targetNumber);
LOS_q = NaN(platformNumber,targetNumber);
lead_eta = NaN(platformNumber,targetNumber);

headError_psi = NaN(platformNumber,targetNumber,weaponNumber);

for platformIndex = 1 : platformNumber
    if platformState(platformIndex,1) == 1
        for targetIndex = 1 : targetNumber
            if targetState(1,targetIndex) == 1
                distance_r(platformIndex,targetIndex) = norm( platformPosition(platformIndex,:)- targetPosition(targetIndex,:) );
                LOS_q(platformIndex,targetIndex) = atan2( targetPosition(targetIndex,3)-platformPosition(platformIndex,3) , targetPosition(targetIndex,1)-platformPosition(platformIndex,1) );
                lead_eta(platformIndex,targetIndex) = asin( velocityT/velocityM*sin(thetaT(targetIndex,1)-LOS_q(platformIndex,targetIndex)) );
                for weaponIndex = 1 : weaponNumber
                    if weaponState(platformIndex,1,weaponIndex) ~= 0
                        headError_psi(platformIndex,targetIndex,weaponIndex) = thetaM(platformIndex,1,weaponIndex) - LOS_q(platformIndex,targetIndex) - lead_eta(platformIndex,targetIndex);
                    end
                end
            end
        end
    end
end

%% 武器-传感器探测概率
sensorDetectProbability = zeros(sensorNumber,targetNumber);
for targetIndex =  1 : targetNumber
    if targetState(targetIndex) == 1
        for sensorIndex = 1 : sensorNumber
            R = distance_r(sensorIndex,targetIndex) / sensorCoefficient / sensorMaxRange;
            if R < 0.8
                sensorDetectProbability(sensorIndex,targetIndex) = 0.9 - R/8;
            elseif R < 1
                sensorDetectProbability(sensorIndex,targetIndex) = 2 - 1.5*R;
            end
        end
    end
end

%% 武器-目标攻击状态矩阵
weaponLaunchState = zeros(platformNumber,targetNumber,weaponNumber);
for targetIndex = 1 : targetNumber
    if targetState(targetIndex) == 1
        for platformIndex = 1 : platformNumber
            for weaponIndex = 1 : weaponNumber
                if weaponState(platformIndex,1,weaponIndex) == -1
                    weaponLaunchState(platformIndex,targetIndex,weaponIndex) =  weaponState(platformIndex,1,weaponIndex) * ( shortWeaponRange(1)<=distance_r(platformIndex,targetIndex) &&  distance_r(platformIndex,targetIndex)<=shortWeaponRange(2) );
                elseif weaponState(platformIndex,1,weaponIndex) == 1
                    weaponLaunchState(platformIndex,targetIndex,weaponIndex) =  weaponState(platformIndex,1,weaponIndex) * ( longWeaponRange(1)<=distance_r(platformIndex,targetIndex) &&  distance_r(platformIndex,targetIndex)<=longWeaponRange(2) );
                end
            end
        end
    end
end

%% 武器-目标杀伤概率
closeVelocity = NaN(platformNumber,targetNumber,weaponNumber);
t_go = NaN(platformNumber,targetNumber,weaponNumber);
missDistance_deltaS = NaN(platformIndex,targetIndex,weaponIndex);
tau = 1;
timeGo_tGo = NaN(platformNumber,targetNumber,weaponNumber);
lead_etaDot = NaN(platformNumber,targetNumber,weaponNumber);
for platformIndex = 1 : platformNumber
    if platformState(platformIndex,1) == 1
        for targetIndex = 1 : targetNumber
            if targetState(1,targetIndex) == 1
                for weaponIndex = 1 : weaponNumber
                    if weaponLaunchState(platformIndex,targetIndex,weaponIndex) ~= 0
                        closeVelocity(platformIndex,targetIndex,weaponIndex) = velocityT * cos( thetaT(targetIndex,1)-LOS_q(platformIndex,targetIndex) ) - velocityM * cos( thetaM(platformIndex,1,weaponIndex) - LOS_q(platformIndex,targetIndex) );
                        t_go(platformIndex,targetIndex,weaponIndex) = distance_r(platformIndex,targetIndex) / closeVelocity(platformIndex,targetIndex,weaponIndex);
                        missDistance_deltaS(platformIndex,targetIndex,weaponIndex) = abs( headError_psi(platformIndex,targetIndex,weaponIndex) * velocityM * t_go(platformIndex,targetIndex,weaponIndex) * exp(-t_go(platformIndex,targetIndex,weaponIndex)/tau) * ( 1 - t_go(platformIndex,targetIndex,weaponIndex)/tau + t_go(platformIndex,targetIndex,weaponIndex)^2/6/tau^2 ) );
                        timeGo_tGo(platformIndex,targetIndex,weaponIndex) = distance_r(platformIndex,targetIndex)/velocityM * ( 1 + sin(thetaM(platformIndex,1,weaponIndex)-LOS_q(platformIndex,targetIndex))^2/2/(2*guidanceCoefficient(platformIndex,1,weaponIndex)-1) + 3*sin(thetaM(platformIndex,1,weaponIndex)-LOS_q(platformIndex,targetIndex))^4/8/(4*guidanceCoefficient(platformIndex,1,weaponIndex)-3) + 5*sin(thetaM(platformIndex,1,weaponIndex)-LOS_q(platformIndex,targetIndex))^6/16/(6*guidanceCoefficient(platformIndex,1,weaponIndex)-5) + 35*sin(thetaM(platformIndex,1,weaponIndex)-LOS_q(platformIndex,targetIndex))^8/128/(8*guidanceCoefficient(platformIndex,1,weaponIndex)-7) ) * velocityM / (velocityM + velocityT);
                        lead_etaDot(platformIndex,targetIndex,weaponIndex) = lead_eta(platformIndex,targetIndex)/distance_r(platformIndex,targetIndex);
                    end
                end
            end
        end
    end
end

weaponTargetAssignState = abs(weaponLaunchState);

weaponTargetAssignSum = sum(weaponTargetAssignState,'all');
meanDeltaS = sum(missDistance_deltaS,'all','omitnan') / weaponTargetAssignSum;
meanTimeGo = sum(timeGo_tGo,'all','omitnan') / weaponTargetAssignSum;
meanEtaDot = sum(lead_etaDot,'all','omitnan') / weaponTargetAssignSum;

probabilityDeltaS = probabilityPeak(1) .* exp( -0.5 .* (missDistance_deltaS/meanDeltaS).^2 ) .* weaponTargetAssignState;

probabilityTimeGo = probabilityPeak(2) .* exp( -0.5 .* (timeGo_tGo/meanTimeGo).^2 ) .* weaponTargetAssignState;
probabilityEtaDot = probabilityPeak(3) .* exp( -0.5 .* (lead_etaDot/meanEtaDot).^2 ) .* weaponTargetAssignState;

weaponKillProbability = probabilityWeight(1) .* probabilityDeltaS + probabilityWeight(2) .* probabilityTimeGo + probabilityWeight(3) .* probabilityEtaDot;

end
