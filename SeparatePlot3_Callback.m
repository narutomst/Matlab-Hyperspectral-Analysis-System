function SeparatePlot3_Callback(img,cmap,M)

    p = figure();
    axes1 = axes('Parent',p,'Tag','axes1');
    if ndims(img) == 3
        himage = imshow(img,'Parent',axes1);
    elseif ndims(img) == 2
%         img = ind2rgb(img+1,cmap);
%         himage = imshow(img,'Parent',axes1);  %img是double，则值1对应于cmap第一种颜色；img是整数值，则值0对应于cmap第一种颜色
%         colormap(axes1,cmap);
        himage = imshow(img+1,cmap,'Parent',axes1); 
        c = colorbar;
        c.Label.String = '地物类别对应颜色';
        c.Label.FontWeight = 'bold'; 
        
        c.Ticks = 0.5:1:M+0.5;       %刻度线位置
        c.TicksMode = 'Manual';
        c.TickLabels = num2str([-1:M-1]'); %刻度线值
        c.Limits = [1,M+1];
    end  
    hscrollpanel = imscrollpanel(p, himage); 

end