function [archive] = NextArchiveGenerate(Population,archive,nArchive,K)
%SPEA2NONDOMINATEDSORTING 此处显示有关此函数的摘要
%   此处显示详细说明

Q = [Population ; archive];
nQ = numel(Q);

[Q] = FitnessPenaltyCalculate(Q,nQ);

dom = false(nQ,nQ);
for i=1:nQ
    Q(i).S=0;
end

Z = reshape([Q.FitPen],[2 nQ])';

S=[Q.S];
for i = 1 : nQ-1
    for j = i+1 : nQ
        if DominateEstimate(i,j,Z)
            S(i)=S(i)+1;
            dom(i,j)=true;
        elseif DominateEstimate(j,i,Z)
            S(j)=S(j)+1;
            dom(j,i)=true;
        end
    end
end

for i=1:nQ
    Q(i).S = S(i);
    Q(i).R=sum(S(dom(:,i)));
end

SIGMA=pdist2(Z,Z,'seuclidean');
SIGMA=sort(SIGMA);
for i=1:nQ
    Q(i).sigma=SIGMA(:,i);
    Q(i).sigmaK=Q(i).sigma(K);
    Q(i).D=1/(Q(i).sigmaK+2);
    Q(i).F=Q(i).R+Q(i).D;
end

nND=sum([Q.R]==0);
if nND<=nArchive
    F=[Q.F];
    [F, SO]=sort(F);
    Q=Q(SO);
    archive=Q(1:min(nArchive,nQ));
else
    SIGMA=SIGMA(:,[Q.R]==0);
    archive=Q([Q.R]==0);
    k=2;
    while numel(archive)>nArchive
        while min(SIGMA(k,:))==max(SIGMA(k,:)) && k<size(SIGMA,1)
            k=k+1;
        end
        [~, j]=min(SIGMA(k,:));
        archive(j)=[];
        SIGMA(:,j)=[];
    end
end

end

