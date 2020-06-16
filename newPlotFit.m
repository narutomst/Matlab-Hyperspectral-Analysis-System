function [hbox, himage] = newPlotFit(img,handles)
%以适应窗口的方式将图像img显示出来
%复杂之处主要在于：先要把figure中的hscrollpanel给删除掉，重新创建坐标区
%才能显示。本函数显示的img都是普通图片的格式。
% GT图是被截屏为图片传入img中的，因为colorbar总是显示的位置不对，没办法只能截屏了。
    hbox = findobj(handles, 'Tag','hbox');
    
    if ~isempty(findobj(hbox,'Tag','imscrollpanel'))
        delete(findobj(hbox,'Tag','imscrollpanel'));
        axes1 = axes('Parent',hbox,'Tag','axes1');
    elseif ~isempty(findobj(hbox,'Type','axes'))
        axes1 = findobj(hbox,'Type','axes');
    else
        axes1 = axes('Parent',hbox,'Tag','axes1');
    end
%         if strcmp(mark, 'reuse')
%             axes1 = findobj(handles,'Type','axes');
%         elseif strcmp(mark, 'delete')
%             delete(findobj(hbox,'Tag','imscrollpanel'));
%             axes1 = axes('Parent', hbox, ...  
%             'Units', 'Normalized', ...
%             'Position', [0.1,0.1,0.8,0.8], ...
%             'NextPlot', 'Replace', ...
%             'Box', 'Off', 'Visible','off', ...
%             'Tag', 'axes1');
%         else
%             axes1 = axes('Parent', hbox, ...  
%             'Units', 'Normalized', ...
%             'Position', [0.1,0.1,0.8,0.8], ...
%             'NextPlot', 'Replace', ...
%             'Box', 'Off', 'Visible','off', ...
%             'Tag', 'axes1');
%         end
% %         hbox = findobj(handles,'Tag','hbox');
% %         scrollpanel = findobj(hbox,'Tag','scrollpanel');
% %         if isempty(scrollpanel)
% %             scrollpanel = uix.ScrollingPanel( 'Parent', hbox, 'Tag', 'scrollpanel' );
% %         end
%         
% %         axes1 = axes('Parent',scrollpanel);
%         %ActivePositionProperty = 'outerposition';
%         %Outposition = [1.0000    1.0000  330.8333  373.0000];
%         %Position = [44.0300   42.0300  256.3583  303.9950];
%         %
        himage = imshow(img,'Parent',axes1,'InitialMagnification','fit');
%         himage = imshow(img);
% 在显示大图像时，只有命令行窗口显示警告信息时，才说明imshow()首先尝试
% 以原始方式显示图像了
% 如果命令行窗口安安静静的，那就说明imshow()直接跳过了尝试以原始大小显示
% 图像的步骤，可能的原因参考以下对imshow()的参数InitialMagnification
% 的详细说明：
%-----------------------------------------------------------------------------------%
%  'InitialMagnification' - 图像显示的初始放大倍率
% 100 （默认） | 数值标量 | 'fit'
% 
% 图像显示的初始放大倍率，指定为逗号分隔的对组，其中包含 'InitialMagnification' 和一个数值
% 标量或 'fit'。如果设为 100，则 imshow 在 100% 放大倍率下显示图像（每个图像像素对应一个屏幕
% 像素）。如果设为 'fit'，则 imshow 缩放整个图像以适合窗口。
% 首先，imshow 会尝试以指定的放大倍率显示整个图像。如果放大倍率值很大以至于图像太大而无法在
% 屏幕上显示，则 imshow 在适合屏幕大小的最大放大倍率下显示该图像。
% 如果图像显示在图窗中时其 'WindowStyle' 属性设为 'docked'，则 imshow 在适合图窗大小的最大
% 放大倍率下显示该图像。
% 注意：如果指定坐标区的位置（使用 subplot 或 axes），则 imshow 忽略您可能已指定的任何初始放
% 大倍率并默认设置为 'fit' 行为。
%-------------------------------------------------------------------------------------%
% 		hscrollpanel = imscrollpanel(hbox, himage); 
%     默认的'Tag' 是 'imscrollpanel'
% 
pwidthmax = -1;
set( hbox, 'Widths', [pwidthmax,-5] );
end