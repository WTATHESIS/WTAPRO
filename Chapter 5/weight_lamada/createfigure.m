function createfigure(X1, ymatrix1, ymatrix2, ymatrix3)
%CREATEFIGURE(X1, ymatrix1, ymatrix2, ymatrix3)
%  X1:  stairs x
%  YMATRIX1:  stairs ��������
%  YMATRIX2:  stairs ��������
%  YMATRIX3:  stairs ��������

%  �� MATLAB �� 10-Jul-2020 16:04:36 �Զ�����

% ���� figure
figure1 = figure;

% ���� subplot
subplot1 = subplot(3,1,1,'Parent',figure1);
hold(subplot1,'on');

% ʹ�� stairs �ľ������봴������
stairs(X1,ymatrix1,'Parent',subplot1,'LineWidth',1);

% ���� ylabel
ylabel('NMVSA');

% ȡ�������е�ע���Ա����������� X ��Χ
% xlim(subplot1,[0 4]);
% ȡ�������е�ע���Ա����������� Y ��Χ
% ylim(subplot1,[0.7 1.1]);
box(subplot1,'on');
% ������������������
set(subplot1,'XTick',[0 1 2 3 4],'XTickLabel',{'','','','',''});
% ���� axes
axes1 = axes('Parent',figure1,...
    'Position',[0.13 0.463837960417813 0.775000000000001 0.215735294117647]);
hold(axes1,'on');

% ʹ�� stairs �ľ������봴������
stairs(ymatrix2,'Parent',axes1,'LineWidth',1);

% ���� ylabel
ylabel('Number of target');

% ȡ�������е�ע���Ա����������� X ��Χ
% xlim(axes1,[0 4]);
box(axes1,'on');
% ������������������
set(axes1,'XTick',[0 1 2 3 4],'XTickLabel',{'','','','',''});
% ���� axes
axes2 = axes('Parent',figure1,...
    'Position',[0.130520833333333 0.218411214953272 0.775000000000001 0.215735294117647]);
hold(axes2,'on');

% ʹ�� stairs �ľ������봴������
stairs(ymatrix3,'Parent',axes2,'LineWidth',1);

% ���� text
text('Parent',axes2,'FontSize',15,'FontName','Times New Roman',...
    'String','stage 1',...
    'Position',[0.33 -4 0]);

% ���� text
text('Parent',axes2,'FontSize',15,'FontName','Times New Roman',...
    'String','stage 2',...
    'Position',[1.33 -4 0]);

% ���� text
text('Parent',axes2,'FontSize',15,'FontName','Times New Roman',...
    'String','stage 3',...
    'Position',[2.33 -4 0]);

% ���� text
text('Parent',axes2,'FontSize',15,'FontName','Times New Roman',...
    'String','stage 4',...
    'Position',[3.33 -4 0]);

% ���� ylabel
ylabel('Number of weapon');

% ȡ�������е�ע���Ա����������� X ��Χ
% xlim(axes2,[0 4]);
box(axes2,'on');
% ������������������
set(axes2,'XTick',[0 1 2 3 4],'XTickLabel',{'','','','',''});
