function [ epsilon ] = EpsilonGenerate(  Population, PopSize, epsilon , k )
%EPSILONGENERATE 此处显示有关此函数的摘要
%   此处显示详细说明

sita = 0.05 * PopSize;
Tc = 80;
cp = 2;
if k == 1
    ConstraintList = [Population.Constraint];
    SortConstaintList = sort(ConstraintList,'descend');
    epsilon(k) = SortConstaintList(sita);
elseif k <Tc
    epsilon(k) = epsilon(1)*(1-k/Tc)^cp;
elseif k >= Tc
    epsilon(k) = 0;
end

end

