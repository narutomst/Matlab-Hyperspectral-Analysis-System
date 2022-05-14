% f_BP()函数属于自定义的函数
% 是基于BP反向传播算法的DNN模式识别网络
% 返回值应该有准确率，还应该有混淆矩阵的信息？是这样吗？
% 这个网络本身很简单，但是有两点需要注意：

% 1. 如果测试集误差最小值的迭代次数与验证集误差最小值的迭代次数有显著差异，
% 则说明数据XTrain在划分为3个子集时划分不当。
% 2. 若外部测试集(如XTest)误差与训练测试集(XTrain(:, tr.testInd))误差有显著差异，
% 则说明数据划分不当(即XTrain与XTest的划分有问题)。且可能有过拟合。

function [net, tr, tTest, c, cm] = f_RBF(XTrain, TTrain, XTest, TTest, Var)
%这个函数能给出的有价值的计算结果是： net tr tTest c cm 
hiddenSizes = [Var.hiddenNum, Var.hiddenNum1, Var.hiddenNum2, Var.hiddenNum3, Var.hiddenNum4];
hiddenSizes = hiddenSizes(1 : Var.hiddenLayerNum);
trainFcn = Var.trainFcn;
transferFcn = {Var.transferFcn, Var.transferFcn1, Var.transferFcn2, Var.transferFcn3, Var.transferFcn4};

%% 清空环境
% p.Results 
% ans =  
%   包含以下字段的 struct:
% 
%     hiddenLayerNum: '1'
%          hiddenNum: '20'
%         hiddenNum1: '20'
%         hiddenNum2: '20'
%         hiddenNum3: '20'
%         hiddenNum4: '20'
%      plotconfusion: 'true'
%        ploterrhist: 'true'
%        plotperform: 'true'
%            plotroc: 'true'
%     plottrainstate: 'true'
%         showWindow: 'true'
%           trainFcn: 'trainscg'
%        transferFcn: 'tansig'
%       transferFcn1: 'tansig'
%       transferFcn2: 'tansig'
%       transferFcn3: 'tansig'
%       transferFcn4: 'tansig'
%              TTest: [15×264499 double]
%             TTrain: [15×113357 double]
%               type: 'BP'
%              XTest: [10×264499 double]
%             XTrain: [10×113357 double]

warning off


% racc = [];
% best_perf = [];
% best_vperf = [];
% best_tperf = [];

% timerVal_1 = tic;
% disp('训练开始..................................');

    
    % 1. 构建网络
    net = patternnet(hiddenSizes,trainFcn);
 
    for j = 1 : Var.hiddenLayerNum
        net.layers{j}.transferFcn = transferFcn{j};
    end
%     nntransfer
%   Neural Network Toolbox Transfer Functions.
 
%     compet - Competitive transfer function.
%     elliotsig - Elliot sigmoid transfer function.
%     hardlim - Positive hard limit transfer function.
%     hardlims - Symmetric hard limit transfer function.
%     logsig - Logarithmic sigmoid transfer function.
%     netinv - Inverse transfer function.
%     poslin - Positive linear transfer function.
%     purelin - Linear transfer function.
%     radbas - Radial basis transfer function.
%     radbasn - Radial basis normalized transfer function.
%     satlin - Positive saturating linear transfer function.
%     satlins - Symmetric saturating linear transfer function.
%     softmax - Soft max transfer function.
%     tansig - Symmetric sigmoid transfer function.
%     tribas - Triangular basis transfer function.
    % 2. 设置性能参数 
	net.performParam.regularization = 0.1;           
	net.performParam.normalization = 'none';
	% 3. 设置训练参数
	net.trainParam.goal = 1e-6;      % 
	net.trainParam.show = 25;
	net.trainParam.epochs = 2000;
	net.trainParam.showWindow = str2num(Var.showWindow); %str2num('true')==1; str2num('false')==0
	% 4.训练网络
	[net, tr] = train(net,XTrain,TTrain); %, 'useParallel','yes','showResources','yes');
    %在这里开启并行计算，会导致出现警告：使用稀疏矩阵形式的输入数据训练网络将会导致内存占用太大！
    %这一步网络拓扑结构才算正式确定下来10-10-9, %连接权值和偏置值总数是：10*10+9*10+10+9=209

%     view(net);  
    
    if str2num(Var.plotperform)          % str2num('true')==1
        figure()
        plotperform(tr);
    end
    % 说明：为什么有三条曲线？各代表什么意思？
% 在训练多层网络时，一般的做法是首先将数据分成三个子集。
% 第一个子集是训练集，用于计算梯度和更新网络权值和偏差。
% 第二个子集是验证集。在训练过程中监控验证集上的误差。
% 
% 验证误差通常在训练的初始阶段减小，训练集误差也是如此。
% 但是，当网络开始过拟合数据时，验证集上的误差通常会开始上升。
% 当验证集上的误差连续增加达到指定迭代次数（net.trainParam.max_fail）时，训练停止。
% 而验证集误差的最小值对应的网络权值和偏差将会被保存。
% 这种为了提高浅层神经网络的泛化能力，避免过度拟合所采用的技术叫Early Stop技术。
% 
% 测试集误差不用于训练，但用于比较不同的模型。在训练过程中绘制测试集错误也很有用。
% 如果测试集上的误差在与验证集误差明显不同的迭代次数处达到最小值，则这可能表示数据集划分不当。    
%     
	% 5.仿真网络
	YTest = net(XTest); 
	tTest = vec2ind(YTest)';
	% 6. 性能评价
    [c,cm,ind,per] = confusion(TTest,YTest);
    racc = c;
    best_perf = tr.best_perf;
    best_vperf = tr.best_vperf;
    best_tperf = tr.best_tperf;




% 绘制性能便变化曲线
% time1 = toc(timerVal_1);
% disp({['分类完毕，历时',num2str(time1),'秒.']});

    if str2num(Var.plottrainstate)          % str2num('false')==0
        figure()
        plottrainstate(tr);
    end

    if str2num(Var.plotconfusion)    
        figure()
        plotconfusion(TTest, YTest); %输入参数与confusion()的相同
    end 
    % TTest的每一列代表一个观测，且为one-hot-vector。
    % t_sim只要求其值位于[0,1]之间，可不必为one-hot-vector
    % c 为错误分类的比例，可以与tr.best_perf, tr.best_vperf,
    % tr.best_tperf相比较，以判断过拟合(或欠拟合)的显著程度
	% Confusion Matrix 
	
	% 注意：输入参数的格式应该如下
	% class:1×8862 double，是一个展开的类标签的行向量；
	% 而CTest：1×9 double，是一个未展开的类标签的行向量；
	    
    if str2num(Var.plotroc)   
        figure()
        plotroc(TTest, YTest);
    end
    
    if str2num(Var.plotperform)          
        plotperform(tr);
    end

end