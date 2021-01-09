function [ SequencedNextPopSet , SequencedNextPopFitness ] = PopSequence( tempNextPopSet , tempNextPopFitness , tempNextPopSize )
%UNTITLED7 此处显示有关此函数的摘要
%   此处显示详细说明

for i = 1 : tempNextPopSize - 1
    for j = 1 : tempNextPopSize - i
        if tempNextPopFitness(j,1) > tempNextPopFitness(j+1,1)
            IntertempNextPopFitness = tempNextPopFitness(j,1);
            tempNextPopFitness(j,1) = tempNextPopFitness(j+1,1);
            tempNextPopFitness(j+1,1) = IntertempNextPopFitness;
            
            IntertempNextPopSet = tempNextPopSet(j,:);
            tempNextPopSet(j,:) = tempNextPopSet(j+1,:);
            tempNextPopSet(j+1,:) = IntertempNextPopSet;
        end
    end
end

SequencedNextPopFitness = tempNextPopFitness;
SequencedNextPopSet = tempNextPopSet;

end

