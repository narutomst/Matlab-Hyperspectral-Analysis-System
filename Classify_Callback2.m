%%当用户选择【ClassDemo】命令后，本程序运行
function Classify_Callback2(hObject, eventdata, handles) %第113行
global x3 lbs2 x2 lbs mappedA Inputs Targets Inputs1 Inputs2 Inputs3 t0 t1 t2 mA mA1 mA2
%% 数据处理（三维mat转二维，二维gt转一维）
% hmenu4 = findobj(handles,'Tag','Analysis');
hmenu4_1 = findobj(handles,'Label','加载数据');
hmenu4_3 = findobj(handles,'Label','执行降维');

if isempty(hmenu4_3.UserData) || ~isfield(hmenu4_3.UserData, 'drData') || isempty(hmenu4_3.UserData.drData)
    mappedA = hmenu4_1.UserData.x2;         %若数据未做降维，从【加载数据】对象取数据
    disp('注意：数据未做降维处理，直接分类可能需要消耗更多时间！');
else
    mappedA = hmenu4_3.UserData.drData;  %若数据已经做了降维，从【执行降维】对象取数据
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

if min(lbs(:))==0
    lbs = lbs(lbs~=0);
end
% vector_lbs2 = ind2vec(lbs2); % 这个函数输入只能是一维

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
        racc = zeros(n,1);
        best_perf =  zeros(n,1); 
        best_vperf =zeros(n,1); 
        best_tperf = zeros(n,1);
        
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
            %racc 误分率，错误率
            %best_perf 训练集最佳性能（蓝色曲线）
            %best_vperf 验证集最佳性能（绿色曲线）
            %best_tperf 测试集最佳性能（红色曲线）
            %tTest 为预测的类别标签列向量 
        
            racc = [racc; err1];%racc 误分率，错误率
            best_perf = [best_perf; err2]; %best_perf 训练集最佳性能（蓝色曲线）
            best_vperf = [best_vperf; err3]; %best_vperf 验证集最佳性能（绿色曲线）
            best_tperf = [best_tperf; err4];%best_tperf 测试集最佳性能（红色曲线）
      
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
        lbsTest(ind2) = tTest;      %tTest 为预测的类别标签列向量%用预测值代替lbs中的真实值
        hObject.UserData.lbsTest = lbsTest; %保存包含有预测值的标签向量
        
        gtdata = handles.UserData.gtdata;
        gtdata(gtdata~=0)=lbsTest;    %将标签向量排列成GT图

        hObject.UserData.imgNew = double(gtdata);%保存预测出来的GT图
        handles.UserData.imgNew = hObject.UserData.imgNew;
        %绘制预测的GT图和真实的GT图
        SeparatePlot3_Callback(handles.UserData.imgNew, handles.UserData.cmap, handles.UserData.M);
        SeparatePlot3_Callback(handles.UserData.gtdata,    handles.UserData.cmap, handles.UserData.M);
        delete(MyPar) %计算完成后关闭并行处理池
        
        % 绘制性能曲线>>>错误率
        figure()
        plot((1:n)',[best_perf, best_vperf, best_tperf, racc],'LineWidth',1.5);
            %racc 误分率，错误率
            %best_perf 训练集最佳性能（蓝色曲线）
            %best_vperf 验证集最佳性能（绿色曲线）
            %best_tperf 测试集最佳性能（红色曲线）
            %tTest 为预测的类别标签列向量        
        title('训练性能（best_perf,best_vperf,best_tperf）与泛化性能（racc)','Interpreter','none');
        xlabel('次数');
        ylabel('错误率');
        
        hold on
        %mean()函数按列求平均，所以将行形式转换成列形式
        plot([1, n],[mean(racc(:,1)), mean(racc(:,1))],'--','LineWidth',1.5);

        text(1,mean(racc(:,1))*1.030,['racc1:',num2str(mean(racc(:,1)))]);
        try %若racc有两列，即优化前后的数据各占一列，则下面的语句会继续处理第2列数据
            plot([1, n],[mean(racc(:,2)), mean(racc(:,2))],'--','LineWidth',1.5);
            text(1,mean(racc(:,2))*1.030,['racc2:',num2str(mean(racc(:,2)))]);
            legend('best_perf1','best_perf2','best_vperf1','best_vperf2','best_tperf1','best_tperf2','racc1','racc2','Interpreter','none','Location','best');  
            %1表示优化前的数据，2表示优化后的数据
        catch%若racc仅含有一列数据，则按照一列的情形设置图例
            legend('best_perf','best_vperf','best_tperf','racc','Interpreter','none','Location','best');  
        end 
        hold off
        %显示最终分类结果：racc表示分类的错误率，1-racc表示分类准确率。
        
        % 绘制性能曲线>>>>准确率
        figure()
        plot((1:n)',1-[best_perf, best_vperf, best_tperf, racc],'LineWidth',1.5);
            %racc 误分率，错误率
            %best_perf 训练集最佳性能（蓝色曲线）
            %best_vperf 验证集最佳性能（绿色曲线）
            %best_tperf 测试集最佳性能（红色曲线）
            %tTest 为预测的类别标签列向量        
        title('训练性能（acc_perf,acc_vperf,acc_tperf）与泛化性能（acc)','Interpreter','none');
        xlabel('次数');
        ylabel('准确率');
        
        hold on
        acc = 1-racc; %mean()函数按列求平均，所以将行形式转换成列形式
        plot([1, n],[mean(acc(:,1)), mean(acc(:,1))],'--','LineWidth',1.5);
        text(1,mean(acc(:,1))*1.005,['acc1:',num2str(mean(acc(:,1)))]);
        try %若acc有两列，即优化前后的数据各占一列，则下面的语句会继续处理第2列数据
            plot([1, n],[mean(acc(:,2)), mean(acc(:,2))],'--','LineWidth',1.5);
            text(1,mean(acc(:,2))*1.005,['acc2:',num2str(mean(acc(:,2)))]);
            legend('acc_perf1','acc_perf2','acc_vperf1','acc_vperf2','acc_tperf1','acc_tperf2','acc1','acc2','Interpreter','none','Location','best');  
            %1表示优化前的数据，2表示优化后的数据
        catch%若acc仅含有一列数据，则按照一列的情形设置图例
            legend('acc_perf','acc_vperf','acc_tperf','acc','Interpreter','none','Location','best');  
        end 
        hold off
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
