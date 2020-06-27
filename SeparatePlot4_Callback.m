function SeparatePlot4_Callback(img1, img2, cmap, M)
%用3种方式来实现绘制真实标签图和预测标签图

%subplot()方式绘制并排的双子图
    p = figure();
    axes1 = subplot(1,2,1);
    if ndims(img1) == 3
        himage1 = imshow(img1,'Parent',axes1);
    elseif ndims(img1) == 2
        himage1 = imshow(img1+1,cmap,'Parent',axes1); 
        c = colorbar;
        c.Label.String = '地物类别对应颜色';
        c.Label.FontWeight = 'bold'; 
        
        c.Ticks = 0.5:1:M+0.5;       %刻度线位置
        c.TicksMode = 'Manual';
        c.TickLabels = num2str([-1:M-1]'); %刻度线值
        c.Limits = [1,M+1];
    end  
%     hscrollpanel = imscrollpanel(p, himage); 
    axes2 = subplot(1,2,2);
    if ndims(img2) == 3
        himage2 = imshow(img2,'Parent',axes2);
    elseif ndims(img2) == 2
        himage2 = imshow(img2+1,cmap,'Parent',axes2); 
        c = colorbar;
        c.Label.String = '地物类别对应颜色';
        c.Label.FontWeight = 'bold'; 
        
        c.Ticks = 0.5:1:M+0.5;       %刻度线位置
        c.TicksMode = 'Manual';
        c.TickLabels = num2str([-1:M-1]'); %刻度线值
        c.Limits = [1,M+1];
        disp('绘图完成！');
    end 
    
    % 合成双图1：img1和img2先合成一张图，然后再显示出来
    p1 = figure();
    if ndims(img1) == 2 && ndims(img2) == 2
        gap = min(img1(:))*ones(size(img1,1), 5);
        %将多个矩阵水平串联起来
%         img = cat(2,img1, gap, img2);
        img = [img1, gap, img2];
        himage3 = imshow(img+1,cmap); 
        c = colorbar;
        c.Label.String = '地物类别对应颜色';
        c.Label.FontWeight = 'bold'; 
        
        c.Ticks = 0.5:1:M+0.5;       %刻度线位置
        c.TicksMode = 'Manual';
        c.TickLabels = num2str([-1:M-1]'); %刻度线值
        c.Limits = [1,M+1];  
        hscrollpanel = imscrollpanel(p1, himage3); 
    end
    
    %合成双图2：还可以合成镜像双图 flip(A,2)，将矩阵A的每一行翻转
    if 1
        p2 = figure();
        img = [img1, gap, flip(img2,2)];
        himage4 = imshow(img+1,cmap); 
        c = colorbar;
        c.Label.String = '地物类别对应颜色';
        c.Label.FontWeight = 'bold'; 
        
        c.Ticks = 0.5:1:M+0.5;       %刻度线位置
        c.TicksMode = 'Manual';
        c.TickLabels = num2str([-1:M-1]'); %刻度线值
        c.Limits = [1,M+1];  
        hscrollpanel = imscrollpanel(p2, himage4); 
    end
end