function Open1_Callback(hObject, eventdata, handles)
% % 需要初始化hObject
% l = findobj(handles,'Style', 'listbox');
% 
% hObject.UserData.customPath = l.UserData.customPath;
% hObject.UserData.ind = l.UserData.ind;
% hObject.UserData.matdata = [];
% hObject.UserData.gtdata = [];
% hObject.UserData.cmap = [];
% 
% handles.UserData.customPath = l.UserData.customPath;%handle中用来存储最新的信息，listbox1,
% handles.UserData.ind = l.UserData.ind;
% %默认打开地址：本MVC_test.m所在文件夹
% %自定义打开地址：uigetfile第一个参数设置为：{'D:\MA毕业论文\ATrain_Record\20190909\*.mat'}
% %     customPath = {'D:\MA毕业论文\ATrain_Record\20190909\*.mat'};
    customPath = handles.UserData.customPath;
    [matfilename, matpathname, FilterIndex] = uigetfile(customPath, 'Select a mat file');
    if (~isempty(matfilename) && (FilterIndex==1))
        %选择了文件，并且点击了确定，我们才会做处理，否则什么也不做。
        %如果是首次单击【文件】>>【打开】，则不用删除前一幅图像，因为不存在；
        %如果是首次之后单击【文件】>>【打开】，则先删除前一幅图像，避免重叠；

        load([matpathname,matfilename]);
        S = whos('-file',[matpathname,matfilename]);
		x = eval((S.name));
        
        
		if (numel(size(x))==3)&&(size(x,3)>1)&&(size(x,1)>1)&&(size(x,2)>1)
            %判定输入数据为*.mat
            hObject.UserData.currentPath = [matpathname,matfilename];
            handles.UserData.matdata = double(x); % handles中保存最新的选定内容
            handles.UserData.currentPath = hObject.UserData.currentPath; % handles中保存最新的选定内容
            %打开mat
			[hbox,himage] = openMat(double(x), handles);
            %显示选中文件的地址
            text = findobj(handles,'Style','edit');
            text.String = handles.UserData.currentPath;            
% 		elseif (numel(size(x))==2)&&(size(x,1)>1)&&(size(x,2)>1) 
% 			%判定输入数据为groundtruth
%             cmap = [];
% 			openGT(hObject, eventdata, handles, x, cmap, matfilename)%打开*_gt.mat数据
		else
			%错误提示：输入数据格式错误
			msg = 'Input data format is wrong!';
			errordlg(msg);
			return
		end
    end
end