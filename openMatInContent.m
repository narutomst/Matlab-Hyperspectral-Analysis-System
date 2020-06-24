function [hbox, himage] = openMatInContent(hObject, handles)
 % hObject为listbox1   

        load(hObject.UserData.currentPath);
        S = whos('-file',hObject.UserData.currentPath);
		x = eval((S.name));

        n_dims = ndims(x);
        if (n_dims==3)&&(size(x,3)>1)&&(size(x,1)>1)&&(size(x,2)>1)
			%判定输入数据为*.mat
            %打开mat
%             hObject.UserData.matdata = x;
            handles.UserData.matdata = double(x);
			[hbox, himage] = openMat(double(x), handles);
            
            %设置标志值
            hmenu3_1 = findobj(handles,'Label','适应窗口');
            hmenu3_1.UserData.imgGT=0;

            %显示选中文件的地址
            text = findobj(handles,'Style','edit');
            text.String = handles.UserData.currentPath;            
% 		elseif (numel(size(x))==2)&&(size(x,1)>1)&&(size(x,2)>1) 
% 			%判定输入数据为groundtruth
%             cmap = [];
% 			openGT(hObject, eventdata, handles, x, cmap, matfilename)%打开*_gt.mat数据
        elseif (n_dims==2)&&(size(x,1)>1)&&(size(x,2)>1)
            hbox = findobj(handles,'Tag','hbox');
            %进一步区分是lbs2还是降维后的mat
            p = size(x,1)/size(x,2);
            if p>50 || p<0.02
                %判定输入为降维后的数据
                if p>50
                    mappedA = x;
                else
                    mappedA = x';
                end
                hmenu4_3 = findobj(handles,'Label','执行降维');
                if isfield(hmenu4_3.UserData, 'matData') && isempty(hmenu4_3.UserData.matData)
                    hmenu4_3.UserData.drData = mappedA; % hmenu4_3
                    hmenu4_3.UserData.matPath = hObject.UserData.currentPath;
                    hmenu4_3.UserData.matData = mappedA; % hmenu4_3
                end
                    str1 = {'所选择为降维后的二维mat数据，已经加载至hmenu4_3.UserData.drData';...
                    '若接下来想执行分类操作，请继续选择一个与该mat数据匹配的ground truth标签文件';...
                    '假定所选mat数据的主名称为[abc***.mat]，则标签文件的名称通常为[abc_gt.mat]'};
                    str2 = {'mat数据与gt数据已齐备，可以执行【分析】>>【执行分类】'};
                if ~isfield(hmenu4_3.UserData, 'gtData') || isempty(hmenu4_3.UserData.gtData)
                    msg = str1;
                else
                    msg = str2;
                    hmenu4_4 = findobj(handles,'Label','执行分类');
                    hmenu4_4.Enable = 'on';
                    hmenu4_5 = findobj(handles,'Label','重新选择算法');
                    hmenu4_5.Enable = 'on';
                    hmenu4_6 = findobj(handles,'Label','配置算法');
                    hmenu4_6.Enable = 'on';
                end
                msgbox(msg);
%                 hmenu4_3.UserData.drAlgorithm = 'none'; % hmenu4                
            else
                %判定输入数据为*_gt.mat
                %打开mat
%                 cmap = [];
%                 hObject.UserData.cmap = cmap;
%                 hObject.UserData.gtdata=x;
                handles.UserData.gtdata = double(x);
                
                [hbox, himage] = newPlotGT(double(x), handles);
                
                text = findobj(handles,'Style','edit');
                text.String = handles.UserData.currentPath; 
            end
        elseif n_dims == 1 %判定是否为一维的标签数据lbs
            a = unique(x);      %找出x中的唯一值，并且按照升序排列
            b = a(2:end)-a(1:end-1);
            if (a(1)==0 || a(1)==1) && unique(b)==1
                %第一个元素为0或者1
                %相邻元素的差值为1
                str = {'所选择为一维ground truth标签数据，已经加载至hmenu4_3.UserData.lbs';...
                    '若接下来想执行分类操作，请继续选择一个与该标签数据匹配的mat数据文件';...
                    '假定所选gt数据的主名称为[*_gt.mat]，则备选文件的名称通常为*.mat'};
                msgbox(str);
            end

        else
			%错误提示：输入数据格式错误
			msg = 'Input data format is wrong!';
			errordlg(msg);
			return
        end        
end
   
