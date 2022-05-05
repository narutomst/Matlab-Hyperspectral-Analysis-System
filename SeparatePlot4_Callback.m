function SeparatePlot4_Callback(img1, img2, cmap, M)
%��3�ַ�ʽ��ʵ�ֻ�����ʵ��ǩͼ��Ԥ���ǩͼ
Location = 'eastoutside';
if 1
%% subplot()��ʽ���Ʋ��ŵ�˫��ͼ��һ�����л�������һ��
    p = figure();  % fig�ı���ɫΪColor: [0.9400 0.9400 0.9400]
    if size(img1,1) > size(img1,2)*0.8
        flag = 121;     % һ������������ͼ������4����ʾ��ʽ��
        %1. ������������ʾ��ÿ����ͼ��һ��colorbar��2. ������������ʾ�������ͼ����һ��colorbar��
        %3. ����������ʾ��ÿ����ͼ��һ��colorbar��   4. ����������ʾ�������ͼ����һ��colorbar��
        %��ʾЧ��1
        num = 2;
        for i =1:num
            axes_1 = subplot(num,1,i);
            if ndims(img1) == 3
                himage_1 = imshow(img1,'Parent',axes_1);
            elseif ndims(img1) == 2
                himage_1 = imshow(img1+1,cmap,'Parent',axes_1);

                c = colorbar(Location);
                c.Label.String = '��������Ӧ��ɫ';
                c.Label.FontWeight = 'bold'; 
                c.Ticks = 0.5:1:M+0.5;       %�̶���λ��
                c.TicksMode = 'Manual';
                c.TickLabels = num2str([-1:M-1]'); %�̶���ֵ
                c.Limits = [1,M+1];
            end 
        end
% c = colorbar;
% colorbar��Position����
% �Զ���λ�úʹ�С��ָ��Ϊ [left, bottom, width, height] ��ʽ����Ԫ��������
% left �� bottom Ԫ��ָ��ͼ�����½ǵ���ɫ�����½ǵľ��롣
% width �� height Ԫ��ָ����ɫ����ά�ȡ�Units ����ȷ��λ�õ�λ��
% 
% ���ָ�� Position ���ԣ��� MATLAB �� Location ���Ը���Ϊ 'manual'��
% �� Location ����Ϊ 'manual' ʱ���������������������С����Ӧ��ɫ����
% cPosition = c.Position;
% colorbar off
% axes('position', [cPosition(1), cPosition(2), cPosition(3), cPosition(4)*2.18]);
% axis off;

        % ��ͼ1������һ�ݣ�����ͼ1��colorbar�رգ�������ͼ����һ��colorbar
        p_1 = figure();
        str = ['copyobj(['];
        for i = 1:numel(p.Children)
            str = [str, 'p.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
        end
        str = [str, '], p_1)'];
        eval(str);                                                  % h = copyobj(cobj,[newParent1,newParent2])
        obj = findobj(p_1, 'Type', 'colorBar');        % clb = findobj(handles,'Type','colorBar');
        obj(1).Visible='off';
        % ��ʾЧ��3
        p_2 = figure();
        str = ['copyobj(['];
        for i = 1:numel(p.Children)
            str = [str, 'p.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
        end
        str = [str, '], p_2)'];
        eval(str);
        himage = findobj(p_2, 'Type', 'image');
        hscrollpanel = imscrollpanel(p_2, himage);   
        % ��ʾЧ��4
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
        flag = 211;     % ����һ��������ͼ������4����ʾ��ʽ��
        %1. ������������ʾ��ÿ����ͼ��һ��colorbar��
        %2. ������������ʾ�������ͼ����һ��colorbar��Location = 'southoutside'��
        %3. ����������ʾ��ÿ����ͼ��һ��colorbar��Location = 'eastoutside'��   
        %4. ����������ʾ�������ͼ����һ��colorbar��Location = 'southoutside'��
        % ����������Axes�����Ի᷵������himage����������������ִ�н��ᱨ��
        %himage = findobj(p_2, 'Type', 'image');
        %hscrollpanel = imscrollpanel(p_2, himage); 
        % ����ʾЧ��3��4�ǲ����ܵ�
        
        %��ʾЧ��1
        num = 2;
        for i =1:num
            axes_1 = subplot(num,1,i);
            if ndims(img1) == 3
                himage_1 = imshow(img1,'Parent',axes_1);
            elseif ndims(img1) == 2
                himage_1 = imshow(img1+1,cmap,'Parent',axes_1);

                c = colorbar(Location);
                c.Label.String = '��������Ӧ��ɫ';
                c.Label.FontWeight = 'bold'; 
                c.Ticks = 0.5:1:M+0.5;       %�̶���λ��
                c.TicksMode = 'Manual';
                c.TickLabels = num2str([-1:M-1]'); %�̶���ֵ
                c.Limits = [1,M+1];
            end 
        end

        % ��ʾЧ��2
        % ������ʾЧ��2��figure����
        % ��������ͼ��colorbar Location����Ϊ'southoutside'
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

        % ��ʾЧ��3��
        % ������ʾЧ��2��figure����
        % �ٽ���ͼ��colorbar�رգ�ֻ�������һ����ͼ��colorbar
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
  %% �ϳ�˫ͼ1��img1��img2�Ⱥϳ�һ��ͼ��Ȼ������ʾ����
if 1  
    p1 = figure();
    if ndims(img1) == 2 && ndims(img2) == 2

        if flag==121
            gap = min(img1(:))*ones(size(img1,1), 5);
            %���������ˮƽ��������        
            img = [img1, gap, img2];
        else
            gap = min(img1(:))*ones(5, size(img1,2));
            %���������ֱ��������  ����4����ʾ��ʽ��
        %1. ������������ʾ��Location = 'eastoutside'��2. ������������ʾ��Location = 'southoutside';
        %3. ����������ʾ��Location = 'eastoutside'��   4. ����������ʾ��Location = 'southoutside';          
            img = [img1; gap; img2];
        end
        % ��ʾЧ��1
        himage3 = imshow(img+1,cmap); 
        c = colorbar(Location);
        c.Label.String = '��������Ӧ��ɫ';
        c.Label.FontWeight = 'bold'; 
        
        c.Ticks = 0.5:1:M+0.5;       %�̶���λ��
        c.TicksMode = 'Manual';
        c.TickLabels = num2str([-1:M-1]'); %�̶���ֵ
        c.Limits = [1,M+1];
        
        % ��ʾЧ��2
        % ������ʾЧ��1��figure����p1
        % ��colorbar��ʾ�� 'southoutside'
        p1_1 = figure();
        str = ['copyobj(['];
        for i = 1:numel(p1.Children)
            str = [str, 'p1.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
        end
        str = [str, '], p1_1)'];
        eval(str);                                                  % h = copyobj(cobj,[newParent1,newParent2])
        obj = findobj(p1_1, 'Type', 'colorBar');        % clb = findobj(handles,'Type','colorBar');
        obj.Location='southoutside';
        % ��ʾЧ��3
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
        % ��ʾЧ��4
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
%% �ϳ�˫ͼ2�������Ժϳɾ���˫ͼ flip(A,2)��������A��ÿһ�з�ת
if 1
    p2 = figure();
    if flag==121
        img = [img1, gap, flip(img2,2)]; % ������Ϊ��ֱ����
    else
        img = [img1; gap; flip(img2,1)]; % ������Ϊˮƽ����    
    end
    % ��ʾЧ��1
    himage4 = imshow(img+1,cmap); 
    c = colorbar(Location);
    c.Label.String = '��������Ӧ��ɫ';
    c.Label.FontWeight = 'bold'; 

    c.Ticks = 0.5:1:M+0.5;       %�̶���λ��
    c.TicksMode = 'Manual';
    c.TickLabels = num2str([-1:M-1]'); %�̶���ֵ
    c.Limits = [1,M+1];

    % ��ʾЧ��2����colorbar��ʾ�� 'southoutside'
    p2_1 = figure();
    str = ['copyobj(['];
    for i = 1:numel(p2.Children)
        str = [str, 'p2.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
    end
    str = [str, '], p2_1)'];
    eval(str);                                                  % h = copyobj(cobj,[newParent1,newParent2])
    obj = findobj(p2_1, 'Type', 'colorBar');        % clb = findobj(handles,'Type','colorBar');
    obj.Location='southoutside'; 
    % ��ʾЧ��3   
    p2_2 = figure();
    str = ['copyobj(['];
    for i = 1:numel(p2.Children)
        str = [str, 'p2.Children(', num2str(i), '), ']; % copyobj(p.Children(i), p_1);
    end
    str = [str, '], p2_2)'];
    eval(str);
    himage = findobj(p2_2, 'Type', 'image');
    hscrollpanel = imscrollpanel(p2_2, himage);   
    % ��ʾЧ��4
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