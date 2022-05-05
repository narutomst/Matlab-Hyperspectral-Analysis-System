function SeparatePlot4_Callback(img1, img2, cmap, M)
%用3种方式来实现绘制真实标签图和预测标签图
Location = 'eastoutside';
if 1
%% subplot()方式绘制并排的双子图，一行两列或者两行一列
    p = figure();  % fig的背景色为Color: [0.9400 0.9400 0.9400]
    if size(img1,1) > size(img1,2)*0.8
        flag = 121;     % 一行两列排列子图，共有4种显示方式：
        %1. 不带滚动条显示，每个子图带一个colorbar；2. 不带滚动条显示，多个子图共用一个colorbar；
        %3. 带滚动条显示，每个子图带一个colorbar；   4. 带滚动条显示，多个子图共用一个colorbar；
        %显示效果1
        num = 2;
        for i =1:num
            axes_1 = subplot(num,1,i);
            if ndims(img1) == 3
                himage_1 = imshow(img1,'Parent',axes_1);
            elseif ndims(img1) == 2
                himage_1 = imshow(img1+1,cmap,'Parent',axes_1);

                c = colorbar(Location);
                c.Label.String = '地物类别对应颜色';
                c.Label.FontWeight = 'bold'; 
                c.Ticks = 0.5:1:M+0.5;       %刻度线位置
                c.TicksMode = 'Manual';
                c.TickLabels = num2str([-1:M-1]'); %刻度线值
                c.Limits = [1,M+1];
            end 
        end
% c = colorbar;
% colorbar的Position属性
% 自定义位置和大小，指定为 [left, bottom, width, height] 形式的四元素向量。
% left 和 bottom 元素指定图窗左下角到颜色栏左下角的距离。
% width 和 height 元素指定颜色栏的维度。Units 属性确定位置单位。
% 
% 如果指定 Position 属性，则 MATLAB 将 Location 属性更改为 'manual'。
% 当 Location 属性为 'manual' 时，关联坐标区不会调整大小以适应颜色栏。
% cPosition = c.Position;
% colorbar off
% axes('position', [cPosition(1), cPosition(2), cPosition(3), cPosition(4)*2.18]);
% axis off;

        % 将图1对象复制一份，将子图1的colorbar关闭，两个子图公用一个colorbar
        p_1 = figure();
        str = ['copyobj(['];
        for i = 1:numel(p.Children)
            str = [str, 'p.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
        end
        str = [str, '], p_1)'];
        eval(str);                                                  % h = copyobj(cobj,[newParent1,newParent2])
        obj = findobj(p_1, 'Type', 'colorBar');        % clb = findobj(handles,'Type','colorBar');
        obj(1).Visible='off';
        % 显示效果3
        p_2 = figure();
        str = ['copyobj(['];
        for i = 1:numel(p.Children)
            str = [str, 'p.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
        end
        str = [str, '], p_2)'];
        eval(str);
        himage = findobj(p_2, 'Type', 'image');
        hscrollpanel = imscrollpanel(p_2, himage);   
        % 显示效果4
        p_3 = figure();
        str = ['copyobj(['];
        for i = 1:numel(p.Children)
            str = [str, 'p_1.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
        end
        str = [str, '], p_3)'];
        eval(str);
        himage = findobj(p_3, 'Type', 'image');
        hscrollpanel = imscrollpanel(p_3, himage);               
    else
        flag = 211;     % 两行一列排列子图，共有4种显示方式：
        %1. 不带滚动条显示，每个子图带一个colorbar；
        %2. 不带滚动条显示，多个子图共用一个colorbar，Location = 'southoutside'；
        %3. 带滚动条显示，每个子图带一个colorbar，Location = 'eastoutside'；   
        %4. 带滚动条显示，多个子图共用一个colorbar，Location = 'southoutside'；
        % 由于有两个Axes，所以会返回两个himage对象，所以下面的语句执行将会报错
        %himage = findobj(p_2, 'Type', 'image');
        %hscrollpanel = imscrollpanel(p_2, himage); 
        % 即显示效果3和4是不可能的
        
        %显示效果1
        num = 2;
        for i =1:num
            axes_1 = subplot(num,1,i);
            if ndims(img1) == 3
                himage_1 = imshow(img1,'Parent',axes_1);
            elseif ndims(img1) == 2
                himage_1 = imshow(img1+1,cmap,'Parent',axes_1);

                c = colorbar(Location);
                c.Label.String = '地物类别对应颜色';
                c.Label.FontWeight = 'bold'; 
                c.Ticks = 0.5:1:M+0.5;       %刻度线位置
                c.TicksMode = 'Manual';
                c.TickLabels = num2str([-1:M-1]'); %刻度线值
                c.Limits = [1,M+1];
            end 
        end

        % 显示效果2
        % 复制显示效果2的figure对象，
        % 将所有子图的colorbar Location设置为'southoutside'
        p_1 = figure();
        str = ['copyobj(['];
        for i = 1:numel(p.Children)
            str = [str, 'p.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
        end
        str = [str, '], p_1)'];
        eval(str);                                                  % h = copyobj(cobj,[newParent1,newParent2])
        obj = findobj(p_1, 'Type', 'colorBar');        % clb = findobj(handles,'Type','colorBar');
        for i = 1:numel(obj)
            obj(i).Location = 'southoutside';
        end

        % 显示效果3，
        % 复制显示效果2的figure对象，
        % 再将子图的colorbar关闭，只保留最后一个子图的colorbar
        p_2 = figure();
        str = ['copyobj(['];
        for i = 1:numel(p.Children)
            str = [str, 'p_1.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
        end
        str = [str, '], p_2)'];
        eval(str);
        obj = findobj(p_2, 'Type', 'colorBar');          
        for i = 2:numel(obj)
            obj(i).Visible='off';  
        end
    end
end    
  %% 合成双图1：img1和img2先合成一张图，然后再显示出来
if 1  
    p1 = figure();
    if ndims(img1) == 2 && ndims(img2) == 2

        if flag==121
            gap = min(img1(:))*ones(size(img1,1), 5);
            %将多个矩阵水平串联起来        
            img = [img1, gap, img2];
        else
            gap = min(img1(:))*ones(5, size(img1,2));
            %将多个矩阵垂直串联起来  共有4种显示方式：
        %1. 不带滚动条显示，Location = 'eastoutside'；2. 不带滚动条显示，Location = 'southoutside';
        %3. 带滚动条显示，Location = 'eastoutside'；   4. 带滚动条显示，Location = 'southoutside';          
            img = [img1; gap; img2];
        end
        % 显示效果1
        himage3 = imshow(img+1,cmap); 
        c = colorbar(Location);
        c.Label.String = '地物类别对应颜色';
        c.Label.FontWeight = 'bold'; 
        
        c.Ticks = 0.5:1:M+0.5;       %刻度线位置
        c.TicksMode = 'Manual';
        c.TickLabels = num2str([-1:M-1]'); %刻度线值
        c.Limits = [1,M+1];
        
        % 显示效果2
        % 复制显示效果1的figure对象p1
        % 将colorbar显示到 'southoutside'
        p1_1 = figure();
        str = ['copyobj(['];
        for i = 1:numel(p1.Children)
            str = [str, 'p1.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
        end
        str = [str, '], p1_1)'];
        eval(str);                                                  % h = copyobj(cobj,[newParent1,newParent2])
        obj = findobj(p1_1, 'Type', 'colorBar');        % clb = findobj(handles,'Type','colorBar');
        obj.Location='southoutside';
        % 显示效果3
        % 
        p1_2 = figure();
        str = ['copyobj(['];
        for i = 1:numel(p1.Children)
            str = [str, 'p1.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
        end
        str = [str, '], p1_2)'];
        eval(str);
        himage = findobj(p1_2, 'Type', 'image');
        hscrollpanel = imscrollpanel(p1_2, himage);   
        % 显示效果4
        p1_3 = figure();
        str = ['copyobj(['];
        for i = 1:numel(p1.Children)
            str = [str, 'p1_1.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
        end
        str = [str, '], p1_3)'];
        eval(str);
        himage = findobj(p1_3, 'Type', 'image');
        hscrollpanel = imscrollpanel(p1_3, himage);        
    end
end    
%% 合成双图2：还可以合成镜像双图 flip(A,2)，将矩阵A的每一行翻转
if 1
    p2 = figure();
    if flag==121
        img = [img1, gap, flip(img2,2)]; % 镜像轴为垂直方向
    else
        img = [img1; gap; flip(img2,1)]; % 镜像轴为水平方向    
    end
    % 显示效果1
    himage4 = imshow(img+1,cmap); 
    c = colorbar(Location);
    c.Label.String = '地物类别对应颜色';
    c.Label.FontWeight = 'bold'; 

    c.Ticks = 0.5:1:M+0.5;       %刻度线位置
    c.TicksMode = 'Manual';
    c.TickLabels = num2str([-1:M-1]'); %刻度线值
    c.Limits = [1,M+1];

    % 显示效果2，将colorbar显示到 'southoutside'
    p2_1 = figure();
    str = ['copyobj(['];
    for i = 1:numel(p2.Children)
        str = [str, 'p2.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
    end
    str = [str, '], p2_1)'];
    eval(str);                                                  % h = copyobj(cobj,[newParent1,newParent2])
    obj = findobj(p2_1, 'Type', 'colorBar');        % clb = findobj(handles,'Type','colorBar');
    obj.Location='southoutside'; 
    % 显示效果3   
    p2_2 = figure();
    str = ['copyobj(['];
    for i = 1:numel(p2.Children)
        str = [str, 'p2.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
    end
    str = [str, '], p2_2)'];
    eval(str);
    himage = findobj(p2_2, 'Type', 'image');
    hscrollpanel = imscrollpanel(p2_2, himage);   
    % 显示效果4
    p2_3 = figure();
    str = ['copyobj(['];
    for i = 1:numel(p2.Children)
        str = [str, 'p2_1.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
    end
    str = [str, '], p2_3)'];
    eval(str);
    himage = findobj(p2_3, 'Type', 'image');
    hscrollpanel = imscrollpanel(p2_3, himage);        
end
end