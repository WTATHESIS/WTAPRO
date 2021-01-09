
% AverageSizeFitness = zeros(6,100);
% 
% for i = 1 : 10 
%     
%     for j = 1 : 30
%         
%         FileName1 = ['SizeFitnessRecord',num2str(i),num2str(j),'.mat'];
%         load(FileName1);
%         
%         for m = 2 : 6
%             for n = 1 : 100
%                 AverageSizeFitness(m,n) = AverageSizeFitness(m,n) + SizeFitnessRecord{n,m}.Fitness(1,1);
%             end
%         end
%         
%     end
%     
%     AverageSizeFitness = AverageSizeFitness/30;
%     
%     FileName2 = ['AverageSizeFitness',num2str(i)];
%     ValueName2 = ['AverageSizeFitness'];
%     save(FileName2,ValueName2);
%     
% end

for i = 2 : 6
    
    figure(i-1);
    
    for j = 1 : 1 : 10
        
        FileName = ['AverageSizeFitness',num2str(j),'.mat'];
        load(FileName);
        
        %plot(AverageSizeFitness(i,:));
        plot(AverageSizeFitness(i,90:100));
        hold on
        
    end
    
    legend('2','4','6','8','10');
    
end