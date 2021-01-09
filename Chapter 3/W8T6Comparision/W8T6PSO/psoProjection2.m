function [x,fval] = psoProjection2(lb,ub,v,p)

%   Editor: Yan Ou
%   Date: 2013/10/07


% set the defualt value for the inertia, correction_factor, iteration
np = 300;
iteration = 100;
inertia = 0.1;
correction_factor = 2;

% neighborhoodNum = round(np/3); % define the neighborhood number as the calculation of the global best solution

xIni = rand(np,length(lb));
vIni = rand(np,length(lb));
% vIni = (-abs(ub-lb)*ones(1,np)+(abs(ub-lb)+abs(ub-lb))*rand(np,1)')'; % TODO: improve this function by reducing the computational time
swarm = zeros(np,5,size(xIni,2));
% neighborSwarm = zeros(neighborhoodNum,5,size(xIni,2));
swarm(:,1,:) = xIni;
swarm(:,3,:) = xIni;
swarm(:,2,:) = vIni;
swarm(:,4,1) = 1000000000;
[tempValue, tempIndex] = min(swarm(:, 4, 1));
gbest = swarm(tempIndex, 3, :);
gbestValue = []; % the gather of the gbest values
stopValue = 100; % the stop criteria of the iteration

% run particle swarm optimization algorithm to converge the particle swarm
for iter = 1 : iteration
    % pl, pb, pb_val
    for i = 1 : np
        
        % project the particle which is outside the boundary to inside the boundary
        newParticle = swarm(i, 1, :) + swarm(i, 2, :);
        newParticle = min(newParticle,reshape(ub,1,1,length(lb)));
        newParticle = max(newParticle,reshape(lb,1,1,length(lb)));
        % reset the velocity of the particles
        swarm(i, 2, :) = newParticle - swarm(i,1,:);
        % calculate the new particle position
        swarm(i, 1, :) = newParticle;
        
        val = wta_loss(swarm(i,1,:),v,p);
        if val < swarm(i, 4, 1)                 % if new position is better
            swarm(i,3,:) = swarm(i,1,:);
            swarm(i, 4, 1) = val;               % and best value
        end
    end

    % pg
%     swarmPosition = reshape(swarm(:,1,:),np,length(lb));
%     particlePosition = reshape(swarm(i,1,:),1,length(lb));
%     swarmDist = bsxfun(@minus, swarmPosition, particlePosition);
%     swarmDist = sqrt(sum(swarmDist.^2,2));
%     sortDist = sort(swarmDist);
%     threshold = sortDist(neighborhoodNum);
%     neighborSwarm = swarm(swarmDist<=threshold,:,:); % find the neighborhood particles
    [tempValue, tempIndex] = min(swarm(:, 4, 1));        % global best position
    fun_gbest = wta_loss(gbest,v,p);
    if (tempValue < fun_gbest)
        gbest = swarm(tempIndex, 3, :);
    end
    swarm(i,5,:) = gbest;
    gbestValue(end+1) = wta_loss(gbest,v,p);
    
    % velocity
    for i = 1:np
        swarm(i, 2, :) = inertia*swarm(i, 2, :) + correction_factor*rand(1,1,size(xIni,2)).*(swarm(i, 3, :) - swarm(i, 1, :)) + correction_factor*rand(1,1,size(xIni,2)).*(gbest - swarm(i, 1, :));   %x velocity component
    end
    
    % stop criteria
    if iter > 11
        stopValue = sum(log(gbestValue(end-10:end)));
        deltaGbestValue = abs(gbestValue(2:end) - gbestValue(1:end-1));
        deltaGbestValueLog = log(deltaGbestValue(deltaGbestValue~=0));
        if length(deltaGbestValueLog) > 10
            sumDelta = sum(deltaGbestValueLog(end-10:end));
        else
            sumDelta = sum(deltaGbestValueLog);
        end
        if sumDelta < stopValue/2
            break;
        end
    end
end

% return the value
[temp, gbest] = min(swarm(:, 4, 1));
x = swarm(gbest, 1, :);
fval = wta_loss(x,v,p);
end