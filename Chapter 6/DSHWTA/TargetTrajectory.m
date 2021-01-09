function [XT,ZT,YT,CIT,FAI,TT,endTime,victory,terminalDistance] = TargetTrajectory(platformNumber,platformPosition,platformState,weaponNumber,weaponState,shortWeaponRange,longWeaponRange,targetNumber,targetPosition,targetState,thetaT,phiT,velocityT,time)
%TARGETTRAJECTORY 此处显示有关此函数的摘要
%   此处显示详细说明

Tm = 0.01;      %龙格库塔迭代步长

%% 输出数据初始化
Xt = targetPosition(:,1);
Zt = targetPosition(:,2);
Yt = targetPosition(:,3);
Vt = velocityT * ones(targetNumber,1);
Cita_t = pi - thetaT;
Fai_t = phiT;

XT = cell(targetNumber,1);
YT = cell(targetNumber,1);
ZT = cell(targetNumber,1);
VT = cell(targetNumber,1);
CIT = cell(targetNumber,1);
FAI = cell(targetNumber,1);

tT = time * ones(targetNumber,1);
TT = cell(targetNumber,1);

distance_r = NaN(platformNumber,targetNumber);
weaponLaunchState = zeros(platformNumber,targetNumber,weaponNumber);
targetAttackFlag = zeros(platformNumber,targetNumber);

terminalDistance = shortWeaponRange(1,2);
if any(weaponState==1,'all')
    terminalDistance = longWeaponRange(1,2);
end

while(1)
    
    for targetIndex = 1 : targetNumber
        
        if targetState(1,targetIndex) == 1
            
            if Yt(targetIndex,1) < 8000   %目标纵向过载
                Nyt = 1 + 0.5*rand;
            elseif Yt(targetIndex,1) > 10000
                Nyt = 1 - 0.5*rand;
            else
                Nyt = 1 + 0.5*(1-2*rand);
            end
            
            if Zt(targetIndex,1) < 10000
                Nzt = 1*rand;
            elseif Zt(targetIndex,1) > 70000
                Nzt = -1 * rand;
            else
                Nzt = 1 * (1-2*rand);
            end
            
            Nxt = 0;
            
            [ updateXt, updateYt, updateZt, updateVt, updateCita_t, updateFai_t ] = Tlgkt( Xt(targetIndex,1), Yt(targetIndex,1), Zt(targetIndex,1), Vt(targetIndex,1), Cita_t(targetIndex,1), Fai_t(targetIndex,1), Nxt, Nyt, Nzt, Tm);
            tT(targetIndex,1) = tT(targetIndex,1) + Tm;
            
            Xt(targetIndex,1) = updateXt;
            Yt(targetIndex,1) = updateYt;
            Zt(targetIndex,1) = updateZt;
            Vt(targetIndex,1) = updateVt;
            Cita_t(targetIndex,1) = updateCita_t;
            Fai_t(targetIndex,1) = updateFai_t;
            
            XT{targetIndex,1} = [ XT{targetIndex,1}, Xt(targetIndex,1) ];
            YT{targetIndex,1} = [ YT{targetIndex,1}, Yt(targetIndex,1) ];
            ZT{targetIndex,1} = [ ZT{targetIndex,1}, Zt(targetIndex,1) ];
            VT{targetIndex,1} = [ VT{targetIndex,1}, Vt(targetIndex,1) ];
            CIT{targetIndex,1} = [ CIT{targetIndex,1}, Cita_t(targetIndex,1) ];
            FAI{targetIndex,1} = [ FAI{targetIndex,1}, Fai_t(targetIndex,1) ];
            TT{targetIndex,1} = [ TT{targetIndex,1}, tT(targetIndex,1) ];
            
            if Xt(targetIndex,1) < -terminalDistance
                endTime = max(tT,[],1);
                fprintf('target %d has penetrated successfully!\n',targetIndex);
                fileName = [pwd,'/Results/InterceptionProcess.txt'];
%                 delete(fileName);
                fid = fopen(fileName,'a+');
                fprintf(fid,'target %d has penetrated successfully!\n',targetIndex);
                fclose(fid);
                victory = - 1;
                return;
            end
            
            %% 武器-目标攻击状态矩阵
            for platformIndex = 1 : platformNumber
                if platformState(platformIndex,1) == 1
                    distance_r(platformIndex,targetIndex) = norm( platformPosition(platformIndex,:) - [Xt(targetIndex,1) Zt(targetIndex,1) Yt(targetIndex,1)] );
                end
                for weaponIndex = 1 : weaponNumber
                    if weaponState(platformIndex,1,weaponIndex) == -1
                        weaponLaunchState(platformIndex,targetIndex,weaponIndex) =  weaponState(platformIndex,1,weaponIndex) * ( shortWeaponRange(1)<=distance_r(platformIndex,targetIndex) &&  distance_r(platformIndex,targetIndex)<=shortWeaponRange(2) );
                    elseif weaponState(platformIndex,1,weaponIndex) == 1
                        weaponLaunchState(platformIndex,targetIndex,weaponIndex) =  weaponState(platformIndex,1,weaponIndex) * ( longWeaponRange(1)<=distance_r(platformIndex,targetIndex) &&  distance_r(platformIndex,targetIndex)<=longWeaponRange(2) );
                    end
                end
                if any(weaponLaunchState(:,targetIndex,:)~=0,'all')
                    targetAttackFlag(platformIndex,targetIndex) = 1;
                end
            end
            
        end
        
    end
    
    if sum(max(targetAttackFlag,[],2))>=sum(targetState) && sum(max(targetAttackFlag,[],1))==sum(targetState)
        endTime = max(tT,[],1);
        victory = NaN;
        return
    end
    
end

end

