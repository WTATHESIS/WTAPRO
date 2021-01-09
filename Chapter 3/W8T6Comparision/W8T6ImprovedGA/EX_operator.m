function [child_1,child_2]  = EX_operator(parent_1,parent_2,weapon,goodgene)

child_1 = parent_1;
child_2 = parent_2;
% internum=ceil(weapon*rand(1));%循环次数
% for k=1:internum
  reservenum=[];
  num1=0;
  num2=0;
    for j=1:weapon
        if child_1(j)==child_2(j)
            if child_1(j)==goodgene(j)
                reservenum=[reservenum,j];
            end
        end
    end
    selectedgene1 = ceil(weapon*rand(1));%第一个交叉点
    while ~isempty(find(reservenum==selectedgene1, 1))
        selectedgene1 = ceil(weapon*rand(1));
        num1=num1+1;
        if num1>50
            break;
        end
    end
    selectedgene2 = ceil(weapon*rand(1));%第二个交叉点
    while ~isempty(find(reservenum==selectedgene2, 1))||(selectedgene1==selectedgene2)
        selectedgene2 = ceil(weapon*rand(1));
        num2=num2+1;
         if num2>50
            break;
        end
    end
    temp1=child_1(selectedgene1);
    child_1(selectedgene1)=child_2(selectedgene2);
    child_2(selectedgene2)=temp1;
    temp2=child_1(selectedgene2);
    child_1(selectedgene2)=child_2(selectedgene1);
    child_2(selectedgene1)=temp2;
while ~(any(child_1(1,1:weapon))&&any(child_2(1,1:weapon)))
    child_1 = parent_1;
    child_2 = parent_2;
     num1=0;
     num2=0;
    selectedgene1 = ceil(weapon*rand(1));%第一个交叉点
    while ~isempty(find(reservenum==selectedgene1, 1))
        selectedgene1 = ceil(weapon*rand(1));
        num1=num1+1;
        if num1>50
            break;
        end
    end
    selectedgene2 = ceil(weapon*rand(1));%第二个交叉点
    while ~isempty(find(reservenum==selectedgene2, 1))||(selectedgene1==selectedgene2)
        selectedgene2 = ceil(weapon*rand(1));
        num2=num2+1;
         if num2>50
            break;
        end
    end

    temp1=child_1(selectedgene1);
    child_1(selectedgene1)=child_2(selectedgene2);
    child_2(selectedgene2)=temp1;
    temp2=child_1(selectedgene2);
    child_1(selectedgene2)=child_2(selectedgene1);
    child_2(selectedgene1)=temp2;
end
% end



