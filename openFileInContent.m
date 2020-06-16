function openFileInContent(hObject,handles)
if isfile(hObject.UserData.currentPath)
    fPath = hObject.UserData.currentPath; %绝对路径，
    [filepath,name,ext] = fileparts(fPath);

    hbox = findobj(handles,'Tag','hbox');
    axes1 = findobj(hbox,'Type','axes');
    
%     if ~isempty(findobj(hbox,'Tag','imscrollpanel'))
%         delete(findobj(hbox,'Tag','imscrollpanel'));
%         axes1 = axes('Parent',hbox,'Tag','axes1');
%     elseif ~isempty(findobj(hbox,'Type','axes'))
%         axes1 = findobj(hbox,'Type','axes');
%     else
%         axes1 = axes('Parent',hbox,'Tag','axes1');
%     end
    
    
    if strcmp(ext,'.bmp') || strcmp(ext,'.png') || ...
            strcmp(ext,'.jpg') || strcmp(ext,'.gif')
        disp(['打开*',ext]);
        himage = imshow(fPath,'Parent',axes1); 
%         hscrollpanel = imscrollpanel(hbox, himage); 

    elseif strcmp(ext,'.mat')
        disp(['打开*',ext]);
        %在左侧目录栏双击打开

            [hbox,himage] = openMatInContent(hObject, handles);
       
    elseif strcmp(ext,'.fig')
        disp('打开*.fig????');
        %不确定该*.fig文件到底是哪种！那就两种类型的打开方式都试一下。
        try    
%             disp('执行第一路');  %打开*.fig图像
            himage = openfig(fPath, 'reuse');
        catch
            himage = guide(fPath);           %打开GUIDE创建的*.fig文件
            disp('执行第二路');
        end    
    elseif strcmp(ext,'.img') %
        [boston,R] = geotiffread(fPath);
        % D:\Program Files\Polyspace\R2019b\toolbox\map\mapdata\boston.tif
        figure
        himage = mapshow(boston,R);
        axis image off
    elseif strcmp(ext,'.tif')
        [X1,map1]=imread(fPath);
        
%         X1 = double(X1);
%         map1 = double(map1);
        try
            himage = imshow(fPath,'Parent',axes1);
        catch
            n_dims = ndims(X1);
            size_3 = size(X1,3);
            if n_dims==3 && size_3>3
                ind = [size_3,round((1+size_3)/2),1];
                img = synthesize_image(X1,ind);
                himage = imshow(img,'Parent',axes1);
%                 hscrollpanel = imscrollpanel(hbox, himage);
                handles.UserData.matdata = X1;
                handles.UserData.ind = ind;
            end
        end
    else
        disp('文件格式不支持！');
        return
    end
%     hscrollpanel = imscrollpanel(hbox, h1);
    pwidthmax = -1.5;
    set( hbox, 'Widths', [pwidthmax,-5] );
    hObject.UserData.himage = himage;
end    
end