%本函数实现在伪彩色图上显示标记区域，即将Mat图和GT图重叠在一起
function img = stack_image(imgMat, imgGT, cmap, M)
% id1 = imgGT~=0;    %512×614 logical
% id2 = imgGT~=[0,0,0];  %会报错！矩阵维度必须一致。
% id3 = imgGT(:)~=0; %314368×1 logical
% id4 = imgGT(:)~=[0,0,0]; %314368×3 logical
% a = [min(imgMat(:)),max(imgMat(:)),min(imgGT(:)),max(imgGT(:))]
% imgMat(id1)=imgGT(id1);   %395 587
%这个赋值语句只是相当于改变了imgMat的第一页，而imgMat(:,:,2)和imgMat(:,:,3)未改变

for i = 2:M
    id1 = (imgGT==i-1);  
%     [row,col]=find(imgGT==(i-1));
%     imgMat(row,col,:)=cmap(i,:);   %无法执行赋值，因为左侧的大小为 761×761×3，右侧的大小为 1×3。
%     imgMat(row,col,:) = reshape(cmap(i,:),1,1,[]);
%     imgMat((imgGT==i-1))= reshape(cmap(i,:),1,1,[]);
%     c = reshape(cmap(i,:),1,1,[]);
%     d = repmat(c,numel(row),numel(col),1);

%先拆解，再重组。首先将3维图片拆解为3张2维图片。每张2维图片上使用逻辑索引赋值。
    imgMat1 = imgMat(:,:,1);
    imgMat1(id1) = cmap(i,1);             %imgGT==1的点总共有761个
    imgMat2 = imgMat(:,:,2);
    imgMat2(id1) = cmap(i,2);             %imgGT==1的点总共有761个
    imgMat3 = imgMat(:,:,3);
    imgMat3(id1) = cmap(i,3);             %imgGT==1的点总共有761个
% 3张2维图片赋值完毕后，再将3张2维图片重组为一张3维图片。
    imgMat(:,:,1) = imgMat1;
    imgMat(:,:,2) = imgMat2;
    imgMat(:,:,3) = imgMat3;
end

p = figure();
% axes1 = axes('Parent',p,'Tag','axes1');
himage = imshow(imgMat);%,'Parent',axes1);
hscrollpanel = imscrollpanel(p, himage); 
end