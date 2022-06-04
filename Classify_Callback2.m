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
% paraTable_c =
% 
%   1×25 table
% 
%             dimReduce rate app  executionTimes  trainFcn  hiddenNum  transferFcn showWindow plotperform plottrainstate ploterrhist plotconfusion plotroc hiddenLayerNum hiddenNum1 transferFcn1 hiddenNum2 transferFcn2 hiddenNum3 transferFcn3 hiddenNum4 transferFcn4 hiddenNumOptimization startNum stopNum
%             _________     ____ ___    ______________    __________  _________      ___________   __________      ___________    ______________ ___________ _____________   _______  ______________       __________      ____________    __________      ____________    __________    ____________    __________      ____________    _____________________        ________    _______
% 
% TANSIG      true       0.2   3             20            "trainscg"       10            "tansig"         false               false             false             false           false           false           2                      20              "tansig"            20               "tansig"          20             "tansig"          20                "tansig"                   true                       1           100  
% 
% paraTable_c.Properties
% 
% ans = 
%   TableProperties - 属性:
% 
%              Description: ''
%                 UserData: []
%           DimensionNames: {'Row'  'Variables'}
%            VariableNames: {1×25 cell}
%     VariableDescriptions: {}
%            VariableUnits: {}
%       VariableContinuity: []
%                 RowNames: {'TANSIG'}
%         CustomProperties: 未设置自定义属性。
% 请使用 addprop 和 rmprop 修改 CustomProperties。
% 
% paraTable_c.Properties.RowNames
% ans =
%   1×1 cell 数组



% 得到最终分类准确率acc
% hyperDemo_1(hmenu4_1.UserData.x3);
% hyperDemo_detectors_1(hmenu4_1.UserData.x3);
% 一维分类方法
timerVal_1 = tic;
disp('数据准备.......................................................................');

rate = paraTable_c.rate;   % 所使用的训练集占比

if min(lbs(:))==0
    lbs = lbs(lbs~=0);
end
% vector_lbs2 = ind2vec(lbs2); % 这个函数输入只能是一维

% 3. ClassDemo
% 根据 'ParametersForDimReduceClassify.xlsx' sheet2 中的参数设计前向型浅层神经网络来分类
% 优点：可以设置多个隐含层，可以设置各层的传递函数及神经元个数
% 缺点：灵活性不够，需要自己开发，工作量大
    validateattributes(paraTable_c.dimReduce,{'logical'},{'integer'},'','dimReduce',1);
    validateattributes(paraTable_c.executionTimes,{'numeric'},{'integer','positive','>=',1,'<=',500},'','executionTimes',4);
    validateattributes(paraTable_c.hiddenLayerNum,{'numeric'},{'integer','positive','>=',1,'<=',5},'','hiddenLayerNum',14);
    validateattributes(paraTable_c.hiddenNumOptimization,{'logical'},{'integer'},'','hiddenNumOptimization',23);
    if paraTable_c.hiddenNumOptimization
        validateattributes(paraTable_c.startNum,{'numeric'},{'integer','positive','>=',1,'<=',500},'','startNum',24);
        validateattributes(paraTable_c.stopNum,{'numeric'},{'integer','positive','>=',1,'<=',500},'','stopNum',25);
    end

    time1 = toc(timerVal_1);
    disp({['数据准备完毕，历时',num2str(time1),'秒.',...
    hmenu4_1.UserData.matPath,' 开始执行分类']});

    if paraTable_c.dimReduce && ~isempty(hmenu4_3.UserData) && isfield(hmenu4_3.UserData, 'drData') && ~isempty(hmenu4_3.UserData.drData)

        % 执行20次分类，就划分20次数据；这样做是为了尽可能的使数据划分均匀
        % 因为目前的数据在pca降维后存在严重的数据倾斜，即第1主成分所占的比重太大了
        % 这样的话真的有利于分类吗？
        n = paraTable_c.executionTimes; % 迭代计算次数
        N = hmenu4_1.UserData.M-1;     % 类别总数
        
        % 询问是否要打开并行池
        quest = {'\fontsize{10} 是否要使用并行计算（Parallel Computing）？'};
                 % \fontsize{10}：字体大小修饰符，作用是使其后面的字符大小都为10磅；
        dlgtitle = '并行计算';         
        btn1 = '是';
        btn2 = '否';
        opts.Default = btn2;
        opts.Interpreter = 'tex';
        % answer = questdlg(quest,dlgtitle,btn1,btn2,defbtn);
        answer = questdlg(quest, dlgtitle, btn1, btn2, opts);
        if strcmp(answer, '是')
            try
                MyPar = parpool; %如果并行池未开启，则打开并行处理池
            catch
                MyPar = gcp; %如果并行池已经开启，则将当前并行池赋值给MyPar
            end
        end
        
        cAlgorithmNameSet1 = ["TANSIG", "RBF"];
        cAlgorithmNameSet2 = ["GA_TANSIG", "GA_RBF", "PSO_TANSIG", "PSO_RBF"];
        if sum(ismember(paraTable_c.Properties.RowNames, cAlgorithmNameSet1))
            % 每次迭代计算中，函数的返回值[net, tr, tTest, c, cm]只有一组值
            setsNum = 1; % 使用组数setsNum来进行循环计算获得TPR, OA, AA, Kappa
        elseif sum(ismember(paraTable_c.Properties.RowNames, cAlgorithmNameSet2))
            % 每次迭代计算中，函数的返回值[net, tr, tTest, c, cm]具有两组值
            % 一组是网络参数优化之前的，另一组是网络参数优化之后的。
            setsNum = 2; 
        else
            disp('所选择的分类算法在每次迭代计算时可能会产生超过两组结果，无法保存！');
        end
        acc_best = zeros(setsNum, setsNum); % 记录n次迭代下的最高准确率OA的值
        % acc_best(1,1)保存优化前的最高acc值; acc_best(2, 2)保存优化后的最高acc值
        % acc_best(1,2)保存优化前的最高acc值对应的网络在优化后的准确率值
        % acc_best(2,1)保存优化后的最高acc值对应的网络在优化前的准确率值
        net_best = cell(setsNum, setsNum); % 记录最高准确率下训练好的网络（用于绘制GT图）
        % net_best{1,1}保存优化前具有最高acc值的网络; net_best{2, 2}保存优化后具有最高acc值的网络
        % net_best{1,2}保存优化前具有最高acc值的网络在优化后的网络
        % net_best{2,1}保存优化后具有最高acc值的网络在优化前的网络

        tTest_best = cell(1, setsNum);
        % tTest_best也可以初始化为cell(setsNum, setsNum)，考虑到会极大消耗存储空间，
        % 于是将其初始化为cell(1, setsNum)。
        % tTest_best{1,1}保存优化前具有最高acc值的网络预测向量结果; 
        % tTest_best{1,2}保存优化后具有最高acc值的网络预测向量结果；
        cmNormalizedValues1 = zeros(N, N, n, setsNum); %保存正常顺序的混淆矩阵
        % cmNormalizedValues1(:, :, k, 1)保存第k次迭代计算优化前的网络性能的混淆矩阵;
        % cmNormalizedValues1(:, :, k, 2)保存第k次迭代计算优化后的网络性能的混淆矩阵;
        cmNormalizedValues2 = zeros(N, N, n, setsNum); %保存调整顺序后的混淆矩阵
        cmClassLabels2 = zeros(n, N, setsNum);
        acc = zeros(n, setsNum);
        % acc(k,1)保存第k次迭代计算优化前的准确率；acc(k,2)保存第k次迭代计算优化后的准确率；
       
