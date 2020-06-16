% 输入handles，取得matPath和gtPath，载入数据后并转换到相应的维数。
%即三维mat转为二维(x3转为x2)，二维标签转换为一维向量(lbs2转为lbs)
function [x3,x2,lbs2,lbs,matInfo,gtInfo] = dataProcess2(handles)
    matPath = handles.UserData.matPath;
    gtPath = handles.UserData.gtPath;
    % 获取x3，3维形式的高光谱数据
    load(matPath);
    S = whos('-file',matPath);
    matInfo = S;
    x3 = eval((S.name));
    n_dims = ndims(x3);
    % 三维数据转换为二维数据
    if  n_dims == 3
        m = size(x3,1)*size(x3,2);%21025
        n = size(x3,3);
        x2 = reshape(x3,m,n); %将原图的像素值按列取出来拼接成一个列向量，
                                           %x2标识2维矩阵
    elseif n_dims == 2
        x2 = x3;    %所选择mat数据为二维mat
        x3 = [];
    end
    
    % 获取lbs2，2维的标签数据
    load(gtPath);
    S = whos('-file',gtPath);
    gtInfo = S;
    lbs2 = eval((S.name));
    lbs2 = double(lbs2);
    % 二维标签转换为一维标签
    n_dims = ndims(lbs2);
    if n_dims == 1                %所选择标签数据为一维标签
        lbs = lbs2;
%         while (min(lbs(:))==0)  %使lbs最小值为1
%             lbs = lbs+1;
%         end
        lbs2 = [];
    elseif n_dims == 2
        lbs = reshape(lbs2,m,1);%将标签按列取出来拼接成一个列向量
                                            %lbs表示一维标签
%         while (min(lbs(:))==0)  %使lbs最小值为1
%             lbs = lbs+1;
%         end                                            
    elseif n_dims == 3
        lbs = [];
        str = {'所选择标签文件可能有问题，维度为3.';'可查看hmenu4_1.UserData.lbs2'};
        warndlg(str);
    end
end