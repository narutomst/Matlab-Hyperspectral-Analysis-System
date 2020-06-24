function SeparatePlot2_Callback(hObject, eventdata, handles)
% 【单独绘制(原始大小)】
%只有当前图窗口显示有图片，我们才执行。否则啥也不干。
if ~isempty(findobj(handles,'Type','image')) 
    himage = findobj(handles,'Type','image');
    hmenu3_1 = hObject.Parent.Children(4);
    p = figure();
    if isempty(findobj(handles,'Type','colorbar')) && ~hmenu3_1.UserData.imgGT
    %既不存在colorbar，imgGT又不等于1，则说明当前窗口中为普通图片
    %在新的figure中以原始大小显示普通图片
        himage = imshow(himage.CData,'Parent',gca);     
    else
    %在新的figure中以原始大小显示GT图片
        himage = plot1(handles);
    end
    hscrollpanel = imscrollpanel(p, himage);  
end    
  

end