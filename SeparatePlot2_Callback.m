function SeparatePlot2_Callback(hObject, eventdata, handles)
% newPlotGT(hObject, handles);
%只有当前图窗口显示有图片，我们才执行。否则啥也不干。
if ~isempty(findobj(handles,'Type','image'))   
    img = handles.UserData.img;
    p = figure();
    axes1 = axes('Parent',p,'Tag','axes1');
    if ndims(img) == 3
        himage = imshow(img,'Parent',axes1);
    elseif ndims(img) == 2
        himage = imshow(img,handles.UserData.cmap,'Parent',axes1);
        c = colorbar;
        c.Label.String = '地物类别对应颜色';
        c.Label.FontWeight = 'bold'; 
        
        M = handles.UserData.M;
        
        c.Ticks = 0.5:1:M+0.5;       %刻度线位置
        c.TicksMode = 'Manual';
        c.TickLabels = num2str([-1:M-1]'); %刻度线值
        c.Limits = [1,M+1];
    end  
    hscrollpanel = imscrollpanel(p, himage); 
end
end