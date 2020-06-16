function [hbox, himage] = openMat(x3,handles)
%打开*.mat数据

% 	x3 = hObject.UserData.matdata; %将数据集内的变量名统一为x2; %错误：引用了不存在的字段mat
		%% 绘制彩色图
	% 得到3个通道编号
    ind = handles.UserData.ind;    %错误：引用了不存在的字段ind
	% 合成增强图像 
	img = synthesize_image(x3, ind);   
    handles.UserData.imgMat = img;

    [hbox, himage] = newPlot(img, handles);

end