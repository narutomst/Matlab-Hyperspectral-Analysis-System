%当用户选择【nprtool】命令后，本程序运行
function Classify_Callback4(hObject, eventdata, handles) %第113行
global Inputs Targets Inputs1 Targets1 Inputs2 Targets2 Inputs3 Targets3 mA1 mA2 Inputs_1 Targets_1 Inputs_2 Targets_2
% 在此处并且在主程序初始位置设置为全局变量，才能在nprtool的数据输入选择框中看到相应变量

%% 数据处理（三维mat转二维，二维gt转一维）
% hmenu4 = findobj(handles,'Tag','Analysis');
hmenu4_1 = findobj(handles,'Label','加载数据');
hmenu4_3 = findobj(handles,'Label','执行降维');

if isempty(hmenu4_3.UserData) || ~isfield(hmenu4_3.UserData, 'drData') || isempty(hmenu4_3.UserData.drData)
    mappedA = hmenu4_1.UserData.x2;         %若数据未做降维
else
    mappedA = hmenu4_3.UserData.drData;  %若数据已经做了降维
end
disp('分类：数据有效性检查............');
% if isfield(hmenu4_1.UserData, 'x2') || ~isempty(hmenu4_1.UserData.x2)
try
    x2 = hmenu4_1.UserData.x2;
catch
    feedData(hmenu4_1,handles);%若数据载入未成功
    return;
end

try
    lbs = hmenu4_1.UserData.lbs; 
catch
    feedData(hmenu4_1,handles);%若标签数据载入未成功
    return;
end

try
    type = hmenu4_1.UserData.cAlgorithm;%若未选择分类算法
catch
    feedData(hmenu4_1,handles);
    return;
end

%请输入训练集和测试集的样本数比例
%     prompt = ['请输入训练集和测试集的样本数比例。当前比例为',num2str(hObject.UserData.rate)];
%     dlg_title = '指定训练集与测试集的样本数比例';
%     an = inputdlg(prompt,dlg_title,1);%resize属性设置为on
%     if ~isempty(an{:})
%         rate = str2double(an{:}); 
%     end

% 所选择的算法名称及序号
type = hmenu4_1.UserData.cAlgorithm;
val = hmenu4_1.UserData.cValue;
% 根据序号读取默认参数
dataLines = [val+1, val+1];%第val个算法对应于excel的第val+1行
% dataLines = val+1;

workbookFile = fullfile(handles.UserData.mFilePath,"ParametersForDimReduceClassify.xlsx");
try
    paraTable_c = importfile2(workbookFile, "Sheet2", dataLines);
catch    
    paraTable_c = importfile2(workbookFile, "Sheet2", [2,2]);
end
t = table2cell(paraTable_c);
n = numel(t); 
para = cell(1,2*n);
for i = 1:n
	para{2*i} = t{i};
	para{2*i-1} = paraTable_c.Properties.VariableNames{i};
end

% 得到最终分类准确率acc
% hyperDemo_1(hmenu4_1.UserData.x3);
% hyperDemo_detectors_1(hmenu4_1.UserData.x3);
% 一维分类方法
timerVal_1 = tic;
disp('数据准备.......................................................................');

rate = paraTable_c.rate;



%% nprtool的数据需要按列来准备，并且是将数据和标签分开的

% Inputs和Targets是为nprtool准备的第1组数据(通常情况下是未降维的数据)
    Inputs = x2';
    if min(lbs(:))==0
        lbs = lbs(lbs~=0);
    end
% vector_lbs2 = ind2vec(lbs2); % 这个函数输入只能是一维
    Targets = ind2vec(lbs');

% 随机生成序号，划分整个数据集
    n = size(x2,1);        % 样本总数
    m = randperm(n);  % 生成1～n的整数随机排序向量
    k = round(rate*n);  % 获取训练集样本总数
    ind1 = m(1:k);
    ind2 = m(k+1:end);

% 准备第2组数据（ind1占比为 rate）
    Inputs_1 = Inputs(:, ind1);
    Targets_1 = Targets(:, ind1);

% 准备第3组数据（ind1占比为 rate）
    Inputs_2 = Inputs(:, ind2);
    Targets_2 = Targets(:, ind2);
% 1. nnstart >> nprtool（Pattern Recognition and Classification）
% 请为每种App准备合适的"数据结构"，否则GUI界面中将可能看不到待选的变量
% 输入数据最好每一列为一个样本
% 优点：
% nprtool的缺点：只有一个隐含层，且执行训练的时候只能是单线程
% 准备第2组数据 (通常情况下是已经降维的数据)
    Inputs1= mappedA';
    Targets1 = Targets';
% 准备第3组数据（将第2组数据划分为两份，本份数据占比为（1-rate））  
    Inputs2 = table2array(mA1(:, 1:end-1))';  %将表的数值子集(即排除categorical列及非数值列)转换为数组
    Targets2 = table2array(mA1(:, end))';
    Targets2 = ind2vec(double(Targets2));
% 准备第4组数据（将第2组数据划分为两份，本份数据占比为 rate）      
    Inputs3 = table2array(mA2(:, 1:end-1))';
    Targets3 = table2array(mA2(:, end))';
    Targets3 = ind2vec(double(Targets3));
    
    time1 = toc(timerVal_1);
    disp({['数据准备完毕，历时',num2str(time1),'秒.',...
    hmenu4_1.UserData.matPath,' 开始执行分类']});

    nprtool;

end
