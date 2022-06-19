%%当用户选择【ClassDemo】命令后，本程序运行
function Classify_Callback2(hObject, eventdata, handles) %第113行
global x3 lbs2 x2 lbs mappedA Inputs Targets Inputs1 Inputs2 Inputs3 t0 t1 t2 mA mA1 mA2
%% 数据处理（三维mat转二维，二维gt转一维）
% hmenu4 = findobj(handles,'Tag','Analysis');
hmenu4_1 = findobj(handles,'Label','加载数据');
hmenu4_3 = findobj(handles,'Label','执行降维');

if isempty(hmenu4_3.UserData) || ~isfield(hmenu4_3.UserData, 'drData') || isempty(hmenu4_3.UserData.drData)
    mappedA = double(hmenu4_1.UserData.x2);         %若数据未做降维，从【加载数据】对象取数据
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
%   1×28 table 
%             dimReduce rate app  executionTimes  trainFcn  hiddenNum  transferFcn showWindow plotperform plottrainstate ploterrhist plotconfusion plotroc 
%             _________     ____ ___    ______________    __________  _________      ___________   __________      ___________    ______________ ___________ _____________   _______   
% TANSIG      true       0.2   3             20            "trainscg"       10            "tansig"         false               false             false             false           false           false   
%             hiddenLayerNum hiddenNum1 transferFcn1 hiddenNum2 transferFcn2 hiddenNum3 transferFcn3 hiddenNum4 transferFcn4 
%               ______________       __________      ____________    __________      ____________    __________    ____________    __________      ____________    
%                       2                      20              "tansig"            20               "tansig"          20             "tansig"          20                "tansig"                     
%           hiddenNumOptimization startNum stopNum  hLayerNumOptimization startLayerNum stopLayerNum
%              _____________________        ________    _______      _____________________        ____________    ____________ 
%                        true                           1           100                      true                           1                   4
% paraTable_c.Properties
% ans = 
%   TableProperties - 属性:
% 
%              Description: ''
%                 UserData: []
%           DimensionNames: {'Row'  'Variables'}
%            VariableNames: {1×28 cell}
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
    validateattributes(paraTable_c.hLayerNumOptimization,{'logical'},{'integer'},'','hLayerNumOptimization',26);
    if paraTable_c.hLayerNumOptimization
        validateattributes(paraTable_c.startLayerNum,{'numeric'},{'integer','positive','>=',1,'<=',4},'','startNum',27);
        validateattributes(paraTable_c.stopLayerNum,{'numeric'},{'integer','positive','>=',1,'<=',4},'','stopNum',28);
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
        time1 = toc(timerVal_1);
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

% 数据位于filename = "C:\Matlab练习\Project20191002\工程测试\2022-06-12 14-07-04\Botswana\PCA\GA_TANSIG\Botswana_PCA_GA_TANSIG.xlsx";
% 该数据为2层隐含层的网络，且逐层累积迭代寻优的结果，
% 即在第一层节点数优化时，第二层（以及其他）隐含层的节点数使用的是默认的20。
% 当第一层最后一个黄金分割点被代入到var中的hiddenNum参数中，并计算出分类准确率后，
% 第一层寻优就完成了，程序就进入了第二层（即iLayer从1变为2），var中的第一层隐含层节点数参数hiddenNum就不再被改动了
% 同理，当第二层最后一个黄金分割点被代入到var中的hiddenNum1参数中，并计算出分类准确率后，
% 第二层寻优就完成了，程序就进入了第三层（即iLayer从2变为3），
% var中的第一层和第二层隐含层节点数参数hiddenNum和hiddenNum1就不再被改动了
% 所以，Classify_Callback2.m中这个264~420行的代码块，特别适合从第一层隐含层开始，中间不跳层，到第N层隐含层的逐层累积迭代寻优

