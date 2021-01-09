function [y_norm] = y_to_norm_v2(y_begin,y_end)

%Y_TO_NORM_V2 此处显示有关此函数的摘要
%   此处显示详细说明

if nargin ~= 2
    error('Wrong number of input arguments! y_to_norm_v2(y_begin,y_end)')
end

h_axes = get(gcf,'CurrentAxes');    %get axes handle.
axesoffsets = get(h_axes,'Position');%get axes position on the figure.
y_axislimits = get(gca, 'ylim');     %get axes extremeties.
y_dir = get(gca,'ydir');
y_scale = get(gca,'YScale');

%get axes length
y_axislength_lin = abs(y_axislimits(2) - y_axislimits(1));


if strcmp(y_dir,'normal')      %axis not reversed
    if strcmp(y_scale,'log')
        %get axes length in log scale.
        y_axislength_log = abs(log10(y_axislimits(2)) - log10(y_axislimits(1)));
        
        %normalized distance from the lower left corner of figure.
        y_begin_norm = axesoffsets(2)+axesoffsets(4)*abs(log10(y_begin)-log10(y_axislimits(1)))/(y_axislength_log);
        %y_end_norm = axesoffsets(2)+axesoffsets(4)*abs(log10(y_end)-log10(y_axislimits(1)))/(y_axislength_log);
        
        y_norm = [y_begin_norm y_end];
    elseif strcmp(y_scale,'linear')%linear scale.
        %normalized distance from the lower left corner of figure.
        y_begin_norm = axesoffsets(2)+axesoffsets(4)*abs((y_begin-y_axislimits(1))/y_axislength_lin);
        %y_end_norm = axesoffsets(2)+axesoffsets(4)*abs((y_end-y_axislimits(1))/y_axislength_lin);
        
        y_norm = [y_begin_norm y_end];
    else
        error('use only lin or log in quotes for scale')
    end
    
elseif strcmp(ydir,'reverse')  %axis is reversed
    if strcmp(y_scale,'log')
        %get axes length in log scale.
        y_axislength_log = abs(log10(y_axislimits(2)) - log10(y_axislimits(1)));
        %normalized distance from the lower left corner of figure.
        y_begin_norm = axesoffsets(2)+axesoffsets(4)*abs(log10(y_axislimits(2))-log10(y_begin))/(y_axislength_log);
        %y_end_norm = axesoffsets(2)+axesoffsets(4)*abs(log10(y_axislimits(2))-log10(y_end))/(y_axislength_log);
        
        y_norm = [y_begin_norm y_end];
    elseif strcmp(y_scale,'linear')
        %normalized distance from the lower left corner of figure.
        y_begin_norm = axesoffsets(2)+axesoffsets(4)*abs((y_axislimits(2)-y_begin)/y_axislength_lin);
        %y_end_norm = axesoffsets(2)+axesoffsets(4)*abs((y_axislimits(2)-y_end)/y_axislength_lin);
        
        y_norm = [y_begin_norm y_end];
    else
        error('use only lin or log in quotes for scale')
    end
else
    error('use only r or nr in quotes for reverse')
end


