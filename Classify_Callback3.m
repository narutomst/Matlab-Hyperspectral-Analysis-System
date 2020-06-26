%当用户选择【Classification Learner】命令后，本程序运行
function Classify_Callback3(hObject, eventdata, handles) %第113行
global x3 lbs2 x2 lbs mappedA Inputs Targets Inputs1 Inputs2 Inputs3 t0 t1 t2 mA mA1 mA2
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
ss = table2struct(paraTable_c);
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

%% 准备好数据之后，以下有好几种思路

if min(lbs(:))==0
    lbs = lbs(lbs~=0);
end
% vector_lbs2 = ind2vec(lbs2); % 这个函数输入只能是一维


% 2. classificationLearner
% 请为每种App准备合适的"数据结构"，否则GUI界面中将可能看不到待选的变量
% 输入数据为table类型，每一列为一种属性，最后一列为categorical类型的数据

% 优点：a.可以手动选择要包含在模型中的预测变量，b.可以启用主成分分析以转换特征并删除冗余维度
% c.可以指定对响应类的错误预测的罚分
% 缺点：输入数据必须为一维，不能执行二维数据的分类

    if ~exist('t0','var') || isempty(t0) || size(x2,1)~=size(t0,1)    
        t0 = createTable(x2, lbs);
        [t1,t2] = createTwoTable(x2,lbs,rate);
        mA = createTable(mappedA, lbs);
        [mA1,mA2] = createTwoTable(mappedA,lbs,rate);
    end
    str = {'已生成了未降维的table类型的数据t0,t1,t2和降维的mA,mA1,mA2'; ...
        't0为总表，包含全部数据，t1和t2为按rate所指定的比例rate拆分的子表.';
        'mA为总表，对应于降维后的t0，mA1和mA2为按rate所指定的比例拆分子表.';
        '以上6组数据均可以用于Classification App用于训练分类器和预测结果';
        '具体数据可访问hmenu4_4.UserData.t0,hmenu4_4.UserData.t1和hmenu4_4.UserData.t2';
        'hmenu4_4.UserData.mA,hmenu4_4.UserData.mA1和hmenu4_4.UserData.mA2';
        '若要重新拆分数据，请在命令行执行：[mA1,mA2] = createTwoTable(mappedA,lbs,rate); [t1,t2] = createTwoTable(x2,lbs,rate);或'};
    disp(str);    
    
    time1 = toc(timerVal_1);
    disp({['数据准备完毕，历时',num2str(time1),'秒.',...
    hmenu4_1.UserData.matPath,' 开始执行分类']});
    
    classificationLearner

% 不建议使用未降维数据直接分类，因为有时候计算时间太长了。超过4小时

end
