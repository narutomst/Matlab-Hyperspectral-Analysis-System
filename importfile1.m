function paraTable_dr = importfile1(workbookFile, sheetName, dataLines)
%IMPORTFILE1 导入电子表格中的数据
%  UNTITLED = IMPORTFILE1(FILE) 读取名为 FILE 的 Microsoft Excel
%  电子表格文件的第一张工作表中的数据。  以表形式返回数据。
%
%  UNTITLED = IMPORTFILE1(FILE, SHEET) 从指定的工作表中读取。
%
%  UNTITLED = IMPORTFILE1(FILE, SHEET,DATALINES)按指定的行间隔读取指定工作表中的数据。
%  对于不连续的行间隔，请将 DATALINES 指定为正整数标量或 N×2正整数标量数组。
%  
%
%  示例:
%  Untitled = importfile1("D:\MA毕业论文\ATrain_Record\20191002\降维参数统计.xlsx", "Sheet1", [2, 35]);
%
%  另请参阅 READTABLE。
%
% 由 MATLAB 于 2019-10-17 03:36:47 自动生成

%% 输入处理

% 如果未指定工作表，则将读取第一张工作表
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% 如果未指定行的起点和终点，则会定义默认值。
if nargin <= 2
    dataLines = [2, 35];
end

%% 设置导入选项并导入数据
opts = spreadsheetImportOptions("NumVariables", 14);

% 指定工作表和范围
opts.Sheet = sheetName;
%opts.RowNamesRange = "A" + dataLines(1, 1) + ":A" + dataLines(1, 2);
opts.RowNamesRange = "A" + dataLines(1, 1);
opts.DataRange = "B" + dataLines(1, 1) + ":O" + dataLines(1, 2);


% 指定列名称和类型
opts.VariableNames = ["no_dims", "no_analyzers", "max_iterations", "k",         "sigma",   "finetune",  "t",          "kernel", "perplexity", "initial_dims", "type",  "lambda",  "percentage", "eig_impl"];
opts.VariableTypes =   ["double",   "double",          "double",            "double", "double", "logical",     "double", "string", "double",     "double",       "string", "double",  "double",        "string"];

% 指定文件级属性
opts.ImportErrorRule = 'omitvar';
opts.MissingRule = 'omitvar';

% 指定变量属性
% opts = setvaropts(opts, ["VarName1", "finetune", "kernel", "type"], "WhitespaceRule", "preserve");
% opts = setvaropts(opts, ["VarName1", "eig_impl", "finetune", "kernel", "type"], "EmptyFieldRule", "auto");
% opts = setvaropts(opts, ["no_dims", "max_iterations", "sigma", "k", "t", "perplexity", "initial_dims", "lambda", "no_analyzers", "percentage"], "TreatAsMissing", '');

% 导入数据

paraTable_dr = readtable(workbookFile, opts, 'ReadRowNames',true, "UseExcel", false);

% for idx = 2:size(dataLines, 1)
%     opts.DataRange = "B" + dataLines(idx, 1) + ":O" + dataLines(idx, 2);
%     tb = readtable(workbookFile, opts, "UseExcel", false);
%     paraTable_dr = [paraTable_dr; tb]; %#ok<AGROW>
% end

end