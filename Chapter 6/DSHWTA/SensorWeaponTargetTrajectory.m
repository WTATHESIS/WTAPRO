function [XT,ZT,YT,CIT,FAI,TT,XM,ZM,YM,CITM,FAIM,T,targetState,platformNull,irradiatePosition,endTime] = SensorWeaponTargetTrajectory(targetState,targetPosition,targetNumber,velocityT,thetaT,phiT,platformPosition,platformNumber,velocityM,thetaM,phiM,guidanceCoefficient,optimalSolution,decisionTime,responseTime,assessTime,stageIndex)
%SENSORWEAPONTARGETTRAJECTORY 此处显示有关此函数的摘要
%   此处显示详细说明

%% 写入文件
fileName = [pwd,'/Results/InterceptionProcess.txt'];
% delete(fileName);
fid = fopen(fileName,'a+');
fprintf(fid,'Stage %d\n',stageIndex);

platformNull = NaN(1,platformNumber);

%% 武器参数
% t = 0;          %导弹飞行时间
t0 = 9;        %发动机工作时间
tr = 120;       %弹上能源工作时间
% tj = 5;        %引信解除保险时间
Tm = 0.01;      %龙格库塔迭代步长

m=120;     g=9.8;     P0=10*g*m;   %P0发动机推力
G=m*g;
Cx0=0.01691;
S=0.28^2*pi;  %rou所在高度空气密度，Cx0零升阻力系数，S导弹当量截面积

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

% NZT = cell(targetNumber,1);

Xm = platformPosition(:,1);
Zm = platformPosition(:,2);
Vm = velocityM * ones(platformNumber,1);
Ym = platformPosition(:,3);
Cita_m = zeros(platformNumber,1);
Fai_m = zeros(platformNumber,1);
guidanceLaw = zeros(platformNumber,1);
for platformIndex = 1 : platformNumber
    targetLabel = optimalSolution.IIPlatformCode(1,platformIndex);
    weaponLabel = optimalSolution.IIIPlatformComplement(1,platformIndex);
    if targetLabel ~= 0 && weaponLabel ~= 0
        Cita_m(platformIndex,1) = thetaM(platformIndex,1,weaponLabel);
        Fai_m(platformIndex,1) = phiM(platformIndex,1,weaponLabel);
        guidanceLaw(platformIndex,1) = guidanceCoefficient(platformIndex,1,weaponLabel);
    end
end

XM = cell(platformNumber,1);
YM = cell(platformNumber,1);
ZM = cell(platformNumber,1);
VM = cell(platformNumber,1);
CITM = cell(platformNumber,1);
FAIM = cell(platformNumber,1);
% CNm = cell{platformNumber,1};

DD = zeros(platformNumber,1);
DM = cell(platformNumber,1);

t = decisionTime * ones(platformNumber,1);
T = cell(platformNumber,1);

tT = decisionTime * ones(targetNumber,1);
TT = cell(targetNumber,1);

% simulateTime = decisionTime;

for targetIndex = 1 : targetNumber
    if targetState == 1
        XT{targetIndex,1} = Xt(targetIndex,1);
        ZT{targetIndex,1} = Zt(targetIndex,1);
        YT{targetIndex,1} = Yt(targetIndex,1);
        VT{targetIndex,1} = Vt(targetIndex,1);
        CIT{targetIndex,1} = Cita_t(targetIndex,1);
        FAI{targetIndex,1} = Fai_t(targetIndex,1);
    end
end

for platformIndex = 1 : platformNumber
    targetLabel = optimalSolution.IIPlatformCode(1,platformIndex);
    if targetLabel ~= 0
        
        XM{platformIndex,1} = Xm(platformIndex,1);
        ZM{platformIndex,1} = Zm(platformIndex,1);
        YM{platformIndex,1} = Ym(platformIndex,1);
        VM{platformIndex,1} = Vm(platformIndex,1);
        CITM{platformIndex,1} = Cita_m(platformIndex,1);
        FAIM{platformIndex,1} = Fai_m(platformIndex,1);
        %         CNm{platformIndex,1} = 1;
        
        DD(platformIndex,1) =  norm( [Xm(platformIndex,1),Zm(platformIndex,1),Ym(platformIndex,1)] - [Xt(targetLabel,1),Zt(targetLabel,1),Yt(targetLabel,1)] );
        DM{platformIndex,1} = DD(platformIndex,1);
        
        T{platformIndex,1} = t(platformIndex,1);
    end
