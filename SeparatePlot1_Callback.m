function SeparatePlot1_Callback(hObject, eventdata, handles)
%只有当前图窗口显示有图片，我们才执行。否则啥也不干。
if ~isempty(findobj(handles,'Type','image'))       
    img = handles.UserData.img;
    figure
    if ndims(img) == 3
        himage = imshow(img);
    elseif ndims(img) == 2
        himage = imshow(img,handles.UserData.cmap);
        c = colorbar;
        c.Label.String = '地物类别对应颜色';
        c.Label.FontWeight = 'bold'; 
        M = handles.UserData.M;
        
        c.Ticks = 0.5:1:M+0.5;       %刻度线位置
        c.TicksMode = 'Manual';
        c.TickLabels = num2str([-1:M-1]'); %刻度线值
        c.Limits = [1,M+1];
    end
end
end