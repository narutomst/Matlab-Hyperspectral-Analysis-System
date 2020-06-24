function SeparatePlot1_Callback(hObject, eventdata, handles)
% 【单独绘制(自适应)】
%只有当前图窗口显示有图片，我们才执行。否则啥也不干。
if 0&&~isempty(findobj(handles,'Type','image')) 
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
end

if 1&&~isempty(findobj(handles,'Type','image'))       
    himage = findobj(handles,'Type','image');
    
    figure()
    if ~isempty(findobj(handles,'Tag','imscrollpanel'))
        if ~isempty(findobj(handles,'Type','colorbar'))
            %在新的figure中显示GT图片
            himage = plot1(handles);
        else
            %在新的figure中显示普通图片
            himage = imshow(himage.CData);%经过试验，即便加上,'InitialMagnification',200，图片也无法显示到原始大小
        end
    else %窗口中有图但是没有滚动条
        hmenu3_1 = hObject.Parent.Children(4);%也是[适应窗口]
        if ~hmenu3_1.UserData.imgGT     %查询【适应窗口】操作的对象是普通图还是GT图
        %  在新的figure中显示普通图片
            himage = imshow(himage.CData);
        else
            %在新的figure中显示GT图片
            himage = plot1(handles);
        end
    end   
end
end