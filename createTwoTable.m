% ������ά��mat���ݺ�һά��gt���ݣ��ú����Զ���������table
% �ֱ�������Classification App����ѵ����������ʹ��ѵ���õķ�����ģ��Ԥ����

function [table1,table2,ind1,ind2] = createTwoTable(x2,lbs,rate) 
% �������ݣ�x, 2ά����ÿһ��Ϊһ��������ÿһ��Ϊһ������
%                 y,��������Ϊxÿ���������������ֵ
%                 rate��������0��1����ָ��ѵ������ռ�İٷֱ�
dbstop if error
C = numel(unique(lbs(:))); %�ܵ������
Cnum = zeros(C, 1);
Cind = cell(1, C);
for i = 1:C
    Cnum(i) = sum(lbs==i);%ͳ��ÿһ���������
    Cind{i} = find(lbs==i); %ͳ��ÿһ���������
end
% ����ÿһ��Ҫ��ȡ��������
Cnum1 = round(Cnum*rate);
% ��ÿһ�������г�����ɸ�����
r = arrayfun(@(n, k) randperm(n, k), Cnum, Cnum1, 'UniformOutput', false);
%rΪC��1 cell��ÿ��cell�б������ÿһ���б���ȡ��������������(��������ʽ)
%��r�����Ϊһ������
ind1 = [];
for i = 1:C
    a = Cind{i};
   ind1 = [ind1; a(r{i})];
end
table1 = createTable(x2(ind1, :), lbs(ind1));%ѵ����
 ind2 = [1: size(x2, 1)]';
 ind2(ind1) = [];

table2 = createTable(x2(ind2, :), lbs(ind2));%���Լ�

% ����t1��t2��������Classification App����ѵ����������Ԥ����