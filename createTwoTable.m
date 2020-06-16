% 给定二维的mat数据和一维的gt数据，该函数自动生成两个table
% 分别用于在Classification App用于训练分类器和使用训练好的分类器模型预测结果

function [table1,table2,ind1,ind2] = createTwoTable(x2,lbs,rate) 
% 输入数据：x, 2维矩阵，每一行为一个样本，每一列为一个属性
%                 y,列向量，为x每个样本所属的类的值
%                 rate，标量（0～1），指定训练集所占的百分比

n = size(x2,1);        % 样本总数
m = randperm(n);  % 生成1～n的整数随机排序向量
k = round(rate*n);  % 获取训练集样本总数
table1 = createTable(x2(m(1:k),:), lbs(m(1:k)));%训练集
ind1 = m(1:k);
table2 = createTable(x2(m(k+1:end),:), lbs(m(k+1:end)));%测试集
ind2 = m(k+1:end);
% 数据t1和t2可以用于Classification App用于训练分类器和预测结果