%使用pso优化TANSIG神经网络算法
%% 该代码为基于PSO和TANSIG网络的预测
function [netTrained, trainRecord, predictedVector, misclassRate, cmt] = f_PSO_TANSIG(XTrain, TTrain, XTest, TTest, Var)
%这个函数能给出的有价值的计算结果是：[net tr tTest c cm]，将其保存到[netTrained, trainRecord, predictedVector, misclassRate, cmt]
        % net，训练好的网络netTrained
        % tr，训练记录结构体trainRecord，包含了best_perf 训练集最佳性能（蓝色曲线），
        % best_vperf 验证集最佳性能（绿色曲线），best_tperf 测试集最佳性能（红色曲线）
        %tTest 为预测的类别标签列向量predictedVector
        % c, 误分率misclassRate，错误率；1-c，即准确率OA
        % cm, 混淆矩阵，保存到cmt  
        
warning off
% 定义返回变量的大小，因为每个返回变量都有优化前和优化后的两个值，所以使用cell array来保存。
% 对于函数f_TANSIG(), f_RBF(), f_BP()，上述返回值都是1×1 cell array；
% 对于函数f_GA_TANSIG(), f_GA_RBF(), f_GA_BP()，f_PSO_TANSIG(), f_PSO_RBF(), f_PSO_BP()
% 上述返回值都是2×1 cell array；
netTrained = cell(2,1);
trainRecord = cell(2,1);
predictedVector = cell(2,1);
misclassRate = cell(2,1);
cmt = cell(2,1);
%% II. 获取隐含层节点数及传递函数
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
    net = patternnet(hiddenSizes,trainFcn);%默认的三个传递函数分别是：隐层1-tansig，隐层2-tansig，输出层-softmax
 
    for j = 1 : Var.hiddenLayerNum %这里仅设置修改隐层的传递函数
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
	[net, tr] = train(net, XTrain, TTrain);% 'useParallel','yes','showResources','yes');%这一步网络拓扑结构才算正式确定下来10-10-9
												 %连接权值和偏置值总数是：10*10+9*10+10+9=209
