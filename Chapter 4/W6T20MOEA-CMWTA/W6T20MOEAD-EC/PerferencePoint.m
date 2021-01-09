function [ z ] = PerferencePoint( ObjectNum , Population , PopSize )
%PERFERENCEPOINT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

z = zeros( 2 , ObjectNum );
temp1 = zeros( PopSize , ObjectNum );
for i = 1 : PopSize
    temp1(i,:) = Population(i).Fitness; 
end
for i = 1 : ObjectNum
    z(1,i) = min(temp1(:,i));
    z(2,i) = max(temp1(:,i));
end

end

