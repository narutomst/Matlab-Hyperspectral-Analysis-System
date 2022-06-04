%%���û�ѡ��ClassDemo������󣬱���������
function Classify_Callback2(hObject, eventdata, handles) %��113��
global x3 lbs2 x2 lbs mappedA Inputs Targets Inputs1 Inputs2 Inputs3 t0 t1 t2 mA mA1 mA2
%% ���ݴ�����άmatת��ά����άgtתһά��
% hmenu4 = findobj(handles,'Tag','Analysis');
hmenu4_1 = findobj(handles,'Label','��������');
hmenu4_3 = findobj(handles,'Label','ִ�н�ά');

if isempty(hmenu4_3.UserData) || ~isfield(hmenu4_3.UserData, 'drData') || isempty(hmenu4_3.UserData.drData)
    mappedA = hmenu4_1.UserData.x2;         %������δ����ά���ӡ��������ݡ�����ȡ����
    disp('ע�⣺����δ����ά����ֱ�ӷ��������Ҫ���ĸ���ʱ�䣡');
else
    mappedA = hmenu4_3.UserData.drData;  %�������Ѿ����˽�ά���ӡ�ִ�н�ά������ȡ����
end
disp('���ࣺ������Ч�Լ��............');

% if isfield(hmenu4_1.UserData, 'x2') || ~isempty(hmenu4_1.UserData.x2)
try
    x2 = hmenu4_1.UserData.x2;
catch
    feedData(hmenu4_1,handles);%����������δ�ɹ�
    return;
end

try
    lbs = hmenu4_1.UserData.lbs; 
catch
    feedData(hmenu4_1,handles);%����ǩ��������δ�ɹ�
    return;
end

try
    type = hmenu4_1.UserData.cAlgorithm;%��δѡ������㷨
catch
    feedData(hmenu4_1,handles);
    return;
end

%������ѵ�����Ͳ��Լ�������������
%     prompt = ['������ѵ�����Ͳ��Լ�����������������ǰ����Ϊ',num2str(hObject.UserData.rate)];
%     dlg_title = 'ָ��ѵ��������Լ�������������';
%     an = inputdlg(prompt,dlg_title,1);%resize��������Ϊon
%     if ~isempty(an{:})
%         rate = str2double(an{:}); 
%     end

% ��ѡ����㷨���Ƽ����
type = hmenu4_1.UserData.cAlgorithm;
val = hmenu4_1.UserData.cValue;
% ������Ŷ�ȡĬ�ϲ���
dataLines = [val+1, val+1];%��val���㷨��Ӧ��excel�ĵ�val+1��
% dataLines = val+1;

workbookFile = fullfile(handles.UserData.mFilePath,"ParametersForDimReduceClassify.xlsx");
try
    paraTable_c = importfile2(workbookFile, "Sheet2", dataLines);
catch    
    paraTable_c = importfile2(workbookFile, "Sheet2", [2,2]);
end
% paraTable_c =
% 
%   1��25 table
% 
%             dimReduce rate app  executionTimes  trainFcn  hiddenNum  transferFcn showWindow plotperform plottrainstate ploterrhist plotconfusion plotroc hiddenLayerNum hiddenNum1 transferFcn1 hiddenNum2 transferFcn2 hiddenNum3 transferFcn3 hiddenNum4 transferFcn4 hiddenNumOptimization startNum stopNum
%             _________     ____ ___    ______________    __________  _________      ___________   __________      ___________    ______________ ___________ _____________   _______  ______________       __________      ____________    __________      ____________    __________    ____________    __________      ____________    _____________________        ________    _______
% 
% TANSIG      true       0.2   3             20            "trainscg"       10            "tansig"         false               false             false             false           false           false           2                      20              "tansig"            20               "tansig"          20             "tansig"          20                "tansig"                   true                       1           100  
% 
% paraTable_c.Properties
% 
% ans = 
%   TableProperties - ����:
% 
%              Description: ''
%                 UserData: []
%           DimensionNames: {'Row'  'Variables'}
%            VariableNames: {1��25 cell}
%     VariableDescriptions: {}
%            VariableUnits: {}
%       VariableContinuity: []
%                 RowNames: {'TANSIG'}
%         CustomProperties: δ�����Զ������ԡ�
% ��ʹ�� addprop �� rmprop �޸� CustomProperties��
% 
% paraTable_c.Properties.RowNames
% ans =
%   1��1 cell ����



% �õ����շ���׼ȷ��acc
% hyperDemo_1(hmenu4_1.UserData.x3);
% hyperDemo_detectors_1(hmenu4_1.UserData.x3);
% һά���෽��
timerVal_1 = tic;
disp('����׼��.......................................................................');

rate = paraTable_c.rate;   % ��ʹ�õ�ѵ����ռ��

if min(lbs(:))==0
    lbs = lbs(lbs~=0);
end
% vector_lbs2 = ind2vec(lbs2); % �����������ֻ����һά

