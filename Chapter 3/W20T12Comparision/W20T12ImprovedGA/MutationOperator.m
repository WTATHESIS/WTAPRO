function [ Individual ] = MutationOperator( Individual , WeaponNum , TargetNum )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

MutationPos = randi(WeaponNum);     % ������ɱ������λ
PreMutationGene = Individual(1,MutationPos);     % ����������λԭ�������
Individual(1,MutationPos) = randi(TargetNum);     % �������

%   �������ʧЧ
while ( Individual(1,MutationPos) == PreMutationGene )
    Individual(1,MutationPos) = randi(TargetNum);
end

end