%         % 记录每次得到的分类准确率，每一列的准确率对应一次迭代
%         acc_full =   zeros(iterationPerLearningRate, iterationonSize , 'single');  
%         idx_best = zeros(iterationonSize, 1); % 在每一个输入尺寸下记录一个最佳的学习进度曲线图    
%         accTable = table();  % 记录每一次的OA值，iterationPerLearningRate次重复计算的OA保存为一列，共有iterationonSize列
%         avgTable = table(); % 将iterationPerLearningRate次重复计算的各类TPR求平均保存为一列，每一列对应一个输入尺寸，共有iterationonSize列
%         % TPR = single(classNumber, iterationPerLearningRate, iterationonSize);
%         TPR = zeros(9, iterationPerLearningRate, iterationonSize, 'single');        
                
        racc = zeros(n, setsNum);        % 即混淆矩阵返回值中的第一个值c，误分率，等于1-acc
        err_perf = zeros(n, setsNum);   % （即trainRecord.best_perf）
        err_vperf = zeros(n, setsNum); %（即trainRecord.best_vperf）
        err_tperf = zeros(n, setsNum); %（即trainRecord.best_tperf）       
%% 利用黄金分割搜索法来寻找各个隐藏层神经元的最佳个数
% 这里仅针对单个隐层进行寻优，以说明寻找最佳隐含层节点数的过程，但是对于多个隐含层的情况，
% 这种方法并不见得就有好的效果，例如单隐层huston.mat数据集上0.2的训练集，1~100的寻优结果为85
% 这个效果会好于双隐层，每层只有40个节点的网络吗？不一定。因为通常而言，窄而深的网络分类效果更好。
% 而在单层优化时，节点越多效果越好。
% 所以单层的结论和可能不适用于多层。
        if paraTable_c.hiddenNumOptimization
            % 询问是否要进行黄金分割法来寻找隐含层节点数的最优值
            quest = {'\fontsize{10} 是否要使用黄金分割法来寻找隐含层节点数的最优值？'};
                     % \fontsize{10}：字体大小修饰符，作用是使其后面的字符大小都为10磅；
            dlgtitle = '隐含层节点数优化';         
            btn1 = '是';
            btn2 = '否';
            opts.Default = btn2;
            opts.Interpreter = 'tex';
            % answer = questdlg(quest,dlgtitle,btn1,btn2,defbtn);
            answer = questdlg(quest, dlgtitle, btn1, btn2, opts);
                                        
            % Handle response
            switch answer
                case '是'
                       
                    Ni = size(hmenu4_3.UserData.drData, 2); %输入层节点数记为Ni，10249x5 double
                    No = N; %输出层节点数记为No
                    Nh = []; %隐含层节点数记为Nh
                    a = paraTable_c.startNum; % 区间下界；向零取整，以免遗漏任何一个可能的节点数
                    b = paraTable_c.stopNum; %区间上界；         
                    gold_point = cell(1,paraTable_c.hiddenLayerNum);%记录黄金分割点
                    avg_acc = cell(1,paraTable_c.hiddenLayerNum);%记录分割点对应的准确率

                    for LayerNum=1 : paraTable_c.hiddenLayerNum  % 每个隐藏层一个大循环
                        N_1 = 20; %每个黄金分割点上的计算次数。
                        flag=1;

                        while(flag)
                            x_1 = a + 0.382*(b-a); %x_1和x_2总是位于区间中间
                            x_2 = a + 0.618*(b-a); %所以为了不漏掉可能的点，x_1的整数值应该尽量向左端点约值，x_2的整数值应该尽量向右端点约值
                            x = [floor(x_1), ceil(x_2)];              %每次取两个黄金分割点

                            [Lia, Locb] = ismember(x, gold_point{LayerNum}); %
                            % Lia = 1x2 logical array, 可能的值：[0,0] [1,0] [0,1] [1,1]
                            % Locb = 1xnumel(gold_point{LayerNum})，可能的值（假定numel(gold_point{LayerNum})=5）为：
                            % [0 0 0 0 0], [0 0 1 0 0], [0 0 0 0 1], [0 1 0 1 0]
                            % 
                            % Lia=[0,0]，表示x中的两个值在gold_point{LayerNum}中没有查询到重复的情况,
                            % 这时的Locb = [0 0 0 0 0]
                            % Lia=[1,0],
                            % 表示x中第一个值与gold_point{LayerNum}中的某个值重复，假设此时Locb=[0 0 1 0 0]
                            % 则说明重复在gold_point{LayerNum}中的第三个数，这个数在gold_point{LayerNum}中只有一个
                            % 其最小索引为1.
                            % Lia=[1,1] 表示x中的两个值与gold_point{LayerNum}中的值重复，假设此时Locb=[0 1 0 1 0]
                            % 则说明重复在gold_point{LayerNum}中的第二个数和第四个数，这两个数在gold_point{LayerNum}中只出现了一次
                            % 因此最小最小索引都为1.

                            switch Lia(1)*2+Lia(2)

                                case 0 % 若x中两个数字都和gold_point中没有重复，则两个黄金分割点都计算，保存
                                    acc = {[],[]}; %记录两个黄金分割点各20次的准确率
                                    acc_average = [0,0];%记录两个黄金分割点的平均准确率
                                    for i = 1 : 2
                                        for j = 1 : N_1
                                            c = fcn1(mappedA, lbs, rate, x(i), 'trainscg');
                                            acc{i} = [acc{i}, 1-c];
                                        end
                                        acc_average(i) = mean(acc{i});
                                    end

                                    if acc_average(1) >= acc_average(2)
                                        b = ceil(x_2);
                                    else
                                        a = floor(x_1);
                                    end
                                    gold_point{LayerNum} = [gold_point{LayerNum}, x]
                                    avg_acc{LayerNum} = [avg_acc{LayerNum}, acc_average]

                                case 1 % 若x中第二个数与gold_point中的点重复，则只计算第一个，保存第一个
                                    acc = []; %记录x中第一个黄金分割点各20次的准确率
                                    acc_average = [0];%记录x中第一个黄金分割点的平均准确率		
                                    for j = 1 : N_1
                                        [c, net] = fcn1(mappedA, lbs, rate, x(1), 'trainscg');
                                        acc = [acc, 1-c];
                                    end
                                    acc_average = mean(acc);

                                    if acc_average >= avg_acc{LayerNum}(nonzeros(Locb))
                                        b = ceil(x_2);
                                    else
                                        a = floor(x_1);
                                    end

                                    gold_point{LayerNum} = [gold_point{LayerNum}, x(1)]
                                    avg_acc{LayerNum} = [avg_acc{LayerNum}, acc_average]

                                case 2 % 若x中第一个数与gold_point中的点重复，则只计算第二个，保存第二个
                                    acc = []; %记录x中第二个黄金分割点各20次的准确率
                                    acc_average = [0];%记录x中第二个黄金分割点的平均准确率		
                                    for j = 1 : N_1
                                        [c, net] = fcn1(mappedA, lbs, rate, x(2), 'trainscg');
                                        acc = [acc, 1-c];
                                    end
                                    acc_average = mean(acc);

                                    if avg_acc{LayerNum}(nonzeros(Locb)) >= acc_average%第2个点的准确率与avg_acc(Locb)做比较
                                        b = ceil(x_2);
                                    else
                                        a = floor(x_1);
                                    end

                                    gold_point{LayerNum} = [gold_point{LayerNum}, x(2)]
                                    avg_acc{LayerNum} = [avg_acc{LayerNum}, acc_average]		 	 		
                                % 若x中两个数字都和gold_point重复，则结束switch
                            end

                            % 当round(x_1) == round(x_2)时，以round(x_1)为隐含层节点数建立网络
                            % 计算完成后再停止while()循环
                            if round(x_1) == round(x_2)
                                flag = 0;
                            end

                        end
                        Nh = [Nh, x(1)];
                    end
                % 黄金分割法寻优结束。
                % 保存结果       
                hiddenNumInfor = struct();
                hiddenNumInfor.dataset = hmenu4_1.UserData.matPath;    % 所使用的数据集名称
                hiddenNumInfor.rate = paraTable_c.rate;                             % 所使用的训练集占比
                hiddenNumInfor.drAlgorithmName = hmenu4_1.UserData.drAlgorithm;  % 降维算法名称
                hiddenNumInfor.drDimesion = size(hmenu4_3.UserData.drData, 2);          % 降维维数
                hiddenNumInfor.cAlgorithmName = hmenu4_1.UserData.cAlgorithm;      % 分类算法名称
                hiddenNumInfor.hiddenLayerNum = paraTable_c.hiddenLayerNum;         % 隐含层的层数
                % 各个隐含层的所使用的传递函数名称
                hiddenLayerName = [paraTable_c.transferFcn]; %transferFcn, transferFcn1, transferFcn2, transferFcn3, transferFcn4
                for i =1:paraTable_c.hiddenLayerNum-1
                    estr = ['hiddenLayerName = [hiddenLayerName, paraTable_c.transferFcn', num2str(i),'];'];
                    eval(estr);
                end
                hiddenNumInfor.hiddenLayerName = hiddenLayerName; 

                hiddenNumInfor.startNum = paraTable_c.startNum;
                hiddenNumInfor.stopNum = paraTable_c.startNum;
                % 将寻找到的最优网络net与gold_point, avg_acc,寻优信息hiddenNumInfo一起保存为mat数据。
                filename = fullfile('C:\Matlab练习\Project20191002\工程测试\', ['net_optim ', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS'), '.mat']); %将时间信息加入到文件名中
                save(filename, 'hiddenNumInfor', 'gold_point', 'avg_acc');

                % 将找到的各个隐层节点数的最优值赋值给paraTable_c中的相应变量(这里只考虑单隐层的情况)
                if paraTable_c.hiddenLayerNum==1
                    paraTable_c.hiddenNum=Nh(1);
                    for i = 1:paraTable_c.hiddenLayerNum-1
                        estr = ['paraTable_c.hiddenNum', num2str(i), '=Nh(',num2str(i+1),');' ];
                        eval(estr);
                    end
                end
                % 黄金分割法寻优结果保存完毕                    
            end
        end

        
    t = table2cell(paraTable_c);
    ss = table2struct(paraTable_c);
    k = numel(t); 
    para = cell(1,2*k);
    for i = 1:k
        para{2*i} = t{i};
        para{2*i-1} = paraTable_c.Properties.VariableNames{i};
    end
    var = cellfun(@string, para(9:end)); %对cell array中的所有cell应用string

        for k = 1 : n
            [mA1, mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate);  % rate: 所使用的训练集占比
            XTrain = table2array(mA1(:, 1:end-1))';  %mappedA和mA都是每一行为一个样本，而XTrain是每一列为一个样本，
        %     TTrain = dummyvar(double(mA1.Class))';
            TTrain = ind2vec(double(mA1.Class)');
            XTest = table2array(mA2(:, 1:end-1))';
        %     TTest = dummyvar(double(mA2.Class))';
            TTest = ind2vec(double(mA2.Class)');
            disp(['第',num2str(k),'次计算']);
            [netTrained, trainRecord, predictedVector, misclassRate, cmt] = classDemo(XTrain, TTrain, XTest, TTest, type, var);%前3个为必需参数，后面为可选参数
            %这个函数能给出的有价值的计算结果是： [net tr tTest c cm], 
            % 这里写为netTrained, trainRecord, predictedVector, misclassRate, cmt
            % netTrained，即net，训练好的网络
            % trainRecord，即tr，训练记录结构体，包含了tr.best_perf 训练集最佳性能（蓝色曲线），
            % tr.best_vperf 验证集最佳性能（绿色曲线），tr.best_tperf 测试集最佳性能（红色曲线）
            % predictedVector，即tTest，为预测的类别标签列向量
            % misclassRate，即混淆矩阵返回值的第一个值c, 误分率，其值等于1-acc；而1-c，即准确率OA
            % cmt，即cm, 混淆矩阵
            % 上述返回值都是cell array，对于函数f_TANSIG(), f_RBF(), f_BP()，上述返回值都是1×1 cell array；
            % 对于函数f_GA_TANSIG(), f_GA_RBF(), f_GA_BP()，f_PSO_TANSIG(), f_PSO_RBF(), f_PSO_BP()，
            % 上述返回值都是2×1 cell array；
            
            % 每计算一次，保存一次准确率及混淆矩阵
            acc(k, :) = cellfun(@(x) 1-x, misclassRate);
            racc(k, :) = 1-acc(k, :);                                % racc 误分率，即混淆矩阵返回值中的第一个值c, 其值为1-acc
            err_perf(k, :) = cellfun(@(x) x.best_perf, trainRecord);     %trainRecord.best_perf 训练集最佳性能（蓝色曲线）
            err_vperf(k, :) = cellfun(@(x) x.best_vperf, trainRecord);  %trainRecord.best_vperf 验证集最佳性能（绿色曲线）
            err_tperf(k, :) = cellfun(@(x) x.best_tperf, trainRecord);   %trainRecord.best_tperf 测试集最佳性能（红色曲线）  
            
            for iset = 1:setsNum
                cmNormalizedValues1(:, :, k, iset) = cmt{iset};
                % 如何找到最优网络net，及预测向量等结果？是找优化前的最高准确率还是找优化后的最高准确率？
                % 记录一个优化前的最高值，记录一个优化后的最高值。
                % 如果优化前后的两个最高准确率不是发生同一次（第k次）怎么办？
                % 记录优化前和优化后的最优值
                if acc(k, iset) > acc_best(iset, iset)    
                    % acc_best(1,1)保存优化前的最高acc值; acc_best(2, 2)保存优化后的最高acc值
                    % acc_best(1,2)保存优化前的最高acc值对应的网络在优化后的准确率值
                    % acc_best(2,1)保存优化后的最高acc值对应的网络在优化前的准确率值
                    acc_best(iset, :)=acc(k, :);
                    net_best(iset, :)=netTrained;
                    tTest_best(1, iset)=predictedVector(iset);
                    % tTest_best{1,1}保存优化前具有最高acc值的网络的预测向量结果；
                    % tTest_best{1,2}保存优化后具有最高acc值的网络的预测向量结果。                  
                end
            end
 
        end
        info_1 = hmenu4_1.UserData;
        info_1.cElapsedTime = toc(timerVal_1)-time1; % 保存分类消耗时间
    
        %% 计算分类结果（根据混淆矩阵cmNormalizedValues1，计算OA, AA, Kappa）
        [size1, size2, size3, size4] = size(cmNormalizedValues1);  % 16×16×20×2 double
        cmt = cmNormalizedValues1;
%         load('工程测试\20220517\cmNormalizedValues1.mat','cmt'); %用于测试
%         [size1, size2, size3, size4] = size(cmt);   % huston.mat数据集的混淆矩阵尺寸：15×15×20×2
        
        %# 先计算TPR
        Ns = sum(sum(cmt(:, :, 1, 1)));   %测试集样本总数
        p_o = sum(squeeze(sum(cmt.*repmat(eye(size1),1,1,size3, size4), 2)))/Ns; % 1×20×2
        p_e = sum( squeeze(sum(cmt)).*squeeze(sum(cmt,2)) )/Ns^2; % 1×20×2
        Kappa = (p_o - p_e)./(1 - p_e);% 1×20×2
        OA = single(p_o);            %1×20×2
        TPR = single(squeeze( sum(cmt.*repmat(eye(size1),1,1,size3,size4), 2)./sum(cmt, 2) ));%15×20×2
        AA = mean(TPR);  %1×20×2
        % 这种情况是20列，想要得到平均值，应该对TPR、OA、 AA、Kappa的行求平均，即mean(TPR, 2);
        c = zeros(size2+3, size3+2, size4,'single');
        % size2+3表示在上方向上增加了OA、 AA、Kappa三行数据。
        % size3+2表示在列方向上增加了average、std两列。
        c(1 : size2, 1:size3, :) = TPR; 
        c(size2+1, 1:size3, :) = OA; 
        c(size2+2, 1:size3, :) = AA; 
        c(size2+3, 1:size3, :) = Kappa;
        c(:, size3+1, :) = mean(c(:, 1:size3, :), 2);
        c(:, size3+2, :) = std(c(:, 1:size3, :), 0, 2); %对矩阵的行求标准差，等价于% std(permute(c(:, 1:size3, :),[2,1,3]));
        % c的最终尺寸为18×22×2

    %% 将分类结果写入Excel表格
     %为cell的每一列创建列名称 VariableNames
        VariableNames = cell(1,size3+2);
        for i = 1:size3
            VariableNames{i}= ['iter_',num2str(i)];
        end
        VariableNames(size3+1 : size3+2)  = {'average', 'std'};
        % 创建行的名称 RowNames，必须是字符元胞数组 即1×(15+3) cell；
        RowNames = cell(1, size1+3); % 3行分别是OA、AA、kappa；
        for i = 1:size(cmt, 1)
            RowNames{i} = ['class_',num2str(i)];
        end
        RowNames(i+1 : end) = {'OA', 'AA', 'Kappa'};
        
        %# 生成Excel文件保存地址
        path = ['C:\Matlab练习\Project20191002\工程测试\', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS')];
        try
            path = fullfile(path, hmenu4_1.UserData.datasetName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
        catch
        end
        if ~exist(path, 'dir')
            [status,msg,msgID] = mkdir(path);
        end
            filename = [hmenu4_1.UserData.datasetName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
        try
            filename = fullfile(path,filename);%拼接路径
        catch
        end
        
        for iset = 1:size4
            accTable = array2table(c(:, :, iset), 'VariableNames', VariableNames);
            accTable.Properties.RowNames = RowNames;
            % Sheet 1保存优化之前的分类结果，Sheet 2保存优化之后的分类结果。
            writetable(accTable,filename,'Sheet',iset,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);
        end
        %% 保存有关分类结果及网络配置的详细信息到附加Sheet中
        % 保存降维及分类参数设置paraTable_c到Sheet(iset+1)，即Sheet 3中
        writetable(paraTable_c, filename, 'Sheet',iset+1,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);
        
        %# 保存数据集信息hmenu4_1.UserData到Sheet(iset+1)
        %info_1 = hmenu4_1.UserData;
        info_1.x3 = [];
        info_1.lbs2 = [];
        info_1.x2 = [];
        info_1.lbs = [];
        info_1.cmap = [];
        % info_1.elapsedTimec = toc(timerVal_1)-time1; % 保存分类消耗时间
        info_1 = struct2table(info_1, 'AsArray',true);
        writetable(info_1, filename, 'Sheet',iset+1,'Range','A3', 'WriteRowNames',true, 'WriteVariableNames', true);
        %# 单独处理cmap
        info_cmap = hmenu4_1.UserData.cmap;
        VariableNames = ["R","G","B"]; %VariableNames属性为字符向量元胞数组{'R','G','B'}。
        % 如需指定多个变量名称，请在字符串数组["R","G","B"]或字符向量元胞数组{'R','G','B'}中指定这些名称。
        % 创建行的名称 RowNames，格式为字符串数组["1","2","3"]或字符向量元胞数组{'1','2','3'}；
        RowNames = string(1:size(info_cmap,1)); % ；
        info_cmap = array2table(info_cmap, 'VariableNames', VariableNames);
        info_cmap.Properties.RowNames = RowNames;
        writetable(info_cmap,filename,'Sheet',iset+1,'Range','A5', 'WriteRowNames',true, 'WriteVariableNames', true);
       
        %% 保存训练过程中的性能数据err_perf, err_vperf, err_tperf, racc到Excel中Sheet
        T1 = createTableForWrite(err_perf, err_vperf, err_tperf, racc);
        errTable = [T1.Variables; mean(T1.Variables); std(T1.Variables)];  % T1.Variables 是20×8 double
        errTable = array2table(errTable, 'VariableNames', T1.Properties.VariableNames);
        errTable.Properties.RowNames = [T1.Properties.RowNames; {'average'}; {'std'}]; %新增2行的行名称
        filename = "C:\Matlab练习\Project20191002\工程测试\2022-06-04 19-45-16\Botswana\LDA\GA_TANSIG\Botswana_LDA_GA_TANSIG.xlsx";
        errTable.Properties.Description = '保存训练过程中的性能数据err_perf, err_vperf, err_tperf, racc';
        writetable(errTable,filename,'Sheet',iset+2,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true); 

        %## 保存view(net)图像，详细参看C:\Matlab练习\Project20191002\save_view(net).m
        jframe = view(net_best{1,1});
        jframe_properties = get(jframe);
        jpanel = get(jframe,'ContentPane');
        jpanel_properties = get(jpanel);
        hFig = figure('Menubar','none', 'Position',[100, 100, jpanel_properties.Width, jpanel_properties.Height]);
        [~,h] = javacomponent(jpanel);
        h_properties = get(h);
        set(h, 'units','normalized', 'position',[0 0 1 1]);
        %# close java window
        jframe.setVisible(false);
        jframe.dispose();
        %# print to file
        filename_2 = fullfile(path,"net_best{2,2}");%拼接路径
        set(hFig, 'PaperPositionMode', 'auto');
        saveas(hFig, filename_2);        % 保存为fig
        saveas(hFig, filename_2,'jpg'); %保存为jpg
        %# close figure
        close(hFig);

        %# 保存net_best{}为"net_best.mat"
        % net_best{1,1}保存优化前具有最高acc值的网络; net_best{2, 2}保存优化后具有最高acc值的网络
        % net_best{1,2}保存优化前具有最高acc值的网络在优化后的网络
        % net_best{2,1}保存优化后具有最高acc值的网络在优化前的网络
        filename_2 = fullfile(path,"net_best.mat");%拼接路径
        save(filename_2, 'net_best');
        
        %% 绘制net_best{2,2}的混淆矩阵图及ROC图
        % load("C:\Matlab练习\Project20191002\工程测试\2022-06-02 16-46-57\Botswana\PCA\GA_TANSIG\net_best.mat");
        % load("C:\Matlab练习\Project20191002\工程测试\2022-06-04 02-35-46\Botswana\PCA\PSO_RBF\net_best.mat");
        netBest = net_best{2,2};
        YTest = netBest(mappedA'); 
        % mappedA是每一行为一个样本，而输入到train()，net()，sim()函数的XTest XTrain必须保证每一列为一个样本，
        % net()的返回值类型为one-hot-vector，每一列代表一个输入样本所属的类           
        TTest = ind2vec(lbs');
        figure()
        f = plotconfusion(TTest, YTest); %输入参数与confusion()的相同
        f.Units = 'normalized';
        f.Position = [0.2375, 0.000926, 0.5562, 0.9315];  % 具有14个类别的混淆矩阵图的最佳尺寸
        f.Children(1).FontName = 'MS Sans Serif';
        
        f.Children(2).Title.String = '混淆矩阵';
        f.Children(2).XLabel.String = '真实类别';
        f.Children(2).YLabel.String = '预测类别';
        f.Children(2).XTickLabelRotation = 0;
% f.Children(2).Children
% ans = 
%     677×1 graphics 数组:
% 
%   Line
%   Line
%   Text     (5.2%)
%   Text     (94.8%)
%   Patch
%   Text     (4.0%)
%   Text     (96.0%)
%   Patch
%   ……
%   Text     (8.3%)
%   Text     (270)
%   Patch
        % path = "C:\Matlab练习\Project20191002\工程测试\2022-06-02 16-46-57\Botswana\PCA\GA_TANSIG";
        filename_2 = fullfile(path,"net_best{2,2}_"+"originConfusion");%拼接路径
        saveas(gcf, filename_2);        % 原始混淆矩阵保存为fig
        
        %# 这里，我们需要处理的范围是i=1:14,j=1:14，将每一个格子中的百分数去掉
        N = hmenu4_1.UserData.M-1;     % 类别总数
        for i = 1:N
            for j = 1:N
                %for k = 1:2
                idx_1 = 2+(15-j)*15*3+(15-i) *3+1;
                % 将每一个格子中的百分数去掉
                f.Children(2).Children(idx_1).String='';
                % 将每一个格子中的整数位置调整到格子正中间 
                idx_2 = 2+(15-j)*15*3+(15-i) *3+2;
                f.Children(2).Children(idx_2).VerticalAlignment = 'middle';
                % 将每一个格子的颜色修改为其他颜色,比如品红色[0.8529 0.4686  0.6765 ]
                % confusion matrix默认的格子底色1 浅红色 [0.9765 0.7686 0.7529]; 
                % confusion matrix默认的格子底色2 浅绿色 [0.7373 0.9020 0.7686];  
                idx_3 = 2+(15-j)*15*3+(15-i) *3+3;
                f.Children(2).Children(idx_3).FaceColor = [0.8529 0.4686  0.6765];
            end
        end
        % 将混淆矩阵对角线上的每个格子的颜色设置为浅蓝色[0.6686 0.8529 0.9765 ]
        for i = 1:N
            idx_3 = 2+(15-i)*15*3+(15-i) *3+3;
            f.Children(2).Children(idx_3).FaceColor = [0.6686 0.8529 0.9765];
        end
        % 修改最右边一列和最下面一行的字体的颜色
        % confusion matrix默认的字体颜色1 红色Color: [0.8863 0.2392 0.1765]
        % confusion matrix默认的字体颜色2 绿色Color: [0.1333 0.6745 0.2353]
        for i=1:N
            %for j = N+1
            idx_1 = 2+(15-i) *3+1;
            f.Children(2).Children(idx_1).Color = [0.75 0.01  0.01];
            idx_2 = 2+(15-i) *3+2;
            f.Children(2).Children(idx_2).Color = [0 0 1];            
        end
        for j=1:N   %for i = N+1
            idx_1 = 2+(15-j)*15*3+1;
            f.Children(2).Children(idx_1).Color = [0.75 0.01  0.01];
            idx_2 = 2+(15-j)*15*3+2;
            f.Children(2).Children(idx_2).Color = [0 0 1];            
        end
        % i=15,j=15
        f.Children(2).Children(2+1).Color = [0.75 0.01  0.01];
        f.Children(2).Children(2+2).Color = [0 0  0];
        
        %# 混淆矩阵格式修改完毕，可以保存
        filename_2 = fullfile(path,"net_best{2,2}_"+"simpleConfusion");%拼接路径
        saveas(gcf, filename_2);        % 简化后的混淆矩阵保存为fig
        saveas(gcf, filename_2,'jpg'); % 简化后的混淆矩阵保存为jpg
        
        %## 绘制ROC曲线
        %#ROC原始曲线
        figure()
        f = plotroc(TTest, YTest);
%         f.Children
%         ans = 
%           3×1 graphics 数组:
%           UIControl
%           Legend       (Class 1, Class 2, Class 3, Class 4, Class 5, Class 6, Clas…)
%           Axes         (ROC)       filename_2 = fullfile(path,"net_best{2,2}_"+"originROC");%拼接路径
        filename_2 = fullfile(path,"net_best{2,2}_"+"originROC");
        saveas(gcf, filename_2);        % 保存为fig
        %# 对ROC图进行格式化
        f.Children(3).Title.String = '接收者操作特征曲线'; % (receiver operating characteristic curve
        f.Children(3).XLabel.String = '假阳性率'; %False Positive Rate
        f.Children(3).YLabel.String = '真阳性率'; %True Positive Rate
        filename_2 = fullfile(path,"net_best{2,2}_"+"接收者操作特征曲线");
        saveas(gcf, filename_2);        % 保存为fig
        saveas(gcf, filename_2,'jpg'); %保存为jpg

        %#ROC局部放大曲线 [0, 0.5] [0.5, 1]
        %filename_2 = fullfile(path,"net_best{2,2}_"+"zoomROC");%拼接路径
        filename_2 = fullfile(path,"net_best{2,2}_"+"接收者操作特征曲线局部放大");%拼接路径
        f.Children(3).XLim = [0, 0.5];
        f.Children(3).YLim = [0.5, 1];
        %saveas(gcf, filename_2);        % 保存为fig
        saveas(gcf, filename_2,'jpg'); %保存为jpg
        %#ROC局部放大曲线 [0, 0.25] [0.75, 1]
        %filename_2 = fullfile(path,"net_best{2,2}_"+"zoomROC2");%拼接路径
        filename_2 = fullfile(path,"net_best{2,2}_"+"接收者操作特征曲线局部放大2");%拼接路径
        f.Children(3).XLim = [0, 0.25];
        f.Children(3).YLim = [0.75, 1];
        %saveas(gcf, filename_2);        % 保存为fig
        saveas(gcf, filename_2,'jpg'); %保存为jpg        
% % 测试到此，一切正常       
        

        
        %% 绘制预测的GT图和真实的GT图
        %YTest是net()的返回值，类型为one-hot-vector，每一列代表一个输入样本所属的类
        Ylbs = vec2ind(YTest)';  %vec2ind()函数的输入数据，要求是由one-hot-vector列向量组成的矩阵
        %Ylbs表示预测的lbs
%         lbsTest = lbs;
%         lbsTest(ind2Best) = tTest_best;         %tTest 为预测的类别标签列向量%用预测值代替lbs中的真实值
%                                                               %tTestBest为n个预测的类别标签列向量中最优的那个
%         hObject.UserData.lbsTest = lbsTest; %保存包含有预测值的标签向量
%         
        gtdata = handles.UserData.gtdata;
        gtdata(gtdata~=0)=Ylbs;    %将标签向量排列成GT图
        Ygtdata = gtdata; %Ygtdata表示预测的gtdata
%         hObject.UserData.imgNew = double(gtdata);%保存预测出来的GT图
%         handles.UserData.imgNew = hObject.UserData.imgNew;
%         %绘制预测的GT图和真实的GT图
%         SeparatePlot3_Callback(handles.UserData.imgNew, handles.UserData.cmap, handles.UserData.M);
%         SeparatePlot3_Callback(handles.UserData.gtdata,    handles.UserData.cmap, handles.UserData.M);
%         SeparatePlot4_Callback(handles.UserData.gtdata, handles.UserData.imgNew, handles.UserData.cmap, handles.UserData.M);

        % 此时的hObject是hmenu4_4_2，Text: 'ClassDemo'，Type: 'uimenu'
        % 此时的 handles.UserData.gtdata: [1476×256 double]

        filename_2 = fullfile(path,"net_best{2,2}_"+"预测图");%拼接路径
        SeparatePlot3_Callback(Ygtdata, handles.UserData.cmap, handles.UserData.M);
        saveas(gcf, filename_2);        % 保存为fig
        saveas(gcf, filename_2,'jpg'); %保存为jpg
        filename_2 = fullfile(path, [hmenu4_1.UserData.datasetName, 'GT图']);%拼接路径
        SeparatePlot3_Callback(handles.UserData.gtdata,    handles.UserData.cmap, handles.UserData.M);
        saveas(gcf, filename_2);        % 保存为fig
        saveas(gcf, filename_2,'jpg'); %保存为jpg
        
        %# SeparatePlot4_Callback()将会绘制多张双图模式的GT图vs预测图，请手动保存满意的图片
        SeparatePlot4_Callback(handles.UserData.gtdata, Ygtdata, handles.UserData.cmap, handles.UserData.M);      
        filename_2 = fullfile(path,"net_best{2,2}_"+"GT图与预测图");%拼接路径
        % 手动执行以下两句，可保存当前figure
%         saveas(gcf, filename_2);        % 保存为fig
%         saveas(gcf, filename_2,'jpg'); %保存为jpg
        
        %% 绘制性能曲线
        %# 保存训练过程中的性能数据err_perf, err_vperf, err_tperf, racc
        
        %# 绘制错误率曲线
        figure()
        plotErr(err_perf, err_vperf, err_tperf, racc, 4);
            %racc 误分率，错误率
            %err_perf 训练集最佳性能（蓝色曲线）
            %err_vperf 验证集最佳性能（绿色曲线）
            %err_tperf 测试集最佳性能（红色曲线）
            %tTest 为预测的类别标签列向量        
        filename_2 = fullfile(path, [num2str(n), '次网络训练性能曲线_误差率']); %拼接路径
        saveas(gcf, filename_2);        % 保存为fig
        saveas(gcf, filename_2,'jpg'); %保存为jpg
        %# 绘制准确率曲线       
        % load("C:\Matlab练习\Project20191002\工程测试\2022-06-04 19-45-16\Botswana\LDA\GA_TANSIG\racc,err_perf,err_vperf,err_tperf.mat")
        figure()
        plotAcc(1-err_perf, 1-err_vperf, 1-err_tperf, acc, 4);
        filename_2 = fullfile(path, [num2str(n), '次网络训练性能曲线_准确率']); %拼接路径
        saveas(gcf, filename_2);        % 保存为fig
        saveas(gcf, filename_2,'jpg'); %保存为jpg
        %% 显示分类用时
        time2 = toc(timerVal_1);
        % filename = [hmenu4_1.UserData.datasetName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
        % filename = fullfile(path, filename);
        disp({[hmenu4_1.UserData.matPath, ' 分类完毕! 历时',num2str(time2-time1),'秒.']});
        disp(['分类结果详细数据保存于',filename]);
        
        %delete(MyPar) %计算完成后关闭并行处理池

        
    % 如果加载数据完毕，未选择[执行降维]而直接选择[执行分类]，则询问是否启动classificationLearner    
    else
            quest = {'\fontsize{10} 数据未执行降维，直接分类需要耗费较长时间。若想使用未降维的数据直接分类，请选择下面一种分类方式；',...
                         '若想使用经过降维的数据进行分类，请先点击‘exit’退出，随后在菜单栏选择[\bf分析\rm]>>[\bf执行降维\rm]'};
                     % \fontsize{10}：字体大小修饰符，作用是使其后面的字符大小都为10磅；
                     % \bf：字体加粗修饰符，作用是使其后面的字符都变为加粗字体，该修饰符会一直作用到文本结尾，直到遇到另外一种字体格式修饰符（例如\rm）时截止。
                     % \rm：常规字体修饰符，作用是使其后面的字符都变为常规字体，该修饰符会一直作用到文本结尾，直到遇到另外一种字体格式修饰符时截止。
            dlgtitle = '分类方式选择';
            btn1 = 'Clssification Learner';
            btn2 = 'ClassDemo';
            btn3 = 'exit';
%             defbtn = btn3;
            opts.Default = btn3;
            opts.Interpreter = 'tex';
%             answer = questdlg(quest, dlgtitle, btn1, btn2, btn3, defbtn);
            answer = questdlg(quest, dlgtitle, btn1, btn2, btn3, opts);
                                        
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
                        TTrain = ind2vec(double(mA1.Class)');
                        %%警告使用稀疏矩阵形式的输入数据训练网络将会导致内存占用太大！所以还是换成下面的向量形式的TTrain？
                        % TTrain = double(mA1.Class)';
                        XTest = table2array(mA2(:, 1:end-1))';             %XTest每一列为一个样本                
                        TTest = ind2vec(double(mA2.Class)');            %TTest每一列为一个类别标签
                        disp(['第',num2str(k),'次计算']);
                        [net, tr, tTest, c, cm] = classDemo(XTrain, TTrain, XTest, TTest, type, var);%前3个为必需参数，后面为可选参数
                        %这个函数能给出的有价值的计算结果是： net tr tTest c cm 
                        % net，训练好的网络
                        % tr，训练记录结构体，包含了best_perf 训练集最佳性能（蓝色曲线），best_vperf 验证集最佳性能（绿色曲线），best_tperf 测试集最佳性能（红色曲线）
                        %tTest 为预测的类别标签列向量
                        % c, 误分率，错误率；1-c，即准确率OA
                        % cm, 混淆矩阵                        

                        racc = [racc; err1];%racc 误分率，错误率
                        best_perf = [best_perf; err2]; %best_perf 训练集最佳性能（蓝色曲线）
                        best_vperf = [best_vperf; err3]; %best_vperf 验证集最佳性能（绿色曲线）
                        best_tperf = [best_tperf; err4];%best_tperf 测试集最佳性能（红色曲线）

                        % 挑选出最优泛化性能下的tTest;
                        [m, m1] = min(err1); %返回最小值及其索引
                        if m<raccBest
                            raccBest = m;
                            tTestBest = tTest(:, m1);
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
                    path = ['C:\Matlab练习\Project20191002\工程测试\', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS')];
                    try
                        path = fullfile(path, hmenu4_1.UserData.datasetName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
                    catch
                    end
                    if ~exist(path, 'dir')
                        [status,msg,msgID] = mkdir(path);
                    end
                        filename = [hmenu4_1.UserData.datasetName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
                    try
                        filename = fullfile(path,filename);%拼接路径
                    catch
                    end
                    writetable(T,filename,'Sheet',1,'Range','A1', 'WriteRowNames',true);
                    T1 = createTableForWrite(acc_perf, acc_vperf, acc_tperf, acc)
                    %T1 = table(acc_perf, acc_vperf, acc_tperf, acc, 'RowNames',arrayfun(@string, [1:numel(acc)]'))
                    %filename = [hmenu4_1.UserData.datasetName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
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
    path = ['C:\Matlab练习\Project20191002\工程测试\', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS')];
    saveAllFigure(path,handles,'.fig');
    gc = gcf; 
    closeFigure([2:gc.Number]);
%     closeFigure([2:13]);
end

%% 子函数（用于黄金分割法寻优隐含层最佳节点数）
function [c, net] = fcn1(mappedA, lbs, rate, hiddenSizes, trainFcn)
    % 划分数据
    [mA1, mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate);  % rate: 所使用的训练集占比
    XTrain = table2array(mA1(:, 1:end-1))';
    TTrain = ind2vec(double(mA1.Class)');
    %%警告使用稀疏矩阵形式的输入数据训练网络将会导致内存占用太大！所以还是换成下面的向量形式的TTrain?
    % 这样的话最后使用网络net(XTest)获得的outputs也是一个向量形式，这个向量不符合confusion(targets,outputs)
    % 对多分类输入数据的形式要求，所以不能直接输入到confusion(targets,outputs)。
    % confusion()要求多分类的targets必须是S×Q的矩阵形式，且每一列必须是one-hot-vector，outputs也必须是S×Q的矩阵形式
    % outputs的元素值大小位于[0,1]之间，且每一列的最大值对应其所属的S类中的一个。
    % 而且，当对outputs向量进行转换成系数矩阵时会报错。
    % 所以不得不继续使用稀疏矩阵形式的TTrain来作为训练网络的输入数据。
    % 至少在未开并行计算的情况下是没有出现过警告的。
    XTest = table2array(mA2(:, 1:end-1))';
    TTest = ind2vec(double(mA2.Class)');                                
    %构建网络
    net = feedforwardnet(hiddenSizes, trainFcn); %feedforwardnet(x(i),'trainscg')
    % 设置参数 (以下是trainscg的相关参数，可搜索trainscg查看)
    net.trainParam.epochs = 1000;
    net.trainParam.show = 10;
    net.trainParam.showWindow = false;
    % 训练网络
    [net, tr] = train(net, XTrain, TTrain);   %不能开并行计算，否则会触发内存占用过大的警告！
    %. 仿真网络
    YTest = net(XTest); 
    %. 性能评价
    [c,cm,ind,per] = confusion(TTest,YTest);
end
