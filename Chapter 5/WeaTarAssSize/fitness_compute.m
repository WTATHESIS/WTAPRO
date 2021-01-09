function [totfit,curfit,postfit,tarsurpro,asssurpro] = fitness_compute(weasta,tarsta,asssta,weakillpro,tarkillpro,assval,weadec,tardec,curwei)
%FITNESS_COMPUTE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

%% ��ǰ��������
[tareffkillpro,tarsurpro] = tareffkillpro_compute(tarsta,weakillpro,tarkillpro,weadec);
[totexcassval,~,asssurpro] = target_asset_fitness(assval,asssta,tareffkillpro,tardec);
% curfit = totexcassval;
curfit = totexcassval/sum(assval.*asssta);

%% ʣ���������½׶�̬����������
if all(weasta==0)
    postfit = 0;
else
    temp1 = 1 - (1 - sum(weakillpro .* weasta')/sum(weasta)) .^ (sum(weasta)/sum(tarsta));
    temp2 = assval .* asssurpro .* tarsta' .* tarkillpro .* temp1';
    postfit = sum(temp2,'all')/sum(tarsta)/sum(assval .* asssta .* asssurpro);
    
%     temp2 = assval .* tarsta' .* tarkillpro .* temp1';
%     postfit = sum(temp2,'all')/sum(tarsta)/sum(assval.*asssta);
end

totfit = curwei * curfit + ( 1 - curwei ) * postfit;

end