% 3. ClassDemo
% ���� 'ParametersForDimReduceClassify.xlsx' sheet2 �еĲ������ǰ����ǳ��������������
% �ŵ㣺�������ö�������㣬�������ø���Ĵ��ݺ�������Ԫ����
% ȱ�㣺����Բ�������Ҫ�Լ���������������
    validateattributes(paraTable_c.dimReduce,{'logical'},{'integer'},'','dimReduce',1);
    validateattributes(paraTable_c.executionTimes,{'numeric'},{'integer','positive','>=',1,'<=',500},'','executionTimes',4);
    validateattributes(paraTable_c.hiddenLayerNum,{'numeric'},{'integer','positive','>=',1,'<=',5},'','hiddenLayerNum',14);
    validateattributes(paraTable_c.hiddenNumOptimization,{'logical'},{'integer'},'','hiddenNumOptimization',23);
    if paraTable_c.hiddenNumOptimization
        validateattributes(paraTable_c.startNum,{'numeric'},{'integer','positive','>=',1,'<=',500},'','startNum',24);
        validateattributes(paraTable_c.stopNum,{'numeric'},{'integer','positive','>=',1,'<=',500},'','stopNum',25);
    end

    time1 = toc(timerVal_1);
    disp({['����׼����ϣ���ʱ',num2str(time1),'��.',...
    hmenu4_1.UserData.matPath,' ��ʼִ�з���']});

    if paraTable_c.dimReduce && ~isempty(hmenu4_3.UserData) && isfield(hmenu4_3.UserData, 'drData') && ~isempty(hmenu4_3.UserData.drData)

        % ִ��20�η��࣬�ͻ���20�����ݣ���������Ϊ�˾����ܵ�ʹ���ݻ��־���
        % ��ΪĿǰ��������pca��ά��������ص�������б������1���ɷ���ռ�ı���̫����
        % �����Ļ���������ڷ�����
        n = paraTable_c.executionTimes; % �����������
        N = hmenu4_1.UserData.M-1;     % �������
        
        % ѯ���Ƿ�Ҫ�򿪲��г�
        quest = {'\fontsize{10} �Ƿ�Ҫʹ�ò��м��㣨Parallel Computing����'};
                 % \fontsize{10}�������С���η���������ʹ�������ַ���С��Ϊ10����
        dlgtitle = '���м���';         
        btn1 = '��';
        btn2 = '��';
        opts.Default = btn2;
        opts.Interpreter = 'tex';
        % answer = questdlg(quest,dlgtitle,btn1,btn2,defbtn);
        answer = questdlg(quest, dlgtitle, btn1, btn2, opts);
        if strcmp(answer, '��')
            try
                MyPar = parpool; %������г�δ��������򿪲��д����
            catch
                MyPar = gcp; %������г��Ѿ��������򽫵�ǰ���гظ�ֵ��MyPar
            end
        end
        
        cAlgorithmNameSet1 = ["TANSIG", "RBF"];
        cAlgorithmNameSet2 = ["GA_TANSIG", "GA_RBF", "PSO_TANSIG", "PSO_RBF"];
        if sum(ismember(paraTable_c.Properties.RowNames, cAlgorithmNameSet1))
            % ÿ�ε��������У������ķ���ֵ[net, tr, tTest, c, cm]ֻ��һ��ֵ
            setsNum = 1; % ʹ������setsNum������ѭ��������TPR, OA, AA, Kappa
        elseif sum(ismember(paraTable_c.Properties.RowNames, cAlgorithmNameSet2))
            % ÿ�ε��������У������ķ���ֵ[net, tr, tTest, c, cm]��������ֵ
            % һ������������Ż�֮ǰ�ģ���һ������������Ż�֮��ġ�
            setsNum = 2; 
        else
            disp('��ѡ��ķ����㷨��ÿ�ε�������ʱ���ܻ�����������������޷����棡');
        end
        acc_best = zeros(setsNum, setsNum); % ��¼n�ε����µ����׼ȷ��OA��ֵ
        % acc_best(1,1)�����Ż�ǰ�����accֵ; acc_best(2, 2)�����Ż�������accֵ
        % acc_best(1,2)�����Ż�ǰ�����accֵ��Ӧ���������Ż����׼ȷ��ֵ
        % acc_best(2,1)�����Ż�������accֵ��Ӧ���������Ż�ǰ��׼ȷ��ֵ
        net_best = cell(setsNum, setsNum); % ��¼���׼ȷ����ѵ���õ����磨���ڻ���GTͼ��
        % net_best{1,1}�����Ż�ǰ�������accֵ������; net_best{2, 2}�����Ż���������accֵ������
        % net_best{1,2}�����Ż�ǰ�������accֵ���������Ż��������
        % net_best{2,1}�����Ż���������accֵ���������Ż�ǰ������

        tTest_best = cell(1, setsNum);
        % tTest_bestҲ���Գ�ʼ��Ϊcell(setsNum, setsNum)�����ǵ��Ἣ�����Ĵ洢�ռ䣬
        % ���ǽ����ʼ��Ϊcell(1, setsNum)��
        % tTest_best{1,1}�����Ż�ǰ�������accֵ������Ԥ���������; 
        % tTest_best{1,2}�����Ż���������accֵ������Ԥ�����������
        cmNormalizedValues1 = zeros(N, N, n, setsNum); %��������˳��Ļ�������
        % cmNormalizedValues1(:, :, k, 1)�����k�ε��������Ż�ǰ���������ܵĻ�������;
        % cmNormalizedValues1(:, :, k, 2)�����k�ε��������Ż�����������ܵĻ�������;
        cmNormalizedValues2 = zeros(N, N, n, setsNum); %�������˳���Ļ�������
        cmClassLabels2 = zeros(n, N, setsNum);
        acc = zeros(n, setsNum);
        % acc(k,1)�����k�ε��������Ż�ǰ��׼ȷ�ʣ�acc(k,2)�����k�ε��������Ż����׼ȷ�ʣ�
       
%         % ��¼ÿ�εõ��ķ���׼ȷ�ʣ�ÿһ�е�׼ȷ�ʶ�Ӧһ�ε���
%         acc_full =   zeros(iterationPerLearningRate, iterationonSize , 'single');  
%         idx_best = zeros(iterationonSize, 1); % ��ÿһ������ߴ��¼�¼һ����ѵ�ѧϰ��������ͼ    
%         accTable = table();  % ��¼ÿһ�ε�OAֵ��iterationPerLearningRate���ظ������OA����Ϊһ�У�����iterationonSize��
%         avgTable = table(); % ��iterationPerLearningRate���ظ�����ĸ���TPR��ƽ������Ϊһ�У�ÿһ�ж�Ӧһ������ߴ磬����iterationonSize��
%         % TPR = single(classNumber, iterationPerLearningRate, iterationonSize);
%         TPR = zeros(9, iterationPerLearningRate, iterationonSize, 'single');        
                
        racc = zeros(n, setsNum);        % ���������󷵻�ֵ�еĵ�һ��ֵc������ʣ�����1-acc
        err_perf = zeros(n, setsNum);   % ����trainRecord.best_perf��
        err_vperf = zeros(n, setsNum); %����trainRecord.best_vperf��
        err_tperf = zeros(n, setsNum); %����trainRecord.best_tperf��       