% 但是目前上述excel文件sheet 5 中获得的第一隐含层的黄金分割点，到最后面竟然出现了左右横跳的情况，
% 比如第15~20个黄金分割点是[97, 95, 99, 94, 96, 98]
% 所以，对最终黄金分割点的确定，代码还需要改进，这是第一个问题

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
            answer_hiddenNumOptimization = questdlg(quest, dlgtitle, btn1, btn2, opts);
                                        
            % Handle response
            switch answer_hiddenNumOptimization
                case '是'
                    time_1 = toc(timerVal_1);
                    Ni = size(hmenu4_3.UserData.drData, 2); %输入层节点数记为Ni，10249x5 double
                    No = N; %输出层节点数记为No
                    Nh = []; %隐含层节点数记为Nh
                    gold_point = cell(1,paraTable_c.hiddenLayerNum);%记录黄金分割点
                    acc_avg = cell(1,paraTable_c.hiddenLayerNum);   
                    % acc表示包含各类别分类准确率、OA、AA、Kappa在内的完整分类准确率数据，
                    % acc_avg表示20次重复计算得到的完整分类准确率的平均值
                    OA_detail = cell(1,paraTable_c.hiddenLayerNum); %记录在黄金分割点上重复计算20次获得的20个OA值
                    %# 生成首次隐含层节点优化时的var，作为classDemo()函数的输入参数
                    OA_avg = cell(1,paraTable_c.hiddenLayerNum); % 记录mean(OA_detail{iLayer})
                    time_goldSection = zeros(1,paraTable_c.hiddenLayerNum); %记录每一层节点数优化所消耗的时间
                    
                    t = table2cell(paraTable_c);   
                    % t =
                    %   1×28 cell 数组
                    %     {[1]}    {[0.2000]}    {[3]}    {[20]}    {["trainscg"]}    {[20]}    {["tansig"]}    {[0]}    {[0]}
                    %     {[0]}    {[0]}    {[0]}    {[0]}    {[2]}    {[20]}    {["tansig"]}    {[20]}    {["tansig"]}    {[20]}
                    %     {["tansig"]}    {[20]}    {["tansig"]}    {[1]}    {[1]}    {[100]}  {[1]}    {[1]}    {[4]}
                    k = numel(t);                        % 28
                    para = cell(1,2*k);                 % 1×56 cell 数组
                    for i = 1:k
                        para{2*i-1} = paraTable_c.Properties.VariableNames{i};
                        para{2*i} = t{i};            
                    end
                    % para =
                    %   1×56 cell 数组
                    %   列 1 至 8
                    %     {'dimReduce'}    {[1]}    {'rate'}    {[0.2000]}    {'app'}    {[3]}    {'executionTimes'}    {[20]}    
                    %   列 9 至 50
                    %     {'trainFcn'}  {["trainscg"]}    {'hiddenNum'}    {[20]}    {'transferFcn'}    {["tansig"]}    {'showWindow'}    {[0]}
                    %     {'plotperform'}    {[0]}    {'plottrainstate'}    {[0]}    {'ploterrhist'}    {[0]}    {'plotconfusion'}    {[0]}
                    %     {'plotroc'}    {[0]}    {'hiddenLayerNum'}    {[2]}    {'hiddenNum1'}    {[20]}    {'transferFcn1'}    {["tansig"]}
                    %     {'hiddenNum2'}    {[20]}    {'transferFcn2'}    {["tansig"]}    {'hiddenNum3'}    {[20]}    {'transferFcn3'}
                    %     {["tansig"]}    {'hiddenNum4'}    {[20]}    {'transferFcn4'}    {["tansig"]}    
                    %     {'hiddenNumOptimi…'}    {[1]}    {'startNum'}    {[1]}    {'stopNum'}    {[100]} 
                    %     {'hLayerNumOptimi…'}    {[1]}    {'startLayerNum'}    {[1]}    {'stopLayerNum'}    {[4]} 
                    var = cellfun(@string, para(9:end)); %对cell array中的每一个cell应用string
                    % var = 
                    %   1×48 string 数组
                    %     "trainFcn"    "trainscg"    "hiddenNum"    "20"    "transferFcn"    "tansig"    "showWindow"    "false"
                    %     "plotperform"    "false"    "plottrainstate"    "false"    "ploterrhist"    "false"    "plotconfusion"    "false"
                    %     "plotroc"    "false"    "hiddenLayerNum"    "2"    "hiddenNum1"    "20"    "transferFcn1"    "tansig"    "hiddenNum2"
                    %     "20"    "transferFcn2"    "tansig"    "hiddenNum3"    "20"    "transferFcn3"    "tansig"    "hiddenNum4"    "20"
                    %     "transferFcn4"    "tansig"    "hiddenNumOptimiza…"    "true"    "startNum"    "1"    "stopNum"    "100"      
                    %     "hLayerNumOptimiza…"    "true"    "startLayerNum"    "1"    "stopLayerNum"    "4" 
                    for iLayer=1 : paraTable_c.hiddenLayerNum  % 每个隐藏层一个大循环
                        N_1 = n; %每个黄金分割点上的计算次数就按照ParametersForDimReduceClassify.xlsx中设定的迭代次数executionTimes来吧。
                        a = paraTable_c.startNum; % 区间下界；向零取整，以免遗漏任何一个可能的节点数
                        b = paraTable_c.stopNum; %区间上界；
                        acc_avg{iLayer} = [];    %  用于迭代保存多个列数据，每一列代表在一个黄金分割点上20次重复计算得到的分类结果
                                                                %（即对20次分类结果的[各类别的准确率，OA,AA,kappa]取平均所得到的一列数据）
                        OA_detail{iLayer} = []; %  用于迭代保存多个列数据，每一列代表在一个黄金分割点上20次重复计算得到的20个OA值
                        OA_avg{iLayer} = []; % 记录mean(OA_detail{iLayer})
                        % 找到var中需要更新的参数的序号，即更新var中的第LayerNum个隐含层的节点数为x(i), hiddenNumLayerNum
                        TF = contains(var, 'hiddenNum');
                        if iLayer>1
                            TF = contains(var, ['hiddenNum', num2str(iLayer)]);
                        end
                        str_idx = find(TF);
                        
                        flag=1;
                        while(flag)
                            x_1 = a + 0.382*(b-a); %x_1和x_2总是位于区间中间
                            x_2 = a + 0.618*(b-a); %所以为了不漏掉可能的点，x_1的整数值应该尽量向左端点约值，x_2的整数值应该尽量向右端点约值
                            x = [floor(x_1), ceil(x_2)];              %每次取两个黄金分割点

                            [Lia, Locb] = ismember(x, gold_point{iLayer}); %
                            % Lia = 1x2 logical array, 可能的值：[0,0] [1,0] [0,1] [1,1]
                            % Locb = 1xnumel(gold_point{iLayer})，可能的值（假定numel(gold_point{iLayer})=5）为：
                            % [0 0 0 0 0], [0 0 1 0 0], [0 0 0 0 1], [0 1 0 1 0]
                            % 
                            % Lia=[0,0]，表示x中的两个值在gold_point{iLayer}中没有查询到重复的情况,
                            % 这时的Locb = [0 0 0 0 0]
                            % Lia=[0,1]，
                            % 表示x中第二个值与gold_point{iLayer}中的某个值重复，假设此时Locb=[0 0 1 0 0]
                            % 则说明重复在gold_point{iLayer}中的第三个数，这个数在gold_point{iLayer}中只有一个
                            % 其最小索引为1.
                            % Lia=[1,0],
                            % 表示x中第一个值与gold_point{iLayer}中的某个值重复，假设此时Locb=[0 0 1 0 0]
                            % 则说明重复在gold_point{iLayer}中的第三个数，这个数在gold_point{iLayer}中只有一个
                            % 其最小索引为1.
                            % Lia=[1,1] 表示x中的两个值与gold_point{iLayer}中的值重复，假设此时Locb=[0 1 0 1 0]
                            % 则说明重复在gold_point{iLayer}中的第二个数和第四个数，这两个数在gold_point{iLayer}中只出现了一次
                            % 因此最小最小索引都为1.

                            switch Lia(1)*2+Lia(2)

                                case 0 
                                    % Lia=[0,0]，表示x中的两个值在gold_point{iLayer}中没有查询到重复的情况,
                                    % 这时的Locb = [0 0 0 0 0]
                                    % 若x中两个数字都和gold_point中没有重复，则两个黄金分割点都计算，保存
                                     
                                    %OA_avg记录两个黄金分割点作为第LayerNum隐含层节点数时的分类准确率中的OA值20次平均准确率
                                    for i = 1 : 2
                                        % 这里想要获得的结果包括，两个黄金分割点20次计算各得到一列分类结果的数据
                                        % 保存到acc_avg中
                                        % 这里能给出的输入参数有mappedA, lbs, rate, type, var
                                        % 可以在fcn1内部进行n次重复计算，返回值给出一列分类结果的数据及20次acc
                                        %# 更新var中的第LayerNum个隐含层的节点数为x(i), hiddenNumLayerNum
                                        %TF = contains(str,pattern)
                                        var(str_idx+1) = string(x(i));
                                        % 输入参数 (n, N, setsNum, mappedA, lbs, rate, type, var)
                                        % 输出2个列向量，20次分类结果的平均值avgResult_20iter, 和20次分类结果的OA值，OA_20iter
                                        [avgResult_20iter, OA_20iter] = fcn1(n, N, setsNum, mappedA, lbs, rate, type, var);                                     
                                        acc_avg{iLayer} = [acc_avg{iLayer}, avgResult_20iter];
                                        OA_detail{iLayer} = [OA_detail{iLayer}, OA_20iter]; 
                                        OA_avg{iLayer} = [OA_avg{iLayer}, mean(OA_20iter)];
                                    end

                                    if OA_avg{iLayer}(end-1) >= OA_avg{iLayer}(end)
                                        b = ceil(x_2);
                                    else
                                        a = floor(x_1);
                                    end
                                    gold_point{iLayer} = [gold_point{iLayer}, x];

                                case 1
                                    % Lia=[0,1]，
                                    % 表示x中第二个值与gold_point{iLayer}中的某个值重复，假设此时Locb=[0 0 1 0 0]
                                    % 则说明重复在gold_point{iLayer}中的第三个数，这个数在gold_point{iLayer}中只有一个
                                    % 其最小索引为1.
                                    % 若x中第二个数与gold_point中的点重复，则只计算第一个，保存第一个
                                    	
                                    %记录两个黄金分割点作为第LayerNum隐含层节点数时的分类准确率中的OA值20次平均准确率
                                    var(str_idx+1) = string(x(1));
                                    % 输入参数 (n, N, setsNum, mappedA, lbs, rate, type, var)
                                    % 输出2个列向量，20次分类结果的平均值avgResult_20iter, 和20次分类结果的OA值，OA_20iter
                                    [avgResult_20iter, OA_20iter] = fcn1(n, N, setsNum, mappedA, lbs, rate, type, var);                                     
                                    acc_avg{iLayer} = [acc_avg{iLayer}, avgResult_20iter];
                                    OA_detail{iLayer} = [OA_detail{iLayer}, OA_20iter]; 
                                         
                                    if mean(OA_20iter) >= OA_avg{iLayer}(nonzeros(Locb))
                                        b = ceil(x_2);
                                    else
                                        a = floor(x_1);
                                    end
                                    OA_avg{iLayer} = [OA_avg{iLayer}, mean(OA_20iter)];
                                    gold_point{iLayer} = [gold_point{iLayer}, x(1)];

                                case 2
                                    % Lia=[1,0],
                                    % 表示x中第一个值与gold_point{iLayer}中的某个值重复，假设此时Locb=[0 0 1 0 0]
                                    % 则说明重复在gold_point{iLayer}中的第三个数，这个数在gold_point{iLayer}中只有一个
                                    % 其最小索引为1.                                    
                                    % 若x中第一个数与gold_point中的点重复，则只计算第二个，保存第二个	

                                    var(str_idx+1) = string(x(2));
                                    % 输入参数 (n, N, setsNum, mappedA, lbs, rate, type, var)
                                    % 输出2个列向量，20次分类结果的平均值avgResult_20iter, 和20次分类结果的OA值，OA_20iter
                                    [avgResult_20iter, OA_20iter] = fcn1(n, N, setsNum, mappedA, lbs, rate, type, var);                                     
                                    acc_avg{iLayer} = [acc_avg{iLayer}, avgResult_20iter];
                                    OA_detail{iLayer} = [OA_detail{iLayer}, OA_20iter];                                   

                                    if OA_avg{iLayer}(nonzeros(Locb)) >= mean(OA_20iter)%第2个点的准确率与acc_avg(Locb)做比较
                                        b = ceil(x_2);
                                    else
                                        a = floor(x_1);
                                    end
                                    OA_avg{iLayer} = [OA_avg{iLayer}, mean(OA_20iter)];
                                    gold_point{iLayer} = [gold_point{iLayer}, x(2)];

                                otherwise
                                    % 若x中两个数字都和gold_point重复，则结束switch
                            end

                            % 当round(x_1) == round(x_2)时，以round(x_1)为隐含层节点数建立网络
                            % 计算完成后再停止while()循环
                            if round(x_1) == round(x_2)
                                flag = 0;
                            end
                        end
                        %# 保存第iLayer隐含层的最佳节点数
                        Nh = [Nh, x(1)];
                        
                        % 在黄金分割点上的计算结束
                        %# 将startNum和stopNum作为第LayerNum隐含层节点数的计算结果也添加进acc_avg和OA_detail中来
                        % 这样第LayerNum隐含层节点数（即网络宽度）与分类准确率的关系将更加完整
                        if paraTable_c.startNum==1 %若startNum==1，则令startNum=2，作为第LayerNum隐含层节点数进行计算
                            startNum = 2;
                        else
                            startNum = paraTable_c.startNum;
                        end
                        stopNum = paraTable_c.stopNum;
                        x = [startNum, stopNum];
                        for i = 1 : 2
                            %# 更新var中的第LayerNum个隐含层的节点数为x(i), hiddenNumLayerNum
                            %TF = contains(str,pattern)
                            var(str_idx+1) = string(x(i));
                            % 输入参数 (n, N, setsNum, mappedA, lbs, rate, type, var)
                            % 输出2个列向量，20次分类结果的平均值avgResult_20iter, 和20次分类结果的OA值，OA_20iter
                            [avgResult_20iter, OA_20iter] = fcn1(n, N, setsNum, mappedA, lbs, rate, type, var);                                     
                            acc_avg{iLayer} = [acc_avg{iLayer}, avgResult_20iter];
                            OA_detail{iLayer} = [OA_detail{iLayer}, OA_20iter];
                        end
                        OA_avg{iLayer} = [OA_avg{iLayer}, mean(OA_20iter)];
                        gold_point{iLayer} = [gold_point{iLayer}, x];
                        %# 保存第LayerNum隐含层节点数取黄金分割点时的分类结果
                        % gold_point{iLayer}，acc_avg{iLayer}, OA_detail{iLayer}, OA_avg{iLayer}
                        % 或者等所有hiddenLayerNum个隐含层节点数全部优化完之后再保存
                        d = time_goldSection(end);
                        time_goldSection(iLayer) = toc(timerVal_1) - time_1 - d;
                    end
					% 黄金分割法寻优结束。

					% 将找到的各个隐层节点数的最优值赋值给paraTable_c中的相应变量(这里只考虑单隐层的情况)
					if paraTable_c.hiddenLayerNum==1
						paraTable_c.hiddenNum=Nh(1);
						for i = 1:paraTable_c.hiddenLayerNum-1
							estr = ['paraTable_c.hiddenNum', num2str(i), '=Nh(',num2str(i+1),');' ];
							eval(estr);
						end
					end
					% 黄金分割法寻优结果保存完毕
                case '否'
            end
            
        end
       
        t = table2cell(paraTable_c);
        % t =
        %   1×28 cell 数组
        %     {[1]}    {[0.2000]}    {[3]}    {[20]}    {["trainscg"]}    {[20]}    {["tansig"]}    {[0]}    {[0]}
        %     {[0]}    {[0]}    {[0]}    {[0]}    {[2]}    {[20]}    {["tansig"]}    {[20]}    {["tansig"]}    {[20]}
        %     {["tansig"]}    {[20]}    {["tansig"]}    {[1]}    {[1]}    {[100]}   {[1]}    {[1]}    {[4]}
        k = numel(t);                        % 28
        para = cell(1,2*k);                 % 1×56 cell 数组
        for i = 1:k
            para{2*i-1} = paraTable_c.Properties.VariableNames{i};
            para{2*i} = t{i};            
        end
        % para =
        %   1×56 cell 数组
        %   列 1 至 8
        %     {'dimReduce'}    {[1]}    {'rate'}    {[0.2000]}    {'app'}    {[3]}    {'executionTimes'}    {[20]}    
        %   列 9 至 50
        %     {'trainFcn'}  {["trainscg"]}    {'hiddenNum'}    {[20]}    {'transferFcn'}    {["tansig"]}    {'showWindow'}    {[0]}
        %     {'plotperform'}    {[0]}    {'plottrainstate'}    {[0]}    {'ploterrhist'}    {[0]}    {'plotconfusion'}    {[0]}
        %     {'plotroc'}    {[0]}    {'hiddenLayerNum'}    {[2]}    {'hiddenNum1'}    {[20]}    {'transferFcn1'}    {["tansig"]}
        %     {'hiddenNum2'}    {[20]}    {'transferFcn2'}    {["tansig"]}    {'hiddenNum3'}    {[20]}    {'transferFcn3'}
        %     {["tansig"]}    {'hiddenNum4'}    {[20]}    {'transferFcn4'}    {["tansig"]}    
        %     {'hiddenNumOptimi…'}    {[1]}   {'startNum'}    {[1]}    {'stopNum'}    {[100]} 
        %     {'hLayerNumOptimi…'}    {[1]}    {'startLayerNum'}    {[1]}    {'stopLayerNum'}    {[4]} 
        var = cellfun(@string, para(9:end)); %对cell array中的每一个cell应用string
        % var = 
        %   1×48 string 数组
        %     "trainFcn"    "trainscg"    "hiddenNum"    "20"    "transferFcn"    "tansig"    "showWindow"    "false"
        %     "plotperform"    "false"    "plottrainstate"    "false"    "ploterrhist"    "false"    "plotconfusion"    "false"
        %     "plotroc"    "false"    "hiddenLayerNum"    "2"    "hiddenNum1"    "20"    "transferFcn1"    "tansig"    "hiddenNum2"
        %     "20"    "transferFcn2"    "tansig"    "hiddenNum3"    "20"    "transferFcn3"    "tansig"    "hiddenNum4"    "20"
        %     "transferFcn4"    "tansig"    "hiddenNumOptimiza…"    "true"    "startNum"    "1"    "stopNum"    "100"
        %     "hLayerNumOptimiza…"    "true"    "startLayerNum"    "1"    "stopLayerNum"    "4" 
 if 1  %# 按照ParametersForDimReduceClassify中设定的参数进行常规分类    
        for k = 1 : n
            [mA1, mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate);  % rate: 所使用的训练集占比
            XTrain = table2array(mA1(:, 1:end-1))';  %mappedA和mA都是每一行为一个样本，而XTrain是每一列为一个样本，
        %     TTrain = dummyvar(double(mA1.Class))';
            TTrain = ind2vec(double(mA1.Class)');    %%有时候会出现警告使用稀疏矩阵形式的输入数据训练网络将会导致内存占用太大！
            XTest = table2array(mA2(:, 1:end-1))';   %XTest每一列为一个样本
        %     TTest = dummyvar(double(mA2.Class))';
            TTest = ind2vec(double(mA2.Class)');     %TTest每一列为一个类别标签
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
        % load('工程测试\20220517\cmNormalizedValues1.mat','cmt'); %用于测试
        % [size1, size2, size3, size4] = size(cmt);   % huston.mat数据集的混淆矩阵尺寸：15×15×20×2
        
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
        %# 为cell的每一列创建列名称 VariableNames
        VariableNames = cell(1,size3+2);
        for i = 1:size3
            VariableNames{i}= ['iter_',num2str(i)];
        end
        VariableNames(size3+1 : size3+2)  = {'average', 'std'};
        %# 创建行的名称 RowNames，必须是字符元胞数组 即1×(15+3) cell；
        RowNames = cell(1, size1+3); % 3行分别是OA、AA、kappa；
        for i = 1:size(cmt, 1)
            RowNames{i} = ['class_',num2str(i)];
        end
        RowNames(i+1 : end) = {'OA', 'AA', 'Kappa'};
        
        %# 生成Excel文件保存地址
        % 生成文件夹名称
        path = ['C:\Matlab练习\Project20191002\工程测试\', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS')];
        try
            path = fullfile(path, hmenu4_1.UserData.datasetName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
        catch
        end
        % 如果生成的文件夹名称不存在，则先创建文件夹
        if ~exist(path, 'dir')
            [status,msg,msgID] = mkdir(path);
        end
        % 生成Excel文件名
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
        info_1 = hmenu4_1.UserData;
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
        %# 保存time_goldSection
        if exist('time_goldSection','var')==1
            VariableNames = ["iLayer_"+string(1:paraTable_c.hiddenLayerNum)];
            RowNames = "colapsedTime";
            timeTable = array2table(time_goldSection, 'VariableNames', VariableNames);
            timeTable.Properties.RowNames = RowNames;
            writetable(timeTable,filename,'Sheet',iset+1,'Range','A27', 'WriteRowNames',true, 'WriteVariableNames', true);
        end
        
        %% 保存训练过程中的性能数据err_perf, err_vperf, err_tperf, racc到Excel中Sheet
        T1 = createTableForWrite(err_perf, err_vperf, err_tperf, racc);
        errTable = [T1.Variables; mean(T1.Variables); std(T1.Variables)];  % T1.Variables 是20×8 double
        errTable = array2table(errTable, 'VariableNames', T1.Properties.VariableNames);
        errTable.Properties.RowNames = [T1.Properties.RowNames; {'average'}; {'std'}]; %新增2行的行名称
        %filename = "C:\Matlab练习\Project20191002\工程测试\2022-06-04 19-45-16\Botswana\LDA\GA_TANSIG\Botswana_LDA_GA_TANSIG.xlsx";
        errTable.Properties.Description = '保存训练过程中的性能数据err_perf, err_vperf, err_tperf, racc';
        writetable(errTable,filename,'Sheet',iset+2,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true); 

        %% 保存神经网络隐含层节点数的优化结果
        % 将寻找到的最优网络net与gold_point, acc_avg, OA_detail，寻优信息hiddenNumInfo一起保存为mat数据。
        % 之所以放到这里是因为有两个原因
        % 1. 如果直接在前面【神经网络隐含层节点数寻优】代码块中生成带时间的文件夹名的话，时间会过于早于Excel的写入时间。
        % 2. 神经网络隐含层节点数寻优的结果与数据集、降维算法、分类算法都有关系，这里的path包含了上述的几个关键信息，
        %     所以直接用这里的path作为[保存神经网络隐含层节点数的优化结果]是更合理的。
        if paraTable_c.hiddenNumOptimization && strcmp(answer_hiddenNumOptimization, '是')
            gold_point_sorted = cell(1,paraTable_c.hiddenLayerNum);
            acc_avg_sorted = cell(1,paraTable_c.hiddenLayerNum);
            OA_detail_sorted = cell(1,paraTable_c.hiddenLayerNum);
            %## 每一隐含层的计算结果保存到一个sheet中
            for iLayer = 1:paraTable_c.hiddenLayerNum
                %# 对第iLayer隐含层的分类准确率gold_point{iLayer}, acc_avg{iLayer}, OA_detail{iLayer}在列维度上调整顺序
                % 利用sort()函数对gold_point{iLayer}中的数按从小到大排序，结果保存到gold_point_sorted{iLayer}中，
                % 同时还得到了排序索引I
                % 继而利用排序索引I, 在列维度上对acc_avg{iLayer},OA_detail{iLayer}排序
                % 结果保存到acc_avg_sorted{iLayer}，OA_detail_sorted{iLayer}

                [B, I] = sort(gold_point{iLayer});
                gold_point_sorted{iLayer} = B;
                acc_avg_sorted{iLayer} = acc_avg{iLayer}(:, I);
                OA_detail_sorted{iLayer} = OA_detail{iLayer}(:, I);
                %# 将排序之后的第iLayer隐含层的分类准确率整理成table格式
                [size_1, size_2] = size(acc_avg{iLayer});
                accData = [gold_point{iLayer}; gold_point_sorted{iLayer}; acc_avg_sorted{iLayer};...
                    OA_detail_sorted{iLayer}; mean(OA_detail_sorted{iLayer}); std(OA_detail_sorted{iLayer})];
                % 为cell的每一列创建列名称 VariableNames
                VariableNames = cell(1,size_2);
                for i = 1:size_2
                    VariableNames{i}= ['goldPoint_',num2str(i)];
                end
                %# 创建行的名称 RowNames，必须是字符元胞数组 即1×(2+size_1+size_3+2) cell；
                [size_3, size_4] = size(OA_detail{iLayer});
                RowNames = cell(1, 2+size_1+size_3+2); 
                RowNames{1} = ['goldPoint{iLayer=',num2str(iLayer),'}'];
                RowNames{2} = 'goldPoint_sorted';
                for i = 1+2 : size_1-3+2              % acc_avg最后3行分别是OA、AA、kappa
                    RowNames{i} = ['class_',num2str(i-2)];
                end
                RowNames(i+1 : i+3) = {'OA', 'AA', 'Kappa'};
                i = i+3;
                RowNames(i+1: i+size_3) = cellstr("iter_"+string(1:size_3));
                i = i+size_3;
                RowNames(i+1 : i+2)  = {'average', 'std'};
                % path，filename都已经有了
                accTable = array2table(accData, 'VariableNames', VariableNames);
                accTable.Properties.RowNames = RowNames;
                % Sheet 1保存优化之前的分类结果，Sheet 2保存优化之后的分类结果。
                % Sheet 3保存执行分类任务的网络相关信息，Sheet 4保存训练性能信息。
                % Sheet iLayer+4可以保存第iLayer隐含层的分类准确率信息，
                writetable(accTable,filename,'Sheet',iLayer + iset+2,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);                
                
            end
        end
        
        %% 保存各种图像结果
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
        % f.Children
        % ans = 
        % 3×1 graphics 数组:
        % UIControl
        % Legend       (Class 1, Class 2, Class 3, Class 4, Class 5, Class 6, Clas…)
        % Axes         (ROC)       filename_2 = fullfile(path,"net_best{2,2}_"+"originROC");%拼接路径
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
        %Ylbs表示预测的lbs，为一个列向量
        % 不能通过将Ylbs通过reshape()的方式重排为二维矩阵，因为Ylbs仅仅是样本集中点的类别编号，
        % 而非整张图片上的所有像素点的类别编号
        % 正确的做法是：将全部样本数据输入netBest，获取Ylbs（列向量），
        % 再将列向量Ylbs嵌入二维矩阵gtdata，获取新的二维矩阵Ygtdata

        gtdata = handles.UserData.gtdata;
        gtdata(gtdata~=0)=Ylbs;    %将标签向量排列成GT图
        Ygtdata = gtdata; %Ygtdata表示预测的gtdata
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
        % saveas(gcf, filename_2);        % 保存为fig
        % saveas(gcf, filename_2,'jpg'); %保存为jpg
        
        %% 绘制性能曲线       
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
 end        
        %% 网络隐含层层数的优化 询问是否要执行隐含层层数（即网络深度）优化
        [mA1, mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate);  % rate: 所使用的训练集占比
        XTrain = table2array(mA1(:, 1:end-1))';  %mappedA和mA都是每一行为一个样本，而XTrain是每一列为一个样本，
        if paraTable_c.hLayerNumOptimization
            % 询问是否要进行神经网络隐含层层数的最优值搜索
            quest = {'\fontsize{10} 是否要执行网络隐含层层数优化来寻找隐含层层数的最优值？'};
                     % \fontsize{10}：字体大小修饰符，作用是使其后面的字符大小都为10磅；
            dlgtitle = '网络隐含层层数（即网络深度）优化';
            btn1 = '是';
            btn2 = '否';
            opts.Default = btn2;
            opts.Interpreter = 'tex';
            % answer = questdlg(quest,dlgtitle,btn1,btn2,defbtn);
            answer_hLayerNumOptimization = questdlg(quest, dlgtitle, btn1, btn2, opts);
                                        
            % Handle response
            switch answer_hLayerNumOptimization
                case '是'
                    % %## 首先确定隐含层神经元数量，可以采用公式来计算，也可以手动指定
                    % time_1 = toc(timerVal_1);
                    % [Ni, Ns] = size(XTrain); % XTrain每一列为一个样本，则行数为降维数，即输入层节点数。列数为训练集样本数
                    % % 输入向量的维数等于输入层的节点数。
                    % N = hmenu4_1.UserData.M-1;     % 类别总数
                    % No = N; %输出层节点数记为No
                    % % Botswana, round(3248*0.2)=650,No=14, 650./(a*(10+14))=[13.5417 2.7083]

                    % a = [2, 10]; % 系数a通常取2~10
                    % % 隐含层节点数计算公式 Nh = Ns/(a*(Ni+No));  %隐含层节点数记为Nh
                    % Nhd = Ns./(a*(Ni+No));
                    % % 当Ni=5;No=14;Ns=650时，Nhd=[17.1, 3.4];
                    % % Ni=10时，No=14;Ns=650时，Nhd=[13.6, 2.7];
                    % % 则隐含层的神经元取值下界值可定为floor(Nh(2))=3，
                    % % 上界值可定为ceil(Nh(1)/floor(Nh(2)))*floor(Nh(2))，循环次数为ceil(Nh(1)/floor(Nh(2)))
                    % iteration = ceil(Nhd(1)/floor(Nhd(2)));
                    % Nhd_min = floor(Nhd(2));
                    % Nhd_max = ceil(Nhd(1)/floor(Nhd(2)))*floor(Nhd(2));
                    
                    % %# 初始化分类结果保存变量
                    % % 对于隐含层节点数为Nhd = [18,3]这个例子中，一个固定的隐含层节点数在1~5层隐含层的情况下进行遍历，则可以得到5列分类结果
                    % % 则总共6个隐含层节点数，可以得到5×6=30列分类结果
                    % % 如果每个sheet只保存一个固定的隐含层节点数在1~5层隐含层的情况下进行遍历的5列结果的话，则需要保存至少6个sheet
                    % % 这样还是太浪费了，所以将30列分类结果保存到同一个sheet中
                    % % 第二个sheet保存OA_20iter，与第一个sheet中的列一一对应。
                    % % errTable先不保存了，一个固定的隐含层节点数在隐含层的层数固定的情况下，就可以获得n=20个err_perf数据
                    % % 则6个隐含层节点数在5个隐含层层数下，将有20×5×6=600个数据，太多了不好保存
                    % % 隐含层层数总是从1层到stopLayerNum+1层
					
					%## 手动指定要遍历的隐含层节点数
                    hiddenNum = [150]; %, 120, 125, 130, 135, 140, 145, 150];
                    % hiddenNum = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
                    % hiddenNum = [55, 60, 65, 70, 75, 80, 85, 90, 95, 100];
                    if ~exist('Nhd_min', 'var')
                        if exist('hiddenNum', 'var')
                            if hiddenNum(:)~=0
                                Nhd_min=min(hiddenNum);
                            else
                                disp(['Nhd_min不存在，且min(hiddenNum)为0，无法赋值给Nhd_min']);
                            end
                        else
                            disp(['Nhd_min不存在，且hiddenNum不存在，无法赋值给Nhd_min']);
                        end
                    end
                    if ~exist('Nhd_max', 'var')
                        if exist('hiddenNum', 'var')
                            if hiddenNum(:)~=0
                                Nhd_max=max(hiddenNum);
                            else
                                disp(['hiddenNum中有部分元素值为0，无法赋值给Nhd_min']);
                            end
                        else
                            disp(['Nhd_max不存在，且hiddenNum不存在，无法赋值给Nhd_max']);
                        end
                    end                   
                    iteration = numel(hiddenNum);
                    stopNum = paraTable_c.stopLayerNum+1;
                    iColomn = stopNum*iteration;
                    %iColomn = 5*iteration;
                    acc_avg = zeros(N+3, iColomn);
                    if ismember(type, {'GA_TANSIG','GA_RBF','PSO_TANSIG','PSO_RBF'})
                        err_avg = zeros(8, iColomn);
                    elseif ismember(type, {'TANSIG','RBF'})
                        err_avg = zeros(4, iColomn);
                    end
                    % acc表示包含各类别分类准确率、OA、AA、Kappa在内的完整分类准确率数据，
                    % acc_avg表示20次重复计算得到的完整分类准确率的平均值
                    OA_detail = zeros(n, iColomn); %记录在黄金分割点上重复计算20次获得的20个OA值
                    OA_avg = zeros(1, iColomn); % 记录mean(OA_detail)
                    time_Layer = zeros(1, iColomn); %记录每一个节点数在不同层数时所消耗的时间
                    %# 对照在ParametersForDimReduceClassify中设定的上下界进行修正
                    % 只要计算出的下界值大于等于设定的下界值，且计算出的上界值小于等于设定的上界值。就算满足要求
                    %if floor(Nhd(2))<=paraTable_c.startLayerNum && ceil(Nhd(1)/floor(Nhd(2)))*floor(Nhd(2))<=paraTable_c.stopLayerNum
                    %    disp('开始进行隐含层层数优化');
                    %elseif floor(Nhd(2))>paraTable_c.startLayerNum                        
                    %    paraTable_c.startLayerNum;
                    %    paraTable_c.stopLayerNum;
                    %end
					
					% 以hiddenLayerNum和stopLayerNum来决定寻优层数
					% 即隐含层层数总是从1层到stopLayerNum+1层
					% hiddenNum = zeros(1,iteration);
                    time_start = toc(timerVal_1);
                    for i = 1: iteration
                        % 隐含层节点数为Nhd_min*i;
                        %hiddenNum(i) = Nhd_min*i + 14;
                        % 更新输入变量paraTable_c
                        for iLayer = 1:stopNum
                            paraTable_c.hiddenLayerNum = iLayer;
                            paraTable_c.hiddenNum = hiddenNum(i);
                            if iLayer>1
                                for j = 1:iLayer-1
                                    estr = ['paraTable_c.hiddenNum',num2str(j),' = ', num2str(hiddenNum(i)),';'];
                                    eval(estr);
                                end
                            end
                            t = table2cell(paraTable_c);   
                            % t =
                            %   1×28 cell 数组
                            %     {[1]}    {[0.2000]}    {[3]}    {[20]}    {["trainscg"]}    {[20]}    {["tansig"]}    {[0]}    {[0]}
                            %     {[0]}    {[0]}    {[0]}    {[0]}    {[2]}    {[20]}    {["tansig"]}    {[20]}    {["tansig"]}    {[20]}
                            %     {["tansig"]}    {[20]}    {["tansig"]}    {[1]}    {[1]}    {[100]}  {[1]}    {[1]}    {[4]}
                            k = numel(t);                        % 28
                            para = cell(1,2*k);                 % 1×56 cell 数组
                            for iPara = 1:k
                                para{2*iPara-1} = paraTable_c.Properties.VariableNames{iPara};
                                para{2*iPara} = t{iPara};            
                            end
                            % para =
                            %   1×56 cell 数组
                            %   列 1 至 8
                            %     {'dimReduce'}    {[1]}    {'rate'}    {[0.2000]}    {'app'}    {[3]}    {'executionTimes'}    {[20]}    
                            %   列 9 至 50
                            %     {'trainFcn'}  {["trainscg"]}    {'hiddenNum'}    {[20]}    {'transferFcn'}    {["tansig"]}    {'showWindow'}    {[0]}
                            %     {'plotperform'}    {[0]}    {'plottrainstate'}    {[0]}    {'ploterrhist'}    {[0]}    {'plotconfusion'}    {[0]}
                            %     {'plotroc'}    {[0]}    {'hiddenLayerNum'}    {[2]}    {'hiddenNum1'}    {[20]}    {'transferFcn1'}    {["tansig"]}
                            %     {'hiddenNum2'}    {[20]}    {'transferFcn2'}    {["tansig"]}    {'hiddenNum3'}    {[20]}    {'transferFcn3'}
                            %     {["tansig"]}    {'hiddenNum4'}    {[20]}    {'transferFcn4'}    {["tansig"]}    
                            %     {'hiddenNumOptimi…'}    {[1]}    {'startNum'}    {[1]}    {'stopNum'}    {[100]} 
                            %     {'hLayerNumOptimi…'}    {[1]}    {'startLayerNum'}    {[1]}    {'stopLayerNum'}    {[4]} 
                            var = cellfun(@string, para(9:end)); %对cell array中的每一个cell应用string
                            % var = 
                            %   1×48 string 数组
                            %     "trainFcn"    "trainscg"    "hiddenNum"    "20"    "transferFcn"    "tansig"    "showWindow"    "false"
                            %     "plotperform"    "false"    "plottrainstate"    "false"    "ploterrhist"    "false"    "plotconfusion"    "false"
                            %     "plotroc"    "false"    "hiddenLayerNum"    "2"    "hiddenNum1"    "20"    "transferFcn1"    "tansig"    "hiddenNum2"
                            %     "20"    "transferFcn2"    "tansig"    "hiddenNum3"    "20"    "transferFcn3"    "tansig"    "hiddenNum4"    "20"
                            %     "transferFcn4"    "tansig"    "hiddenNumOptimiza…"    "true"    "startNum"    "1"    "stopNum"    "100"
                            %     "hLayerNumOptimiza…"    "true"    "startLayerNum"    "1"    "stopLayerNum"    "4"    

                            % 输出2个列向量，20次分类结果的平均值avgResult_20iter, 和20次分类结果的OA值，OA_20iter
                            [avgResult_20iter, OA_20iter, avgError_20iter] = fcn2(n, N, setsNum, mappedA, lbs, rate, type, var);
                            acc_avg(:, (i-1)*stopNum+iLayer) = avgResult_20iter;
                            OA_detail(:, (i-1)*stopNum+iLayer) = OA_20iter;    
                            OA_avg(:, (i-1)*stopNum+iLayer) = mean(OA_20iter);
                            err_avg(:, (i-1)*stopNum+iLayer) = avgError_20iter;
                            time_Layer((i-1)*stopNum+iLayer) = toc(timerVal_1) - time_start;
                        end
                    end
                    timeLayer = zeros(1, numel(time_Layer));
                    for i = 2:numel(time_Layer)
                        timeLayer(i) = time_Layer(i)-time_Layer(i-1);
                    end
                    timeLayer(1) = time_Layer(1);
                    
                    %## 保存隐含层层数寻优结果
                    %# 为cell的每一列创建列名称 VariableNames
                    % hNum1hLayer1~hNum1hLayer5, hNum2hLayer1~hNum2hLayer5, ……，hNum6hLayer1~hNum6hLayer5
                    VariableNames = cell(1, iColomn);
                    for i = 1:iteration
                        for iLayer = 1:stopNum
                            VariableNames{(i-1)*stopNum+iLayer}= ['hNum=',num2str(hiddenNum(i)),' hLayer=',num2str(iLayer)];
                        end
                    end
                    %# 创建行的名称 RowNames1，必须是字符元胞数组或者字符串数组；
                    [size_1, size_2] = size([acc_avg; timeLayer]);
                    RowNames1(1:size_1-4) = "class_"+string(1:(size_1-4)); 
                    RowNames1(size_1-3) = "OA";
                    RowNames1(size_1-2) = "AA";
                    RowNames1(size_1-1) = "Kappa";
                    RowNames1(size_1) = "time_Layer"; % 每一层计算所消耗的时间
                    %# 创建行的名称 RowNames2，必须是字符元胞数组或者字符串数组； 
                    [size_3, size_4] = size(OA_detail);
                    RowNames2 = "iter_"+string(1:size_3); 
                    RowNames2(size_3+1) = "average";
                    RowNames2(size_3+2) = "std";

                    %# 生成Excel文件保存地址
                    % 生成文件夹名称
                    path = ['C:\Matlab练习\Project20191002\工程测试\', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS')];
                    try
                        path = fullfile(path, hmenu4_1.UserData.datasetName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
                    catch
                    end
                    % 如果生成的文件夹名称不存在，则先创建文件夹
                    if ~exist(path, 'dir')
                        [status,msg,msgID] = mkdir(path);
                    end
                    % path已经有了，filename重新生成
                    filename = [hmenu4_1.UserData.datasetName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'_hLayerOptimization','.xlsx'];
                    filename = fullfile(path, filename);
                    accTable = array2table([acc_avg; timeLayer], 'VariableNames', VariableNames);
                    accTable.Properties.RowNames = RowNames1;
                    % Sheet 1保存优化30列（6个隐含层节点与5个隐含层）分类结果acc_avg。
                    % 每一列都是20次重复计算的分类准确率的平均值，包括各类别的分类准确率，以及OA, AA, Kappa
                    writetable(accTable,filename,'Sheet',1,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);
                    % Sheet 2保存优化30列（6个隐含层节点与5个隐含层）分类结果OA_detail。   
                    % 每一列是20次重复计算获得的20个OA值
                    OATable = array2table([OA_detail; OA_avg; std(OA_detail)], 'VariableNames', VariableNames);
                    OATable.Properties.RowNames = RowNames2;
                    writetable(OATable,filename,'Sheet',2,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);  

                    %# 网络信息保存
                    %% 保存有关分类结果及网络配置的详细信息到附加Sheet中
                    % 保存降维及分类参数设置paraTable_c到Sheet 3中，
                    % 主要是startNum和stopNum, startLayerNum 和stopLayerNum
                    paraTable_c.startNum = Nhd_min;
                    paraTable_c.stopNum = Nhd_max;
                    writetable(paraTable_c, filename, 'Sheet',3,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);

                    %# 保存数据集信息hmenu4_1.UserData到Sheet(iset+1)
                    info_1 = hmenu4_1.UserData;
                    info_1.x3 = [];
                    info_1.lbs2 = [];
                    info_1.x2 = [];
                    info_1.lbs = [];
                    info_1.cmap = [];
                    info_1.Nhd_min = Nhd_min;
                    info_1.Nhd_max = Nhd_max;
                    % info_1.elapsedTimec = toc(timerVal_1)-time1; % 保存分类消耗时间
                    info_1 = struct2table(info_1, 'AsArray',true);
                    writetable(info_1, filename, 'Sheet',3,'Range','A3', 'WriteRowNames',true, 'WriteVariableNames', true);
                    %# 单独处理cmap
                    info_cmap = hmenu4_1.UserData.cmap;
                    variableNames = ["R","G","B"]; %VariableNames属性为字符向量元胞数组{'R','G','B'}。
                    % 如需指定多个变量名称，请在字符串数组["R","G","B"]或字符向量元胞数组{'R','G','B'}中指定这些名称。
                    % 创建行的名称 RowNames3，格式为字符串数组["1","2","3"]或字符向量元胞数组{'1','2','3'}；
                    RowNames3 = string(1:size(info_cmap,1)); % ；
                    info_cmap = array2table(info_cmap, 'VariableNames', variableNames);
                    info_cmap.Properties.RowNames = RowNames3;
                    writetable(info_cmap,filename,'Sheet',3,'Range','A5', 'WriteRowNames',true, 'WriteVariableNames', true);

                    %# 创建行的名称 RowNames4，必须是字符元胞数组或者字符串数组；
                    [size_5, size_6] = size(err_avg);
                    if size_5==8
                        RowNames4 = {'err_perf1','err_perf2','err_vperf1','err_vperf2','err_tperf1','err_tperf2','racc1','racc2'};
                    elseif size_5==4
                        RowNames4 = {'err_perf','err_vperf','err_tperf','racc'};
                    end
                    errTable = array2table(err_avg, 'VariableNames', VariableNames);
                    errTable.Properties.RowNames = RowNames4;
                    % Sheet 3保存优化30列（6个隐含层节点与5个隐含层）训练性能数据err_avg。
                    % 每一列都是20次重复计算的训练性能数据的平均值，包括各类别的分类准确率，以及OA, AA, Kappa
                    writetable(errTable,filename,'Sheet',4,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);            
                    %# 隐含层层数寻优结果保存完毕

                    %% 绘制性能曲线（在训练集、验证集、测试集上的性能）       
                    %# 绘制错误率曲线
                    % path = "C:\Matlab练习\Project20191002\工程测试\2022-06-13 00-57-38\Botswana\PCA\GA_TANSIG";
                    % excelPath = "C:\Matlab练习\Project20191002\工程测试\2022-06-13 00-57-38\Botswana\PCA\GA_TANSIG\Botswana_PCA_GA_TANSIG_hLayerOptimization.xlsx";
                    % errTable = readtable(excelPath,'Sheet',4, 'ReadRowNames',true);
                    % 使用第一个维度名称访问行名称, errTable.Row
                    % 使用第二个维度名称访问数据, T.Variables 此语法等效于 T{:, :}。
                    errArray = errTable.Variables;
                    [s1, s2] = size(errArray);     % 8×50 double
                    hiddenLayerNum = 5;
                    setsNum = s1/4;
                    iteration = s2/hiddenLayerNum;
                    for i = 1:iteration
                        errData = errArray(:, 1+(i-1)*hiddenLayerNum : i*hiddenLayerNum)';
                        err_perf = errData(:, 1:setsNum);
                        err_vperf = errData(:, 1+setsNum:setsNum*2);
                        err_tperf = errData(:, 1+setsNum*2:setsNum*3); 
                        racc = errData(:, 1+setsNum*3:setsNum*4);
                        [size_1, size_2] = size(err_perf);

                        %## 绘制误差率曲线
                        % plotErr(err_perf, err_vperf, err_tperf, racc, 4);
                        p = figure();
                        plot((1:size_1)',[err_perf, err_vperf, err_tperf], 'LineWidth',1.5);
                        title(['训练性能误差率曲线(hiddenNum=',num2str(hiddenNum(i)),')'],'Interpreter','none');
                        xlabel('层数');
                        ylabel('误差率');
                            %racc 误分率，错误率
                            %err_perf 训练集最佳性能（蓝色曲线）
                            %err_vperf 验证集最佳性能（绿色曲线）
                            %err_tperf 测试集最佳性能（红色曲线）
                            %tTest 为预测的类别标签列向量
                        try %若err有两列，即优化前后的数据各占一列，则下面的语句会继续处理第2列数据
                            legend('err_perf1','err_perf2','err_vperf1','err_vperf2','err_tperf1','err_tperf2','Interpreter','none','Location','best');  
                            %1表示优化前的数据，2表示优化后的数据
                        catch%若err仅含有一列数据，则按照一列的情形设置图例
                            legend('err_perf','err_vperf','err_tperf','Interpreter','none','Location','best');  
                        end
                        xticks((1:size_1));  % 将x轴上的刻度设置为整数
                        filename_2 = fullfile(path, ['不同层数隐含层的神经网络的训练性能曲线_误差率', '(hiddenNum=',num2str(hiddenNum(i)),')']); %拼接路径
                        saveas(gcf, filename_2);        % 保存为fig
                        saveas(gcf, filename_2,'jpg'); %保存为jpg

                        %## 绘制准确率曲线       
                        %plotAcc(1-err_perf, 1-err_vperf, 1-err_tperf);
                        p=figure();
                        plot((1:size_1)',[1-err_perf, 1-err_vperf, 1-err_tperf], 'LineWidth',1.5);
                        title(['训练性能准确率曲线','(hiddenNum=',num2str(hiddenNum(i)),')'],'Interpreter','none');
                        xlabel('层数');
                        ylabel('准确率');
                            %racc 误分率，错误率
                            %err_perf 训练集最佳性能（蓝色曲线）
                            %err_vperf 验证集最佳性能（绿色曲线）
                            %err_tperf 测试集最佳性能（红色曲线）               
                        try %若acc有两列，即优化前后的数据各占一列，则下面的语句会继续处理第2列数据
                            legend('acc_perf1','acc_perf2','acc_vperf1','acc_vperf2','acc_tperf1','acc_tperf2','Interpreter','none','Location','best');  
                            %1表示优化前的数据，2表示优化后的数据
                        catch%若acc仅含有一列数据，则按照一列的情形设置图例
                            legend('acc_perf','acc_vperf','acc_tperf','Interpreter','none','Location','best');  
                        end
                        xticks((1:size_1));  % 将x轴上的刻度设置为整数
                        filename_2 = fullfile(path, ['不同层数隐含层的神经网络的训练性能曲线_准确率', '(hiddenNum=',num2str(hiddenNum(i)),')']); %拼接路径
                        saveas(gcf, filename_2);        % 保存为fig
                        saveas(gcf, filename_2,'jpg'); %保存为jpg
                    end

                    %% 整理出acc_matrix并绘制曲线
                    % 找到'OA'所在的行索引
                    [Lia,Locb] = ismember('OA', accTable.Row);
                    % 输出结果：Lia = logical 1，Locb = 15。而N=14, 'OA'恰好位于第N+1行
                    if Lia
                        size_row = numel(hiddenNum);
                        size_col = stopNum;
                        %## 
                        % acc_avg(N+1, 1+(i-1)*5:5*i)
                        % 先将acc_avg按照acc_avg(N+1, 1+(i-1)*5:5*i)取出来，每一次作为一列。整理成5行numel(hiddenNum)列的矩阵acc_matrix。
                        % 1. 现在的绘图方式是，将隐含层节点数固定，研究隐含层的层数从1层增加到5层所导致的网络分类准确率的变化。
                        % 如果将每一列绘制成一条曲线。纵坐标为准确率，横坐标为隐含层层数。legend为隐含层节点数。
                        % 则可以说明网络分类准确率与隐含层节点数直接的关系。
                        acc_matrix = reshape(accTable{Locb,:}, stopNum, []); %5行10列，每一列都是同一个隐含层节点数在1~5层隐含层的情况下的分类准确率
                        figure()
                        plot((1:stopNum)', acc_matrix, 'LineWidth',1.5);
                        title(['不同隐含层节点数的准确率曲线'],'Interpreter','none');
                        ylabel('准确率');
                        xlabel('隐含层层数');
                        % legend(labels), labels使用字符向量元胞数组、字符串数组
                        try
                            legend(["隐含层节点数="+string(hiddenNum(1):hiddenNum(2)-hiddenNum(1):hiddenNum(end))],'Interpreter','none','Location','best');
                        catch
                            legend("隐含层节点数="+string(hiddenNum(1)),'Interpreter','none','Location','best');
                        end
                        xticks((1:size_1));  % 将x轴上的刻度设置为整数

                        try
                            filename_2 = ['不同节点数隐含层的神经网络的准确率','(hiddenNum=',num2str(hiddenNum(1)),'-',num2str(hiddenNum(2)-hiddenNum(1)),'-',num2str(hiddenNum(end)),')'];
                        catch
                            filename_2 = ['不同节点数隐含层的神经网络的准确率','(hiddenNum=',num2str(hiddenNum(1)),')'];
                        end   
                        filename_2 = fullfile(path, filename_2); %拼接路径
                        saveas(gcf, filename_2);        % 保存为fig
                        saveas(gcf, filename_2,'jpg'); %保存为jpg
                        %##
                        % 2. 另外一种绘图方式可以是，在隐含层层数固定的情况下，绘制出隐含层节点数与网络分类准确率的关系曲线。
                        % 这样当隐含层的层数从1层增加到5层时，就能绘制出5条曲线。
                        % 这5条曲线放在一起比分类准确率的高低，就能说明网络深度与分类准确率的关系。
                        % 绘制acc_matrix的转置矩阵。 
                        figure()
                        %plot((1:numel(hiddenNum))', acc_matrix');
                        plot(hiddenNum', acc_matrix', 'LineWidth',1.5);
                        title(['不同隐含层层数的准确率曲线'],'Interpreter','none');
                        ylabel('准确率')
                        xlabel('隐含层节点数')
                        legend(["隐含层层数="+string(1:stopNum)],'Interpreter','none','Location','best');
                        xticks(hiddenNum);  % 将x轴上的刻度设置为整数
                        try
                            xlim([hiddenNum(1) hiddenNum(end)]);
                        catch
                        end
                        % 优化前的5条绘制一幅图，优化后的5条绘制一幅图？fcn2()仅返回优化后的分类准确率，舍弃掉了优化前的分类准确率
                        filename_2 = ['不同层数隐含层的神经网络的准确率','(hLayerNum=1-1-',num2str(stopNum),')'];
                        filename_2 = fullfile(path, filename_2); %拼接路径
                        saveas(gcf, filename_2);        % 保存为fig
                        saveas(gcf, filename_2,'jpg'); %保存为jpg                    
                    end
				case '否'
            end
        end
            
    %% 如果加载数据完毕，未选择[执行降维]而直接选择[执行分类]，则询问是否启动classificationLearner
    else  %属于第122行的if
        
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
                    answer_hiddenNumOptimization = questdlg(quest, dlgtitle, btn1, btn2, opts);

                    % Handle response
					switch answer_hiddenNumOptimization
						
						case '是'
							time_1 = toc(timerVal_1);
							Ni = size(hmenu4_3.UserData.drData, 2); %输入层节点数记为Ni，10249x5 double
							No = N; %输出层节点数记为No
							Nh = []; %隐含层节点数记为Nh        
							gold_point = cell(1,paraTable_c.hiddenLayerNum);%记录黄金分割点
							acc_avg = cell(1,paraTable_c.hiddenLayerNum);%记录分割点对应的准确率
							OA_detail = cell(1,paraTable_c.hiddenLayerNum); %记录在黄金分割点上重复计算20次获得的20个OA值
							%# 生成首次隐含层节点优化时的var，作为classDemo()函数的输入参数
							OA_avg = cell(1,paraTable_c.hiddenLayerNum); % 记录mean(OA_detail{iLayer})
							time_goldSection = zeros(1,paraTable_c.hiddenLayerNum); %记录每一层节点数优化所消耗的时间

							t = table2cell(paraTable_c);                             
							k = numel(t);                        % 28
							para = cell(1,2*k);                 % 1×56 cell 数组
							for i = 1:k
								para{2*i-1} = paraTable_c.Properties.VariableNames{i};
								para{2*i} = t{i};            
							end                            
							var = cellfun(@string, para(9:end)); 
							for iLayer=1 : paraTable_c.hiddenLayerNum  % 每个隐藏层一个大循环
								N_1 = n; %每个黄金分割点上的计算次数。
								a = paraTable_c.startNum; % 区间下界；向零取整，以免遗漏任何一个可能的节点数
								b = paraTable_c.stopNum; %区间上界； 
								acc_avg{iLayer} = [];    %  用于迭代保存多个列数据，每一列代表在一个黄金分割点上20次重复计算得到的分类结果
																		%（即对20次分类结果的[各类别的准确率，OA,AA,kappa]取平均所得到的一列数据）
								OA_detail{iLayer} = []; %  用于迭代保存多个列数据，每一列代表在一个黄金分割点上20次重复计算得到的20个OA值
								OA_avg{iLayer} = []; % 记录mean(OA_detail{iLayer})
								% 找到var中需要更新的参数的序号，即更新var中的第LayerNum个隐含层的节点数为x(i), hiddenNumLayerNum
								TF = contains(var, 'hiddenNum');
								if iLayer>1
									TF = contains(var, ['hiddenNum', num2str(iLayer)]);
								end
								str_idx = find(TF);

								flag=1;
								while(flag)
									x_1 = a + 0.382*(b-a); %x_1和x_2总是位于区间中间
									x_2 = a + 0.618*(b-a); %所以为了不漏掉可能的点，x_1的整数值应该尽量向左端点约值，x_2的整数值应该尽量向右端点约值
									x = [floor(x_1), ceil(x_2)];              %每次取两个黄金分割点

									[Lia, Locb] = ismember(x, gold_point{iLayer}); %
									% Lia = 1x2 logical array, 可能的值：[0,0] [1,0] [0,1] [1,1]
									% Locb = 1xnumel(gold_point{iLayer})，可能的值（假定numel(gold_point{iLayer})=5）为：
									% [0 0 0 0 0], [0 0 1 0 0], [0 0 0 0 1], [0 1 0 1 0]
									% 
									% Lia=[0,0]，表示x中的两个值在gold_point{iLayer}中没有查询到重复的情况,
									% 这时的Locb = [0 0 0 0 0]
									% Lia=[1,0],
									% 表示x中第一个值与gold_point{iLayer}中的某个值重复，假设此时Locb=[0 0 1 0 0]
									% 则说明重复在gold_point{iLayer}中的第三个数，这个数在gold_point{iLayer}中只有一个
									% 其最小索引为1.
									% Lia=[1,1] 表示x中的两个值与gold_point{iLayer}中的值重复，假设此时Locb=[0 1 0 1 0]
									% 则说明重复在gold_point{iLayer}中的第二个数和第四个数，这两个数在gold_point{iLayer}中只出现了一次
									% 因此最小最小索引都为1.

									switch Lia(1)*2+Lia(2)

										case 0 % 若x中两个数字都和gold_point中没有重复，则两个黄金分割点都计算，保存

											for i = 1 : 2
												var(str_idx+1) = string(x(i));
												% 输入参数 (n, N, setsNum, mappedA, lbs, rate, type, var)
												% 输出2个列向量，20次分类结果的平均值avgResult_20iter, 和20次分类结果的OA值，OA_20iter
												[avgResult_20iter, OA_20iter] = fcn1(n, N, setsNum, mappedA, lbs, rate, type, var);                                     
												acc_avg{iLayer} = [acc_avg{iLayer}, avgResult_20iter];
												OA_detail{iLayer} = [OA_detail{iLayer}, OA_20iter]; 
												OA_avg{iLayer} = [OA_avg{iLayer}, mean(OA_20iter)];
											end

											if OA_avg{iLayer}(end-1) >= OA_avg{iLayer}(end)
												b = ceil(x_2);
											else
												a = floor(x_1);
											end
											gold_point{iLayer} = [gold_point{iLayer}, x];

										case 1 % 若x中第二个数与gold_point中的点重复，则只计算第一个，保存第一个
											% Lia=[0,1]，
											% 表示x中第二个值与gold_point{iLayer}中的某个值重复，假设此时Locb=[0 0 1 0 0]
											% 则说明重复在gold_point{iLayer}中的第三个数，这个数在gold_point{iLayer}中只有一个
											% 其最小索引为1.
											% 若x中第二个数与gold_point中的点重复，则只计算第一个，保存第一个

											%记录两个黄金分割点作为第LayerNum隐含层节点数时的分类准确率中的OA值20次平均准确率
											var(str_idx+1) = string(x(1));
											% 输入参数 (n, N, setsNum, mappedA, lbs, rate, type, var)
											% 输出2个列向量，20次分类结果的平均值avgResult_20iter, 和20次分类结果的OA值，OA_20iter
											[avgResult_20iter, OA_20iter] = fcn1(n, N, setsNum, mappedA, lbs, rate, type, var);                                     
											acc_avg{iLayer} = [acc_avg{iLayer}, avgResult_20iter];
											OA_detail{iLayer} = [OA_detail{iLayer}, OA_20iter]; 

											if mean(OA_20iter) >= OA_avg{iLayer}(nonzeros(Locb))
												b = ceil(x_2);
											else
												a = floor(x_1);
											end
											OA_avg{iLayer} = [OA_avg{iLayer}, mean(OA_20iter)];
											gold_point{iLayer} = [gold_point{iLayer}, x(1)];

										case 2 % 若x中第一个数与gold_point中的点重复，则只计算第二个，保存第二个
											% Lia=[1,0],
											% 表示x中第一个值与gold_point{iLayer}中的某个值重复，假设此时Locb=[0 0 1 0 0]
											% 则说明重复在gold_point{iLayer}中的第三个数，这个数在gold_point{iLayer}中只有一个
											% 其最小索引为1.                                    
											% 若x中第一个数与gold_point中的点重复，则只计算第二个，保存第二个	

											var(str_idx+1) = string(x(2));
											% 输入参数 (n, N, setsNum, mappedA, lbs, rate, type, var)
											% 输出2个列向量，20次分类结果的平均值avgResult_20iter, 和20次分类结果的OA值，OA_20iter
											[avgResult_20iter, OA_20iter] = fcn1(n, N, setsNum, mappedA, lbs, rate, type, var);                                     
											acc_avg{iLayer} = [acc_avg{iLayer}, avgResult_20iter];
											OA_detail{iLayer} = [OA_detail{iLayer}, OA_20iter];                                   

											if OA_avg{iLayer}(nonzeros(Locb)) >= mean(OA_20iter)%第2个点的准确率与acc_avg(Locb)做比较
												b = ceil(x_2);
											else
												a = floor(x_1);
											end
											OA_avg{iLayer} = [OA_avg{iLayer}, mean(OA_20iter)];
											gold_point{iLayer} = [gold_point{iLayer}, x(2)];
										otherwise
										% 若x中两个数字都和gold_point重复，则结束switch
									end

									% 当round(x_1) == round(x_2)时，以round(x_1)为隐含层节点数建立网络
									% 计算完成后再停止while()循环
									if round(x_1) == round(x_2)
										flag = 0;
									end
								end
								%# 保存第iLayer隐含层的最佳节点数
								Nh = [Nh, x(1)];
								%# 将startNum和stopNum作为第LayerNum隐含层节点数的计算结果也添加进acc_avg和OA_detail中来
								% 这样第LayerNum隐含层节点数（即网络宽度）与分类准确率的关系将更加完整
								if paraTable_c.startNum==1 %若startNum==1，则令startNum=2，作为第LayerNum隐含层节点数进行计算
									startNum = 2;
								else
									startNum = paraTable_c.startNum;
								end
								stopNum = paraTable_c.stopNum;
								x = [startNum, stopNum];
								for i = 1 : 2
									%# 更新var中的第LayerNum个隐含层的节点数为x(i), hiddenNumLayerNum
									%TF = contains(str,pattern)
									var(str_idx+1) = string(x(i));
									% 输入参数 (n, N, setsNum, mappedA, lbs, rate, type, var)
									% 输出2个列向量，20次分类结果的平均值avgResult_20iter, 和20次分类结果的OA值，OA_20iter
									[avgResult_20iter, OA_20iter] = fcn1(n, N, setsNum, mappedA, lbs, rate, type, var);                                     
									acc_avg{iLayer} = [acc_avg{iLayer}, avgResult_20iter];
									OA_detail{iLayer} = [OA_detail{iLayer}, OA_20iter];
								end
								OA_avg{iLayer} = [OA_avg{iLayer}, mean(OA_20iter)];
								gold_point{iLayer} = [gold_point{iLayer}, x];
								%# 保存第LayerNum隐含层节点数取黄金分割点时的分类结果
								% gold_point{iLayer}，acc_avg{iLayer}, OA_detail{iLayer}, OA_avg{iLayer}
								% 或者等所有hiddenLayerNum个隐含层节点数全部优化完之后再保存
								d = time_goldSection(end);
								time_goldSection(iLayer) = toc(timerVal_1) - time_1 - d;                                
							end
							% 黄金分割法寻优结束。

							% 将找到的各个隐层节点数的最优值赋值给paraTable_c中的相应变量(这里只考虑单隐层的情况)
							if paraTable_c.hiddenLayerNum==1
								paraTable_c.hiddenNum=Nh(1);
								for i = 1:paraTable_c.hiddenLayerNum-1
									estr = ['paraTable_c.hiddenNum', num2str(i), '=Nh(',num2str(i+1),');' ];
									eval(estr);
								end
							end
							% 黄金分割法寻优结果保存完毕
						case '否'
					end
				end

                t = table2cell(paraTable_c);
                
                k = numel(t); 
                para = cell(1,2*k);
                for i = 1:k
                    para{2*i-1} = paraTable_c.Properties.VariableNames{i};
                    para{2*i} = t{i};
                end
                var = cellfun(@string, para(9:end)); %对cell array中的所有cell应用string
        
                for k = 1 : n
                    [mA1,mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate); % rate: 所使用的训练集占比
                    XTrain = table2array(mA1(:, 1:end-1))';           %mappedA和mA都是每一行为一个样本，而XTrain是每一列为一个样本，
                    TTrain = ind2vec(double(mA1.Class)');
                    %%警告使用稀疏矩阵形式的输入数据训练网络将会导致内存占用太大！所以还是换成下面的向量形式的TTrain？
                    % TTrain = double(mA1.Class)';
                    XTest = table2array(mA2(:, 1:end-1))';             %XTest每一列为一个样本                
                    TTest = ind2vec(double(mA2.Class)');            %TTest每一列为一个类别标签
                    disp(['第',num2str(k),'次计算']);
                    [netTrained, trainRecord, predictedVector, misclassRate, cmt] = classDemo(XTrain, TTrain, XTest, TTest, type, var);%前3个为必需参数，后面为可选参数
                    %这个函数能给出的有价值的计算结果是： net tr tTest c cm 
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
                % load('工程测试\20220517\cmNormalizedValues1.mat','cmt'); %用于测试
                % [size1, size2, size3, size4] = size(cmt);   % huston.mat数据集的混淆矩阵尺寸：15×15×20×2

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
                    path = fullfile(path, hmenu4_1.UserData.datasetName, [hmenu4_1.UserData.drAlgorithm,'null'], hmenu4_1.UserData.cAlgorithm);
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
                info_1 = hmenu4_1.UserData;
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
                %# 保存time_goldSection
                if exist('time_goldSection','var')==1
                    VariableNames = ["iLayer_"+string(1:paraTable_c.hiddenLayerNum)];
                    RowNames = "colapsedTime";
                    timeTable = array2table(time_goldSection, 'VariableNames', VariableNames);
                    timeTable.Properties.RowNames = RowNames;
                    writetable(timeTable,filename,'Sheet',iset+1,'Range','A27', 'WriteRowNames',true, 'WriteVariableNames', true);
                end
                %% 保存训练过程中的性能数据err_perf, err_vperf, err_tperf, racc到Excel中Sheet
                T1 = createTableForWrite(err_perf, err_vperf, err_tperf, racc);
                errTable = [T1.Variables; mean(T1.Variables); std(T1.Variables)];  % T1.Variables 是20×8 double
                errTable = array2table(errTable, 'VariableNames', T1.Properties.VariableNames);
                errTable.Properties.RowNames = [T1.Properties.RowNames; {'average'}; {'std'}]; %新增2行的行名称
                filename = "C:\Matlab练习\Project20191002\工程测试\2022-06-04 19-45-16\Botswana\LDA\GA_TANSIG\Botswana_LDA_GA_TANSIG.xlsx";
                errTable.Properties.Description = '保存训练过程中的性能数据err_perf, err_vperf, err_tperf, racc';
                writetable(errTable,filename,'Sheet',iset+2,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);  

                %% 保存神经网络隐含层节点数的优化结果
                % 将寻找到的最优网络net与gold_point, acc_avg, OA_detail，寻优信息hiddenNumInfo一起保存为mat数据。
                % 之所以放到这里是因为有两个原因
                % 1. 如果直接在前面【神经网络隐含层节点数寻优】代码块中生成带时间的文件夹名的话，时间会过于早于Excel的写入时间。
                % 2. 神经网络隐含层节点数寻优的结果与数据集、降维算法、分类算法都有关系，这里的path包含了上述的几个关键信息，
                %     所以直接用这里的path作为[保存神经网络隐含层节点数的优化结果]是更合理的。
                if paraTable_c.hiddenNumOptimization && strcmp(answer_hiddenNumOptimization, '是')
                    gold_point_sorted = cell(1,paraTable_c.hiddenLayerNum);
                    acc_avg_sorted = cell(1,paraTable_c.hiddenLayerNum);
                    OA_detail_sorted = cell(1,paraTable_c.hiddenLayerNum);
                    %## 每一隐含层的计算结果保存到一个sheet中
                    for iLayer = 1:paraTable_c.hiddenLayerNum
                        %# 对第iLayer隐含层的分类准确率gold_point{iLayer}, acc_avg{iLayer}, OA_detail{iLayer}在列维度上调整顺序
                        % 利用sort()函数对gold_point{iLayer}中的数按从小到大排序，结果保存到gold_point_sorted{iLayer}中，
                        % 同时还得到了排序索引I
                        % 继而利用排序索引I, 在列维度上对acc_avg{iLayer},OA_detail{iLayer}排序
                        % 结果保存到acc_avg_sorted{iLayer}，OA_detail_sorted{iLayer}

                        [B, I] = sort(gold_point{iLayer});
                        gold_point_sorted{iLayer} = B;
                        acc_avg_sorted{iLayer} = acc_avg{iLayer}(:, I);
                        OA_detail_sorted{iLayer} = OA_detail{iLayer}(:, I);
                        %# 将排序之后的第iLayer隐含层的分类准确率整理成table格式
                        [size_1, size_2] = size(acc_avg{iLayer});
                        accData = [gold_point{iLayer}; gold_point_sorted{iLayer}; acc_avg_sorted{iLayer};...
                            OA_detail_sorted{iLayer}; mean(OA_detail_sorted{iLayer}); std(OA_detail_sorted{iLayer})];
                        % 为cell的每一列创建列名称 VariableNames
                        VariableNames = cell(1,size_2);
                        for i = 1:size_2
                            VariableNames{i}= ['goldPoint_',num2str(i)];
                        end
                        %# 创建行的名称 RowNames，必须是字符元胞数组 即1×(2+size_1+size_3+2) cell；
                        [size_3, size_4] = size(OA_detail{iLayer});
                        RowNames = cell(1, 2+size_1+size_3+2); 
                        RowNames{1} = ['goldPoint{iLayer=',num2str(iLayer),'}'];
                        RowNames{2} = 'goldPoint_sorted';
                        for i = 1+2 : size_1-3+2              % acc_avg最后3行分别是OA、AA、kappa
                            RowNames{i} = ['class_',num2str(i-2)];
                        end
                        RowNames(i+1 : i+3) = {'OA', 'AA', 'Kappa'};
                        i = i+3;
                        RowNames(i+1: i+size_3) = cellstr("iter_"+string(1:size_3));
                        i = i+size_3;
                        RowNames(i+1 : i+2)  = {'average', 'std'};
                        % path，filename都已经有了
                        accTable = array2table(accData, 'VariableNames', VariableNames);
                        accTable.Properties.RowNames = RowNames;
                        % Sheet 1保存优化之前的分类结果，Sheet 2保存优化之后的分类结果。
                        % Sheet 3保存执行分类任务的网络相关信息，Sheet 4保存训练性能信息。
                        % Sheet iLayer+4可以保存第iLayer隐含层的分类准确率信息，
                        writetable(accTable,filename,'Sheet',iLayer + iset+2,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);                

                    end
                end

                %% 保存各种图像结果                
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
                % f.Children
                % ans = 
                % 3×1 graphics 数组:
                % UIControl
                % Legend       (Class 1, Class 2, Class 3, Class 4, Class 5, Class 6, Clas…)
                % Axes         (ROC)       filename_2 = fullfile(path,"net_best{2,2}_"+"originROC");%拼接路径
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
                %Ylbs表示预测的lbs，为一个列向量
                % 不能通过将Ylbs通过reshape()的方式重排为二维矩阵，因为Ylbs仅仅是样本集中点的类别编号，
                % 而非整张图片上的所有像素点的类别编号
                % 正确的做法是：将全部样本数据输入netBest，获取Ylbs（列向量），
                % 再将列向量Ylbs嵌入二维矩阵gtdata，获取新的二维矩阵Ygtdata

                gtdata = handles.UserData.gtdata;
                gtdata(gtdata~=0)=Ylbs;    %将标签向量排列成GT图
                Ygtdata = gtdata; %Ygtdata表示预测的gtdata
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
                % saveas(gcf, filename_2);        % 保存为fig
                % saveas(gcf, filename_2,'jpg'); %保存为jpg

                %% 绘制性能曲线       
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
                delete(MyPar) %计算完成后关闭并行处理池
                
                %% 网络隐含层层数的优化 询问是否要执行隐含层层数（即网络深度）优化
                [mA1, mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate);  % rate: 所使用的训练集占比
                XTrain = table2array(mA1(:, 1:end-1))';  %mappedA和mA都是每一行为一个样本，而XTrain是每一列为一个样本，
				if paraTable_c.hLayerNumOptimization
                    % 询问是否要进行神经网络隐含层层数的最优值搜索
                    quest = {'\fontsize{10} 是否要执行网络隐含层层数优化来寻找隐含层层数的最优值？'};
                             % \fontsize{10}：字体大小修饰符，作用是使其后面的字符大小都为10磅；
                    dlgtitle = '网络隐含层层数（即网络深度）优化';
                    btn1 = '是';
                    btn2 = '否';
                    opts.Default = btn2;
                    opts.Interpreter = 'tex';
                    % answer = questdlg(quest,dlgtitle,btn1,btn2,defbtn);
                    answer_hLayerNumOptimization = questdlg(quest, dlgtitle, btn1, btn2, opts);

                    % Handle response
					switch answer_hLayerNumOptimization
						case '是'
							% %## 首先确定隐含层神经元数量，可以采用公式来计算，也可以手动指定
							% time_1 = toc(timerVal_1);
							% [Ni, Ns] = size(XTrain); % XTrain每一列为一个样本，则行数为降维数，即输入层节点数。列数为训练集样本数
							% % 输入向量的维数等于输入层的节点数。
							% N = hmenu4_1.UserData.M-1;     % 类别总数
							% No = N; %输出层节点数记为No
							% % Botswana, round(3248*0.2)=650,No=14, 650./(a*(10+14))=[13.5417 2.7083]

							% a = [2, 10]; % 系数a通常取2~10
							% % 隐含层节点数计算公式 Nh = Ns/(a*(Ni+No));  %隐含层节点数记为Nh
							% Nhd = Ns./(a*(Ni+No));
							% % 当Ni=5;No=14;Ns=650时，Nhd=[17.1, 3.4];
							% % Ni=10时，No=14;Ns=650时，Nhd=[13.6, 2.7];
							% % 则隐含层的神经元取值下界值可定为floor(Nh(2))=3，
							% % 上界值可定为ceil(Nh(1)/floor(Nh(2)))*floor(Nh(2))，循环次数为ceil(Nh(1)/floor(Nh(2)))
							% iteration = ceil(Nhd(1)/floor(Nhd(2)));
							% Nhd_min = floor(Nhd(2));
							% Nhd_max = ceil(Nhd(1)/floor(Nhd(2)))*floor(Nhd(2));

							% %# 初始化分类结果保存变量
							% % 对于隐含层节点数为Nhd = [18,3]这个例子中，一个固定的隐含层节点数在1~5层隐含层的情况下进行遍历，则可以得到5列分类结果
							% % 则总共6个隐含层节点数，可以得到5×6=30列分类结果
							% % 如果每个sheet只保存一个固定的隐含层节点数在1~5层隐含层的情况下进行遍历的5列结果的话，则需要保存至少6个sheet
							% % 这样还是太浪费了，所以将30列分类结果保存到同一个sheet中
							% % 第二个sheet保存OA_20iter，与第一个sheet中的列一一对应。
							% % errTable先不保存了，一个固定的隐含层节点数在隐含层的层数固定的情况下，就可以获得n=20个err_perf数据
							% % 则6个隐含层节点数在5个隐含层层数下，将有20×5×6=600个数据，太多了不好保存
							% % 隐含层层数总是从1层到stopLayerNum+1层

							%## 手动指定要遍历的隐含层节点数
							hiddenNum = [150]; %, 120, 125, 130, 135, 140, 145, 150];
							% hiddenNum = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
							% hiddenNum = [55, 60, 65, 70, 75, 80, 85, 90, 95, 100];
							if ~exist('Nhd_min', 'var')
								if exist('hiddenNum', 'var')
									if hiddenNum(:)~=0
										Nhd_min=min(hiddenNum);
									else
										disp(['Nhd_min不存在，且min(hiddenNum)为0，无法赋值给Nhd_min']);
									end
								else
									disp(['Nhd_min不存在，且hiddenNum不存在，无法赋值给Nhd_min']);
								end
							end
							if ~exist('Nhd_max', 'var')
								if exist('hiddenNum', 'var')
									if hiddenNum(:)~=0
										Nhd_max=max(hiddenNum);
									else
										disp(['hiddenNum中有部分元素值为0，无法赋值给Nhd_min']);
									end
								else
									disp(['Nhd_max不存在，且hiddenNum不存在，无法赋值给Nhd_max']);
								end
							end                   
							iteration = numel(hiddenNum);
							stopNum = paraTable_c.stopLayerNum+1;
							iColomn = stopNum*iteration;
							%iColomn = 5*iteration;
							acc_avg = zeros(N+3, iColomn);
							if ismember(type, {'GA_TANSIG','GA_RBF','PSO_TANSIG','PSO_RBF'})
								err_avg = zeros(8, iColomn);
							elseif ismember(type, {'TANSIG','RBF'})
								err_avg = zeros(4, iColomn);
							end
							% acc表示包含各类别分类准确率、OA、AA、Kappa在内的完整分类准确率数据，
							% acc_avg表示20次重复计算得到的完整分类准确率的平均值
							OA_detail = zeros(n, iColomn); %记录在黄金分割点上重复计算20次获得的20个OA值
							OA_avg = zeros(1, iColomn); % 记录mean(OA_detail)
							time_Layer = zeros(1, iColomn); %记录每一个节点数在不同层数时所消耗的时间
							%# 对照在ParametersForDimReduceClassify中设定的上下界进行修正
							% 只要计算出的下界值大于等于设定的下界值，且计算出的上界值小于等于设定的上界值。就算满足要求
							%if floor(Nhd(2))<=paraTable_c.startLayerNum && ceil(Nhd(1)/floor(Nhd(2)))*floor(Nhd(2))<=paraTable_c.stopLayerNum
							%    disp('开始进行隐含层层数优化');
							%elseif floor(Nhd(2))>paraTable_c.startLayerNum                        
							%    paraTable_c.startLayerNum;
							%    paraTable_c.stopLayerNum;
							%end

							% 以hiddenLayerNum和stopLayerNum来决定寻优层数
							% 即隐含层层数总是从1层到stopLayerNum+1层
							% hiddenNum = zeros(1,iteration);
							time_start = toc(timerVal_1);
							for i = 1: iteration
								% 隐含层节点数为Nhd_min*i;
								%hiddenNum(i) = Nhd_min*i + 14;
								% 更新输入变量paraTable_c
								for iLayer = 1:stopNum
									paraTable_c.hiddenLayerNum = iLayer;
									paraTable_c.hiddenNum = hiddenNum(i);
									if iLayer>1
										for j = 1:iLayer-1
											estr = ['paraTable_c.hiddenNum',num2str(j),' = ', num2str(hiddenNum(i)),';'];
											eval(estr);
										end
									end
									t = table2cell(paraTable_c);   
									% t =
									%   1×28 cell 数组
									%     {[1]}    {[0.2000]}    {[3]}    {[20]}    {["trainscg"]}    {[20]}    {["tansig"]}    {[0]}    {[0]}
									%     {[0]}    {[0]}    {[0]}    {[0]}    {[2]}    {[20]}    {["tansig"]}    {[20]}    {["tansig"]}    {[20]}
									%     {["tansig"]}    {[20]}    {["tansig"]}    {[1]}    {[1]}    {[100]}  {[1]}    {[1]}    {[4]}
									k = numel(t);                        % 28
									para = cell(1,2*k);                 % 1×56 cell 数组
									for iPara = 1:k
										para{2*iPara-1} = paraTable_c.Properties.VariableNames{iPara};
										para{2*iPara} = t{iPara};            
									end
									% para =
									%   1×56 cell 数组
									%   列 1 至 8
									%     {'dimReduce'}    {[1]}    {'rate'}    {[0.2000]}    {'app'}    {[3]}    {'executionTimes'}    {[20]}    
									%   列 9 至 50
									%     {'trainFcn'}  {["trainscg"]}    {'hiddenNum'}    {[20]}    {'transferFcn'}    {["tansig"]}    {'showWindow'}    {[0]}
									%     {'plotperform'}    {[0]}    {'plottrainstate'}    {[0]}    {'ploterrhist'}    {[0]}    {'plotconfusion'}    {[0]}
									%     {'plotroc'}    {[0]}    {'hiddenLayerNum'}    {[2]}    {'hiddenNum1'}    {[20]}    {'transferFcn1'}    {["tansig"]}
									%     {'hiddenNum2'}    {[20]}    {'transferFcn2'}    {["tansig"]}    {'hiddenNum3'}    {[20]}    {'transferFcn3'}
									%     {["tansig"]}    {'hiddenNum4'}    {[20]}    {'transferFcn4'}    {["tansig"]}    
									%     {'hiddenNumOptimi…'}    {[1]}    {'startNum'}    {[1]}    {'stopNum'}    {[100]} 
									%     {'hLayerNumOptimi…'}    {[1]}    {'startLayerNum'}    {[1]}    {'stopLayerNum'}    {[4]} 
									var = cellfun(@string, para(9:end)); %对cell array中的每一个cell应用string
									% var = 
									%   1×48 string 数组
									%     "trainFcn"    "trainscg"    "hiddenNum"    "20"    "transferFcn"    "tansig"    "showWindow"    "false"
									%     "plotperform"    "false"    "plottrainstate"    "false"    "ploterrhist"    "false"    "plotconfusion"    "false"
									%     "plotroc"    "false"    "hiddenLayerNum"    "2"    "hiddenNum1"    "20"    "transferFcn1"    "tansig"    "hiddenNum2"
									%     "20"    "transferFcn2"    "tansig"    "hiddenNum3"    "20"    "transferFcn3"    "tansig"    "hiddenNum4"    "20"
									%     "transferFcn4"    "tansig"    "hiddenNumOptimiza…"    "true"    "startNum"    "1"    "stopNum"    "100"
									%     "hLayerNumOptimiza…"    "true"    "startLayerNum"    "1"    "stopLayerNum"    "4"    

									% 输出2个列向量，20次分类结果的平均值avgResult_20iter, 和20次分类结果的OA值，OA_20iter
									[avgResult_20iter, OA_20iter, avgError_20iter] = fcn2(n, N, setsNum, mappedA, lbs, rate, type, var);
									acc_avg(:, (i-1)*stopNum+iLayer) = avgResult_20iter;
									OA_detail(:, (i-1)*stopNum+iLayer) = OA_20iter;    
									OA_avg(:, (i-1)*stopNum+iLayer) = mean(OA_20iter);
									err_avg(:, (i-1)*stopNum+iLayer) = avgError_20iter;
									time_Layer((i-1)*stopNum+iLayer) = toc(timerVal_1) - time_start;
								end
							end
							timeLayer = zeros(1, numel(time_Layer));
							for i = 2:numel(time_Layer)
								timeLayer(i) = time_Layer(i)-time_Layer(i-1);
							end
							timeLayer(1) = time_Layer(1);

							%## 保存隐含层层数寻优结果
							%# 为cell的每一列创建列名称 VariableNames
							% hNum1hLayer1~hNum1hLayer5, hNum2hLayer1~hNum2hLayer5, ……，hNum6hLayer1~hNum6hLayer5
							VariableNames = cell(1, iColomn);
							for i = 1:iteration
								for iLayer = 1:stopNum
									VariableNames{(i-1)*stopNum+iLayer}= ['hNum=',num2str(hiddenNum(i)),' hLayer=',num2str(iLayer)];
								end
							end
							%# 创建行的名称 RowNames1，必须是字符元胞数组或者字符串数组；
							[size_1, size_2] = size([acc_avg; timeLayer]);
							RowNames1(1:size_1-4) = "class_"+string(1:(size_1-4)); 
							RowNames1(size_1-3) = "OA";
							RowNames1(size_1-2) = "AA";
							RowNames1(size_1-1) = "Kappa";
							RowNames1(size_1) = "time_Layer"; % 每一层计算所消耗的时间
							%# 创建行的名称 RowNames2，必须是字符元胞数组或者字符串数组； 
							[size_3, size_4] = size(OA_detail);
							RowNames2 = "iter_"+string(1:size_3); 
							RowNames2(size_3+1) = "average";
							RowNames2(size_3+2) = "std";

							%# 生成Excel文件保存地址
							% 生成文件夹名称
							path = ['C:\Matlab练习\Project20191002\工程测试\', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS')];
							try
								path = fullfile(path, hmenu4_1.UserData.datasetName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
							catch
							end
							% 如果生成的文件夹名称不存在，则先创建文件夹
							if ~exist(path, 'dir')
								[status,msg,msgID] = mkdir(path);
							end
							% path已经有了，filename重新生成
							filename = [hmenu4_1.UserData.datasetName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'_hLayerOptimization','.xlsx'];
							filename = fullfile(path, filename);
							accTable = array2table([acc_avg; timeLayer], 'VariableNames', VariableNames);
							accTable.Properties.RowNames = RowNames1;
							% Sheet 1保存优化30列（6个隐含层节点与5个隐含层）分类结果acc_avg。
							% 每一列都是20次重复计算的分类准确率的平均值，包括各类别的分类准确率，以及OA, AA, Kappa
							writetable(accTable,filename,'Sheet',1,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);
							% Sheet 2保存优化30列（6个隐含层节点与5个隐含层）分类结果OA_detail。   
							% 每一列是20次重复计算获得的20个OA值
							OATable = array2table([OA_detail; OA_avg; std(OA_detail)], 'VariableNames', VariableNames);
							OATable.Properties.RowNames = RowNames2;
							writetable(OATable,filename,'Sheet',2,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);  

							%# 网络信息保存
							%% 保存有关分类结果及网络配置的详细信息到附加Sheet中
							% 保存降维及分类参数设置paraTable_c到Sheet 3中，
							% 主要是startNum和stopNum, startLayerNum 和stopLayerNum
							paraTable_c.startNum = Nhd_min;
							paraTable_c.stopNum = Nhd_max;
							writetable(paraTable_c, filename, 'Sheet',3,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);

							%# 保存数据集信息hmenu4_1.UserData到Sheet(iset+1)
							info_1 = hmenu4_1.UserData;
							info_1.x3 = [];
							info_1.lbs2 = [];
							info_1.x2 = [];
							info_1.lbs = [];
							info_1.cmap = [];
							info_1.Nhd_min = Nhd_min;
							info_1.Nhd_max = Nhd_max;
							% info_1.elapsedTimec = toc(timerVal_1)-time1; % 保存分类消耗时间
							info_1 = struct2table(info_1, 'AsArray',true);
							writetable(info_1, filename, 'Sheet',3,'Range','A3', 'WriteRowNames',true, 'WriteVariableNames', true);
							%# 单独处理cmap
							info_cmap = hmenu4_1.UserData.cmap;
							variableNames = ["R","G","B"]; %VariableNames属性为字符向量元胞数组{'R','G','B'}。
							% 如需指定多个变量名称，请在字符串数组["R","G","B"]或字符向量元胞数组{'R','G','B'}中指定这些名称。
							% 创建行的名称 RowNames3，格式为字符串数组["1","2","3"]或字符向量元胞数组{'1','2','3'}；
							RowNames3 = string(1:size(info_cmap,1)); % ；
							info_cmap = array2table(info_cmap, 'VariableNames', variableNames);
							info_cmap.Properties.RowNames = RowNames3;
							writetable(info_cmap,filename,'Sheet',3,'Range','A5', 'WriteRowNames',true, 'WriteVariableNames', true);

							%# 创建行的名称 RowNames4，必须是字符元胞数组或者字符串数组；
							[size_5, size_6] = size(err_avg);
							if size_5==8
								RowNames4 = {'err_perf1','err_perf2','err_vperf1','err_vperf2','err_tperf1','err_tperf2','racc1','racc2'};
							elseif size_5==4
								RowNames4 = {'err_perf','err_vperf','err_tperf','racc'};
							end
							errTable = array2table(err_avg, 'VariableNames', VariableNames);
							errTable.Properties.RowNames = RowNames4;
							% Sheet 3保存优化30列（6个隐含层节点与5个隐含层）训练性能数据err_avg。
							% 每一列都是20次重复计算的训练性能数据的平均值，包括各类别的分类准确率，以及OA, AA, Kappa
							writetable(errTable,filename,'Sheet',4,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);            
							%# 隐含层层数寻优结果保存完毕 
						case '否'
					end
				end
            case 'exit'
                disp('ClassDemo已经退出.')
                %dessert = 0;
		end    
       
    end
    %     path = ['C:\Matlab练习\Project20191002\工程测试\', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS')];
    %     saveAllFigure(path,handles,'.fig');
    %     gc = gcf; 
    %     closeFigure([2:gc.Number]);
    %     closeFigure([2:13]);
end

%% 子函数（用于黄金分割法寻优隐含层最佳节点数）
function [avgResult_20iter, OA_20iter] = fcn1(n, N, setsNum, mappedA, lbs, rate, type, var)

	%# n,N,sets这三个参数主要用于保存分类结果的各个变量的初始化
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
	acc = zeros(n, setsNum);
	% acc(k,1)保存第k次迭代计算优化前的准确率；acc(k,2)保存第k次迭代计算优化后的准确率；
			
	racc = zeros(n, setsNum);        % 即混淆矩阵返回值中的第一个值c，误分率，等于1-acc
	err_perf = zeros(n, setsNum);   % （即trainRecord.best_perf）
	err_vperf = zeros(n, setsNum); %（即trainRecord.best_vperf）
	err_tperf = zeros(n, setsNum); %（即trainRecord.best_tperf） 
	
    for k = 1:n
    % 划分数据
		[mA1, mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate);  % rate: 所使用的训练集占比
		XTrain = table2array(mA1(:, 1:end-1))';   %mappedA和mA都是每一行为一个样本，而XTrain是每一列为一个样本，
		TTrain = ind2vec(double(mA1.Class)');
		%%有时候会出现警告使用稀疏矩阵形式的输入数据训练网络将会导致内存占用太大！所以还是换成下面的向量形式的TTrain?
		% 这样的话最后使用网络net(XTest)获得的outputs也是一个向量形式，这个向量不符合confusion(targets,outputs)
		% 对多分类输入数据的形式要求，所以不能直接输入到confusion(targets,outputs)。
		% confusion()要求多分类的targets必须是S×Q的矩阵形式，且每一列必须是one-hot-vector，outputs也必须是S×Q的矩阵形式
		% outputs的元素值大小位于[0,1]之间，且每一列的最大值对应其所属的S类中的一个。
		% 而且，当对outputs向量进行转换成系数矩阵时会报错。
		% 所以不得不继续使用稀疏矩阵形式的TTrain来作为训练网络的输入数据。
		% 至少在未开并行计算的情况下是没有出现过警告的。
		XTest = table2array(mA2(:, 1:end-1))';     %XTest每一列为一个样本
		TTest = ind2vec(double(mA2.Class)');     %TTest每一列为一个类别标签                            
		disp(['第',num2str(k),'次计算']);
		[netTrained, trainRecord, predictedVector, misclassRate, cmt] = classDemo(XTrain, TTrain, XTest, TTest, type, var);%前3个为必需参数，后面为可选参数
		%这个函数能给出的有价值的计算结果是： [net tr tTest c cm],     
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

	%% 计算分类结果（根据混淆矩阵cmNormalizedValues1，计算OA, AA, Kappa）
	[size1, size2, size3, size4] = size(cmNormalizedValues1);  % 16×16×20×2 double
	cmt = cmNormalizedValues1;
	% load('工程测试\20220517\cmNormalizedValues1.mat','cmt'); %用于测试
	% [size1, size2, size3, size4] = size(cmt);   % huston.mat数据集的混淆矩阵尺寸：15×15×20×2
	
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
    
    % 返回结果，优化后的c中的average一列，以及OA
	avgResult_20iter = c(:,size3+1,end);   % 返回c中的average一列
	OA_20iter = c(size2+1,1:n,end)'; % 返回c中的OA一行
end

%% 子函数（用于在固定隐含层节点数的情况下计算不同层数的分类准确率）
function [avgResult_20iter, OA_20iter, avgError_20iter] = fcn2(n, N, setsNum, mappedA, lbs, rate, type, var)

	% %# n,N,sets这三个参数主要用于保存分类结果的各个变量的初始化
	% acc_best = zeros(setsNum, setsNum); % 记录n次迭代下的最高准确率OA的值
	% % acc_best(1,1)保存优化前的最高acc值; acc_best(2, 2)保存优化后的最高acc值
	% % acc_best(1,2)保存优化前的最高acc值对应的网络在优化后的准确率值
	% % acc_best(2,1)保存优化后的最高acc值对应的网络在优化前的准确率值
	% net_best = cell(setsNum, setsNum); % 记录最高准确率下训练好的网络（用于绘制GT图）
	% % net_best{1,1}保存优化前具有最高acc值的网络; net_best{2, 2}保存优化后具有最高acc值的网络
	% % net_best{1,2}保存优化前具有最高acc值的网络在优化后的网络
	% % net_best{2,1}保存优化后具有最高acc值的网络在优化前的网络

	% tTest_best = cell(1, setsNum);
	% tTest_best也可以初始化为cell(setsNum, setsNum)，考虑到会极大消耗存储空间，
	% 于是将其初始化为cell(1, setsNum)。
	% tTest_best{1,1}保存优化前具有最高acc值的网络预测向量结果; 
	% tTest_best{1,2}保存优化后具有最高acc值的网络预测向量结果；
	cmNormalizedValues1 = zeros(N, N, n, setsNum); %保存正常顺序的混淆矩阵
	% cmNormalizedValues1(:, :, k, 1)保存第k次迭代计算优化前的网络性能的混淆矩阵;
	% cmNormalizedValues1(:, :, k, 2)保存第k次迭代计算优化后的网络性能的混淆矩阵;
	acc = zeros(n, setsNum);
	% acc(k,1)保存第k次迭代计算优化前的准确率；acc(k,2)保存第k次迭代计算优化后的准确率；
			
	racc = zeros(n, setsNum);        % 即混淆矩阵返回值中的第一个值c，误分率，等于1-acc
	err_perf = zeros(n, setsNum);   % （即trainRecord.best_perf）
	err_vperf = zeros(n, setsNum); %（即trainRecord.best_vperf）
	err_tperf = zeros(n, setsNum); %（即trainRecord.best_tperf） 
	
    for k = 1:n
    % 划分数据
		[mA1, mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate);  % rate: 所使用的训练集占比
		XTrain = table2array(mA1(:, 1:end-1))';   %mappedA和mA都是每一行为一个样本，而XTrain是每一列为一个样本，
		TTrain = ind2vec(double(mA1.Class)');
		%%有时候会出现警告使用稀疏矩阵形式的输入数据训练网络将会导致内存占用太大！所以还是换成下面的向量形式的TTrain?
		% 这样的话最后使用网络net(XTest)获得的outputs也是一个向量形式，这个向量不符合confusion(targets,outputs)
		% 对多分类输入数据的形式要求，所以不能直接输入到confusion(targets,outputs)。
		% confusion()要求多分类的targets必须是S×Q的矩阵形式，且每一列必须是one-hot-vector，outputs也必须是S×Q的矩阵形式
		% outputs的元素值大小位于[0,1]之间，且每一列的最大值对应其所属的S类中的一个。
		% 而且，当对outputs向量进行转换成系数矩阵时会报错。
		% 所以不得不继续使用稀疏矩阵形式的TTrain来作为训练网络的输入数据。
		% 至少在未开并行计算的情况下是没有出现过警告的。
		XTest = table2array(mA2(:, 1:end-1))';     %XTest每一列为一个样本
		TTest = ind2vec(double(mA2.Class)');     %TTest每一列为一个类别标签                            
		disp(['第',num2str(k),'次计算']);
		[netTrained, trainRecord, predictedVector, misclassRate, cmt] = classDemo(XTrain, TTrain, XTest, TTest, type, var);%前3个为必需参数，后面为可选参数
		%这个函数能给出的有价值的计算结果是： [net tr tTest c cm],     
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
            % if acc(k, iset) > acc_best(iset, iset)    
				% % acc_best(1,1)保存优化前的最高acc值; acc_best(2, 2)保存优化后的最高acc值
				% % acc_best(1,2)保存优化前的最高acc值对应的网络在优化后的准确率值
				% % acc_best(2,1)保存优化后的最高acc值对应的网络在优化前的准确率值
				% acc_best(iset, :)=acc(k, :);
				% net_best(iset, :)=netTrained;
				% tTest_best(1, iset)=predictedVector(iset);
				% % tTest_best{1,1}保存优化前具有最高acc值的网络的预测向量结果；
				% % tTest_best{1,2}保存优化后具有最高acc值的网络的预测向量结果。                  
            % end
        end
    end

	%% 计算分类结果（根据混淆矩阵cmNormalizedValues1，计算OA, AA, Kappa）
	[size1, size2, size3, size4] = size(cmNormalizedValues1);  % 16×16×20×2 double
	cmt = cmNormalizedValues1;
	% load('工程测试\20220517\cmNormalizedValues1.mat','cmt'); %用于测试
	% [size1, size2, size3, size4] = size(cmt);   % huston.mat数据集的混淆矩阵尺寸：15×15×20×2
	
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
    
    % 返回分类结果，优化后的c中的average一列，以及OA
	avgResult_20iter = c(:,size3+1,end);   % 返回c中的average一列
	OA_20iter = c(size2+1,1:n,end)'; % 返回c中的OA一行
	% 返回训练性能数据 T1
	T1 = createTableForWrite(err_perf, err_vperf, err_tperf, racc);
	avgError_20iter = mean(T1.Variables)';
	% errTable = [T1.Variables; mean(T1.Variables); std(T1.Variables)];  % T1.Variables 是20×8 double
	% errTable = array2table(errTable, 'VariableNames', T1.Properties.VariableNames);
	% errTable.Properties.RowNames = [T1.Properties.RowNames; {'average'}; {'std'}]; %新增2行的行名称	
	% errTable = T1;
	% 
end
