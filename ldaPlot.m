function ldaPlot(x2,lbs,handles)
% x2,lbs��ȥ���������ص������
% ������ɢ��ͼ����һ�ֿ��ӻ���ʽ��tSNE
hmenu4_1 = findobj(handles,'Label','��������');
drName = hmenu4_1.UserData.drAlgorithm;

if min(lbs)<=0  %������ݺ��б������أ�������ȥ����������
    b = find(lbs);
    x2 = x2(b, :);
    lbs = lbs(b, :);
end

cmap = handles.UserData.cmap;
x = x2(:,1);
y = x2(:,2);
sz = 5; %ɢ��ͼ��Ҫ���Ƶĵ�Ĵ�С


min_c = min(lbs);
max_c = max(lbs);
c = zeros(size(lbs,1), 3); %׼����ɫ��
for j = min_c : max_c
    ind = find(lbs==j);
    l_ind = length(ind);
    c(ind, :) = repmat(cmap(j+1,:),l_ind,1);
end
[filepath,name,ext] = fileparts(hmenu4_1.UserData.matPath);

figure
scatter(x,y,sz,c,'filled'); %�������е�
% % Ӣ�ı�ע
% xlabel('Feature 1');
% ylabel('Feature 2');
% title([name, ' dataset, ', drName, ' Dimensionality Reduction'],'Interpreter','none');
% ���ı�ע
xlabel('���� 1');
ylabel('���� 2');
title([name, '���ݼ���', drName, '��ά'],'Interpreter','none');
% saveas(gcf,[str{i},'_LDAdimRed_allPoints_color','.bmp']);
% close figure(1)
end