%% ���ûƽ�ָ���������Ѱ�Ҹ������ز���Ԫ����Ѹ���
% �������Ե����������Ѱ�ţ���˵��Ѱ�����������ڵ����Ĺ��̣����Ƕ��ڶ��������������
% ���ַ����������þ��кõ�Ч�������絥����huston.mat���ݼ���0.2��ѵ������1~100��Ѱ�Ž��Ϊ85
% ���Ч�������˫���㣬ÿ��ֻ��40���ڵ�������𣿲�һ������Ϊͨ�����ԣ�խ������������Ч�����á�
% ���ڵ����Ż�ʱ���ڵ�Խ��Ч��Խ�á�
% ���Ե���Ľ��ۺͿ��ܲ������ڶ�㡣
        if paraTable_c.hiddenNumOptimization
            % ѯ���Ƿ�Ҫ���лƽ�ָ��Ѱ��������ڵ���������ֵ
            quest = {'\fontsize{10} �Ƿ�Ҫʹ�ûƽ�ָ��Ѱ��������ڵ���������ֵ��'};
                     % \fontsize{10}�������С���η���������ʹ�������ַ���С��Ϊ10����
            dlgtitle = '������ڵ����Ż�';         
            btn1 = '��';
            btn2 = '��';
            opts.Default = btn2;
            opts.Interpreter = 'tex';
            % answer = questdlg(quest,dlgtitle,btn1,btn2,defbtn);
            answer = questdlg(quest, dlgtitle, btn1, btn2, opts);
                                        
            % Handle response
            switch answer
                case '��'
                       
                    Ni = size(hmenu4_3.UserData.drData, 2); %�����ڵ�����ΪNi��10249x5 double
                    No = N; %�����ڵ�����ΪNo
                    Nh = []; %������ڵ�����ΪNh
                    a = paraTable_c.startNum; % �����½磻����ȡ����������©�κ�һ�����ܵĽڵ���
                    b = paraTable_c.stopNum; %�����Ͻ磻         
                    gold_point = cell(1,paraTable_c.hiddenLayerNum);%��¼�ƽ�ָ��
                    avg_acc = cell(1,paraTable_c.hiddenLayerNum);%��¼�ָ���Ӧ��׼ȷ��

                    for LayerNum=1 : paraTable_c.hiddenLayerNum  % ÿ�����ز�һ����ѭ��
                        N_1 = 20; %ÿ���ƽ�ָ���ϵļ��������
                        flag=1;

                        while(flag)
                            x_1 = a + 0.382*(b-a); %x_1��x_2����λ�������м�
                            x_2 = a + 0.618*(b-a); %����Ϊ�˲�©�����ܵĵ㣬x_1������ֵӦ�þ�������˵�Լֵ��x_2������ֵӦ�þ������Ҷ˵�Լֵ
                            x = [floor(x_1), ceil(x_2)];              %ÿ��ȡ�����ƽ�ָ��

                            [Lia, Locb] = ismember(x, gold_point{LayerNum}); %
                            % Lia = 1x2 logical array, ���ܵ�ֵ��[0,0] [1,0] [0,1] [1,1]
                            % Locb = 1xnumel(gold_point{LayerNum})�����ܵ�ֵ���ٶ�numel(gold_point{LayerNum})=5��Ϊ��
                            % [0 0 0 0 0], [0 0 1 0 0], [0 0 0 0 1], [0 1 0 1 0]
                            % 
                            % Lia=[0,0]����ʾx�е�����ֵ��gold_point{LayerNum}��û�в�ѯ���ظ������,
                            % ��ʱ��Locb = [0 0 0 0 0]
                            % Lia=[1,0],
                            % ��ʾx�е�һ��ֵ��gold_point{LayerNum}�е�ĳ��ֵ�ظ��������ʱLocb=[0 0 1 0 0]
                            % ��˵���ظ���gold_point{LayerNum}�еĵ����������������gold_point{LayerNum}��ֻ��һ��
                            % ����С����Ϊ1.
                            % Lia=[1,1] ��ʾx�е�����ֵ��gold_point{LayerNum}�е�ֵ�ظ��������ʱLocb=[0 1 0 1 0]
                            % ��˵���ظ���gold_point{LayerNum}�еĵڶ������͵��ĸ���������������gold_point{LayerNum}��ֻ������һ��
                            % �����С��С������Ϊ1.

                            switch Lia(1)*2+Lia(2)

                                case 0 % ��x���������ֶ���gold_point��û���ظ����������ƽ�ָ�㶼���㣬����
                                    acc = {[],[]}; %��¼�����ƽ�ָ���20�ε�׼ȷ��
                                    acc_average = [0,0];%��¼�����ƽ�ָ���ƽ��׼ȷ��
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

                                case 1 % ��x�еڶ�������gold_point�еĵ��ظ�����ֻ�����һ���������һ��
                                    acc = []; %��¼x�е�һ���ƽ�ָ���20�ε�׼ȷ��
                                    acc_average = [0];%��¼x�е�һ���ƽ�ָ���ƽ��׼ȷ��		
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

                                case 2 % ��x�е�һ������gold_point�еĵ��ظ�����ֻ����ڶ���������ڶ���
                                    acc = []; %��¼x�еڶ����ƽ�ָ���20�ε�׼ȷ��
                                    acc_average = [0];%��¼x�еڶ����ƽ�ָ���ƽ��׼ȷ��		
                                    for j = 1 : N_1
                                        [c, net] = fcn1(mappedA, lbs, rate, x(2), 'trainscg');
                                        acc = [acc, 1-c];
                                    end
                                    acc_average = mean(acc);

                                    if avg_acc{LayerNum}(nonzeros(Locb)) >= acc_average%��2�����׼ȷ����avg_acc(Locb)���Ƚ�
                                        b = ceil(x_2);
                                    else
                                        a = floor(x_1);
                                    end

                                    gold_point{LayerNum} = [gold_point{LayerNum}, x(2)]
                                    avg_acc{LayerNum} = [avg_acc{LayerNum}, acc_average]		 	 		
                                % ��x���������ֶ���gold_point�ظ��������switch
                            end

                            % ��round(x_1) == round(x_2)ʱ����round(x_1)Ϊ������ڵ�����������
                            % ������ɺ���ֹͣwhile()ѭ��
                            if round(x_1) == round(x_2)
                                flag = 0;
                            end

                        end
                        Nh = [Nh, x(1)];
                    end
                % �ƽ�ָѰ�Ž�����
                % ������       
                hiddenNumInfor = struct();
                hiddenNumInfor.dataset = hmenu4_1.UserData.matPath;    % ��ʹ�õ����ݼ�����
                hiddenNumInfor.rate = paraTable_c.rate;                             % ��ʹ�õ�ѵ����ռ��
                hiddenNumInfor.drAlgorithmName = hmenu4_1.UserData.drAlgorithm;  % ��ά�㷨����
                hiddenNumInfor.drDimesion = size(hmenu4_3.UserData.drData, 2);          % ��άά��
                hiddenNumInfor.cAlgorithmName = hmenu4_1.UserData.cAlgorithm;      % �����㷨����
                hiddenNumInfor.hiddenLayerNum = paraTable_c.hiddenLayerNum;         % ������Ĳ���
                % �������������ʹ�õĴ��ݺ�������
                hiddenLayerName = [paraTable_c.transferFcn]; %transferFcn, transferFcn1, transferFcn2, transferFcn3, transferFcn4
                for i =1:paraTable_c.hiddenLayerNum-1
                    estr = ['hiddenLayerName = [hiddenLayerName, paraTable_c.transferFcn', num2str(i),'];'];
                    eval(estr);
                end
                hiddenNumInfor.hiddenLayerName = hiddenLayerName; 

                hiddenNumInfor.startNum = paraTable_c.startNum;
                hiddenNumInfor.stopNum = paraTable_c.startNum;
                % ��Ѱ�ҵ�����������net��gold_point, avg_acc,Ѱ����ϢhiddenNumInfoһ�𱣴�Ϊmat���ݡ�
                filename = fullfile('C:\Matlab��ϰ\Project20191002\���̲���\', ['net_optim ', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS'), '.mat']); %��ʱ����Ϣ���뵽�ļ�����
                save(filename, 'hiddenNumInfor', 'gold_point', 'avg_acc');

                % ���ҵ��ĸ�������ڵ���������ֵ��ֵ��paraTable_c�е���Ӧ����(����ֻ���ǵ���������)
                if paraTable_c.hiddenLayerNum==1
                    paraTable_c.hiddenNum=Nh(1);
                    for i = 1:paraTable_c.hiddenLayerNum-1
                        estr = ['paraTable_c.hiddenNum', num2str(i), '=Nh(',num2str(i+1),');' ];
                        eval(estr);
                    end
                end
                % �ƽ�ָѰ�Ž���������                    
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
    var = cellfun(@string, para(9:end)); %��cell array�е�����cellӦ��string

        for k = 1 : n
            [mA1, mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate);  % rate: ��ʹ�õ�ѵ����ռ��
            XTrain = table2array(mA1(:, 1:end-1))';  %mappedA��mA����ÿһ��Ϊһ����������XTrain��ÿһ��Ϊһ��������
        %     TTrain = dummyvar(double(mA1.Class))';
            TTrain = ind2vec(double(mA1.Class)');
            XTest = table2array(mA2(:, 1:end-1))';
        %     TTest = dummyvar(double(mA2.Class))';
            TTest = ind2vec(double(mA2.Class)');
            disp(['��',num2str(k),'�μ���']);
            [netTrained, trainRecord, predictedVector, misclassRate, cmt] = classDemo(XTrain, TTrain, XTest, TTest, type, var);%ǰ3��Ϊ�������������Ϊ��ѡ����
            %��������ܸ������м�ֵ�ļ������ǣ� [net tr tTest c cm], 
            % ����дΪnetTrained, trainRecord, predictedVector, misclassRate, cmt
            % netTrained����net��ѵ���õ�����
            % trainRecord����tr��ѵ����¼�ṹ�壬������tr.best_perf ѵ����������ܣ���ɫ���ߣ���
            % tr.best_vperf ��֤��������ܣ���ɫ���ߣ���tr.best_tperf ���Լ�������ܣ���ɫ���ߣ�
            % predictedVector����tTest��ΪԤ�������ǩ������
            % misclassRate�����������󷵻�ֵ�ĵ�һ��ֵc, ����ʣ���ֵ����1-acc����1-c����׼ȷ��OA
            % cmt����cm, ��������
            % ��������ֵ����cell array�����ں���f_TANSIG(), f_RBF(), f_BP()����������ֵ����1��1 cell array��
            % ���ں���f_GA_TANSIG(), f_GA_RBF(), f_GA_BP()��f_PSO_TANSIG(), f_PSO_RBF(), f_PSO_BP()��
            % ��������ֵ����2��1 cell array��
            
            % ÿ����һ�Σ�����һ��׼ȷ�ʼ���������
            acc(k, :) = cellfun(@(x) 1-x, misclassRate);
            racc(k, :) = 1-acc(k, :);                                % racc ����ʣ����������󷵻�ֵ�еĵ�һ��ֵc, ��ֵΪ1-acc
            err_perf(k, :) = cellfun(@(x) x.best_perf, trainRecord);     %trainRecord.best_perf ѵ����������ܣ���ɫ���ߣ�
            err_vperf(k, :) = cellfun(@(x) x.best_vperf, trainRecord);  %trainRecord.best_vperf ��֤��������ܣ���ɫ���ߣ�
            err_tperf(k, :) = cellfun(@(x) x.best_tperf, trainRecord);   %trainRecord.best_tperf ���Լ�������ܣ���ɫ���ߣ�  
            
            for iset = 1:setsNum
                cmNormalizedValues1(:, :, k, iset) = cmt{iset};
                % ����ҵ���������net����Ԥ�������Ƚ���������Ż�ǰ�����׼ȷ�ʻ������Ż�������׼ȷ�ʣ�
                % ��¼һ���Ż�ǰ�����ֵ����¼һ���Ż�������ֵ��
                % ����Ż�ǰ����������׼ȷ�ʲ��Ƿ���ͬһ�Σ���k�Σ���ô�죿
                % ��¼�Ż�ǰ���Ż��������ֵ
                if acc(k, iset) > acc_best(iset, iset)    
                    % acc_best(1,1)�����Ż�ǰ�����accֵ; acc_best(2, 2)�����Ż�������accֵ
                    % acc_best(1,2)�����Ż�ǰ�����accֵ��Ӧ���������Ż����׼ȷ��ֵ
                    % acc_best(2,1)�����Ż�������accֵ��Ӧ���������Ż�ǰ��׼ȷ��ֵ
                    acc_best(iset, :)=acc(k, :);
                    net_best(iset, :)=netTrained;
                    tTest_best(1, iset)=predictedVector(iset);
                    % tTest_best{1,1}�����Ż�ǰ�������accֵ�������Ԥ�����������
                    % tTest_best{1,2}�����Ż���������accֵ�������Ԥ�����������                  
                end
            end
 
        end
        info_1 = hmenu4_1.UserData;
        info_1.cElapsedTime = toc(timerVal_1)-time1; % �����������ʱ��
    
        %% ��������������ݻ�������cmNormalizedValues1������OA, AA, Kappa��
        [size1, size2, size3, size4] = size(cmNormalizedValues1);  % 16��16��20��2 double
        cmt = cmNormalizedValues1;
%         load('���̲���\20220517\cmNormalizedValues1.mat','cmt'); %���ڲ���
%         [size1, size2, size3, size4] = size(cmt);   % huston.mat���ݼ��Ļ�������ߴ磺15��15��20��2
        
        %# �ȼ���TPR
        Ns = sum(sum(cmt(:, :, 1, 1)));   %���Լ���������
        p_o = sum(squeeze(sum(cmt.*repmat(eye(size1),1,1,size3, size4), 2)))/Ns; % 1��20��2
        p_e = sum( squeeze(sum(cmt)).*squeeze(sum(cmt,2)) )/Ns^2; % 1��20��2
        Kappa = (p_o - p_e)./(1 - p_e);% 1��20��2
        OA = single(p_o);            %1��20��2
        TPR = single(squeeze( sum(cmt.*repmat(eye(size1),1,1,size3,size4), 2)./sum(cmt, 2) ));%15��20��2
        AA = mean(TPR);  %1��20��2
        % ���������20�У���Ҫ�õ�ƽ��ֵ��Ӧ�ö�TPR��OA�� AA��Kappa������ƽ������mean(TPR, 2);
        c = zeros(size2+3, size3+2, size4,'single');
        % size2+3��ʾ���Ϸ�����������OA�� AA��Kappa�������ݡ�
        % size3+2��ʾ���з�����������average��std���С�
        c(1 : size2, 1:size3, :) = TPR; 
        c(size2+1, 1:size3, :) = OA; 
        c(size2+2, 1:size3, :) = AA; 
        c(size2+3, 1:size3, :) = Kappa;
        c(:, size3+1, :) = mean(c(:, 1:size3, :), 2);
        c(:, size3+2, :) = std(c(:, 1:size3, :), 0, 2); %�Ծ���������׼��ȼ���% std(permute(c(:, 1:size3, :),[2,1,3]));
        % c�����ճߴ�Ϊ18��22��2

    %% ��������д��Excel���
     %Ϊcell��ÿһ�д��������� VariableNames
        VariableNames = cell(1,size3+2);
        for i = 1:size3
            VariableNames{i}= ['iter_',num2str(i)];
        end
        VariableNames(size3+1 : size3+2)  = {'average', 'std'};
        % �����е����� RowNames���������ַ�Ԫ������ ��1��(15+3) cell��
        RowNames = cell(1, size1+3); % 3�зֱ���OA��AA��kappa��
        for i = 1:size(cmt, 1)
            RowNames{i} = ['class_',num2str(i)];
        end
        RowNames(i+1 : end) = {'OA', 'AA', 'Kappa'};
        
        %# ����Excel�ļ������ַ
        path = ['C:\Matlab��ϰ\Project20191002\���̲���\', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS')];
        try
            path = fullfile(path, hmenu4_1.UserData.datasetName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
        catch
        end
        if ~exist(path, 'dir')
            [status,msg,msgID] = mkdir(path);
        end
            filename = [hmenu4_1.UserData.datasetName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
        try
            filename = fullfile(path,filename);%ƴ��·��
        catch
        end
        
        for iset = 1:size4
            accTable = array2table(c(:, :, iset), 'VariableNames', VariableNames);
            accTable.Properties.RowNames = RowNames;
            % Sheet 1�����Ż�֮ǰ�ķ�������Sheet 2�����Ż�֮��ķ�������
            writetable(accTable,filename,'Sheet',iset,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);
        end
        %% �����йط��������������õ���ϸ��Ϣ������Sheet��
        % ���潵ά�������������paraTable_c��Sheet(iset+1)����Sheet 3��
        writetable(paraTable_c, filename, 'Sheet',iset+1,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);
        
        %# �������ݼ���Ϣhmenu4_1.UserData��Sheet(iset+1)
        %info_1 = hmenu4_1.UserData;
        info_1.x3 = [];
        info_1.lbs2 = [];
        info_1.x2 = [];
        info_1.lbs = [];
        info_1.cmap = [];
        % info_1.elapsedTimec = toc(timerVal_1)-time1; % �����������ʱ��
        info_1 = struct2table(info_1, 'AsArray',true);
        writetable(info_1, filename, 'Sheet',iset+1,'Range','A3', 'WriteRowNames',true, 'WriteVariableNames', true);
        %# ��������cmap
        info_cmap = hmenu4_1.UserData.cmap;
        VariableNames = ["R","G","B"]; %VariableNames����Ϊ�ַ�����Ԫ������{'R','G','B'}��
        % ����ָ������������ƣ������ַ�������["R","G","B"]���ַ�����Ԫ������{'R','G','B'}��ָ����Щ���ơ�
        % �����е����� RowNames����ʽΪ�ַ�������["1","2","3"]���ַ�����Ԫ������{'1','2','3'}��
        RowNames = string(1:size(info_cmap,1)); % ��
        info_cmap = array2table(info_cmap, 'VariableNames', VariableNames);
        info_cmap.Properties.RowNames = RowNames;
        writetable(info_cmap,filename,'Sheet',iset+1,'Range','A5', 'WriteRowNames',true, 'WriteVariableNames', true);
       
        %% ����ѵ�������е���������err_perf, err_vperf, err_tperf, racc��Excel��Sheet
        T1 = createTableForWrite(err_perf, err_vperf, err_tperf, racc);
        errTable = [T1.Variables; mean(T1.Variables); std(T1.Variables)];  % T1.Variables ��20��8 double
        errTable = array2table(errTable, 'VariableNames', T1.Properties.VariableNames);
        errTable.Properties.RowNames = [T1.Properties.RowNames; {'average'}; {'std'}]; %����2�е�������
        filename = "C:\Matlab��ϰ\Project20191002\���̲���\2022-06-04 19-45-16\Botswana\LDA\GA_TANSIG\Botswana_LDA_GA_TANSIG.xlsx";
        errTable.Properties.Description = '����ѵ�������е���������err_perf, err_vperf, err_tperf, racc';
        writetable(errTable,filename,'Sheet',iset+2,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true); 

        %## ����view(net)ͼ����ϸ�ο�C:\Matlab��ϰ\Project20191002\save_view(net).m
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
        filename_2 = fullfile(path,"net_best{2,2}");%ƴ��·��
        set(hFig, 'PaperPositionMode', 'auto');
        saveas(hFig, filename_2);        % ����Ϊfig
        saveas(hFig, filename_2,'jpg'); %����Ϊjpg
        %# close figure
        close(hFig);

        %# ����net_best{}Ϊ"net_best.mat"
        % net_best{1,1}�����Ż�ǰ�������accֵ������; net_best{2, 2}�����Ż���������accֵ������
        % net_best{1,2}�����Ż�ǰ�������accֵ���������Ż��������
        % net_best{2,1}�����Ż���������accֵ���������Ż�ǰ������
        filename_2 = fullfile(path,"net_best.mat");%ƴ��·��
        save(filename_2, 'net_best');
        
        %% ����net_best{2,2}�Ļ�������ͼ��ROCͼ
        % load("C:\Matlab��ϰ\Project20191002\���̲���\2022-06-02 16-46-57\Botswana\PCA\GA_TANSIG\net_best.mat");
        % load("C:\Matlab��ϰ\Project20191002\���̲���\2022-06-04 02-35-46\Botswana\PCA\PSO_RBF\net_best.mat");
        netBest = net_best{2,2};
        YTest = netBest(mappedA'); 
        % mappedA��ÿһ��Ϊһ�������������뵽train()��net()��sim()������XTest XTrain���뱣֤ÿһ��Ϊһ��������
        % net()�ķ���ֵ����Ϊone-hot-vector��ÿһ�д���һ������������������           
        TTest = ind2vec(lbs');
        figure()
        f = plotconfusion(TTest, YTest); %���������confusion()����ͬ
        f.Units = 'normalized';
        f.Position = [0.2375, 0.000926, 0.5562, 0.9315];  % ����14�����Ļ�������ͼ����ѳߴ�
        f.Children(1).FontName = 'MS Sans Serif';
        
        f.Children(2).Title.String = '��������';
        f.Children(2).XLabel.String = '��ʵ���';
        f.Children(2).YLabel.String = 'Ԥ�����';
        f.Children(2).XTickLabelRotation = 0;
% f.Children(2).Children
% ans = 
%     677��1 graphics ����:
% 
%   Line
%   Line
%   Text     (5.2%)
%   Text     (94.8%)
%   Patch
%   Text     (4.0%)
%   Text     (96.0%)
%   Patch
%   ����
%   Text     (8.3%)
%   Text     (270)
%   Patch
        % path = "C:\Matlab��ϰ\Project20191002\���̲���\2022-06-02 16-46-57\Botswana\PCA\GA_TANSIG";
        filename_2 = fullfile(path,"net_best{2,2}_"+"originConfusion");%ƴ��·��
        saveas(gcf, filename_2);        % ԭʼ�������󱣴�Ϊfig
        
        %# ���������Ҫ����ķ�Χ��i=1:14,j=1:14����ÿһ�������еİٷ���ȥ��
        N = hmenu4_1.UserData.M-1;     % �������
        for i = 1:N
            for j = 1:N
                %for k = 1:2
                idx_1 = 2+(15-j)*15*3+(15-i) *3+1;
                % ��ÿһ�������еİٷ���ȥ��
                f.Children(2).Children(idx_1).String='';
                % ��ÿһ�������е�����λ�õ������������м� 
                idx_2 = 2+(15-j)*15*3+(15-i) *3+2;
                f.Children(2).Children(idx_2).VerticalAlignment = 'middle';
                % ��ÿһ�����ӵ���ɫ�޸�Ϊ������ɫ,����Ʒ��ɫ[0.8529 0.4686  0.6765 ]
                % confusion matrixĬ�ϵĸ��ӵ�ɫ1 ǳ��ɫ [0.9765 0.7686 0.7529]; 
                % confusion matrixĬ�ϵĸ��ӵ�ɫ2 ǳ��ɫ [0.7373 0.9020 0.7686];  
                idx_3 = 2+(15-j)*15*3+(15-i) *3+3;
                f.Children(2).Children(idx_3).FaceColor = [0.8529 0.4686  0.6765];
            end
        end
        % ����������Խ����ϵ�ÿ�����ӵ���ɫ����Ϊǳ��ɫ[0.6686 0.8529 0.9765 ]
        for i = 1:N
            idx_3 = 2+(15-i)*15*3+(15-i) *3+3;
            f.Children(2).Children(idx_3).FaceColor = [0.6686 0.8529 0.9765];
        end
        % �޸����ұ�һ�к�������һ�е��������ɫ
        % confusion matrixĬ�ϵ�������ɫ1 ��ɫColor: [0.8863 0.2392 0.1765]
        % confusion matrixĬ�ϵ�������ɫ2 ��ɫColor: [0.1333 0.6745 0.2353]
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
        
        %# ���������ʽ�޸���ϣ����Ա���
        filename_2 = fullfile(path,"net_best{2,2}_"+"simpleConfusion");%ƴ��·��
        saveas(gcf, filename_2);        % �򻯺�Ļ������󱣴�Ϊfig
        saveas(gcf, filename_2,'jpg'); % �򻯺�Ļ������󱣴�Ϊjpg
        
        %## ����ROC����
        %#ROCԭʼ����
        figure()
        f = plotroc(TTest, YTest);
%         f.Children
%         ans = 
%           3��1 graphics ����:
%           UIControl
%           Legend       (Class 1, Class 2, Class 3, Class 4, Class 5, Class 6, Clas��)
%           Axes         (ROC)       filename_2 = fullfile(path,"net_best{2,2}_"+"originROC");%ƴ��·��
        filename_2 = fullfile(path,"net_best{2,2}_"+"originROC");
        saveas(gcf, filename_2);        % ����Ϊfig
        %# ��ROCͼ���и�ʽ��
        f.Children(3).Title.String = '�����߲�����������'; % (receiver operating characteristic curve
        f.Children(3).XLabel.String = '��������'; %False Positive Rate
        f.Children(3).YLabel.String = '��������'; %True Positive Rate
        filename_2 = fullfile(path,"net_best{2,2}_"+"�����߲�����������");
        saveas(gcf, filename_2);        % ����Ϊfig
        saveas(gcf, filename_2,'jpg'); %����Ϊjpg

        %#ROC�ֲ��Ŵ����� [0, 0.5] [0.5, 1]
        %filename_2 = fullfile(path,"net_best{2,2}_"+"zoomROC");%ƴ��·��
        filename_2 = fullfile(path,"net_best{2,2}_"+"�����߲����������߾ֲ��Ŵ�");%ƴ��·��
        f.Children(3).XLim = [0, 0.5];
        f.Children(3).YLim = [0.5, 1];
        %saveas(gcf, filename_2);        % ����Ϊfig
        saveas(gcf, filename_2,'jpg'); %����Ϊjpg
        %#ROC�ֲ��Ŵ����� [0, 0.25] [0.75, 1]
        %filename_2 = fullfile(path,"net_best{2,2}_"+"zoomROC2");%ƴ��·��
        filename_2 = fullfile(path,"net_best{2,2}_"+"�����߲����������߾ֲ��Ŵ�2");%ƴ��·��
        f.Children(3).XLim = [0, 0.25];
        f.Children(3).YLim = [0.75, 1];
        %saveas(gcf, filename_2);        % ����Ϊfig
        saveas(gcf, filename_2,'jpg'); %����Ϊjpg        
% % ���Ե��ˣ�һ������       
        

        
        %% ����Ԥ���GTͼ����ʵ��GTͼ
        %YTest��net()�ķ���ֵ������Ϊone-hot-vector��ÿһ�д���һ������������������
        Ylbs = vec2ind(YTest)';  %vec2ind()�������������ݣ�Ҫ������one-hot-vector��������ɵľ���
        %Ylbs��ʾԤ���lbs
%         lbsTest = lbs;
%         lbsTest(ind2Best) = tTest_best;         %tTest ΪԤ�������ǩ������%��Ԥ��ֵ����lbs�е���ʵֵ
%                                                               %tTestBestΪn��Ԥ�������ǩ�����������ŵ��Ǹ�
%         hObject.UserData.lbsTest = lbsTest; %���������Ԥ��ֵ�ı�ǩ����
%         
        gtdata = handles.UserData.gtdata;
        gtdata(gtdata~=0)=Ylbs;    %����ǩ�������г�GTͼ
        Ygtdata = gtdata; %Ygtdata��ʾԤ���gtdata
%         hObject.UserData.imgNew = double(gtdata);%����Ԥ�������GTͼ
%         handles.UserData.imgNew = hObject.UserData.imgNew;
%         %����Ԥ���GTͼ����ʵ��GTͼ
%         SeparatePlot3_Callback(handles.UserData.imgNew, handles.UserData.cmap, handles.UserData.M);
%         SeparatePlot3_Callback(handles.UserData.gtdata,    handles.UserData.cmap, handles.UserData.M);
%         SeparatePlot4_Callback(handles.UserData.gtdata, handles.UserData.imgNew, handles.UserData.cmap, handles.UserData.M);

        % ��ʱ��hObject��hmenu4_4_2��Text: 'ClassDemo'��Type: 'uimenu'
        % ��ʱ�� handles.UserData.gtdata: [1476��256 double]

        filename_2 = fullfile(path,"net_best{2,2}_"+"Ԥ��ͼ");%ƴ��·��
        SeparatePlot3_Callback(Ygtdata, handles.UserData.cmap, handles.UserData.M);
        saveas(gcf, filename_2);        % ����Ϊfig
        saveas(gcf, filename_2,'jpg'); %����Ϊjpg
        filename_2 = fullfile(path, [hmenu4_1.UserData.datasetName, 'GTͼ']);%ƴ��·��
        SeparatePlot3_Callback(handles.UserData.gtdata,    handles.UserData.cmap, handles.UserData.M);
        saveas(gcf, filename_2);        % ����Ϊfig
        saveas(gcf, filename_2,'jpg'); %����Ϊjpg
        
        %# SeparatePlot4_Callback()������ƶ���˫ͼģʽ��GTͼvsԤ��ͼ�����ֶ����������ͼƬ
        SeparatePlot4_Callback(handles.UserData.gtdata, Ygtdata, handles.UserData.cmap, handles.UserData.M);      
        filename_2 = fullfile(path,"net_best{2,2}_"+"GTͼ��Ԥ��ͼ");%ƴ��·��
        % �ֶ�ִ���������䣬�ɱ��浱ǰfigure
%         saveas(gcf, filename_2);        % ����Ϊfig
%         saveas(gcf, filename_2,'jpg'); %����Ϊjpg
        
        %% ������������
        %# ����ѵ�������е���������err_perf, err_vperf, err_tperf, racc
        
        %# ���ƴ���������
        figure()
        plotErr(err_perf, err_vperf, err_tperf, racc, 4);
            %racc ����ʣ�������
            %err_perf ѵ����������ܣ���ɫ���ߣ�
            %err_vperf ��֤��������ܣ���ɫ���ߣ�
            %err_tperf ���Լ�������ܣ���ɫ���ߣ�
            %tTest ΪԤ�������ǩ������        
        filename_2 = fullfile(path, [num2str(n), '������ѵ����������_�����']); %ƴ��·��
        saveas(gcf, filename_2);        % ����Ϊfig
        saveas(gcf, filename_2,'jpg'); %����Ϊjpg
        %# ����׼ȷ������       
        % load("C:\Matlab��ϰ\Project20191002\���̲���\2022-06-04 19-45-16\Botswana\LDA\GA_TANSIG\racc,err_perf,err_vperf,err_tperf.mat")
        figure()
        plotAcc(1-err_perf, 1-err_vperf, 1-err_tperf, acc, 4);
        filename_2 = fullfile(path, [num2str(n), '������ѵ����������_׼ȷ��']); %ƴ��·��
        saveas(gcf, filename_2);        % ����Ϊfig
        saveas(gcf, filename_2,'jpg'); %����Ϊjpg
        %% ��ʾ������ʱ
        time2 = toc(timerVal_1);
        % filename = [hmenu4_1.UserData.datasetName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
        % filename = fullfile(path, filename);
        disp({[hmenu4_1.UserData.matPath, ' �������! ��ʱ',num2str(time2-time1),'��.']});
        disp(['��������ϸ���ݱ�����',filename]);
        
        %delete(MyPar) %������ɺ�رղ��д����

        
    % �������������ϣ�δѡ��[ִ�н�ά]��ֱ��ѡ��[ִ�з���]����ѯ���Ƿ�����classificationLearner    
    else
            quest = {'\fontsize{10} ����δִ�н�ά��ֱ�ӷ�����Ҫ�ķѽϳ�ʱ�䡣����ʹ��δ��ά������ֱ�ӷ��࣬��ѡ������һ�ַ��෽ʽ��',...
                         '����ʹ�þ�����ά�����ݽ��з��࣬���ȵ����exit���˳�������ڲ˵���ѡ��[\bf����\rm]>>[\bfִ�н�ά\rm]'};
                     % \fontsize{10}�������С���η���������ʹ�������ַ���С��Ϊ10����
                     % \bf������Ӵ����η���������ʹ�������ַ�����Ϊ�Ӵ����壬�����η���һֱ���õ��ı���β��ֱ����������һ�������ʽ���η�������\rm��ʱ��ֹ��
                     % \rm�������������η���������ʹ�������ַ�����Ϊ�������壬�����η���һֱ���õ��ı���β��ֱ����������һ�������ʽ���η�ʱ��ֹ��
            dlgtitle = '���෽ʽѡ��';
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
                    disp([answer ' ����.'])
                    %dessert = 1;
                    if ~exist('t0','var') || isempty(t0) || size(x2,1)~=size(t0,1)
                        t0 = createTable(x2, lbs);
                        [t1,t2] = createTwoTable(x2,lbs,rate);
                        mA = createTable(mappedA, lbs);
                        [mA1,mA2] = createTwoTable(mappedA,lbs,rate);
                    end
                    classificationLearner
                                        
                case 'ClassDemo'
                    disp([answer ' ���ཫ����ִ��.'])
                    %dessert = 2;
                    n = paraTable_c.executionTimes;
                    try
                        MyPar = parpool; %������г�δ��������򿪲��д����
                    catch
                        MyPar = gcp; %������г��Ѿ��������򽫵�ǰ���гظ�ֵ��MyPar
                    end

                    racc = [];
                    best_perf = []; 
                    best_vperf = []; 
                    best_tperf = [];  
                    tTestBest = [];
                    raccBest = 1;  						
                    for k = 1 : n
                        [mA1,mA2, ind1, ind2] = createTwoTable(mappedA,lbs,rate);
                        XTrain = table2array(mA1(:, 1:end-1))';           %XTrainÿһ��Ϊһ������
                        TTrain = ind2vec(double(mA1.Class)');
                        %%����ʹ��ϡ�������ʽ����������ѵ�����罫�ᵼ���ڴ�ռ��̫�����Ի��ǻ��������������ʽ��TTrain��
                        % TTrain = double(mA1.Class)';
                        XTest = table2array(mA2(:, 1:end-1))';             %XTestÿһ��Ϊһ������                
                        TTest = ind2vec(double(mA2.Class)');            %TTestÿһ��Ϊһ������ǩ
                        disp(['��',num2str(k),'�μ���']);
                        [net, tr, tTest, c, cm] = classDemo(XTrain, TTrain, XTest, TTest, type, var);%ǰ3��Ϊ�������������Ϊ��ѡ����
                        %��������ܸ������м�ֵ�ļ������ǣ� net tr tTest c cm 
                        % net��ѵ���õ�����
                        % tr��ѵ����¼�ṹ�壬������best_perf ѵ����������ܣ���ɫ���ߣ���best_vperf ��֤��������ܣ���ɫ���ߣ���best_tperf ���Լ�������ܣ���ɫ���ߣ�
                        %tTest ΪԤ�������ǩ������
                        % c, ����ʣ������ʣ�1-c����׼ȷ��OA
                        % cm, ��������                        

                        racc = [racc; err1];%racc ����ʣ�������
                        best_perf = [best_perf; err2]; %best_perf ѵ����������ܣ���ɫ���ߣ�
                        best_vperf = [best_vperf; err3]; %best_vperf ��֤��������ܣ���ɫ���ߣ�
                        best_tperf = [best_tperf; err4];%best_tperf ���Լ�������ܣ���ɫ���ߣ�

                        % ��ѡ�����ŷ��������µ�tTest;
                        [m, m1] = min(err1); %������Сֵ��������
                        if m<raccBest
                            raccBest = m;
                            tTestBest = tTest(:, m1);
                            ind2Best = ind2;
                            ma2Class = mA2.Class;
                        end 
                    end

                %% �����������浽hObject.UserData��
                    hObject.UserData.racc = racc;
                    hObject.UserData.best_perf = best_perf;
                    hObject.UserData.best_vperf = best_vperf;
                    hObject.UserData.best_tperf = best_tperf;
                    %hObject.UserData.lbsOrigin = lbs;
                    acc = 1-racc;                   %acc׼ȷ�ʣ�racc ����ʣ�������
                    acc_perf = 1-best_perf;    %best_perf ѵ����������ܣ���ɫ���ߣ�
                    acc_vperf = 1-best_vperf; %best_vperf ��֤��������ܣ���ɫ���ߣ�
                    acc_tperf = 1-best_tperf;  %best_tperf ���Լ�������ܣ���ɫ���ߣ�

                %% ��������д��Excel���
                    % ���ȴ���һ�������Բο�table_example20190310.mlx
                    T = createTableForWrite(best_perf, best_vperf, best_tperf, racc)
                    %T = table(best_perf, best_vperf, best_tperf, racc, 'RowNames',arrayfun(@string, [1:numel(racc)]'))
                    % ���ñ���·��
                    path = ['C:\Matlab��ϰ\Project20191002\���̲���\', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS')];
                    try
                        path = fullfile(path, hmenu4_1.UserData.datasetName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
                    catch
                    end
                    if ~exist(path, 'dir')
                        [status,msg,msgID] = mkdir(path);
                    end
                        filename = [hmenu4_1.UserData.datasetName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
                    try
                        filename = fullfile(path,filename);%ƴ��·��
                    catch
                    end
                    writetable(T,filename,'Sheet',1,'Range','A1', 'WriteRowNames',true);
                    T1 = createTableForWrite(acc_perf, acc_vperf, acc_tperf, acc)
                    %T1 = table(acc_perf, acc_vperf, acc_tperf, acc, 'RowNames',arrayfun(@string, [1:numel(acc)]'))
                    %filename = [hmenu4_1.UserData.datasetName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
                    writetable(T1,filename,'Sheet',2,'Range','A1', 'WriteRowNames',true);  

                    %% ����Ԥ���GTͼ����ʵ��GTͼ
                    lbsTest = lbs;
                    lbsTest(ind2Best) = tTestBest;         %tTest ΪԤ�������ǩ������%��Ԥ��ֵ����lbs�е���ʵֵ
                                                                          %tTestBestΪn��Ԥ�������ǩ�����������ŵ��Ǹ�
                    hObject.UserData.lbsTest = lbsTest; %���������Ԥ��ֵ�ı�ǩ����

                    gtdata = handles.UserData.gtdata;
                    gtdata(gtdata~=0)=lbsTest;    %����ǩ�������г�GTͼ

                    hObject.UserData.imgNew = double(gtdata);%����Ԥ�������GTͼ
                    handles.UserData.imgNew = hObject.UserData.imgNew;
                    %����Ԥ���GTͼ����ʵ��GTͼ
                    SeparatePlot3_Callback(handles.UserData.imgNew, handles.UserData.cmap, handles.UserData.M);
                    SeparatePlot3_Callback(handles.UserData.gtdata,    handles.UserData.cmap, handles.UserData.M);
                    SeparatePlot4_Callback(handles.UserData.gtdata, handles.UserData.imgNew, handles.UserData.cmap, handles.UserData.M);

                    %% ����confusion matrix
                    % plotconfusion()���������ݿ�����categorical������
                    % Ҳ�����������ɸ�one-hot vector��������ɵľ���
                    % �������͵����ݻᵼ����ѭ����
                    figure()
                    pf = plotconfusion(ma2Class, categorical(tTestBest));
                    %���浱ǰͼ���е�ͼƬ
                    %filename = generateFilename(path, handles, fmt);
                    %filename = generateFilename('20200627', handles, ['_',num2str(pf.Number),'.fig']);
                    %saveas(pf, filename);        

                    %% ������������>>>������

                    figure()
                    plotErr(best_perf, best_vperf, best_tperf, racc, 4);
                        %racc ����ʣ�������
                        %best_perf ѵ����������ܣ���ɫ���ߣ�
                        %best_vperf ��֤��������ܣ���ɫ���ߣ�
                        %best_tperf ���Լ�������ܣ���ɫ���ߣ�
                        %tTest ΪԤ�������ǩ������        


                    %% ������������>>>>׼ȷ��       
                    figure()
                    plotErr1(acc_perf, acc_vperf, acc_tperf, acc, 4);

                    %% ��ʾ������ʱ
                    time2 = toc(timerVal_1);
                    disp({[hmenu4_1.UserData.matPath, ' �������! ��ʱ',num2str(time2-time1),'��.']});
                    
                    delete(MyPar) %������ɺ�رղ��д����   
                case 'exit'
                    disp('ClassDemo�Ѿ��˳�.')
                    %dessert = 0;
            end    
       
    end
    path = ['C:\Matlab��ϰ\Project20191002\���̲���\', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS')];
    saveAllFigure(path,handles,'.fig');
    gc = gcf; 
    closeFigure([2:gc.Number]);
%     closeFigure([2:13]);
end

%% �Ӻ��������ڻƽ�ָѰ����������ѽڵ�����
function [c, net] = fcn1(mappedA, lbs, rate, hiddenSizes, trainFcn)
    % ��������
    [mA1, mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate);  % rate: ��ʹ�õ�ѵ����ռ��
    XTrain = table2array(mA1(:, 1:end-1))';
    TTrain = ind2vec(double(mA1.Class)');
    %%����ʹ��ϡ�������ʽ����������ѵ�����罫�ᵼ���ڴ�ռ��̫�����Ի��ǻ��������������ʽ��TTrain?
    % �����Ļ����ʹ������net(XTest)��õ�outputsҲ��һ��������ʽ���������������confusion(targets,outputs)
    % �Զ�����������ݵ���ʽҪ�����Բ���ֱ�����뵽confusion(targets,outputs)��
    % confusion()Ҫ�������targets������S��Q�ľ�����ʽ����ÿһ�б�����one-hot-vector��outputsҲ������S��Q�ľ�����ʽ
    % outputs��Ԫ��ֵ��Сλ��[0,1]֮�䣬��ÿһ�е����ֵ��Ӧ��������S���е�һ����
    % ���ң�����outputs��������ת����ϵ������ʱ�ᱨ��
    % ���Բ��ò�����ʹ��ϡ�������ʽ��TTrain����Ϊѵ��������������ݡ�
    % ������δ�����м�����������û�г��ֹ�����ġ�
    XTest = table2array(mA2(:, 1:end-1))';
    TTest = ind2vec(double(mA2.Class)');                                
    %��������
    net = feedforwardnet(hiddenSizes, trainFcn); %feedforwardnet(x(i),'trainscg')
    % ���ò��� (������trainscg����ز�����������trainscg�鿴)
    net.trainParam.epochs = 1000;
    net.trainParam.show = 10;
    net.trainParam.showWindow = false;
    % ѵ������
    [net, tr] = train(net, XTrain, TTrain);   %���ܿ����м��㣬����ᴥ���ڴ�ռ�ù���ľ��棡
    %. ��������
    YTest = net(XTest); 
    %. ��������
    [c,cm,ind,per] = confusion(TTest,YTest);
end
