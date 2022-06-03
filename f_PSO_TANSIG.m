%ʹ��pso�Ż�TANSIG�������㷨
%% �ô���Ϊ����PSO��TANSIG�����Ԥ��
function [netTrained, trainRecord, predictedVector, misclassRate, cmt] = f_PSO_TANSIG(XTrain, TTrain, XTest, TTest, Var)
%��������ܸ������м�ֵ�ļ������ǣ�[net tr tTest c cm]�����䱣�浽[netTrained, trainRecord, predictedVector, misclassRate, cmt]
        % net��ѵ���õ�����netTrained
        % tr��ѵ����¼�ṹ��trainRecord��������best_perf ѵ����������ܣ���ɫ���ߣ���
        % best_vperf ��֤��������ܣ���ɫ���ߣ���best_tperf ���Լ�������ܣ���ɫ���ߣ�
        %tTest ΪԤ�������ǩ������predictedVector
        % c, �����misclassRate�������ʣ�1-c����׼ȷ��OA
        % cm, �������󣬱��浽cmt  
        
warning off
% ���巵�ر����Ĵ�С����Ϊÿ�����ر��������Ż�ǰ���Ż��������ֵ������ʹ��cell array�����档
% ���ں���f_TANSIG(), f_RBF(), f_BP()����������ֵ����1��1 cell array��
% ���ں���f_GA_TANSIG(), f_GA_RBF(), f_GA_BP()��f_PSO_TANSIG(), f_PSO_RBF(), f_PSO_BP()
% ��������ֵ����2��1 cell array��
netTrained = cell(2,1);
trainRecord = cell(2,1);
predictedVector = cell(2,1);
misclassRate = cell(2,1);
cmt = cell(2,1);
%% II. ��ȡ������ڵ��������ݺ���
%'softmax'; %���һ�㼴�����Ĵ��ݺ����� net.layers{Var.hiddenLayerNum+1}.transferFcn
hiddenSizes = [Var.hiddenNum, Var.hiddenNum1, Var.hiddenNum2, Var.hiddenNum3, Var.hiddenNum4];
hiddenSizes = hiddenSizes(1 : Var.hiddenLayerNum);

trainFcn = Var.trainFcn;
transferFcn = {Var.transferFcn, Var.transferFcn1, Var.transferFcn2, Var.transferFcn3, Var.transferFcn4};
inputNum = size(XTrain,1);
outputNum = size(TTrain,1);
acc1 = [];
acc2 = [];

    % 1. ��������
    net = patternnet(hiddenSizes,trainFcn);%Ĭ�ϵ��������ݺ����ֱ��ǣ�����1-tansig������2-tansig�������-softmax
 
    for j = 1 : Var.hiddenLayerNum %����������޸�����Ĵ��ݺ���
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
    % 2. �������ܲ��� 
% 	net.performParam.regularization = 0.1;           
% 	net.performParam.normalization = 'none';
	% 3. ����ѵ������
% 	net.trainParam.goal = 1e-6;      % 
% 	net.trainParam.show = 25;
% 	net.trainParam.epochs = 2000;
	net.trainParam.showWindow = str2num(Var.showWindow); %str2num('true')==1; str2num('false')==0
	% 4.ѵ������
	[net, tr] = train(net, XTrain, TTrain);% 'useParallel','yes','showResources','yes');%��һ���������˽ṹ������ʽȷ������10-10-9
												 %����Ȩֵ��ƫ��ֵ�����ǣ�10*10+9*10+10+9=209
%     view(net);  
    
    if str2num(Var.plotperform)          % str2num('true')==1
        figure()
        plotperform(tr{1});
    end
    % ˵����Ϊʲô���������ߣ�������ʲô��˼��
