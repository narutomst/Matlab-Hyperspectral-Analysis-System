%% 导入电子表格中的数据
% 用于从以下电子表格导入数据的脚本:
%
%    工作簿: D:\MA毕业论文\ATrain_Record\20191002\降维参数统计.xlsx
%    工作表: Sheet1
%
% 由 MATLAB 于 2019-10-17 03:26:19 自动生成

%% 设置导入选项并导入数据
opts = spreadsheetImportOptions("NumVariables", 15);

% 指定工作表和范围
opts.Sheet = "Sheet1";
opts.DataRange = "A2:O35";

% 指定列名称和类型
opts.VariableNames = ["VarName1", "no_dims", "max_iterations", "sigma", "k", "eig_impl", "finetune", "t", "kernel", "perplexity", "initial_dims", "type", "lambda", "no_analyzers", "percentage"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "categorical", "string", "double", "string", "double", "double", "string", "double", "double", "double"];

% 指定变量属性
opts = setvaropts(opts, ["VarName1", "finetune", "kernel", "type"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["VarName1", "eig_impl", "finetune", "kernel", "type"], "EmptyFieldRule", "auto");

% 导入数据
paraTable_dr = readtable("D:\MA毕业论文\ATrain_Record\20191002\降维参数统计.xlsx", opts, "UseExcel", false);


%% 清除临时变量
clear opts