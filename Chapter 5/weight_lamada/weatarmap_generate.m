function [weatarmap,weatarsta] = weatarmap_generate(weanum,tarnum,weakillpro,tareffkill,assval,weatarsta,tardec,sinassfit,effthr)
%WEATARMAP_GENERATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

weatarmap = -inf(weanum,tarnum);
for i = 1 : weanum
    for j = 1 : tarnum
        if weatarsta(i,j) == 1
            assind = find(tardec(j,:)==1);
            if sinassfit(assind) > assval(1,assind)* effthr
                weatarmap(i,j) = -inf;
                weatarsta(i,j) = 0;
            else
                weatarmap(i,j) = sinassfit(1,assind)*tareffkill(j,assind)*weakillpro(i,j)/(1-tareffkill(j,assind));
            end
        end
    end
end

end