end

%% 目标被攻击集合
targetPlatformSet = optimalSolution.targetPlatformCode;
targetPlatformNumber = zeros(1,targetNumber);
for targetIndex = 1 : targetNumber
    targetPlatformNumber(1,targetIndex) = size(targetPlatformSet{1,targetIndex},2);
end

endFlag = 0;    % 攻击完成标识
targetEndFlag = zeros(1,targetNumber);
targetEndFlag(targetState==0) = 1;
sensorStateFlag = zeros(1,targetNumber);
irradiatePosition = zeros(targetNumber,3);

while(1)
    
    %     simulateTime = simulateTime + Tm;
    
    for targetIndex = 1 : targetNumber
        
        if targetState(1,targetIndex) == 1 && targetEndFlag(1,targetIndex) == 0
            
            if tT(targetIndex,1) >= decisionTime + responseTime && sensorStateFlag(1,targetIndex) == 0
                irradiatePosition(targetIndex,:) = [Xt(targetIndex,1) Zt(targetIndex,1) Yt(targetIndex,1)];
                sensorStateFlag(1,targetIndex) = 1;
            end
            
            if Yt(targetIndex,1) < 8000   %目标纵向过载
                Nyt = 1 + 0.5*rand;
            elseif Yt(targetIndex,1) > 10000
                Nyt = 1 - 0.5*rand;
            else
                Nyt = 1 + 0.5*(1-2*rand);
            end
            
            if Zt(targetIndex,1) < 10000
                Nzt = 1 * rand;
            elseif Zt(targetIndex,1) > 70000
                Nzt = -1 * rand;
            else
                Nzt = 1 * (1-2*rand);
            end
            
            Nxt = 0;
            
            [ updateXt, updateYt, updateZt, updateVt, updateCita_t, updateFai_t ] = Tlgkt( Xt(targetIndex,1), Yt(targetIndex,1), Zt(targetIndex,1), Vt(targetIndex,1), Cita_t(targetIndex,1), Fai_t(targetIndex,1), Nxt, Nyt, Nzt, Tm);
            tT(targetIndex,1) = tT(targetIndex,1) + Tm;
            
            platformSet = targetPlatformSet{1,targetIndex};
            platformSetSize = size(platformSet,2);
            if platformSetSize > 0
                
                if tT(targetIndex,1) <= decisionTime + responseTime
                    for platformIndex = 1 : platformSetSize
                        platformLabel = platformSet(1,platformIndex);
                        XM{platformLabel,1} = [ XM{platformLabel,1}, Xm(platformLabel,1) ];
                        YM{platformLabel,1} = [ YM{platformLabel,1}, Ym(platformLabel,1) ];
                        ZM{platformLabel,1} = [ ZM{platformLabel,1}, Zm(platformLabel,1) ];
                        VM{platformLabel,1} = [ VM{platformLabel,1}, Vm(platformLabel,1) ];
                        CITM{platformLabel,1} = [ CITM{platformLabel,1}, Cita_m(platformLabel,1) ];
                        FAIM{platformLabel,1} = [ FAIM{platformLabel,1}, Fai_m(platformLabel,1) ];
                        
                        t(platformLabel,1) = t(platformLabel,1) + Tm;
                        T{platformLabel,1} = [ T{platformLabel,1}, t(platformLabel,1) ];
                    end
                else
                    
                    for platformIndex = 1 : platformSetSize
                        
                        platformLabel = platformSet(1,platformIndex);
                        
                        %                     DD(platformLabel,1) = norm( [Xm(platformLabel,1),Zm(platformLabel,1),Ym(platformLabel,1)] - [Xt(targetIndex,1),Zt(targetIndex,1),Yt(targetIndex,1)] );
                        if t(platformLabel,1)-decisionTime<=t0
                            P=P0;
                        else
                            P=0;
                        end
                        rou=1.22504-1.17614*(1e-4)*Ym(platformLabel,1)+4.31938*(1e-9)*Ym(platformLabel,1)^2;
                        Q=0.5*rou*Vm(platformLabel,1)^2*S*Cx0;   %Q总的空气动力在Ox3轴方向上投影所产生的阻力
                        %------------------求解相对速度
                        Vmx = Vm(platformLabel,1)*cos(Cita_m(platformLabel,1))*cos(Fai_m(platformLabel,1));      Vmy = Vm(platformLabel,1)*sin(Cita_m(platformLabel,1));      Vmz = Vm(platformLabel,1)*cos(Cita_m(platformLabel,1))*sin(Fai_m(platformLabel,1));
                        Vtx = Vt(targetIndex,1)*cos(Cita_t(targetIndex,1))*cos(Fai_t(targetIndex,1));      Vty = Vt(targetIndex,1)*sin(Cita_t(targetIndex,1));      Vtz = Vt(targetIndex,1)*cos(Cita_t(targetIndex,1))*sin(Fai_t(targetIndex,1));
                        dxx = Vtx-Vmx;
                        dyx = Vty-Vmy;
                        dzx = Vtz-Vmz;
                        %------------------求解视线角旋转角速度
                        X = Xt(targetIndex,1)-Xm(platformLabel,1);   Y = Yt(targetIndex,1)-Ym(platformLabel,1);    Z = Zt(targetIndex,1)-Zm(platformLabel,1);      r2 = X^2 + Z^2;     R2 = X^2 + Y^2 + Z^2;
                        dqs = (X*dzx - Z*dxx)/(X^2 + Z^2);
                        dqc = (dyx*r2 - Y*(X*dxx + Z*dzx))/(R2*sqrt(r2));
                        %------------------比例导引率
                        Ny = guidanceLaw(platformLabel,1)*(dqc)*Vm(platformLabel,1)/g + cos(Cita_m(platformLabel,1));
                        Nz = guidanceLaw(platformLabel,1)*(dqs)*Vm(platformLabel,1)*cos(Cita_m(platformLabel,1))/g;
                        
                        [ updateXm, updateYm, updateZm, updateVm, updateCita_m, updateFai_m ] = Mlgkt( Xm(platformLabel,1), Ym(platformLabel,1), Zm(platformLabel,1), Vm(platformLabel,1), Cita_m(platformLabel,1), Fai_m(platformLabel,1), Ny, Nz, Tm, P, Q, G );
                        
                        Xm(platformLabel,1) = updateXm;
                        Ym(platformLabel,1) = updateYm;
                        Zm(platformLabel,1) = updateZm;
                        Vm(platformLabel,1) = updateVm;
                        Cita_m(platformLabel,1) = updateCita_m;
                        Fai_m(platformLabel,1) = updateFai_m;
                        t(platformLabel,1) = t(platformLabel,1)+Tm;
                        
                        XM{platformLabel,1} = [ XM{platformLabel,1}, Xm(platformLabel,1) ];
                        YM{platformLabel,1} = [ YM{platformLabel,1}, Ym(platformLabel,1) ];
                        ZM{platformLabel,1} = [ ZM{platformLabel,1}, Zm(platformLabel,1) ];
                        VM{platformLabel,1} = [ VM{platformLabel,1}, Vm(platformLabel,1) ];
                        T{platformLabel,1} = [ T{platformLabel,1}, t(platformLabel,1) ];
                        CITM{platformLabel,1} = [ CITM{platformLabel,1}, Cita_m(platformLabel,1) ];
                        FAIM{platformLabel,1} = [ FAIM{platformLabel,1}, Fai_m(platformLabel,1) ];
                        
                        DD(platformLabel,1) = norm( [Xm(platformLabel,1),Zm(platformLabel,1),Ym(platformLabel,1)] - [Xt(targetIndex,1),Zt(targetIndex,1),Yt(targetIndex,1)] );
                        DM{platformLabel,1} = [DM{platformLabel,1}, DD(platformLabel,1)];
                        %------------------判断是否命中目标
                        if DD(platformLabel,1) <= 20
                            if rand < optimalSolution.IIIPlatformKillProbability(platformLabel,targetIndex)
                                
                                targetState(1,targetIndex) = 0;
                                targetEndFlag(1,targetIndex) = 1;
                                targetPlatformNumber(1,targetIndex) = targetPlatformNumber(1,targetIndex) - 1;
                                weaponLabel = optimalSolution.IIIPlatformComplement(1,platformLabel);
                                fprintf('target %d is killed by plarform %d using weapon %d\n',targetIndex,platformLabel,weaponLabel);
                                fprintf(fid,'target %d is killed by plarform %d using weapon %d\n',targetIndex,platformLabel,weaponLabel);
                                temp1 = find(targetPlatformSet{1,targetIndex}==platformLabel);
                                targetPlatformSet{1,targetIndex}(temp1) = [];
                                surplusPlatformNumber = size(targetPlatformSet{1,targetIndex},2);
                                if surplusPlatformNumber >0
                                    for surplusPlatformIndex = surplusPlatformNumber: -1 : 1
                                        surplusPlatformLabel = targetPlatformSet{1,targetIndex}(surplusPlatformIndex);
                                        surplusWeaponLabel = optimalSolution.IIIPlatformComplement(1,surplusPlatformLabel);
                                        platformNull(1,surplusPlatformLabel) = 1;
                                        fprintf('target %d is null by platform %d using weapon %d\n',targetIndex,surplusPlatformLabel,surplusWeaponLabel);
                                        fprintf(fid,'target %d is null by platform %d using weapon %d\n',targetIndex,surplusPlatformLabel,surplusWeaponLabel);
                                        targetPlatformSet{1,targetIndex}(surplusPlatformIndex) = [];
                                        targetPlatformNumber(1,targetIndex) = targetPlatformNumber(1,targetIndex) - 1;
                                    end
                                end
                                break;
                            else
                                temp1 = find(targetPlatformSet{1,targetIndex}==platformLabel);
                                targetPlatformSet{1,targetIndex}(temp1) = [];
                                targetPlatformNumber(1,targetIndex) = targetPlatformNumber(1,targetIndex) - 1;
                                weaponLabel = optimalSolution.IIIPlatformComplement(1,platformLabel);
                                fprintf('target %d is survived by platform %d using weapon %d\n',targetIndex,platformLabel,weaponLabel);
                                fprintf(fid,'target %d is survived by platform %d using weapon %d\n',targetIndex,platformLabel,weaponLabel);
                                continue;
                            end
                        end
                        if  t(platformLabel,1) - decisionTime >= tr
                            temp1 = find(targetPlatformSet{1,targetIndex}==platformLabel);
                            targetPlatformSet{1,targetIndex}(temp1) = [];
                            targetPlatformNumber(1,targetIndex) = targetPlatformNumber(1,targetIndex) - 1;
                            weaponLabel = optimalSolution.IIIPlatformComplement(1,platformLabel);
                            fprintf('platform %d using weapon %d soil out\n',platformLabel,weaponLabel);
                            fprintf(fid,'platform %d using weapon %d soil out\n',platformLabel,weaponLabel);
                            continue;
                        end
                    end
                end
            end
            
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
            
            if endFlag == 1 && tT(targetIndex,1) >= maxTime + assessTime
                targetEndFlag(1,targetIndex) = 1;
            end
            
        end
        
    end
    
    %%  武器、目标轨迹解算终止
    if all(targetPlatformNumber==0,'all') && endFlag == 0
        maxTime = max(tT,[],1);
        endFlag = 1;
    end
    if all(targetEndFlag==1,'all')
        endTime = max(tT,[],1);
        return
    end
    
end

fclose(fid);

end

