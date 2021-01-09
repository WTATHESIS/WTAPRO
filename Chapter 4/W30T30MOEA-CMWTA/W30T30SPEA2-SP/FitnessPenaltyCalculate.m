function [Population] = FitnessPenaltyCalculate(Population,PopSize)
%FITNESSPENALTYCALCULATE 此处显示有关此函数的摘要
%   此处显示详细说明

Fit = reshape([Population.Fitness],[2 PopSize])';
MinMaxFit = zeros(2,2);
MinMaxFit(1,1) = min(Fit(:,1));
MinMaxFit(2,1) = max(Fit(:,1));
MinMaxFit(1,2) = min(Fit(:,2));
MinMaxFit(2,2) = max(Fit(:,2));

subCon = reshape([Population.subCon],[3 PopSize])';
MaxCon = zeros(1,3);
MaxCon(1,1) = max(subCon(:,1));
MaxCon(1,2) = max(subCon(:,2));
MaxCon(1,3) = max(subCon(:,3));

Constraint = [Population.Constraint]';
rf = sum(Constraint==0)/PopSize;

f = Fit./(MinMaxFit(2,:)-MinMaxFit(1,:));
v = zeros(PopSize,1);
for i = 1 : 3
    if MaxCon(1,i)~=0
        v = v + subCon(:,i)./MaxCon(1,i);
    end
end
v = v./3;

for i = 1 : PopSize
    if rf == 0
        d = [v(i) v(i)];
        X = [0 0];
    else
        d = (f(i,:).^2 + v(i).^2).^0.5;
        X = [v(i) v(i)];
    end
    if Constraint(i) == 0
        Y = [0 0];
    else
        Y = f(i,:);
    end
    p = (1-rf).*X + rf.*Y;
    Population(i).FitPen = d + p;
end

end

