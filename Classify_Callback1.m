%当用户选择【智能分类】命令后，程序将依据用户在Excel中设置的参数“app”的值
%以及数据是否已经经过降维处理来决定采用何种方式（ClassDemo\Classification Learner\nprtool）进行分类。
function Classify_Callback1(hObject, eventdata, handles) %第113行
global x3 lbs2 x2 lbs mappedA Inputs Targets Inputs1 Targets1 Inputs2 Targets2 Inputs3 Targets3 t0 t1 t2 mA mA1 mA2 Inputs_1 Targets_1 Inputs_2 Targets_2

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
%这里有个大问题，每次修改了xlsx中的参数值并且保存了，但为什么这里读取的值还是修改之前的值？

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

Inputs = x2';
if min(lbs(:))==0
    lbs = lbs(lbs~=0);
end
% vector_lbs2 = ind2vec(lbs2); % 这个函数输入只能是一维
Targets = ind2vec(lbs');

% 1. nnstart >> nprtool（Pattern Recognition and Classification）
% 请为每种App准备合适的"数据结构"，否则GUI界面中将可能看不到待选的变量
% 输入数据最好每一列为一个样本
% 优点：
% nprtool的缺点：只有一个隐含层，且执行训练的时候只能是单线程
if paraTable_c.app==1
        
Classify_Callback4(hObject, eventdata, handles) 

% 2. classificationLearner
% 请为每种App准备合适的"数据结构"，否则GUI界面中将可能看不到待选的变量
% 输入数据为table类型，每一列为一种属性，最后一列为categorical类型的数据

% 优点：a.可以手动选择要包含在模型中的预测变量，b.可以启用主成分分析以转换特征并删除冗余维度
% c.可以指定对响应类的错误预测的罚分
% 缺点：输入数据必须为一维，不能执行二维数据的分类
elseif paraTable_c.app==2
    Classify_Callback3(hObject, eventdata, handles);

    str = {'已生成了未降维的table类型的数据t0,t1,t2和降维的mA,mA1,mA2'; ...
        't0为总表，包含全部数据，t1和t2为按rate所指定的比例rate拆分的子表.';
        'mA为总表，对应于降维后的t0，mA1和mA2为按rate所指定的比例拆分子表.';
        '以上6组数据均可以用于Classification App用于训练分类器和预测结果';
        '具体数据可访问hmenu4_4.UserData.t0,hmenu4_4.UserData.t1和hmenu4_4.UserData.t2';
        'hmenu4_4.UserData.mA,hmenu4_4.UserData.mA1和hmenu4_4.UserData.mA2';
        '若要重新拆分数据，请在命令行执行：[mA1,mA2] = createTwoTable(mappedA,lbs,rate); [t1,t2] = createTwoTable(x2,lbs,rate);或'};
    disp(str);
    classificationLearner
    end
% 不建议使用未降维数据直接分类，因为有时候计算时间太长了。超过4小时
elseif paraTable_c.app==3
% 3. ClassDemo
% 根据 '降维参数统计.xlsx' sheet2 中的参数设计前向型浅层神经网络来分类
% 优点：可以设置多个隐含层，可以设置各层的传递函数及神经元个数
% 缺点：灵活性不够，需要自己开发，工作量大
Classify_Callback2(hObject, eventdata, handles);
else
    disp(['ParametersForDimReduceClassify.xlsx中第3个参数app设置错误！']);
end
