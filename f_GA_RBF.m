% 使用已有的可用于分类的数据集demo_dataset.mat，利用RBF神经网络来做分类
% 基本思路就是按照何同弟的来做
% function [acc1, acc2] = f_GA_RBF()
function [net, tr, tTest, c, cm] = f_GA_RBF(XTrain, TTrain, XTest, TTest, Var)
%这个函数能给出的有价值的计算结果是： net tr tTest c cm 
        % net，训练好的网络
        % tr，训练记录结构体，包含了best_perf 训练集最佳性能（蓝色曲线），best_vperf 验证集最佳性能（绿色曲线），best_tperf 测试集最佳性能（红色曲线）
        %tTest 为预测的类别标签列向量
        % c, 误分率，错误率；1-c，即准确率OA
        % cm, 混淆矩阵  
warning off

%'softmax'; %最后一层即输出层的传递函数是 net.layers{Var.hiddenLayerNum+1}.transferFcn

hiddenSizes = [Var.hiddenNum, Var.hiddenNum1, Var.hiddenNum2, Var.hiddenNum3, Var.hiddenNum4];
hiddenSizes = hiddenSizes(1 : Var.hiddenLayerNum);

trainFcn = Var.trainFcn;
transferFcn = {Var.transferFcn, Var.transferFcn1, Var.transferFcn2, Var.transferFcn3, Var.transferFcn4};
inputNum = size(XTrain,1);
outputNum = size(TTrain,1);
acc1 = [];
acc2 = [];

    % 1. 构建网络
    net = patternnet(hiddenSizes,trainFcn); %默认的三个传递函数分别是：隐层1-tansig，隐层2-tansig，输出层-softmax
 
    for j = 1 : Var.hiddenLayerNum             %这里仅设置修改隐层的传递函数,隐层1-tansig，隐层2-tansig
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
% 	net.performParam.regularization = 0.1;           
% 	net.performParam.normalization = 'none';
	% 3. 设置训练参数
% 	net.trainParam.goal = 1e-6;      % 
% 	net.trainParam.show = 25;
% 	net.trainParam.epochs = 2000;
	net.trainParam.showWindow = str2num(Var.showWindow); %str2num('true')==1; str2num('false')==0
	% 4.训练网络
	[net, tr] = train(net, XTrain, TTrain,'useParallel','yes','showResources','yes');%这一步网络拓扑结构才算正式确定下来10-10-9
												 %连接权值和偏置值总数是：10*10+9*10+10+9=209
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
	tTest1 = vec2ind(YTest)';
	% 6. 性能评价
    [c,cm,ind,per] = confusion(TTest,YTest);
    racc1 = c;
    best_perf1 = tr.best_perf;
    best_vperf1 = tr.best_vperf;
    best_tperf1 = tr.best_tperf;

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
    acc1 = [acc1, 1-racc1]; 
    
%% VI. GA-RBF神经网络
	sumNet = [inputNum,hiddenSizes,outputNum];
    k = numel(sumNet);
    S = 0;          % S = inputNum*S1+ S1*S2+S2*outputNum+ S1 + S2+outputNum;  %编码长度
    for i = 1:k-1
        S = S+sumNet(i)*sumNet(i+1)+sumNet(i+1);
    end
    aa = ones(S,1)*[-1,1];      

%% VII. 遗传算法优化
%%
	% 1. 初始化种群
	popu = 200;  % 种群规模
    evalOps = struct();
    evalOps.inputNum = inputNum;
    evalOps.hiddenNum = hiddenSizes;
    evalOps.outputNum = outputNum;
    evalOps.net = net;
    evalOps.XTrain = XTrain;
    evalOps.TTrain = TTrain;
	initPpp = initializega1(popu,aa,'fun',evalOps,[1e-6 1]);  % 初始化种群      fun 看一下这个函数，解码赋值给网络，并计算适应度值

	%%
	% 2. 迭代优化
	gen = 200;  % 遗传代数
	% 调用GAOT工具箱，其中目标函数定义为gabpEval     endpop  前114列吻合S，115列代表  适应度函数值

	[x,endPop,bPop,trace] = ga1(aa,'fun',evalOps,initPpp,[1e-6 1 1],'maxGenTerm',gen,...
							   'normGeomSelect',[0.09],['arithXover'],[2],'nonUnifMutation',[2 gen 3]);
	%%
	% 3. 绘均方误差变化曲线
	figure
	plot(trace(:,1),1./trace(:,3),'r-', trace(:,1),1./trace(:,2),'b--');
	legend('均值','最优值');%legend('avrg','best');
	xlabel('代际');%xlabel('Generation');
	ylabel('均方误差');%ylabel('Sum-Squared Error');
	string1 = '均方误差曲线';%string1 = 'Sum-Squared Error Curve';
	title(string1);
	%%
	% 4. 绘制适应度函数变化
	figure
	plot(trace(:,1),trace(:,3),'r-', trace(:,1),trace(:,2),'b--');
	legend('均值','最优值');%legend('avrg','best');
	xlabel('代际');%xlabel('Generation');
	ylabel('适应度');%ylabel('Fittness');
	string2 = '适应度函数值曲线';%string2 = 'Fitness Function Value Curve';
	title(string2);

%% VIII. 解码最优解并赋值
%%
% 1. 解码最优解，并且赋值给神经网络
	[val, net] = fun(x, inputNum, hiddenSizes, outputNum, net, XTrain, TTrain);
%     [W,B,val] = gadecod(x);
%% IX. 利用新的权值和阈值进行训练
	net.trainParam.showWindow = str2num(Var.showWindow); %str2num('true')==1; str2num('false')==0
	[net,tr]=train(net,XTrain,TTrain,'useParallel','yes','showResources','yes');

	if str2num(Var.plotperform)          % str2num('true')==1
		figure
		plotperform(tr);
	end

%% X. 仿真测试
	YTest = net(XTest); 
	tTest2 = vec2ind(YTest)';

%% V. 性能评价

    [c2,cm2,ind2,per2] = confusion(TTest,YTest);
    racc2 = c2;
    best_perf2 = tr.best_perf;
    best_vperf2 = tr.best_vperf;
    best_tperf2 = tr.best_tperf;
    

racc = [racc1, racc2];
best_perf = [best_perf1, best_perf2];
best_vperf = [best_vperf1, best_vperf2];
best_tperf = [best_tperf1, best_tperf2];
tTest = [tTest1, tTest2];
%%两种算法的结果对比
% average1 = mean(acc1);
% average2 = mean(acc2);
% variance1 = var(acc1);
% variance2 = var(acc2);
% N1 = length(acc1);
% N2 = length(acc2);
% 
% figure
% plot(1:N1, acc1, 'r-', 1:N2, acc2,'b--');
% legend('RBF','GA\_RBF','Location','best');
% xlabel('次数');
% ylabel('准确率');
% string = '两种算法分类准确率对比';
% title(string);
end