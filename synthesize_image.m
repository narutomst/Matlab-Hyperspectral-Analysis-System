function img = synthesize_image(x3,ind)
%1. 通道按照红绿蓝排序赋值给img
    ind = sort(ind, 'descend'); 
    img = double(x3(:,:,ind));
%2. 对取出的3个通道做局部归一化
    xmin = min(img(:));
    xmax = max(img(:));
    % y = (ymax-ymin)*(x-xmin)/(xmax-xmin) + ymin;
    img = (1-0)*(img-xmin)/(xmax-xmin)+0; %局部归一化
%3. 对3个分量分别做直方图均衡化处理，因为histeq主要是对强度图像做处理
    img(:,:,1) = histeq(img(:,:,1));
    img(:,:,2) = histeq(img(:,:,2));
    img(:,:,3) = histeq(img(:,:,3)); 
end
