function [weaeff,weaeffstd] = weapon_select_information(weanum,tarind,weatarmap)
%WEAPON_EFFECT_SELECT 
%

weaeff = weatarmap(:,tarind);
weaeffstd1 = zeros(weanum,1);
weaeffstd2 = zeros(weanum,1);

for i = 1 : weanum
    if weaeff(i) > 0
        weatar = weatarmap(i,:);
        pritar = weatar(weatar>weaeff(i));
        wortar = weatar(weatar<weaeff(i) & weatar > 0);
        weaeffstd1(i,1) = size(pritar,2);
        worweanum = size(wortar,2);
        if worweanum ~= 0
            for j = 1 : worweanum
                weaeffstd2(i,1) = weaeffstd2(i,1) + (weaeff(i,1)-wortar(1,j))^2;
            end
            weaeffstd2(i,1) = sqrt(weaeffstd2(i,1))/worweanum;
        else
            weaeffstd2(i,1) = weaeff(i,1);
        end
    end
end

weaeffstd = - weaeffstd1 + weaeffstd2;

end

