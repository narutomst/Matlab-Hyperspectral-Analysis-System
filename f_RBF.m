% f_BP()���������Զ���ĺ���
% �ǻ���BP���򴫲��㷨��DNNģʽʶ������
% ����ֵӦ����׼ȷ�ʣ���Ӧ���л����������Ϣ����������
% ������籾��ܼ򵥣�������������Ҫע�⣺

% 1. ������Լ������Сֵ�ĵ�����������֤�������Сֵ�ĵ����������������죬
% ��˵������XTrain�ڻ���Ϊ3���Ӽ�ʱ���ֲ�����
% 2. ���ⲿ���Լ�(��XTest)�����ѵ�����Լ�(XTrain(:, tr.testInd))������������죬
% ��˵�����ݻ��ֲ���(��XTrain��XTest�Ļ���������)���ҿ����й���ϡ�

function [net, tr, tTest, c, cm] = f_RBF(XTrain, TTrain, XTest, TTest, Var)
%��������ܸ������м�ֵ�ļ������ǣ� net tr tTest c cm 
hiddenSizes = [Var.hiddenNum, Var.hiddenNum1, Var.hiddenNum2, Var.hiddenNum3, Var.hiddenNum4];
hiddenSizes = hiddenSizes(1 : Var.hiddenLayerNum);
trainFcn = Var.trainFcn;
transferFcn = {Var.transferFcn, Var.transferFcn1, Var.transferFcn2, Var.transferFcn3, Var.transferFcn4};

%% ��ջ���
% p.Results 
% ans =  
%   ���������ֶε� struct:
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
%              TTest: [15��264499 double]
%             TTrain: [15��113357 double]
%               type: 'BP'
%              XTest: [10��264499 double]
%             XTrain: [10��113357 double]

warning off


% racc = [];
% best_perf = [];
% best_vperf = [];
% best_tperf = [];

% timerVal_1 = tic;
% disp('ѵ����ʼ..................................');

    
    % 1. ��������
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
    % 2. �������ܲ��� 
	net.performParam.regularization = 0.1;           
	net.performParam.normalization = 'none';
	% 3. ����ѵ������
	net.trainParam.goal = 1e-6;      % 
	net.trainParam.show = 25;
	net.trainParam.epochs = 2000;
	net.trainParam.showWindow = str2num(Var.showWindow); %str2num('true')==1; str2num('false')==0
	% 4.ѵ������
	[net, tr] = train(net,XTrain,TTrain); %, 'useParallel','yes','showResources','yes');
    %�����￪�����м��㣬�ᵼ�³��־��棺ʹ��ϡ�������ʽ����������ѵ�����罫�ᵼ���ڴ�ռ��̫��
    %��һ���������˽ṹ������ʽȷ������10-10-9, %����Ȩֵ��ƫ��ֵ�����ǣ�10*10+9*10+10+9=209

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
	YTest = net(XTest); 
	tTest = vec2ind(YTest)';
	% 6. ��������
    [c,cm,ind,per] = confusion(TTest,YTest);
    racc = c;
    best_perf = tr.best_perf;
    best_vperf = tr.best_vperf;
    best_tperf = tr.best_tperf;




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

end