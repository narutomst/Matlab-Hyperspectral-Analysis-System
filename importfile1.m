function paraTable_dr = importfile1(workbookFile, sheetName, dataLines)
%IMPORTFILE1 ������ӱ���е�����
%  UNTITLED = IMPORTFILE1(FILE) ��ȡ��Ϊ FILE �� Microsoft Excel
%  ���ӱ���ļ��ĵ�һ�Ź������е����ݡ�  �Ա���ʽ�������ݡ�
%
%  UNTITLED = IMPORTFILE1(FILE, SHEET) ��ָ���Ĺ������ж�ȡ��
%
%  UNTITLED = IMPORTFILE1(FILE, SHEET,DATALINES)��ָ�����м����ȡָ���������е����ݡ�
%  ���ڲ��������м�����뽫 DATALINES ָ��Ϊ������������ N��2�������������顣
%  
%
%  ʾ��:
%  Untitled = importfile1("D:\MA��ҵ����\ATrain_Record\20191002\��ά����ͳ��.xlsx", "Sheet1", [2, 35]);
%
%  ������� READTABLE��
%
% �� MATLAB �� 2019-10-17 03:36:47 �Զ�����

%% ���봦��

% ���δָ���������򽫶�ȡ��һ�Ź�����
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% ���δָ���е������յ㣬��ᶨ��Ĭ��ֵ��
if nargin <= 2
    dataLines = [2, 35];
end

%% ���õ���ѡ���������
opts = spreadsheetImportOptions("NumVariables", 14);

% ָ��������ͷ�Χ
opts.Sheet = sheetName;
%opts.RowNamesRange = "A" + dataLines(1, 1) + ":A" + dataLines(1, 2);
opts.RowNamesRange = "A" + dataLines(1, 1);
opts.DataRange = "B" + dataLines(1, 1) + ":O" + dataLines(1, 2);


% ָ�������ƺ�����
opts.VariableNames = ["no_dims", "no_analyzers", "max_iterations", "k",         "sigma",   "finetune",  "t",          "kernel", "perplexity", "initial_dims", "type",  "lambda",  "percentage", "eig_impl"];
opts.VariableTypes =   ["double",   "double",          "double",            "double", "double", "logical",     "double", "string", "double",     "double",       "string", "double",  "double",        "string"];

% ָ���ļ�������
opts.ImportErrorRule = 'omitvar';
opts.MissingRule = 'omitvar';

% ָ����������
% opts = setvaropts(opts, ["VarName1", "finetune", "kernel", "type"], "WhitespaceRule", "preserve");
% opts = setvaropts(opts, ["VarName1", "eig_impl", "finetune", "kernel", "type"], "EmptyFieldRule", "auto");
% opts = setvaropts(opts, ["no_dims", "max_iterations", "sigma", "k", "t", "perplexity", "initial_dims", "lambda", "no_analyzers", "percentage"], "TreatAsMissing", '');

% ��������

paraTable_dr = readtable(workbookFile, opts, 'ReadRowNames',true, "UseExcel", false);

% for idx = 2:size(dataLines, 1)
%     opts.DataRange = "B" + dataLines(idx, 1) + ":O" + dataLines(idx, 2);
%     tb = readtable(workbookFile, opts, "UseExcel", false);
%     paraTable_dr = [paraTable_dr; tb]; %#ok<AGROW>
% end

end