% ��ѵ���������ʱ��һ������������Ƚ����ݷֳ������Ӽ���
% ��һ���Ӽ���ѵ���������ڼ����ݶȺ͸�������Ȩֵ��ƫ�
% �ڶ����Ӽ�����֤������ѵ�������м����֤���ϵ���
% 
% ��֤���ͨ����ѵ���ĳ�ʼ�׶μ�С��ѵ�������Ҳ����ˡ�
% ���ǣ������翪ʼ���������ʱ����֤���ϵ����ͨ���Ὺʼ������
% ����֤���ϵ�����������Ӵﵽָ������������net.trainParam.max_fail��ʱ��ѵ��ֹͣ��
% ����֤��������Сֵ��Ӧ������Ȩֵ��ƫ��ᱻ���档
% ����Ϊ�����ǳ��������ķ������������������������õļ�����Early Stop������
% 
% ���Լ�������ѵ���������ڱȽϲ�ͬ��ģ�͡���ѵ�������л��Ʋ��Լ�����Ҳ�����á�
% ������Լ��ϵ����������֤��������Բ�ͬ�ĵ����������ﵽ��Сֵ��������ܱ�ʾ���ݼ����ֲ�����    
%     
	% 5.��������
	YTest = net(XTest); 
	tTest1 = vec2ind(YTest)';
	% 6. ��������
    [c,cm,ind,per] = confusion(TTest,YTest);
    racc1 = c;
    best_perf1 = tr.best_perf;
    best_vperf1 = tr.best_vperf;
    best_tperf1 = tr.best_tperf;

