% 输入handles，取得matPath和gtPath，载入数据后并转换到相应的维数。
%即三维mat转为二维(x3转为x2)，二维标签转换为一维向量(lbs2转为lbs)
function [x2,lbs,matInfo,gtInfo] = dataProcess1(handles)
    matPath = handles.UserData.matPath;
    gtPath = handles.UserData.gtPath;
    % 获取x3，3维形式的高光谱数据
    load(matPath);
    S = whos('-file',matPath);
    matInfo = S;
    x3 = eval((S.name));
    if ndims(x3) == 3
        % 三维数据转换为二维数据
        m = size(x3,1)*size(x3,2);%21025
        n = size(x3,3);
        x2 = reshape(x3,m,n); %将原图的像素值按列取出来拼接成一个列向量，
                                           %x2标识2维矩阵
    else
        x2 = x3;
    end
                                       
    % 获取lbs2，2维的标签数据
    load(gtPath);
    S = whos('-file',gtPath);
    gtInfo = S;
    n_dims = ndims(lbs2);
    if n_dims == 1
        lbs = lbs2;
    elseif n_dims == 2
        lbs2 = eval((S.name));
        % 二维标签转换为一维标签
        lbs = reshape(lbs2,m,1);%将标签按列取出来拼接成一个列向量
                                            %lbs表示一维标签
    elseif n_dims == 3
        lbs = [];
    end
end