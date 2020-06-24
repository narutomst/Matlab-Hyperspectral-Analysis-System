function SeparatePlot1_Callback(hObject, eventdata, handles)
%只有当前图窗口显示有图片，我们才执行。否则啥也不干。
if ~isempty(findobj(handles,'Type','image'))       
    himage = findobj(handles,'Type','image');
    
    figure()
    if ~isempty(findobj(handles,'Tag','imscrollpanel'))
        if ~isempty(findobj(handles,'Type','colorbar'))
            %在新的figure中显示GT图片
            img = handles.UserData.gtdata;
            %[hbox, himage] = newPlotGT(double(x), handles);
            if ndims(img)==2
                M = numel(unique(img(:)));
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
            himage = imshow(img+1,cmap);        

            c = colorbar;
            c.Label.String = '地物类别对应颜色';
            c.Label.FontWeight = 'bold'; 

            c.Ticks = 0.5:1:M+0.5;       %刻度线位置
            c.TicksMode = 'Manual';
            c.TickLabels = num2str([-1:M-1]'); %刻度线值
            c.Limits = [1,M+1];        
        else
            %在新的figure中显示普通图片
            himage = imshow(himage.CData);
        end
    else %窗口中有图但是没有滚动条
        hmenu3_1 = hObject.Parent.Children(4);%也是[适应窗口]
        if ~hmenu3_1.UserData.imgGT     %查询【适应窗口】操作的对象是普通图还是GT图
        %  显示普通图片
            himage = imshow(himage.CData);
        else
            %显示GT图片
            img = handles.UserData.gtdata;
            %[hbox, himage] = newPlotGT(double(x), handles);
            if ndims(img)==2
                M = numel(unique(img(:)));
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
            himage = imshow(img+1,cmap);        

            c = colorbar;
            c.Label.String = '地物类别对应颜色';
            c.Label.FontWeight = 'bold'; 

            c.Ticks = 0.5:1:M+0.5;       %刻度线位置
            c.TicksMode = 'Manual';
            c.TickLabels = num2str([-1:M-1]'); %刻度线值
            c.Limits = [1,M+1];        

        end
    end   
end
end