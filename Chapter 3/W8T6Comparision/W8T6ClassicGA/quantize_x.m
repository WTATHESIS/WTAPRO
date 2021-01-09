function x = quantize_x(x,v,n,m)
x1 = zeros(n,m);
for i=1:n
    max_i = max(x(i,:));
    max_index = find(x(i,:)==max_i);
    if length(max_index)==1
        x1(i,max_index) = 1;
    else 
        value = v(max_index);
        [~,max_value_index] = max(value);
        x1(i,max_index(max_value_index)) = 1;
    end
end
x = x1;