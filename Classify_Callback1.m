%当用户选择【智能分类】命令后，程序将依据用户在Excel中设置的参数“app”的值
%以及数据是否已经经过降维处理来决定采用何种方式（ClassDemo\Classification Learner\nprtool）进行分类。
function Classify_Callback1(hObject, eventdata, handles) %第113行
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

workbookFile = fullfile(handles.UserData.mFilePath,"降维参数统计.xlsx");
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
while (min(lbs(:))==0)
    lbs = lbs+1;
end
% vector_lbs2 = ind2vec(lbs2); % 这个函数输入只能是一维
Targets = ind2vec(lbs');

% 1. nnstart >> nprtool（Pattern Recognition and Classification）
% 请为每种App准备合适的"数据结构"，否则GUI界面中将可能看不到待选的变量
% 输入数据最好每一列为一个样本
% 优点：
% nprtool的缺点：只有一个隐含层，且执行训练的时候只能是单线程
if paraTable_c.app==1
    Inputs1= mappedA';
    Inputs2 = table2array(mA1(:, 1:end-1))';  %将表的数值子集(即排除categorical列及非数值列)转换为数组
    Inputs3 = table2array(mA2(:, 1:end-1))';
    nprtool;

% 2. classificationLearner
% 请为每种App准备合适的"数据结构"，否则GUI界面中将可能看不到待选的变量
% 输入数据为table类型，每一列为一种属性，最后一列为categorical类型的数据

% 优点：a.可以手动选择要包含在模型中的预测变量，b.可以启用主成分分析以转换特征并删除冗余维度
% c.可以指定对响应类的错误预测的罚分
% 缺点：输入数据必须为一维，不能执行二维数据的分类
elseif paraTable_c.app==2
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
    classificationLearner

% 不建议使用未降维数据直接分类，因为有时候计算时间太长了。超过4小时
else
% 3. ClassDemo
% 根据 '降维参数统计.xlsx' sheet2 中的参数设计前向型浅层神经网络来分类
% 优点：可以设置多个隐含层，可以设置各层的传递函数及神经元个数
% 缺点：灵活性不够，需要自己开发，工作量大
    validateattributes(paraTable_c.hiddenLayerNum,{'numeric'},{'integer','positive','>=',1,'<=',5},'','hiddenLayerNum',12)

    time1 = toc(timerVal_1);
    disp({['数据准备完毕，历时',num2str(time1),'秒.',...
    hmenu4_1.UserData.matPath,' 开始执行分类']});

    var = cellfun(@string, para(9:end)); %对cell array中的所有cell应用string

    if paraTable_c.dimReduce && ~isempty(hmenu4_3.UserData) && isfield(hmenu4_3.UserData, 'drData') && ~isempty(hmenu4_3.UserData.drData)

        % 执行20次分类，就划分20次数据；这样做是为了尽可能的使数据划分均匀
        % 因为目前的数据在pca降维后存在严重的数据倾斜，即第1主成分所占的比重太大了
        % 这样的话真的有利于分类吗？
        n = paraTable_c.executionTimes;
        racc = zeros(1,n);
        best_perf =  zeros(1,n); 
        best_vperf =zeros(1,n); 
        best_tperf = zeros(1,n);
        
        try
            MyPar = parpool; %如果并行池未开启，则打开并行处理池
        catch
            MyPar = gcp; %如果并行池已经开启，则将当前并行池赋值给MyPar
        end
        
        racc = [];
        best_perf = []; 
        best_vperf = []; 
        best_tperf = [];        
        for k = 1 : n
            [mA1,mA2, ind1, ind2] = createTwoTable(mappedA,lbs,rate);
            XTrain = table2array(mA1(:, 1:end-1))';
        %     TTrain = dummyvar(double(mA1.Class))';
            TTrain = ind2vec(double(mA1.Class)');
            XTest = table2array(mA2(:, 1:end-1))';
        %     TTest = dummyvar(double(mA2.Class))';
            TTest = ind2vec(double(mA2.Class)');
            disp(['第',num2str(k),'次计算']);
            [err1, err2, err3, err4, tTest] = classDemo(XTrain, TTrain, XTest, TTest, type, var);%前3个为必需参数，后面为可选参数
        %  [racc, best_perf, best_vperf, best_tperf]     
            racc = [racc,err1];
            best_perf = [best_perf, err2]; 
            best_vperf = [best_vperf, err3]; 
            best_tperf = [best_tperf, err4];
        end
        %acc1返回类型为结构体是否合适？
    %         time1 = toc(timerVal_1);
    %         disp({['数据准备完毕，历时',num2str(time1),'秒.'];...
    %         [hmenu4_1.UserData.matPath,' 开始执行分类']});
        hObject.UserData.racc = racc;
        hObject.UserData.best_perf = best_perf;
        hObject.UserData.best_vperf = best_vperf;
        hObject.UserData.best_tperf = best_tperf;
%         hObject.UserData.lbsOrigin = lbs;
        lbsTest = lbs;
        lbsTest(ind2) = tTest;
        hObject.UserData.lbsTest = lbsTest;
        lbsNew = reshape(lbsTest, size(lbs2,1), size(lbs2,2));
        hObject.UserData.lbsNew = lbsNew;
        % 最后绘制预测的标签图
        if ~isa(lbsNew,'double')
            img = double(lbsNew);  
        else
            img = lbsNew;
        end
        hObject.UserData.imgNew = img;
        handles.UserData.imgNew = hObject.UserData.imgNew;

        SeparatePlot3_Callback(img, handles.UserData.cmap, handles.UserData.M);
        SeparatePlot3_Callback(handles.UserData.img, handles.UserData.cmap, handles.UserData.M);
        delete(MyPar) %计算完成后关闭并行处理池
        
        figure
        plot(1:n,[best_perf; best_vperf; best_tperf; racc],'LineWidth',1.5);
        title('训练性能（best_perf,best_vperf,best_tperf）与泛化性能（racc)','Interpreter','none');
        hold on
        racc = racc'; %mean()函数按列求平均，所以将行形式转换成列形式
        plot([1, n],[mean(racc(:,1)), mean(racc(:,1))],'--','LineWidth',1.5);
        text(0,mean(racc(:,1))*1.025,['racc1:',num2str(mean(racc(:,1)))]);

        try %若racc有两列，即优化前后的数据各占一列，则下面的语句会继续处理第2列数据
            plot([1, n],[mean(racc(:,2)), mean(racc(:,2))],'--','LineWidth',1.5);
            text(0,mean(racc(:,2))*1.025,['racc2:',num2str(mean(racc(:,2)))]);
            legend('best_perf1','best_perf2','best_vperf1','best_vperf2','best_tperf1','best_tperf2','racc1','racc2','Interpreter','none','Location','best');  
            %1表示优化前的数据，2表示优化后的数据
        catch%若racc仅含有一列数据，则按照一列的情形设置图例
            legend('best_perf','best_vperf','best_tperf','racc','Interpreter','none','Location','best');  
        end
        hold off
        %显示最终分类结果：racc表示分类的错误率，1-racc表示分类准确率。
        hmenu4_4 = findobj(handles,'Label','执行分类');    
        hmenu4_4.UserData
        
        % 显示分类用时
        time2 = toc(timerVal_1);
        disp({[hmenu4_1.UserData.matPath, ' 分类完毕! 历时',num2str(time2-time1),'秒.']});

    else  % 如果加载数据完毕，未选择[执行降维]而直接选择[执行分类]，则启动classificationLearner
        if ~exist('t0','var') || isempty(t0) || size(x2,1)~=size(t0,1)
            t0 = createTable(x2, lbs);
            [t1,t2] = createTwoTable(x2,lbs,rate);
            mA = createTable(mappedA, lbs);
            [mA1,mA2] = createTwoTable(mappedA,lbs,rate);
        end
        classificationLearner
    end
end

end
