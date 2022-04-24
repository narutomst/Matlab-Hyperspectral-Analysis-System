function ldaPlot(x2,lbs,handles)
% x2,lbs是去除背景像素点的数据
% 绘制其散点图，另一种可视化方式是tSNE
hmenu4_1 = findobj(handles,'Label','加载数据');
drName = hmenu4_1.UserData.drAlgorithm;

if min(lbs)<=0  %如果数据含有背景像素，则首先去除背景像素
    b = find(lbs);
    x2 = x2(b, :);
    lbs = lbs(b, :);
end

cmap = handles.UserData.cmap;
x = x2(:,1);
y = x2(:,2);
sz = 5; %散点图上要绘制的点的大小


min_c = min(lbs);
max_c = max(lbs);
c = zeros(size(lbs,1), 3); %准备颜色表
for j = min_c : max_c
    ind = find(lbs==j);
    l_ind = length(ind);
    c(ind, :) = repmat(cmap(j+1,:),l_ind,1);
end
[filepath,name,ext] = fileparts(hmenu4_1.UserData.matPath);

figure
scatter(x,y,sz,c,'filled'); %画出所有点
% % 英文标注
% xlabel('Feature 1');
% ylabel('Feature 2');
% title([name, ' dataset, ', drName, ' Dimensionality Reduction'],'Interpreter','none');
% 中文标注
xlabel('特征 1');
ylabel('特征 2');
title([name, '数据集，', drName, '降维'],'Interpreter','none');
% saveas(gcf,[str{i},'_LDAdimRed_allPoints_color','.bmp']);
% close figure(1)
end