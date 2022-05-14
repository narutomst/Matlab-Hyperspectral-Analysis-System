
function [net, tr, tTest, c, cm] = f_GA_BP(XTrain, TTrain, XTest, TTest, Var)
%��������ܸ������м�ֵ�ļ������ǣ� net tr tTest c cm 
warning off

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
    net = patternnet(hiddenSizes,trainFcn); %Ĭ�ϵ��������ݺ����ֱ��ǣ�����1-tansig������2-tansig�������-softmax
 
    for j = 1 : Var.hiddenLayerNum             %����������޸�����Ĵ��ݺ���
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
	[net, tr] = train(net, XTrain, TTrain);%��һ���������˽ṹ������ʽȷ��������
                                                        %XTrainÿһ��������һ�����������ڷ������⣬TTrainÿһ����һ��one-hot-vector
												 
%     view(net);  
    
    if str2num(Var.plotperform)          % str2num('true')==1
        figure()
        plotperform(tr);
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
	y = net(XTest); 
% 	tTest = vec2ind(YTest);
	% 6. ��������
    [c,cm,ind,per] = confusion(TTest, y);
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
    acc1 = [acc1, 1-racc1]; 
    
%% VI. GA-BP������
	sumNet = [inputNum, hiddenSizes, outputNum];
    k = numel(sumNet);
    S = 0;          % S = inputNum*S1+ S1*S2+S2*outputNum+ S1 + S2+outputNum;  %���볤��
    for i = 1:k-1
        S = S+sumNet(i)*sumNet(i+1)+sumNet(i+1);
    end
    aa = ones(S,1)*[-1,1];      

%% VII. �Ŵ��㷨�Ż�
%%
	% 1. ��ʼ����Ⱥ
	popu = 200;  % ��Ⱥ��ģ
    evalOps = struct();
    evalOps.inputNum = inputNum;
    evalOps.hiddenNum = hiddenSizes;
    evalOps.outputNum = outputNum;
    evalOps.net = net;
    evalOps.XTrain = XTrain;
    evalOps.TTrain = TTrain;
	initPpp = initializega1(popu,aa,'fun',evalOps,[1e-6 1]);  % ��ʼ����Ⱥ      fun   ��һ�������������������gadecod

	%%
	% 2. �����Ż�
	gen = 200;  % �Ŵ�����
	% ����GAOT�����䣬����Ŀ�꺯������ΪgabpEval     endpop  ǰ114���Ǻ�S��115�д���  ��Ӧ�Ⱥ���ֵ

	[x,endPop,bPop,trace] = ga1(aa,'fun',evalOps,initPpp,[1e-6 1 1],'maxGenTerm',gen,...
							   'normGeomSelect',[0.09],['arithXover'],[2],'nonUnifMutation',[2 gen 3]);
	%%
	% 3. ��������仯����
	figure
	plot(trace(:,1),1./trace(:,3),'r-', trace(:,1),1./trace(:,2),'b--');
	legend('��ֵ','����ֵ');%legend('avrg','best');
	xlabel('����');%xlabel('Generation');
	ylabel('�������');%ylabel('Sum-Squared Error');
	string1 = '�����������';%string1 = 'Sum-Squared Error Curve';
	title(string1);
	%%
	% 4. ������Ӧ�Ⱥ����仯
	figure
	plot(trace(:,1),trace(:,3),'r-', trace(:,1),trace(:,2),'b--');
	legend('��ֵ','����ֵ');%legend('avrg','best');
	xlabel('����');%xlabel('Generation');
	ylabel('��Ӧ��');%ylabel('Fittness');
	string2 = '��Ӧ�Ⱥ���ֵ����';%string2 = 'Fitness Function Value Curve';
	title(string2);

%% VIII. �������ŽⲢ��ֵ
%%
% 1. �������Ž⣬���Ҹ�ֵ��������
	[val, net] = fun(x, inputNum, hiddenSizes, outputNum, net, XTrain, TTrain);
%     [W,B,val] = gadecod(x);
%% IX. �����µ�Ȩֵ����ֵ����ѵ��
	net.trainParam.showWindow = str2num(Var.showWindow); %str2num('true')==1; str2num('false')==0
	[net,tr]=train(net,XTrain,TTrain);

	if str2num(Var.plotperform)          % str2num('true')==1
		figure
		plotperform(tr);
	end

%% X. �������
	y = net(XTest); 

%% V. ��������

    [c2,cm2,ind2,per2] = confusion(TTest,y);
    racc2 = c2;
    best_perf2 = tr.best_perf;
    best_vperf2 = tr.best_vperf;
    best_tperf2 = tr.best_tperf;
    
    acc2 = [acc2, 1-racc2]; 

racc = [racc1; racc2];
best_perf = [best_perf1; best_perf2];
best_vperf = [best_vperf1; best_vperf2];
best_tperf = [best_tperf1; best_tperf2];
%%�����㷨�Ľ���Ա�
% average1 = mean(acc1);
% average2 = mean(acc2);
% variance1 = var(acc1);
% variance2 = var(acc2);
% N1 = length(acc1);
% N2 = length(acc2);
% 
% figure
% plot(1:N1, acc1, 'r-', 1:N2, acc2,'b--');
% legend('BP','GA\_BP','Location','best');
% xlabel('����');
% ylabel('׼ȷ��');
% string = '�����㷨����׼ȷ�ʶԱ�';
% title(string);
end