% �������ܱ�仯����
% time1 = toc(timerVal_1);
% disp({['������ϣ���ʱ',num2str(time1),'��.']});

    if str2num(Var.plottrainstate)          % str2num('false')==0
        figure()
        plottrainstate(tr);
    end

    if str2num(Var.plotconfusion)    
        figure()
        plotconfusion(TTest, YTest); %���������confusion()����ͬ
    end 
    % TTest��ÿһ�д���һ���۲⣬��Ϊone-hot-vector��
    % t_simֻҪ����ֵλ��[0,1]֮�䣬�ɲ���Ϊone-hot-vector
    % c Ϊ�������ı�����������tr.best_perf, tr.best_vperf,
    % tr.best_tperf��Ƚϣ����жϹ����(��Ƿ���)�������̶�
	% Confusion Matrix 
	
	% ע�⣺��������ĸ�ʽӦ������
	% class:1��8862 double����һ��չ�������ǩ����������
	% ��CTest��1��9 double����һ��δչ�������ǩ����������
	    
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
    
	%% VI. PSO_TANSIG������
	%%�����
	%��ʼ�����볤�ȣ����������ֳ�ά����gl
	sumNet = [inputNum,hiddenSizes,outputNum];
    k = numel(sumNet);
    S = 0;          % S = inputNum*S1+ S1*S2+S2*outputNum+ S1 + S2+outputNum;  %���볤��
    for i = 1:k-1
        S = S+sumNet(i)*sumNet(i+1)+sumNet(i+1);
    end

	% PSO������ʼ��

	c1 = 1.49445;
	c2 = 1.49445;
	ws = 0.9;
	we =0.4;
	maxgen=100; % �������� ��100
	sizepop=50;    % ��Ⱥ��ģ��50������
    k_stop = 40;   %��һ����Ӧ��ֵ�����ظ�������40�Σ���ô��Ϊ��������
    
	Vmax=0.3;
	Vmin=-0.3;
	popmax=1.2;
	popmin=-1.2;

	% pop(1,:) = [reshape(net.IW{1},1,[]), net.b{1}', reshape(net.LW{2,1},1,[]), net.b{2}'];
	%% ��ʼ�����Ӻ��ٶ�
	pop=abs(popmax)*rands(sizepop,S);
	V=abs(Vmax)*rands(sizepop,S);
    fitness = zeros(sizepop,1);
    
	for i = 1 : sizepop
		x=pop(i,:);
		[fitness(i),net]=fun(x,inputNum,hiddenSizes,outputNum,net,XTrain,TTrain); %Ⱦɫ�����Ӧ��
	end

	% ���弫ֵ��Ⱥ�弫ֵ
	[bestfitness, bestindex]=max(fitness);
	Pbest=pop; %�������
	fitnessPbest=fitness; %���������Ӧ��ֵ
    Gbest=pop(bestindex, :); %ȫ�����
	fitnessGbest=bestfitness; %ȫ�������Ӧ��ֵ

	%% ����Ѱ��
    yy=[];  %yy���ڱ���ÿһ�μ��������Ⱥ��������Ӧ��ֵ
    yy=[yy,fitnessGbest];%yy��Ҫ�ɱ䳤�ȣ������ȱ��������Ⱥ������Ӧ��ֵ
    count = 0;    % count���ڱ���yy�е������Ӧ�������ظ����ֵĴ���
	for i=1:maxgen
        
		% ÿһ������һ���̶���Ȩ��ϵ��
		w = ws - (ws-we)*(i/maxgen);   % ��0.89���Եݼ���0.4
		% �Ȱ�10�����Ӹ���һ��
		for j = 1 : sizepop
			% �����ٶ�
			V(j, :) = w*V(j, :) + c1*rand*(Pbest(j, :) - pop(j, :)) + c2*rand*(Gbest - pop(j, :));
			V(j,(V(j,:)>Vmax)) = Vmax; % �߽���
			V(j,(V(j,:)<Vmin)) = Vmin;
			% ��������
			pop(j,:) = pop(j,:) + V(j, :);
			pop(j, (pop(j,:) > popmax)) = popmax; %�߽���
			pop(j, (pop(j,:) < popmin)) = popmin;
			
			%����������ӣ����³�ʼ������

			if rand>0.9
				k=ceil(S*rand); %��������ȡ��
				pop(j,k)=rand;
			end

			pos=unidrnd(S);  %gl �˴�������pos=unidrnd(21); ;��21������numsum��
			if rand>0.95
				pop(j,pos)=5*rands(1,1);
			end
			%��������Ӧ��ֵ
			[fitness(j),net]=fun(pop(j,:),inputNum,hiddenSizes,outputNum,net,XTrain,TTrain);
		end
		
		%% ���¸��弫ֵ��Ⱥ�弫ֵ
		for j=1:sizepop
			%�������Ÿ���
			if fitness(j) > fitnessPbest(j)
				Pbest(j,:) = pop(j,:);
				fitnessPbest(j) = fitness(j);
			end
		end
			%Ⱥ�����Ÿ��� 		
		[fitnessGbest, bindx] = max(fitnessPbest);
		Gbest = Pbest(bindx,:);
			
		%%ÿ������ֵ��¼��yy������
        %yy(1)������ǳ�ʼ��Ⱥ��Ⱥ��������Ӧ��ֵ
		yy(i+1)=fitnessGbest;
        
        if yy(i)==fitnessGbest
            count = count+1;
        else
            count=0;
        end
        
        disp([i,yy(i+1)]);
        if count == k_stop       %��һ����Ӧ��ֵ�����ظ�������10�Σ���ô��Ϊ��������
            break
        end
	end

	%% �������
	figure
	plot(yy)
	title(['��Ӧ������' '��ֹ������' num2str(length(yy))],'fontsize',12);
	xlabel('��������','fontsize',12);
	ylabel('��Ӧ��','fontsize',12);

	%% �����ų�ʼ��ֵȨֵ��������Ԥ��
	% ��Ⱥ�����Ÿ���Gbest���н���
	x=Gbest;
    [val, net] = fun(x, inputNum, hiddenSizes, outputNum, net, XTrain, TTrain);

	%% TANSIG����ѵ��
    % ��ʹ���ݶ��½�������أ��㷨Ѱ�Ҿֲ����Ž�
    net.trainParam.showWindow = str2num(Var.showWindow); %str2num('true')==1; str2num('false')==0
	[net, tr]=train(net,XTrain,TTrain); %'useParallel','yes','showResources','yes');
    % �رղ��м���ѡ���Ϊ��ᵼ�¼����������С���⣬������������������ʹ�ˣ�����ʧ���ȡ�
    if str2num(Var.plotperform)          % str2num('true')==1
        figure()
        plotperform(tr{2});
    end
	%% PSO_TANSIG����Ԥ��
	% 5.��������
	YTest = net(XTest); 
	tTest2 = vec2ind(YTest)';
	% 6. ��������
    [c2,cm2,ind2,per2] = confusion(TTest,YTest);
    racc2 = c2;
    best_perf2 = tr.best_perf;
    best_vperf2 = tr.best_vperf;
    best_tperf2 = tr.best_tperf;

% �������ܱ�仯����
% time1 = toc(timerVal_1);
% disp({['������ϣ���ʱ',num2str(time1),'��.']});

    if str2num(Var.plottrainstate)          % str2num('false')==0
        figure()
        plottrainstate(tr{2});
    end

    if str2num(Var.plotconfusion)    
        figure()
        plotconfusion(TTest, YTest); %���������confusion()����ͬ
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
% %%�����㷨�Ľ���Ա�
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
% xlabel('����');
% ylabel('׼ȷ��');
% string = '�����㷨����׼ȷ�ʶԱ�';
% title(string);

end
