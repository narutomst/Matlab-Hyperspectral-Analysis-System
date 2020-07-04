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
k = numel(t); 
para = cell(1,2*k);
for i = 1:k
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
%         racc = zeros(n,1);
%         best_perf =  zeros(n,1); 
%         best_vperf =zeros(n,1); 
%         best_tperf = zeros(n,1);
        
        try
            MyPar = parpool; %如果并行池未开启，则打开并行处理池
        catch
            MyPar = gcp; %如果并行池已经开启，则将当前并行池赋值给MyPar
        end
        
        racc = [];
        best_perf = []; 
        best_vperf = []; 
        best_tperf = [];  
        tTestBest = [];
        raccBest = 1;
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
            
            % 挑选出最优泛化性能下的tTest;
            [m,i] = min(err1); %返回最小值及其索引
            if m<raccBest
                raccBest = m;
                tTestBest = tTest(:, i);
                ind2Best = ind2';
                ma2Class = mA2.Class;
            end 
        end
  
    %% 将分类结果保存到hObject.UserData中
        hObject.UserData.racc = racc;
        hObject.UserData.best_perf = best_perf;
        hObject.UserData.best_vperf = best_vperf;
        hObject.UserData.best_tperf = best_tperf;
        %hObject.UserData.lbsOrigin = lbs;
        acc = 1-racc;                   %acc准确率；racc 误分率，错误率
        acc_perf = 1-best_perf;    %best_perf 训练集最佳性能（蓝色曲线）
        acc_vperf = 1-best_vperf; %best_vperf 验证集最佳性能（绿色曲线）
        acc_tperf = 1-best_tperf;  %best_tperf 测试集最佳性能（红色曲线）
        
    %% 将分类结果写入Excel表格
    T = createTableForWrite(best_perf, best_vperf, best_tperf, racc)
    
        %T = table(best_perf, best_vperf, best_tperf, racc, 'RowNames',arrayfun(@string, [1:nn]'),...
        %    'VariableNames',VN);
        %
        % 设置保存路径
        path = 'C:\Matlab练习\20200627';
        try
            path = fullfile(path, hmenu4_1.UserData.matName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
        catch
        end
        if ~exist(path, 'dir')
            [status,msg,msgID] = mkdir(path);
        end
            filename = [hmenu4_1.UserData.matName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
        try
            filename = fullfile(path,filename);%拼接路径
        catch
        end
        
        writetable(T,filename,'Sheet',1,'Range','A1', 'WriteRowNames',true);
        
        %T1 = table(acc_perf, acc_vperf, acc_tperf, acc, 'RowNames',arrayfun(@string, [1:numel(acc)]'))
        %filename = [hmenu4_1.UserData.matName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
        T1 = createTableForWrite(acc_perf, acc_vperf, acc_tperf, acc)
        writetable(T1,filename,'Sheet',2,'Range','A1', 'WriteRowNames',true);  
        
        %% 绘制预测的GT图和真实的GT图
        lbsTest = lbs;
        lbsTest(ind2Best) = tTestBest;         %tTest 为预测的类别标签列向量%用预测值代替lbs中的真实值
                                                              %tTestBest为n个预测的类别标签列向量中最优的那个
        hObject.UserData.lbsTest = lbsTest; %保存包含有预测值的标签向量
        
        gtdata = handles.UserData.gtdata;
        gtdata(gtdata~=0)=lbsTest;    %将标签向量排列成GT图

        hObject.UserData.imgNew = double(gtdata);%保存预测出来的GT图
        handles.UserData.imgNew = hObject.UserData.imgNew;
        %绘制预测的GT图和真实的GT图
        SeparatePlot3_Callback(handles.UserData.imgNew, handles.UserData.cmap, handles.UserData.M);
        SeparatePlot3_Callback(handles.UserData.gtdata,    handles.UserData.cmap, handles.UserData.M);
        SeparatePlot4_Callback(handles.UserData.gtdata, handles.UserData.imgNew, handles.UserData.cmap, handles.UserData.M);
        
        %% 绘制confusion matrix
        % plotconfusion()，输入数据可以是categorical列向量
        % 也可以是由若干个one-hot vector列向量组成的矩阵
        % 其他类型的数据会导致死循环。
        figure()
        pf = plotconfusion(ma2Class, categorical(tTestBest));
        %保存当前图窗中的图片
        %filename = generateFilename(path, handles, fmt);
        %filename = generateFilename('20200627', handles, ['_',num2str(pf.Number),'.fig']);
        %saveas(pf, filename);        
        
        %% 绘制性能曲线>>>错误率
        
        figure()
        plotErr(best_perf, best_vperf, best_tperf, racc, 4);
            %racc 误分率，错误率
            %best_perf 训练集最佳性能（蓝色曲线）
            %best_vperf 验证集最佳性能（绿色曲线）
            %best_tperf 测试集最佳性能（红色曲线）
            %tTest 为预测的类别标签列向量        

        
        %% 绘制性能曲线>>>>准确率       
        figure()
        plotErr1(acc_perf, acc_vperf, acc_tperf, acc, 4);

        %% 显示分类用时
        time2 = toc(timerVal_1);
        disp({[hmenu4_1.UserData.matPath, ' 分类完毕! 历时',num2str(time2-time1),'秒.']});
        
        %delete(MyPar) %计算完成后关闭并行处理池
        
    % 如果加载数据完毕，未选择[执行降维]而直接选择[执行分类]，则询问是否启动classificationLearner    
    else  
            answer = questdlg('数据未执行降维，想采用以下哪种方式执行分类?', ...
            '分类方式选择', ...
            'Clssification Learner','ClassDemo','exit','exit');
            % Handle response
            switch answer
                case 'Clssification Learner'
                    disp([answer ' 开启.'])
                    %dessert = 1;
                    if ~exist('t0','var') || isempty(t0) || size(x2,1)~=size(t0,1)
                        t0 = createTable(x2, lbs);
                        [t1,t2] = createTwoTable(x2,lbs,rate);
                        mA = createTable(mappedA, lbs);
                        [mA1,mA2] = createTwoTable(mappedA,lbs,rate);
                    end
                    classificationLearner
                    
                    
                case 'ClassDemo'
                    disp([answer ' 分类将继续执行.'])
                    %dessert = 2;
                    n = paraTable_c.executionTimes;
                    try
                        MyPar = parpool; %如果并行池未开启，则打开并行处理池
                    catch
                        MyPar = gcp; %如果并行池已经开启，则将当前并行池赋值给MyPar
                    end

                    racc = [];
                    best_perf = []; 
                    best_vperf = []; 
                    best_tperf = [];  
                    tTestBest = [];
                    raccBest = 1;  						
                    for k = 1 : n
                        [mA1,mA2, ind1, ind2] = createTwoTable(mappedA,lbs,rate);
                        XTrain = table2array(mA1(:, 1:end-1))';           %XTrain每一列为一个样本
                        TTrain = ind2vec(double(mA1.Class)');            %XTrain每一列为一个类别标签
                        XTest = table2array(mA2(:, 1:end-1))';             %XTest每一列为一个样本                
                        TTest = ind2vec(double(mA2.Class)');            %TTest每一列为一个类别标签
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

                        % 挑选出最优泛化性能下的tTest;
                        [m,i] = min(err1); %返回最小值及其索引
                        if m<raccBest
                            raccBest = m;
                            tTestBest = tTest(:, i);
                            ind2Best = ind2;
                            ma2Class = mA2.Class;
                        end 
                    end

                %% 将分类结果保存到hObject.UserData中
                    hObject.UserData.racc = racc;
                    hObject.UserData.best_perf = best_perf;
                    hObject.UserData.best_vperf = best_vperf;
                    hObject.UserData.best_tperf = best_tperf;
                    %hObject.UserData.lbsOrigin = lbs;
                    acc = 1-racc;                   %acc准确率；racc 误分率，错误率
                    acc_perf = 1-best_perf;    %best_perf 训练集最佳性能（蓝色曲线）
                    acc_vperf = 1-best_vperf; %best_vperf 验证集最佳性能（绿色曲线）
                    acc_tperf = 1-best_tperf;  %best_tperf 测试集最佳性能（红色曲线）

                %% 将分类结果写入Excel表格
                    % 首先创建一个表，可以参考table_example20190310.mlx
                    T = createTableForWrite(best_perf, best_vperf, best_tperf, racc)
                    %T = table(best_perf, best_vperf, best_tperf, racc, 'RowNames',arrayfun(@string, [1:numel(racc)]'))
                    % 设置保存路径
                    path = 'C:\Matlab练习\20200627';
                    try
                        path = fullfile(path, hmenu4_1.UserData.matName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
                    catch
                    end
                    if ~exist(path, 'dir')
                        [status,msg,msgID] = mkdir(path);
                    end
                        filename = [hmenu4_1.UserData.matName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
                    try
                        filename = fullfile(path,filename);%拼接路径
                    catch
                    end
                    writetable(T,filename,'Sheet',1,'Range','A1', 'WriteRowNames',true);
                    T1 = createTableForWrite(acc_perf, acc_vperf, acc_tperf, acc)
                    %T1 = table(acc_perf, acc_vperf, acc_tperf, acc, 'RowNames',arrayfun(@string, [1:numel(acc)]'))
                    %filename = [hmenu4_1.UserData.matName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
                    writetable(T1,filename,'Sheet',2,'Range','A1', 'WriteRowNames',true);  

                    %% 绘制预测的GT图和真实的GT图
                    lbsTest = lbs;
                    lbsTest(ind2Best) = tTestBest;         %tTest 为预测的类别标签列向量%用预测值代替lbs中的真实值
                                                                          %tTestBest为n个预测的类别标签列向量中最优的那个
                    hObject.UserData.lbsTest = lbsTest; %保存包含有预测值的标签向量

                    gtdata = handles.UserData.gtdata;
                    gtdata(gtdata~=0)=lbsTest;    %将标签向量排列成GT图

                    hObject.UserData.imgNew = double(gtdata);%保存预测出来的GT图
                    handles.UserData.imgNew = hObject.UserData.imgNew;
                    %绘制预测的GT图和真实的GT图
                    SeparatePlot3_Callback(handles.UserData.imgNew, handles.UserData.cmap, handles.UserData.M);
                    SeparatePlot3_Callback(handles.UserData.gtdata,    handles.UserData.cmap, handles.UserData.M);
                    SeparatePlot4_Callback(handles.UserData.gtdata, handles.UserData.imgNew, handles.UserData.cmap, handles.UserData.M);

                    %% 绘制confusion matrix
                    % plotconfusion()，输入数据可以是categorical列向量
                    % 也可以是由若干个one-hot vector列向量组成的矩阵
                    % 其他类型的数据会导致死循环。
                    figure()
                    pf = plotconfusion(ma2Class, categorical(tTestBest));
                    %保存当前图窗中的图片
                    %filename = generateFilename(path, handles, fmt);
                    %filename = generateFilename('20200627', handles, ['_',num2str(pf.Number),'.fig']);
                    %saveas(pf, filename);        

                    %% 绘制性能曲线>>>错误率

                    figure()
                    plotErr(best_perf, best_vperf, best_tperf, racc, 4);
                        %racc 误分率，错误率
                        %best_perf 训练集最佳性能（蓝色曲线）
                        %best_vperf 验证集最佳性能（绿色曲线）
                        %best_tperf 测试集最佳性能（红色曲线）
                        %tTest 为预测的类别标签列向量        


                    %% 绘制性能曲线>>>>准确率       
                    figure()
                    plotErr1(acc_perf, acc_vperf, acc_tperf, acc, 4);

                    %% 显示分类用时
                    time2 = toc(timerVal_1);
                    disp({[hmenu4_1.UserData.matPath, ' 分类完毕! 历时',num2str(time2-time1),'秒.']});
                    
                    delete(MyPar) %计算完成后关闭并行处理池   
                case 'exit'
                    disp('ClassDemo已经退出.')
                    %dessert = 0;
            end    
       
    end
    saveAllFigure('20200627',handles,'.fig');
    gc = gcf; 
    closeFigure([2:gc.Number]);
%     closeFigure([2:13]);
end
