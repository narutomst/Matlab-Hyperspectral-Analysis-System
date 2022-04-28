function SeparatePlot4_Callback(img1, img2, cmap, M)
%用3种方式来实现绘制真实标签图和预测标签图

%subplot()方式绘制并排的双子图，一行两列或者两行一列
    p = figure();
    if size(img1,1) > size(img1,2)*0.8
        flag = 121;     % 一行两列排列子图
        axes1 = subplot(1,2,1);
    else
        flag = 211;     % 两行一列排列子图
        axes1 = subplot(2,1,1);
    end
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
    if flag==121
        axes2 = subplot(1,2,2);
    else
        axes2 = subplot(2,1,2);  
    end
    
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

        if flag==121
            gap = min(img1(:))*ones(size(img1,1), 5);
            %将多个矩阵水平串联起来
            % img = cat(2,img1, gap, img2);            
            img = [img1, gap, img2];          
        else
            gap = min(img1(:))*ones(5, size(img1,2));
            %将多个矩阵垂直串联起来            
            img = [img1; gap; img2];
        end
        
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
        if flag==121
            img = [img1, gap, flip(img2,2)]; % 镜像轴为垂直方向
        else
            img = [img1; gap; flip(img2,1)]; % 镜像轴为水平方向    
        end
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