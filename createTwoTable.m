% 给定二维的mat数据和一维的gt数据，该函数自动生成两个table
% 分别用于在Classification App用于训练分类器和使用训练好的分类器模型预测结果

function [table1,table2,ind1,ind2] = createTwoTable(x2,lbs,rate) 
% 输入数据：x, 2维矩阵，每一行为一个样本，每一列为一个属性
%                 y,列向量，为x每个样本所属的类的值
%                 rate，标量（0～1），指定训练集所占的百分比
dbstop if error
C = numel(unique(lbs(:))); %总的类别数
Cnum = zeros(C, 1);
Cind = cell(1, C);
for i = 1:C
    Cnum(i) = sum(lbs==i);%统计每一类的样本数
    Cind{i} = find(lbs==i); %统计每一类的行索引
end
% 估计每一类要抽取的样本数
Cnum1 = round(Cnum*rate);
% 从每一类索引中抽出若干个索引
r = arrayfun(@(n, k) randperm(n, k), Cnum, Cnum1, 'UniformOutput', false);
%r为C×1 cell，每个cell中保存的是每一类中被抽取的样本的行索引(行向量形式)
%将r整理成为一个向量
ind1 = [];
for i = 1:C
    a = Cind{i};
   ind1 = [ind1; a(r{i})];
end
table1 = createTable(x2(ind1, :), lbs(ind1));%训练集
 ind2 = [1: size(x2, 1)]';
 ind2(ind1) = [];

table2 = createTable(x2(ind2, :), lbs(ind2));%测试集

% 数据t1和t2可以用于Classification App用于训练分类器和预测结果