function [hbox, himage] = newPlotGT(img, handles)
    
   
    if ndims(img)==2
        M = numel(unique(img(:)));
    end
   
    hbox = findobj(handles, 'Tag','hbox');
 
% %     img = hObject.UserData.img;
    if ~isempty(findobj(hbox,'Tag','imscrollpanel'))
        delete(findobj(hbox,'Tag','imscrollpanel'));
        axes1 = axes('Parent',hbox,'Tag','axes1');
    elseif ~isempty(findobj(hbox,'Type','axes'))
        axes1 = findobj(hbox,'Type','axes');
    else
        axes1 = axes('Parent',hbox,'Tag','axes1');
    end
    
        colorMap = handles.UserData.cmap;   
    
    if isempty(colorMap)
        colorBase = [[1,0,0]; [0,1,0]; [0,0,1]; [1,1,0]; [1,0,1]; [0,1,1]; ...
                            [0.5,0,0]; [0,0.5,0];[0,0,0.5]; [0.25,0.75,0]; [0.85,0.5,0]; [0.5,0.5,0]; ... 
                            [0.5,0,1]; [1,0,0.5]; [0.5,0,0.5]; [0.35,0.65,0.75]; [0,1,0.5]; [0,0.5,0.5]; ...
                            [0.5,0.5,0.5];[0.1,0.1,0.1]];
        bkcGT = handles.UserData.bkcGT; %GT图上的背景颜色        
        colorMap = [bkcGT;colorBase];   %添加背景像素的颜色
        cmap = colormap(colorMap);
        handles.UserData.cmap = cmap;
    end
%     cmap = colormap(colorMap(1:M,:));
    cmap = colormap(colorMap);
    himage = imshow(img+1,cmap,'Parent',axes1);
    hscrollpanel = imscrollpanel(hbox, himage); 
    
% imshow(X,map)的特别说明
% X - 索引图像
% m×n 整数矩阵
% 索引图像，指定为 m×n 整数矩阵。
% 
% 如果将 X 指定为整数数据类型的数组，则值 0 对应于颜色图 map 中的第一种颜色。对于包含 c 种颜色的颜色图，图像 X 的值会被裁剪到范围 [0, c-1] 内。
% 
% 如果将 X 指定为 single 或 double 数据类型的数组，则值 1 对应于颜色图中的第一种颜色。对于包含 c 种颜色的颜色图，图像 X 的值会被裁剪到范围 [1, c] 内。
%     

    c = colorbar;
    c.Label.String = '地物类别对应颜色';
    c.Label.FontWeight = 'bold'; 
    
    c.Ticks = 0.5:1:M+0.5;       %刻度线位置
    c.TicksMode = 'Manual';
    c.TickLabels = num2str([-1:M-1]'); %刻度线值
    c.Limits = [1,M+1];

    
    pwidthmax = -1;
    set( hbox, 'Widths', [pwidthmax,-5] );
    
    handles.UserData.himage = himage;
    handles.UserData.M = M;
    handles.UserData.aPosition = axes1.Position;
    
end