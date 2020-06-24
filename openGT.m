function [hbox, himage] = openGT(x, handles)%打开*_gt.mat数据

	[hbox, himage] = newPlotGT(x,handles);
    %设置标志值
    hmenu3_1 = findobj(handles,'Label','适应窗口');
    hmenu3_1.UserData.imgGT=1;
			
end
