function Open2_Callback(hObject, eventdata, handles)
% % 需要初始化hObject
%     l = findobj(handles,'Style', 'listbox');
%     handles.UserData.customPath = l.UserData.customPath;
%     hObject.UserData.customPath = l.UserData.customPath;
%     hObject.UserData.ind = l.UserData.ind;
%     hObject.UserData.matdata = [];
%     hObject.UserData.gtdata = [];
%     hObject.UserData.cmap = [];
% %默认打开地址：本MVC_test.m所在文件夹
% %自定义打开地址：uigetfile第一个参数设置为：{'D:\MA毕业论文\ATrain_Record\20190909\*.mat'}
% %     customPath = {'D:\MA毕业论文\ATrain_Record\20190909\*.mat'};
    customPath = handles.UserData.customPath;
    [matfilename, matpathname, FilterIndex] = uigetfile(customPath, 'Select a mat file');
    if (~isempty(matfilename) && (FilterIndex==1))
        %选择了文件，并且点击了确定，我们才会做处理，否则什么也不做。
        %如果是首次单击【文件】>>【打开】，则不用删除前一幅图像，因为不存在；
        %如果是首次之后单击【文件】>>【打开】，则先删除前一幅图像，避免重叠；

        load([matpathname, matfilename]);
        S = whos('-file',[matpathname, matfilename]);
		x = eval((S.name));
%         hObject.UserData.gtdata = x;
%         hObject.UserData.currentPath = [matpathname,matfilename];
%         cmap = [];
%         hObject.UserData.cmap = cmap;
		if (numel(size(x))==2)&&(size(x,1)>1)&&(size(x,2)>1) 
			%判定输入数据为groundtruth
            handles.UserData.currentPath = [matpathname,matfilename];
            handles.UserData.gtdata = double(x); % handles中保存最新的选定内容
			[hbox, himage] = newPlotGT(double(x), handles);%打开*_gt.mat数据
        
% 		elseif (numel(size(x))==3)&&(size(x,3)>1)&&(size(x,1)>1)&&(size(x,2)>1)
% 			%判定输入数据为*.mat
% 			openMat(hObject, eventdata, handles, x, matfilename);

		    %显示选中文件的地址
            text = findobj(handles,'Style','edit');
            text.String = handles.UserData.currentPath; 
        else
			%错误提示：输入数据格式错误
			msg = 'Input data format is wrong!';
			errordlg(msg);
			return
		end
    end
end