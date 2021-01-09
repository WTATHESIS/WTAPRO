function createfigure(X1, ymatrix1, ymatrix2, ymatrix3)
%CREATEFIGURE(X1, ymatrix1, ymatrix2, ymatrix3)
%  X1:  stairs x
%  YMATRIX1:  stairs 矩阵数据
%  YMATRIX2:  stairs 矩阵数据
%  YMATRIX3:  stairs 矩阵数据

%  由 MATLAB 于 10-Jul-2020 16:04:36 自动生成

% 创建 figure
figure1 = figure;

% 创建 subplot
subplot1 = subplot(3,1,1,'Parent',figure1);
hold(subplot1,'on');

% 使用 stairs 的矩阵输入创建多行
stairs(X1,ymatrix1,'Parent',subplot1,'LineWidth',1);

% 创建 ylabel
ylabel('NMVSA');

% 取消以下行的注释以保留坐标区的 X 范围
% xlim(subplot1,[0 4]);
% 取消以下行的注释以保留坐标区的 Y 范围
% ylim(subplot1,[0.7 1.1]);
box(subplot1,'on');
% 设置其余坐标区属性
set(subplot1,'XTick',[0 1 2 3 4],'XTickLabel',{'','','','',''});
% 创建 axes
axes1 = axes('Parent',figure1,...
    'Position',[0.13 0.463837960417813 0.775000000000001 0.215735294117647]);
hold(axes1,'on');

% 使用 stairs 的矩阵输入创建多行
stairs(ymatrix2,'Parent',axes1,'LineWidth',1);

% 创建 ylabel
ylabel('Number of target');

% 取消以下行的注释以保留坐标区的 X 范围
% xlim(axes1,[0 4]);
box(axes1,'on');
% 设置其余坐标区属性
set(axes1,'XTick',[0 1 2 3 4],'XTickLabel',{'','','','',''});
% 创建 axes
axes2 = axes('Parent',figure1,...
    'Position',[0.130520833333333 0.218411214953272 0.775000000000001 0.215735294117647]);
hold(axes2,'on');

% 使用 stairs 的矩阵输入创建多行
stairs(ymatrix3,'Parent',axes2,'LineWidth',1);

% 创建 text
text('Parent',axes2,'FontSize',15,'FontName','Times New Roman',...
    'String','stage 1',...
    'Position',[0.33 -4 0]);

% 创建 text
text('Parent',axes2,'FontSize',15,'FontName','Times New Roman',...
    'String','stage 2',...
    'Position',[1.33 -4 0]);

% 创建 text
text('Parent',axes2,'FontSize',15,'FontName','Times New Roman',...
    'String','stage 3',...
    'Position',[2.33 -4 0]);

% 创建 text
text('Parent',axes2,'FontSize',15,'FontName','Times New Roman',...
    'String','stage 4',...
    'Position',[3.33 -4 0]);

% 创建 ylabel
ylabel('Number of weapon');

% 取消以下行的注释以保留坐标区的 X 范围
% xlim(axes2,[0 4]);
box(axes2,'on');
% 设置其余坐标区属性
set(axes2,'XTick',[0 1 2 3 4],'XTickLabel',{'','','','',''});
