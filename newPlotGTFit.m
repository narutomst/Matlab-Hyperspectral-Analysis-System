function [hbox, himage] = newPlotGTFit(img, handles)
%为什么不利用himage直接显示呢？
%因为需要删除滑动条，而删除hscrollpanel就会删除其上面的himage，
%所以就不能利用himage了，所以只能重新绘制一次

    M = handles.UserData.M;
    
    hbox = findobj(handles, 'Tag','hbox');
%     hscrollpanel = findobj(handles,'Tag','imscrollpanel');

    if ~isempty(findobj(hbox,'Tag','imscrollpanel'))
        delete(findobj(hbox,'Tag','imscrollpanel'));
        %删除hscrollpanel就会删除himage，所以就不能利用himage了，所以只能重新绘制一次
        axes1 = axes('Parent',hbox,'Tag','axes1');
    elseif ~isempty(findobj(hbox,'Type','axes'))
        axes1 = findobj(hbox,'Type','axes');
    else
        axes1 = axes('Parent',hbox,'Tag','axes1');
    end
    cmap = handles.UserData.cmap;   
    
    if isempty(cmap)
        colorBase = [ [1,0,0]; [0,1,0]; [0,0,1]; [1,1,0]; [1,0,1]; [0,1,1]; ...
                            [0.5,0,0]; [0,0.5,0];[0,0,0.5]; [0.25,0.75,0]; [0.85,0.5,0]; [0.5,0.5,0]; ... 
                            [0.5,0,1]; [1,0,0.5]; [0.5,0,0.5]; [0.35,0.65,0.75]; [0,1,0.5]; [0,0.5,0.5]; ...
                            [0.5,0.5,0.5];[0.1,0.1,0.1]];
        cmap = [[0,0,0];colorBase];   %添加背景像素的颜色
        hObject.UserData.cmap = cmap;
        handles.UserData.cmap = cmap;
    end
%     cmap = colormap(colorMap(1:M,:));
    cmap = colormap(cmap);
    himage = imshow(img,cmap,'Parent',axes1,'InitialMagnification','fit');
%     hscrollpanel = imscrollpanel(hbox, himage); 
    
%     c = colorbar('Parent',hscrollpanel);
%     c.Label.String = '地物类别对应颜色';
%     c.Limits = [1 M+1];
%     c.Ticks = 1:1:M;
    c = colorbar;
%     c.FontSize = round(c.Position(4)*300/M);
    pwidthmax = -1;
%     set( hbox, 'Widths', [pwidthmax,-5,-0.2] );
    
    c.Units = 'normalized';
    c.Position = [0.578, 0.1084, 0.00673, 0.8168];
    

    handles.UserData.himage = himage;
    hObject.UserData.himage = himage;
    handles.UserData.c = c;
    
end