% ldaPlot1()的作用是将背景类的点去掉，因为背景类的点把其他类别的点给盖住了
% 所以可是话效果看起来不太好 
function ldaPlot1(x2,lbs,handles)
cmap = handles.UserData.cmap;
sz = 5;
% c = linspace(1,10,length(x));
% c = repmat([0,0,0],length(x),1);% ones(length(x),1);
% 使lbs中的最小值降为零
while(min(lbs))
    lbs = lbs - 1;
end
% 选择要显示的点
x = x2(lbs>0,1);
y = x2(lbs>0,2);
lbs = lbs(lbs>0);


min_c = min(lbs);
max_c = max(lbs);
c = zeros(size(lbs,1), 3);
for j = min_c : max_c
    ind = find(lbs==j);
    l_ind = length(ind);
    c(ind, :) = repmat(cmap(j+1,:),l_ind,1);
end

figure
scatter(x,y,sz,c,'filled'); %画出所有点
xlabel('Feature 1');
ylabel('Feature 2');
title(['Dimensionality Reduction Without Background'],'Interpreter','none');
% saveas(gcf,[str{i},'_LDAdimRed_allPoints_color','.bmp']);
% close figure(1)
end