%     view(net);  
    
    if str2num(Var.plotperform)          % str2num('true')==1
        figure()
        plotperform(tr{1});
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
   %acc1 = [acc1, 1-racc1]; 
    netTrained{1} = net;
    trainRecord{1} = tr;
    predictedVector{1} = tTest1;
    misclassRate{1} = c;
    cmt{1} = cm;
    
	%% VI. PSO_TANSIG神经网络
	%%新添加
	%初始化编码长度，以免后面出现超维错误gl
	sumNet = [inputNum,hiddenSizes,outputNum];
    k = numel(sumNet);
    S = 0;          % S = inputNum*S1+ S1*S2+S2*outputNum+ S1 + S2+outputNum;  %编码长度
    for i = 1:k-1
        S = S+sumNet(i)*sumNet(i+1)+sumNet(i+1);
    end

	% PSO参数初始化

	c1 = 1.49445;
	c2 = 1.49445;
	ws = 0.9;
	we =0.4;
	maxgen=100; % 进化次数 ：100
	sizepop=50;    % 种群规模：50个个体
    k_stop = 40;   %若一个适应度值连续重复出现了40次，那么认为进化结束
    
	Vmax=0.3;
	Vmin=-0.3;
	popmax=1.2;
	popmin=-1.2;

	% pop(1,:) = [reshape(net.IW{1},1,[]), net.b{1}', reshape(net.LW{2,1},1,[]), net.b{2}'];
	%% 初始化粒子和速度
	pop=abs(popmax)*rands(sizepop,S);
	V=abs(Vmax)*rands(sizepop,S);
    fitness = zeros(sizepop,1);
    
	for i = 1 : sizepop
		x=pop(i,:);
		[fitness(i),net]=fun(x,inputNum,hiddenSizes,outputNum,net,XTrain,TTrain); %染色体的适应度
	end

	% 个体极值和群体极值
	[bestfitness, bestindex]=max(fitness);
	Pbest=pop; %个体最佳
	fitnessPbest=fitness; %个体最佳适应度值
    Gbest=pop(bestindex, :); %全局最佳
	fitnessGbest=bestfitness; %全局最佳适应度值

	%% 迭代寻优
    yy=[];  %yy用于保存每一次计算产生的群体最优适应度值
    yy=[yy,fitnessGbest];%yy需要可变长度，所以先保存初代种群最优适应度值
    count = 0;    % count用于保存yy中的最佳适应度连续重复出现的次数
	for i=1:maxgen
        
		% 每一代都有一个固定的权重系数
		w = ws - (ws-we)*(i/maxgen);   % 从0.89线性递减到0.4
		% 先把10个粒子更新一遍
		for j = 1 : sizepop
			% 更新速度
			V(j, :) = w*V(j, :) + c1*rand*(Pbest(j, :) - pop(j, :)) + c2*rand*(Gbest - pop(j, :));
			V(j,(V(j,:)>Vmax)) = Vmax; % 边界检查
			V(j,(V(j,:)<Vmin)) = Vmin;
			% 更新粒子
			pop(j,:) = pop(j,:) + V(j, :);
			pop(j, (pop(j,:) > popmax)) = popmax; %边界检查
			pop(j, (pop(j,:) < popmin)) = popmin;
			
			%引入变异算子，重新初始化粒子

			if rand>0.9
				k=ceil(S*rand); %向正无穷取整
				pop(j,k)=rand;
			end

			pos=unidrnd(S);  %gl 此处例程是pos=unidrnd(21); ;把21换成了numsum。
			if rand>0.95
				pop(j,pos)=5*rands(1,1);
			end
			%新粒子适应度值
			[fitness(j),net]=fun(pop(j,:),inputNum,hiddenSizes,outputNum,net,XTrain,TTrain);
		end
		
		%% 更新个体极值和群体极值
		for j=1:sizepop
			%个体最优更新
			if fitness(j) > fitnessPbest(j)
				Pbest(j,:) = pop(j,:);
				fitnessPbest(j) = fitness(j);
			end
		end
			%群体最优更新 		
		[fitnessGbest, bindx] = max(fitnessPbest);
		Gbest = Pbest(bindx,:);
			
		%%每代最优值记录到yy数组中
        %yy(1)保存的是初始种群的群体最优适应度值
		yy(i+1)=fitnessGbest;
        
        if yy(i)==fitnessGbest
            count = count+1;
        else
            count=0;
        end
        
        disp([i,yy(i+1)]);
        if count == k_stop       %若一个适应度值连续重复出现了10次，那么认为进化结束
            break
        end
	end

	%% 结果分析
	figure
	plot(yy)
	title(['适应度曲线' '终止代数＝' num2str(length(yy))],'fontsize',12);
	xlabel('进化代数','fontsize',12);
	ylabel('适应度','fontsize',12);

	%% 把最优初始阀值权值赋予网络预测
	% 对群体最优个体Gbest进行解码
	x=Gbest;
    [val, net] = fun(x, inputNum, hiddenSizes, outputNum, net, XTrain, TTrain);

	%% TANSIG网络训练
    % 即使用梯度下降（或相关）算法寻找局部最优解
    net.trainParam.showWindow = str2num(Var.showWindow); %str2num('true')==1; str2num('false')==0
	[net, tr]=train(net,XTrain,TTrain); %'useParallel','yes','showResources','yes');
    % 关闭并行计算选项，因为这会导致计算机出各种小问题，比如网络适配器不好使了，电脑失声等。
    if str2num(Var.plotperform)          % str2num('true')==1
        figure()
        plotperform(tr{2});
    end
	%% PSO_TANSIG网络预测
	% 5.仿真网络
	YTest = net(XTest); 
	tTest2 = vec2ind(YTest)';
	% 6. 性能评价
    [c2,cm2,ind2,per2] = confusion(TTest,YTest);
    racc2 = c2;
    best_perf2 = tr.best_perf;
    best_vperf2 = tr.best_vperf;
    best_tperf2 = tr.best_tperf;

% 绘制性能便变化曲线
% time1 = toc(timerVal_1);
% disp({['分类完毕，历时',num2str(time1),'秒.']});

    if str2num(Var.plottrainstate)          % str2num('false')==0
        figure()
        plottrainstate(tr{2});
    end

    if str2num(Var.plotconfusion)    
        figure()
        plotconfusion(TTest, YTest); %输入参数与confusion()的相同
    end 
       if str2num(Var.plotroc)   
        figure()
        plotroc(TTest, YTest);
    end
    
    if str2num(Var.plotperform)          
        plotperform(tr{2});
    end
%   acc2 = [acc2, 1-racc2]; 
netTrained{2} = net;
trainRecord{2} = tr;
predictedVector{2} = tTest2;
misclassRate{2} = c2;
cmt{2} = cm2;
   
racc = [racc1, racc2];
best_perf = [best_perf1, best_perf2];
best_vperf = [best_vperf1, best_vperf2];
best_tperf = [best_tperf1, best_tperf2];      
tTest = [tTest1, tTest2];    
% %%两种算法的结果对比
% average1 = mean(acc1);
% average2 = mean(acc2);
% variance1 = var(acc1);
% variance2 = var(acc2);
% N1 = length(acc1);
% N2 = length(acc2);

% figure(2)
% plot(1:N1, acc1, 'r-', 1:N2, acc2,'b--');
% %legend('TANSIG','PSO\_TANSIG','Location','best');
% legend('RBF','PSO\_RBF','Location','best');
% xlabel('次数');
% ylabel('准确率');
% string = '两种算法分类准确率对比';
% title(string);

end
