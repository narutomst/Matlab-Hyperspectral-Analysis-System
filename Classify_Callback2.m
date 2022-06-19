%%���û�ѡ��ClassDemo������󣬱���������
function Classify_Callback2(hObject, eventdata, handles) %��113��
global x3 lbs2 x2 lbs mappedA Inputs Targets Inputs1 Inputs2 Inputs3 t0 t1 t2 mA mA1 mA2
%% ���ݴ�����άmatת��ά����άgtתһά��
% hmenu4 = findobj(handles,'Tag','Analysis');
hmenu4_1 = findobj(handles,'Label','��������');
hmenu4_3 = findobj(handles,'Label','ִ�н�ά');

if isempty(hmenu4_3.UserData) || ~isfield(hmenu4_3.UserData, 'drData') || isempty(hmenu4_3.UserData.drData)
    mappedA = double(hmenu4_1.UserData.x2);         %������δ����ά���ӡ��������ݡ�����ȡ����
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
%   1��28 table 
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
%   TableProperties - ����:
% 
%              Description: ''
%                 UserData: []
%           DimensionNames: {'Row'  'Variables'}
%            VariableNames: {1��28 cell}
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
    validateattributes(paraTable_c.hLayerNumOptimization,{'logical'},{'integer'},'','hLayerNumOptimization',26);
    if paraTable_c.hLayerNumOptimization
        validateattributes(paraTable_c.startLayerNum,{'numeric'},{'integer','positive','>=',1,'<=',4},'','startNum',27);
        validateattributes(paraTable_c.stopLayerNum,{'numeric'},{'integer','positive','>=',1,'<=',4},'','stopNum',28);
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
        time1 = toc(timerVal_1);
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

% ����λ��filename = "C:\Matlab��ϰ\Project20191002\���̲���\2022-06-12 14-07-04\Botswana\PCA\GA_TANSIG\Botswana_PCA_GA_TANSIG.xlsx";
% ������Ϊ2������������磬������ۻ�����Ѱ�ŵĽ����
% ���ڵ�һ��ڵ����Ż�ʱ���ڶ��㣨�Լ�������������Ľڵ���ʹ�õ���Ĭ�ϵ�20��
% ����һ�����һ���ƽ�ָ�㱻���뵽var�е�hiddenNum�����У������������׼ȷ�ʺ�
% ��һ��Ѱ�ž�����ˣ�����ͽ����˵ڶ��㣨��iLayer��1��Ϊ2����var�еĵ�һ��������ڵ�������hiddenNum�Ͳ��ٱ��Ķ���
% ͬ�����ڶ������һ���ƽ�ָ�㱻���뵽var�е�hiddenNum1�����У������������׼ȷ�ʺ�
% �ڶ���Ѱ�ž�����ˣ�����ͽ����˵����㣨��iLayer��2��Ϊ3����
% var�еĵ�һ��͵ڶ���������ڵ�������hiddenNum��hiddenNum1�Ͳ��ٱ��Ķ���
% ���ԣ�Classify_Callback2.m�����264~420�еĴ���飬�ر��ʺϴӵ�һ�������㿪ʼ���м䲻���㣬����N�������������ۻ�����Ѱ��

% ����Ŀǰ����excel�ļ�sheet 5 �л�õĵ�һ������Ļƽ�ָ�㣬������澹Ȼ���������Һ����������
% �����15~20���ƽ�ָ����[97, 95, 99, 94, 96, 98]
% ���ԣ������ջƽ�ָ���ȷ�������뻹��Ҫ�Ľ������ǵ�һ������

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
            answer_hiddenNumOptimization = questdlg(quest, dlgtitle, btn1, btn2, opts);
                                        
            % Handle response
            switch answer_hiddenNumOptimization
                case '��'
                    time_1 = toc(timerVal_1);
                    Ni = size(hmenu4_3.UserData.drData, 2); %�����ڵ�����ΪNi��10249x5 double
                    No = N; %�����ڵ�����ΪNo
                    Nh = []; %������ڵ�����ΪNh
                    gold_point = cell(1,paraTable_c.hiddenLayerNum);%��¼�ƽ�ָ��
                    acc_avg = cell(1,paraTable_c.hiddenLayerNum);   
                    % acc��ʾ������������׼ȷ�ʡ�OA��AA��Kappa���ڵ���������׼ȷ�����ݣ�
                    % acc_avg��ʾ20���ظ�����õ�����������׼ȷ�ʵ�ƽ��ֵ
                    OA_detail = cell(1,paraTable_c.hiddenLayerNum); %��¼�ڻƽ�ָ�����ظ�����20�λ�õ�20��OAֵ
                    %# �����״�������ڵ��Ż�ʱ��var����ΪclassDemo()�������������
                    OA_avg = cell(1,paraTable_c.hiddenLayerNum); % ��¼mean(OA_detail{iLayer})
                    time_goldSection = zeros(1,paraTable_c.hiddenLayerNum); %��¼ÿһ��ڵ����Ż������ĵ�ʱ��
                    
                    t = table2cell(paraTable_c);   
                    % t =
                    %   1��28 cell ����
                    %     {[1]}    {[0.2000]}    {[3]}    {[20]}    {["trainscg"]}    {[20]}    {["tansig"]}    {[0]}    {[0]}
                    %     {[0]}    {[0]}    {[0]}    {[0]}    {[2]}    {[20]}    {["tansig"]}    {[20]}    {["tansig"]}    {[20]}
                    %     {["tansig"]}    {[20]}    {["tansig"]}    {[1]}    {[1]}    {[100]}  {[1]}    {[1]}    {[4]}
                    k = numel(t);                        % 28
                    para = cell(1,2*k);                 % 1��56 cell ����
                    for i = 1:k
                        para{2*i-1} = paraTable_c.Properties.VariableNames{i};
                        para{2*i} = t{i};            
                    end
                    % para =
                    %   1��56 cell ����
                    %   �� 1 �� 8
                    %     {'dimReduce'}    {[1]}    {'rate'}    {[0.2000]}    {'app'}    {[3]}    {'executionTimes'}    {[20]}    
                    %   �� 9 �� 50
                    %     {'trainFcn'}  {["trainscg"]}    {'hiddenNum'}    {[20]}    {'transferFcn'}    {["tansig"]}    {'showWindow'}    {[0]}
                    %     {'plotperform'}    {[0]}    {'plottrainstate'}    {[0]}    {'ploterrhist'}    {[0]}    {'plotconfusion'}    {[0]}
                    %     {'plotroc'}    {[0]}    {'hiddenLayerNum'}    {[2]}    {'hiddenNum1'}    {[20]}    {'transferFcn1'}    {["tansig"]}
                    %     {'hiddenNum2'}    {[20]}    {'transferFcn2'}    {["tansig"]}    {'hiddenNum3'}    {[20]}    {'transferFcn3'}
                    %     {["tansig"]}    {'hiddenNum4'}    {[20]}    {'transferFcn4'}    {["tansig"]}    
                    %     {'hiddenNumOptimi��'}    {[1]}    {'startNum'}    {[1]}    {'stopNum'}    {[100]} 
                    %     {'hLayerNumOptimi��'}    {[1]}    {'startLayerNum'}    {[1]}    {'stopLayerNum'}    {[4]} 
                    var = cellfun(@string, para(9:end)); %��cell array�е�ÿһ��cellӦ��string
                    % var = 
                    %   1��48 string ����
                    %     "trainFcn"    "trainscg"    "hiddenNum"    "20"    "transferFcn"    "tansig"    "showWindow"    "false"
                    %     "plotperform"    "false"    "plottrainstate"    "false"    "ploterrhist"    "false"    "plotconfusion"    "false"
                    %     "plotroc"    "false"    "hiddenLayerNum"    "2"    "hiddenNum1"    "20"    "transferFcn1"    "tansig"    "hiddenNum2"
                    %     "20"    "transferFcn2"    "tansig"    "hiddenNum3"    "20"    "transferFcn3"    "tansig"    "hiddenNum4"    "20"
                    %     "transferFcn4"    "tansig"    "hiddenNumOptimiza��"    "true"    "startNum"    "1"    "stopNum"    "100"      
                    %     "hLayerNumOptimiza��"    "true"    "startLayerNum"    "1"    "stopLayerNum"    "4" 
                    for iLayer=1 : paraTable_c.hiddenLayerNum  % ÿ�����ز�һ����ѭ��
                        N_1 = n; %ÿ���ƽ�ָ���ϵļ�������Ͱ���ParametersForDimReduceClassify.xlsx���趨�ĵ�������executionTimes���ɡ�
                        a = paraTable_c.startNum; % �����½磻����ȡ����������©�κ�һ�����ܵĽڵ���
                        b = paraTable_c.stopNum; %�����Ͻ磻
                        acc_avg{iLayer} = [];    %  ���ڵ��������������ݣ�ÿһ�д�����һ���ƽ�ָ����20���ظ�����õ��ķ�����
                                                                %������20�η�������[������׼ȷ�ʣ�OA,AA,kappa]ȡƽ�����õ���һ�����ݣ�
                        OA_detail{iLayer} = []; %  ���ڵ��������������ݣ�ÿһ�д�����һ���ƽ�ָ����20���ظ�����õ���20��OAֵ
                        OA_avg{iLayer} = []; % ��¼mean(OA_detail{iLayer})
                        % �ҵ�var����Ҫ���µĲ�������ţ�������var�еĵ�LayerNum��������Ľڵ���Ϊx(i), hiddenNumLayerNum
                        TF = contains(var, 'hiddenNum');
                        if iLayer>1
                            TF = contains(var, ['hiddenNum', num2str(iLayer)]);
                        end
                        str_idx = find(TF);
                        
                        flag=1;
                        while(flag)
                            x_1 = a + 0.382*(b-a); %x_1��x_2����λ�������м�
                            x_2 = a + 0.618*(b-a); %����Ϊ�˲�©�����ܵĵ㣬x_1������ֵӦ�þ�������˵�Լֵ��x_2������ֵӦ�þ������Ҷ˵�Լֵ
                            x = [floor(x_1), ceil(x_2)];              %ÿ��ȡ�����ƽ�ָ��

                            [Lia, Locb] = ismember(x, gold_point{iLayer}); %
                            % Lia = 1x2 logical array, ���ܵ�ֵ��[0,0] [1,0] [0,1] [1,1]
                            % Locb = 1xnumel(gold_point{iLayer})�����ܵ�ֵ���ٶ�numel(gold_point{iLayer})=5��Ϊ��
                            % [0 0 0 0 0], [0 0 1 0 0], [0 0 0 0 1], [0 1 0 1 0]
                            % 
                            % Lia=[0,0]����ʾx�е�����ֵ��gold_point{iLayer}��û�в�ѯ���ظ������,
                            % ��ʱ��Locb = [0 0 0 0 0]
                            % Lia=[0,1]��
                            % ��ʾx�еڶ���ֵ��gold_point{iLayer}�е�ĳ��ֵ�ظ��������ʱLocb=[0 0 1 0 0]
                            % ��˵���ظ���gold_point{iLayer}�еĵ����������������gold_point{iLayer}��ֻ��һ��
                            % ����С����Ϊ1.
                            % Lia=[1,0],
                            % ��ʾx�е�һ��ֵ��gold_point{iLayer}�е�ĳ��ֵ�ظ��������ʱLocb=[0 0 1 0 0]
                            % ��˵���ظ���gold_point{iLayer}�еĵ����������������gold_point{iLayer}��ֻ��һ��
                            % ����С����Ϊ1.
                            % Lia=[1,1] ��ʾx�е�����ֵ��gold_point{iLayer}�е�ֵ�ظ��������ʱLocb=[0 1 0 1 0]
                            % ��˵���ظ���gold_point{iLayer}�еĵڶ������͵��ĸ���������������gold_point{iLayer}��ֻ������һ��
                            % �����С��С������Ϊ1.

                            switch Lia(1)*2+Lia(2)

                                case 0 
                                    % Lia=[0,0]����ʾx�е�����ֵ��gold_point{iLayer}��û�в�ѯ���ظ������,
                                    % ��ʱ��Locb = [0 0 0 0 0]
                                    % ��x���������ֶ���gold_point��û���ظ����������ƽ�ָ�㶼���㣬����
                                     
                                    %OA_avg��¼�����ƽ�ָ����Ϊ��LayerNum������ڵ���ʱ�ķ���׼ȷ���е�OAֵ20��ƽ��׼ȷ��
                                    for i = 1 : 2
                                        % ������Ҫ��õĽ�������������ƽ�ָ��20�μ�����õ�һ�з�����������
                                        % ���浽acc_avg��
                                        % �����ܸ��������������mappedA, lbs, rate, type, var
                                        % ������fcn1�ڲ�����n���ظ����㣬����ֵ����һ�з����������ݼ�20��acc
                                        %# ����var�еĵ�LayerNum��������Ľڵ���Ϊx(i), hiddenNumLayerNum
                                        %TF = contains(str,pattern)
                                        var(str_idx+1) = string(x(i));
                                        % ������� (n, N, setsNum, mappedA, lbs, rate, type, var)
                                        % ���2����������20�η�������ƽ��ֵavgResult_20iter, ��20�η�������OAֵ��OA_20iter
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
                                    % Lia=[0,1]��
                                    % ��ʾx�еڶ���ֵ��gold_point{iLayer}�е�ĳ��ֵ�ظ��������ʱLocb=[0 0 1 0 0]
                                    % ��˵���ظ���gold_point{iLayer}�еĵ����������������gold_point{iLayer}��ֻ��һ��
                                    % ����С����Ϊ1.
                                    % ��x�еڶ�������gold_point�еĵ��ظ�����ֻ�����һ���������һ��
                                    	
                                    %��¼�����ƽ�ָ����Ϊ��LayerNum������ڵ���ʱ�ķ���׼ȷ���е�OAֵ20��ƽ��׼ȷ��
                                    var(str_idx+1) = string(x(1));
                                    % ������� (n, N, setsNum, mappedA, lbs, rate, type, var)
                                    % ���2����������20�η�������ƽ��ֵavgResult_20iter, ��20�η�������OAֵ��OA_20iter
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
                                    % ��ʾx�е�һ��ֵ��gold_point{iLayer}�е�ĳ��ֵ�ظ��������ʱLocb=[0 0 1 0 0]
                                    % ��˵���ظ���gold_point{iLayer}�еĵ����������������gold_point{iLayer}��ֻ��һ��
                                    % ����С����Ϊ1.                                    
                                    % ��x�е�һ������gold_point�еĵ��ظ�����ֻ����ڶ���������ڶ���	

                                    var(str_idx+1) = string(x(2));
                                    % ������� (n, N, setsNum, mappedA, lbs, rate, type, var)
                                    % ���2����������20�η�������ƽ��ֵavgResult_20iter, ��20�η�������OAֵ��OA_20iter
                                    [avgResult_20iter, OA_20iter] = fcn1(n, N, setsNum, mappedA, lbs, rate, type, var);                                     
                                    acc_avg{iLayer} = [acc_avg{iLayer}, avgResult_20iter];
                                    OA_detail{iLayer} = [OA_detail{iLayer}, OA_20iter];                                   

                                    if OA_avg{iLayer}(nonzeros(Locb)) >= mean(OA_20iter)%��2�����׼ȷ����acc_avg(Locb)���Ƚ�
                                        b = ceil(x_2);
                                    else
                                        a = floor(x_1);
                                    end
                                    OA_avg{iLayer} = [OA_avg{iLayer}, mean(OA_20iter)];
                                    gold_point{iLayer} = [gold_point{iLayer}, x(2)];

                                otherwise
                                    % ��x���������ֶ���gold_point�ظ��������switch
                            end

                            % ��round(x_1) == round(x_2)ʱ����round(x_1)Ϊ������ڵ�����������
                            % ������ɺ���ֹͣwhile()ѭ��
                            if round(x_1) == round(x_2)
                                flag = 0;
                            end
                        end
                        %# �����iLayer���������ѽڵ���
                        Nh = [Nh, x(1)];
                        
                        % �ڻƽ�ָ���ϵļ������
                        %# ��startNum��stopNum��Ϊ��LayerNum������ڵ����ļ�����Ҳ��ӽ�acc_avg��OA_detail����
                        % ������LayerNum������ڵ������������ȣ������׼ȷ�ʵĹ�ϵ����������
                        if paraTable_c.startNum==1 %��startNum==1������startNum=2����Ϊ��LayerNum������ڵ������м���
                            startNum = 2;
                        else
                            startNum = paraTable_c.startNum;
                        end
                        stopNum = paraTable_c.stopNum;
                        x = [startNum, stopNum];
                        for i = 1 : 2
                            %# ����var�еĵ�LayerNum��������Ľڵ���Ϊx(i), hiddenNumLayerNum
                            %TF = contains(str,pattern)
                            var(str_idx+1) = string(x(i));
                            % ������� (n, N, setsNum, mappedA, lbs, rate, type, var)
                            % ���2����������20�η�������ƽ��ֵavgResult_20iter, ��20�η�������OAֵ��OA_20iter
                            [avgResult_20iter, OA_20iter] = fcn1(n, N, setsNum, mappedA, lbs, rate, type, var);                                     
                            acc_avg{iLayer} = [acc_avg{iLayer}, avgResult_20iter];
                            OA_detail{iLayer} = [OA_detail{iLayer}, OA_20iter];
                        end
                        OA_avg{iLayer} = [OA_avg{iLayer}, mean(OA_20iter)];
                        gold_point{iLayer} = [gold_point{iLayer}, x];
                        %# �����LayerNum������ڵ���ȡ�ƽ�ָ��ʱ�ķ�����
                        % gold_point{iLayer}��acc_avg{iLayer}, OA_detail{iLayer}, OA_avg{iLayer}
                        % ���ߵ�����hiddenLayerNum��������ڵ���ȫ���Ż���֮���ٱ���
                        d = time_goldSection(end);
                        time_goldSection(iLayer) = toc(timerVal_1) - time_1 - d;
                    end
					% �ƽ�ָѰ�Ž�����

					% ���ҵ��ĸ�������ڵ���������ֵ��ֵ��paraTable_c�е���Ӧ����(����ֻ���ǵ���������)
					if paraTable_c.hiddenLayerNum==1
						paraTable_c.hiddenNum=Nh(1);
						for i = 1:paraTable_c.hiddenLayerNum-1
							estr = ['paraTable_c.hiddenNum', num2str(i), '=Nh(',num2str(i+1),');' ];
							eval(estr);
						end
					end
					% �ƽ�ָѰ�Ž���������
                case '��'
            end
            
        end
       
        t = table2cell(paraTable_c);
        % t =
        %   1��28 cell ����
        %     {[1]}    {[0.2000]}    {[3]}    {[20]}    {["trainscg"]}    {[20]}    {["tansig"]}    {[0]}    {[0]}
        %     {[0]}    {[0]}    {[0]}    {[0]}    {[2]}    {[20]}    {["tansig"]}    {[20]}    {["tansig"]}    {[20]}
        %     {["tansig"]}    {[20]}    {["tansig"]}    {[1]}    {[1]}    {[100]}   {[1]}    {[1]}    {[4]}
        k = numel(t);                        % 28
        para = cell(1,2*k);                 % 1��56 cell ����
        for i = 1:k
            para{2*i-1} = paraTable_c.Properties.VariableNames{i};
            para{2*i} = t{i};            
        end
        % para =
        %   1��56 cell ����
        %   �� 1 �� 8
        %     {'dimReduce'}    {[1]}    {'rate'}    {[0.2000]}    {'app'}    {[3]}    {'executionTimes'}    {[20]}    
        %   �� 9 �� 50
        %     {'trainFcn'}  {["trainscg"]}    {'hiddenNum'}    {[20]}    {'transferFcn'}    {["tansig"]}    {'showWindow'}    {[0]}
        %     {'plotperform'}    {[0]}    {'plottrainstate'}    {[0]}    {'ploterrhist'}    {[0]}    {'plotconfusion'}    {[0]}
        %     {'plotroc'}    {[0]}    {'hiddenLayerNum'}    {[2]}    {'hiddenNum1'}    {[20]}    {'transferFcn1'}    {["tansig"]}
        %     {'hiddenNum2'}    {[20]}    {'transferFcn2'}    {["tansig"]}    {'hiddenNum3'}    {[20]}    {'transferFcn3'}
        %     {["tansig"]}    {'hiddenNum4'}    {[20]}    {'transferFcn4'}    {["tansig"]}    
        %     {'hiddenNumOptimi��'}    {[1]}   {'startNum'}    {[1]}    {'stopNum'}    {[100]} 
        %     {'hLayerNumOptimi��'}    {[1]}    {'startLayerNum'}    {[1]}    {'stopLayerNum'}    {[4]} 
        var = cellfun(@string, para(9:end)); %��cell array�е�ÿһ��cellӦ��string
        % var = 
        %   1��48 string ����
        %     "trainFcn"    "trainscg"    "hiddenNum"    "20"    "transferFcn"    "tansig"    "showWindow"    "false"
        %     "plotperform"    "false"    "plottrainstate"    "false"    "ploterrhist"    "false"    "plotconfusion"    "false"
        %     "plotroc"    "false"    "hiddenLayerNum"    "2"    "hiddenNum1"    "20"    "transferFcn1"    "tansig"    "hiddenNum2"
        %     "20"    "transferFcn2"    "tansig"    "hiddenNum3"    "20"    "transferFcn3"    "tansig"    "hiddenNum4"    "20"
        %     "transferFcn4"    "tansig"    "hiddenNumOptimiza��"    "true"    "startNum"    "1"    "stopNum"    "100"
        %     "hLayerNumOptimiza��"    "true"    "startLayerNum"    "1"    "stopLayerNum"    "4" 
 if 1  %# ����ParametersForDimReduceClassify���趨�Ĳ������г������    
        for k = 1 : n
            [mA1, mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate);  % rate: ��ʹ�õ�ѵ����ռ��
            XTrain = table2array(mA1(:, 1:end-1))';  %mappedA��mA����ÿһ��Ϊһ����������XTrain��ÿһ��Ϊһ��������
        %     TTrain = dummyvar(double(mA1.Class))';
            TTrain = ind2vec(double(mA1.Class)');    %%��ʱ�����־���ʹ��ϡ�������ʽ����������ѵ�����罫�ᵼ���ڴ�ռ��̫��
            XTest = table2array(mA2(:, 1:end-1))';   %XTestÿһ��Ϊһ������
        %     TTest = dummyvar(double(mA2.Class))';
            TTest = ind2vec(double(mA2.Class)');     %TTestÿһ��Ϊһ������ǩ
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
        % load('���̲���\20220517\cmNormalizedValues1.mat','cmt'); %���ڲ���
        % [size1, size2, size3, size4] = size(cmt);   % huston.mat���ݼ��Ļ�������ߴ磺15��15��20��2
        
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
        %# Ϊcell��ÿһ�д��������� VariableNames
        VariableNames = cell(1,size3+2);
        for i = 1:size3
            VariableNames{i}= ['iter_',num2str(i)];
        end
        VariableNames(size3+1 : size3+2)  = {'average', 'std'};
        %# �����е����� RowNames���������ַ�Ԫ������ ��1��(15+3) cell��
        RowNames = cell(1, size1+3); % 3�зֱ���OA��AA��kappa��
        for i = 1:size(cmt, 1)
            RowNames{i} = ['class_',num2str(i)];
        end
        RowNames(i+1 : end) = {'OA', 'AA', 'Kappa'};
        
        %# ����Excel�ļ������ַ
        % �����ļ�������
        path = ['C:\Matlab��ϰ\Project20191002\���̲���\', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS')];
        try
            path = fullfile(path, hmenu4_1.UserData.datasetName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
        catch
        end
        % ������ɵ��ļ������Ʋ����ڣ����ȴ����ļ���
        if ~exist(path, 'dir')
            [status,msg,msgID] = mkdir(path);
        end
        % ����Excel�ļ���
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
        info_1 = hmenu4_1.UserData;
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
        %# ����time_goldSection
        if exist('time_goldSection','var')==1
            VariableNames = ["iLayer_"+string(1:paraTable_c.hiddenLayerNum)];
            RowNames = "colapsedTime";
            timeTable = array2table(time_goldSection, 'VariableNames', VariableNames);
            timeTable.Properties.RowNames = RowNames;
            writetable(timeTable,filename,'Sheet',iset+1,'Range','A27', 'WriteRowNames',true, 'WriteVariableNames', true);
        end
        
        %% ����ѵ�������е���������err_perf, err_vperf, err_tperf, racc��Excel��Sheet
        T1 = createTableForWrite(err_perf, err_vperf, err_tperf, racc);
        errTable = [T1.Variables; mean(T1.Variables); std(T1.Variables)];  % T1.Variables ��20��8 double
        errTable = array2table(errTable, 'VariableNames', T1.Properties.VariableNames);
        errTable.Properties.RowNames = [T1.Properties.RowNames; {'average'}; {'std'}]; %����2�е�������
        %filename = "C:\Matlab��ϰ\Project20191002\���̲���\2022-06-04 19-45-16\Botswana\LDA\GA_TANSIG\Botswana_LDA_GA_TANSIG.xlsx";
        errTable.Properties.Description = '����ѵ�������е���������err_perf, err_vperf, err_tperf, racc';
        writetable(errTable,filename,'Sheet',iset+2,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true); 

        %% ����������������ڵ������Ż����
        % ��Ѱ�ҵ�����������net��gold_point, acc_avg, OA_detail��Ѱ����ϢhiddenNumInfoһ�𱣴�Ϊmat���ݡ�
        % ֮���Էŵ���������Ϊ������ԭ��
        % 1. ���ֱ����ǰ�桾������������ڵ���Ѱ�š�����������ɴ�ʱ����ļ������Ļ���ʱ����������Excel��д��ʱ�䡣
        % 2. ������������ڵ���Ѱ�ŵĽ�������ݼ�����ά�㷨�������㷨���й�ϵ�������path�����������ļ����ؼ���Ϣ��
        %     ����ֱ���������path��Ϊ[����������������ڵ������Ż����]�Ǹ�����ġ�
        if paraTable_c.hiddenNumOptimization && strcmp(answer_hiddenNumOptimization, '��')
            gold_point_sorted = cell(1,paraTable_c.hiddenLayerNum);
            acc_avg_sorted = cell(1,paraTable_c.hiddenLayerNum);
            OA_detail_sorted = cell(1,paraTable_c.hiddenLayerNum);
            %## ÿһ������ļ��������浽һ��sheet��
            for iLayer = 1:paraTable_c.hiddenLayerNum
                %# �Ե�iLayer������ķ���׼ȷ��gold_point{iLayer}, acc_avg{iLayer}, OA_detail{iLayer}����ά���ϵ���˳��
                % ����sort()������gold_point{iLayer}�е�������С�������򣬽�����浽gold_point_sorted{iLayer}�У�
                % ͬʱ���õ�����������I
                % �̶�������������I, ����ά���϶�acc_avg{iLayer},OA_detail{iLayer}����
                % ������浽acc_avg_sorted{iLayer}��OA_detail_sorted{iLayer}

                [B, I] = sort(gold_point{iLayer});
                gold_point_sorted{iLayer} = B;
                acc_avg_sorted{iLayer} = acc_avg{iLayer}(:, I);
                OA_detail_sorted{iLayer} = OA_detail{iLayer}(:, I);
                %# ������֮��ĵ�iLayer������ķ���׼ȷ�������table��ʽ
                [size_1, size_2] = size(acc_avg{iLayer});
                accData = [gold_point{iLayer}; gold_point_sorted{iLayer}; acc_avg_sorted{iLayer};...
                    OA_detail_sorted{iLayer}; mean(OA_detail_sorted{iLayer}); std(OA_detail_sorted{iLayer})];
                % Ϊcell��ÿһ�д��������� VariableNames
                VariableNames = cell(1,size_2);
                for i = 1:size_2
                    VariableNames{i}= ['goldPoint_',num2str(i)];
                end
                %# �����е����� RowNames���������ַ�Ԫ������ ��1��(2+size_1+size_3+2) cell��
                [size_3, size_4] = size(OA_detail{iLayer});
                RowNames = cell(1, 2+size_1+size_3+2); 
                RowNames{1} = ['goldPoint{iLayer=',num2str(iLayer),'}'];
                RowNames{2} = 'goldPoint_sorted';
                for i = 1+2 : size_1-3+2              % acc_avg���3�зֱ���OA��AA��kappa
                    RowNames{i} = ['class_',num2str(i-2)];
                end
                RowNames(i+1 : i+3) = {'OA', 'AA', 'Kappa'};
                i = i+3;
                RowNames(i+1: i+size_3) = cellstr("iter_"+string(1:size_3));
                i = i+size_3;
                RowNames(i+1 : i+2)  = {'average', 'std'};
                % path��filename���Ѿ�����
                accTable = array2table(accData, 'VariableNames', VariableNames);
                accTable.Properties.RowNames = RowNames;
                % Sheet 1�����Ż�֮ǰ�ķ�������Sheet 2�����Ż�֮��ķ�������
                % Sheet 3����ִ�з�����������������Ϣ��Sheet 4����ѵ��������Ϣ��
                % Sheet iLayer+4���Ա����iLayer������ķ���׼ȷ����Ϣ��
                writetable(accTable,filename,'Sheet',iLayer + iset+2,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);                
                
            end
        end
        
        %% �������ͼ����
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
        % f.Children
        % ans = 
        % 3��1 graphics ����:
        % UIControl
        % Legend       (Class 1, Class 2, Class 3, Class 4, Class 5, Class 6, Clas��)
        % Axes         (ROC)       filename_2 = fullfile(path,"net_best{2,2}_"+"originROC");%ƴ��·��
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
        %Ylbs��ʾԤ���lbs��Ϊһ��������
        % ����ͨ����Ylbsͨ��reshape()�ķ�ʽ����Ϊ��ά������ΪYlbs�������������е������ţ�
        % ��������ͼƬ�ϵ��������ص�������
        % ��ȷ�������ǣ���ȫ��������������netBest����ȡYlbs������������
        % �ٽ�������YlbsǶ���ά����gtdata����ȡ�µĶ�ά����Ygtdata

        gtdata = handles.UserData.gtdata;
        gtdata(gtdata~=0)=Ylbs;    %����ǩ�������г�GTͼ
        Ygtdata = gtdata; %Ygtdata��ʾԤ���gtdata
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
        % saveas(gcf, filename_2);        % ����Ϊfig
        % saveas(gcf, filename_2,'jpg'); %����Ϊjpg
        
        %% ������������       
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
 end        
        %% ����������������Ż� ѯ���Ƿ�Ҫִ���������������������ȣ��Ż�
        [mA1, mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate);  % rate: ��ʹ�õ�ѵ����ռ��
        XTrain = table2array(mA1(:, 1:end-1))';  %mappedA��mA����ÿһ��Ϊһ����������XTrain��ÿһ��Ϊһ��������
        if paraTable_c.hLayerNumOptimization
            % ѯ���Ƿ�Ҫ�������������������������ֵ����
            quest = {'\fontsize{10} �Ƿ�Ҫִ����������������Ż���Ѱ�����������������ֵ��'};
                     % \fontsize{10}�������С���η���������ʹ�������ַ���С��Ϊ10����
            dlgtitle = '�����������������������ȣ��Ż�';
            btn1 = '��';
            btn2 = '��';
            opts.Default = btn2;
            opts.Interpreter = 'tex';
            % answer = questdlg(quest,dlgtitle,btn1,btn2,defbtn);
            answer_hLayerNumOptimization = questdlg(quest, dlgtitle, btn1, btn2, opts);
                                        
            % Handle response
            switch answer_hLayerNumOptimization
                case '��'
                    % %## ����ȷ����������Ԫ���������Բ��ù�ʽ�����㣬Ҳ�����ֶ�ָ��
                    % time_1 = toc(timerVal_1);
                    % [Ni, Ns] = size(XTrain); % XTrainÿһ��Ϊһ��������������Ϊ��ά�����������ڵ���������Ϊѵ����������
                    % % ����������ά�����������Ľڵ�����
                    % N = hmenu4_1.UserData.M-1;     % �������
                    % No = N; %�����ڵ�����ΪNo
                    % % Botswana, round(3248*0.2)=650,No=14, 650./(a*(10+14))=[13.5417 2.7083]

                    % a = [2, 10]; % ϵ��aͨ��ȡ2~10
                    % % ������ڵ������㹫ʽ Nh = Ns/(a*(Ni+No));  %������ڵ�����ΪNh
                    % Nhd = Ns./(a*(Ni+No));
                    % % ��Ni=5;No=14;Ns=650ʱ��Nhd=[17.1, 3.4];
                    % % Ni=10ʱ��No=14;Ns=650ʱ��Nhd=[13.6, 2.7];
                    % % �����������Ԫȡֵ�½�ֵ�ɶ�Ϊfloor(Nh(2))=3��
                    % % �Ͻ�ֵ�ɶ�Ϊceil(Nh(1)/floor(Nh(2)))*floor(Nh(2))��ѭ������Ϊceil(Nh(1)/floor(Nh(2)))
                    % iteration = ceil(Nhd(1)/floor(Nhd(2)));
                    % Nhd_min = floor(Nhd(2));
                    % Nhd_max = ceil(Nhd(1)/floor(Nhd(2)))*floor(Nhd(2));
                    
                    % %# ��ʼ���������������
                    % % ����������ڵ���ΪNhd = [18,3]��������У�һ���̶���������ڵ�����1~5�������������½��б���������Եõ�5�з�����
                    % % ���ܹ�6��������ڵ��������Եõ�5��6=30�з�����
                    % % ���ÿ��sheetֻ����һ���̶���������ڵ�����1~5�������������½��б�����5�н���Ļ�������Ҫ��������6��sheet
                    % % ��������̫�˷��ˣ����Խ�30�з��������浽ͬһ��sheet��
                    % % �ڶ���sheet����OA_20iter�����һ��sheet�е���һһ��Ӧ��
                    % % errTable�Ȳ������ˣ�һ���̶���������ڵ�����������Ĳ����̶�������£��Ϳ��Ի��n=20��err_perf����
                    % % ��6��������ڵ�����5������������£�����20��5��6=600�����ݣ�̫���˲��ñ���
                    % % ������������Ǵ�1�㵽stopLayerNum+1��
					
					%## �ֶ�ָ��Ҫ������������ڵ���
                    hiddenNum = [150]; %, 120, 125, 130, 135, 140, 145, 150];
                    % hiddenNum = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
                    % hiddenNum = [55, 60, 65, 70, 75, 80, 85, 90, 95, 100];
                    if ~exist('Nhd_min', 'var')
                        if exist('hiddenNum', 'var')
                            if hiddenNum(:)~=0
                                Nhd_min=min(hiddenNum);
                            else
                                disp(['Nhd_min�����ڣ���min(hiddenNum)Ϊ0���޷���ֵ��Nhd_min']);
                            end
                        else
                            disp(['Nhd_min�����ڣ���hiddenNum�����ڣ��޷���ֵ��Nhd_min']);
                        end
                    end
                    if ~exist('Nhd_max', 'var')
                        if exist('hiddenNum', 'var')
                            if hiddenNum(:)~=0
                                Nhd_max=max(hiddenNum);
                            else
                                disp(['hiddenNum���в���Ԫ��ֵΪ0���޷���ֵ��Nhd_min']);
                            end
                        else
                            disp(['Nhd_max�����ڣ���hiddenNum�����ڣ��޷���ֵ��Nhd_max']);
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
                    % acc��ʾ������������׼ȷ�ʡ�OA��AA��Kappa���ڵ���������׼ȷ�����ݣ�
                    % acc_avg��ʾ20���ظ�����õ�����������׼ȷ�ʵ�ƽ��ֵ
                    OA_detail = zeros(n, iColomn); %��¼�ڻƽ�ָ�����ظ�����20�λ�õ�20��OAֵ
                    OA_avg = zeros(1, iColomn); % ��¼mean(OA_detail)
                    time_Layer = zeros(1, iColomn); %��¼ÿһ���ڵ����ڲ�ͬ����ʱ�����ĵ�ʱ��
                    %# ������ParametersForDimReduceClassify���趨�����½��������
                    % ֻҪ��������½�ֵ���ڵ����趨���½�ֵ���Ҽ�������Ͻ�ֵС�ڵ����趨���Ͻ�ֵ����������Ҫ��
                    %if floor(Nhd(2))<=paraTable_c.startLayerNum && ceil(Nhd(1)/floor(Nhd(2)))*floor(Nhd(2))<=paraTable_c.stopLayerNum
                    %    disp('��ʼ��������������Ż�');
                    %elseif floor(Nhd(2))>paraTable_c.startLayerNum                        
                    %    paraTable_c.startLayerNum;
                    %    paraTable_c.stopLayerNum;
                    %end
					
					% ��hiddenLayerNum��stopLayerNum������Ѱ�Ų���
					% ��������������Ǵ�1�㵽stopLayerNum+1��
					% hiddenNum = zeros(1,iteration);
                    time_start = toc(timerVal_1);
                    for i = 1: iteration
                        % ������ڵ���ΪNhd_min*i;
                        %hiddenNum(i) = Nhd_min*i + 14;
                        % �����������paraTable_c
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
                            %   1��28 cell ����
                            %     {[1]}    {[0.2000]}    {[3]}    {[20]}    {["trainscg"]}    {[20]}    {["tansig"]}    {[0]}    {[0]}
                            %     {[0]}    {[0]}    {[0]}    {[0]}    {[2]}    {[20]}    {["tansig"]}    {[20]}    {["tansig"]}    {[20]}
                            %     {["tansig"]}    {[20]}    {["tansig"]}    {[1]}    {[1]}    {[100]}  {[1]}    {[1]}    {[4]}
                            k = numel(t);                        % 28
                            para = cell(1,2*k);                 % 1��56 cell ����
                            for iPara = 1:k
                                para{2*iPara-1} = paraTable_c.Properties.VariableNames{iPara};
                                para{2*iPara} = t{iPara};            
                            end
                            % para =
                            %   1��56 cell ����
                            %   �� 1 �� 8
                            %     {'dimReduce'}    {[1]}    {'rate'}    {[0.2000]}    {'app'}    {[3]}    {'executionTimes'}    {[20]}    
                            %   �� 9 �� 50
                            %     {'trainFcn'}  {["trainscg"]}    {'hiddenNum'}    {[20]}    {'transferFcn'}    {["tansig"]}    {'showWindow'}    {[0]}
                            %     {'plotperform'}    {[0]}    {'plottrainstate'}    {[0]}    {'ploterrhist'}    {[0]}    {'plotconfusion'}    {[0]}
                            %     {'plotroc'}    {[0]}    {'hiddenLayerNum'}    {[2]}    {'hiddenNum1'}    {[20]}    {'transferFcn1'}    {["tansig"]}
                            %     {'hiddenNum2'}    {[20]}    {'transferFcn2'}    {["tansig"]}    {'hiddenNum3'}    {[20]}    {'transferFcn3'}
                            %     {["tansig"]}    {'hiddenNum4'}    {[20]}    {'transferFcn4'}    {["tansig"]}    
                            %     {'hiddenNumOptimi��'}    {[1]}    {'startNum'}    {[1]}    {'stopNum'}    {[100]} 
                            %     {'hLayerNumOptimi��'}    {[1]}    {'startLayerNum'}    {[1]}    {'stopLayerNum'}    {[4]} 
                            var = cellfun(@string, para(9:end)); %��cell array�е�ÿһ��cellӦ��string
                            % var = 
                            %   1��48 string ����
                            %     "trainFcn"    "trainscg"    "hiddenNum"    "20"    "transferFcn"    "tansig"    "showWindow"    "false"
                            %     "plotperform"    "false"    "plottrainstate"    "false"    "ploterrhist"    "false"    "plotconfusion"    "false"
                            %     "plotroc"    "false"    "hiddenLayerNum"    "2"    "hiddenNum1"    "20"    "transferFcn1"    "tansig"    "hiddenNum2"
                            %     "20"    "transferFcn2"    "tansig"    "hiddenNum3"    "20"    "transferFcn3"    "tansig"    "hiddenNum4"    "20"
                            %     "transferFcn4"    "tansig"    "hiddenNumOptimiza��"    "true"    "startNum"    "1"    "stopNum"    "100"
                            %     "hLayerNumOptimiza��"    "true"    "startLayerNum"    "1"    "stopLayerNum"    "4"    

                            % ���2����������20�η�������ƽ��ֵavgResult_20iter, ��20�η�������OAֵ��OA_20iter
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
                    
                    %## �������������Ѱ�Ž��
                    %# Ϊcell��ÿһ�д��������� VariableNames
                    % hNum1hLayer1~hNum1hLayer5, hNum2hLayer1~hNum2hLayer5, ������hNum6hLayer1~hNum6hLayer5
                    VariableNames = cell(1, iColomn);
                    for i = 1:iteration
                        for iLayer = 1:stopNum
                            VariableNames{(i-1)*stopNum+iLayer}= ['hNum=',num2str(hiddenNum(i)),' hLayer=',num2str(iLayer)];
                        end
                    end
                    %# �����е����� RowNames1���������ַ�Ԫ����������ַ������飻
                    [size_1, size_2] = size([acc_avg; timeLayer]);
                    RowNames1(1:size_1-4) = "class_"+string(1:(size_1-4)); 
                    RowNames1(size_1-3) = "OA";
                    RowNames1(size_1-2) = "AA";
                    RowNames1(size_1-1) = "Kappa";
                    RowNames1(size_1) = "time_Layer"; % ÿһ����������ĵ�ʱ��
                    %# �����е����� RowNames2���������ַ�Ԫ����������ַ������飻 
                    [size_3, size_4] = size(OA_detail);
                    RowNames2 = "iter_"+string(1:size_3); 
                    RowNames2(size_3+1) = "average";
                    RowNames2(size_3+2) = "std";

                    %# ����Excel�ļ������ַ
                    % �����ļ�������
                    path = ['C:\Matlab��ϰ\Project20191002\���̲���\', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS')];
                    try
                        path = fullfile(path, hmenu4_1.UserData.datasetName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
                    catch
                    end
                    % ������ɵ��ļ������Ʋ����ڣ����ȴ����ļ���
                    if ~exist(path, 'dir')
                        [status,msg,msgID] = mkdir(path);
                    end
                    % path�Ѿ����ˣ�filename��������
                    filename = [hmenu4_1.UserData.datasetName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'_hLayerOptimization','.xlsx'];
                    filename = fullfile(path, filename);
                    accTable = array2table([acc_avg; timeLayer], 'VariableNames', VariableNames);
                    accTable.Properties.RowNames = RowNames1;
                    % Sheet 1�����Ż�30�У�6��������ڵ���5�������㣩������acc_avg��
                    % ÿһ�ж���20���ظ�����ķ���׼ȷ�ʵ�ƽ��ֵ�����������ķ���׼ȷ�ʣ��Լ�OA, AA, Kappa
                    writetable(accTable,filename,'Sheet',1,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);
                    % Sheet 2�����Ż�30�У�6��������ڵ���5�������㣩������OA_detail��   
                    % ÿһ����20���ظ������õ�20��OAֵ
                    OATable = array2table([OA_detail; OA_avg; std(OA_detail)], 'VariableNames', VariableNames);
                    OATable.Properties.RowNames = RowNames2;
                    writetable(OATable,filename,'Sheet',2,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);  

                    %# ������Ϣ����
                    %% �����йط��������������õ���ϸ��Ϣ������Sheet��
                    % ���潵ά�������������paraTable_c��Sheet 3�У�
                    % ��Ҫ��startNum��stopNum, startLayerNum ��stopLayerNum
                    paraTable_c.startNum = Nhd_min;
                    paraTable_c.stopNum = Nhd_max;
                    writetable(paraTable_c, filename, 'Sheet',3,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);

                    %# �������ݼ���Ϣhmenu4_1.UserData��Sheet(iset+1)
                    info_1 = hmenu4_1.UserData;
                    info_1.x3 = [];
                    info_1.lbs2 = [];
                    info_1.x2 = [];
                    info_1.lbs = [];
                    info_1.cmap = [];
                    info_1.Nhd_min = Nhd_min;
                    info_1.Nhd_max = Nhd_max;
                    % info_1.elapsedTimec = toc(timerVal_1)-time1; % �����������ʱ��
                    info_1 = struct2table(info_1, 'AsArray',true);
                    writetable(info_1, filename, 'Sheet',3,'Range','A3', 'WriteRowNames',true, 'WriteVariableNames', true);
                    %# ��������cmap
                    info_cmap = hmenu4_1.UserData.cmap;
                    variableNames = ["R","G","B"]; %VariableNames����Ϊ�ַ�����Ԫ������{'R','G','B'}��
                    % ����ָ������������ƣ������ַ�������["R","G","B"]���ַ�����Ԫ������{'R','G','B'}��ָ����Щ���ơ�
                    % �����е����� RowNames3����ʽΪ�ַ�������["1","2","3"]���ַ�����Ԫ������{'1','2','3'}��
                    RowNames3 = string(1:size(info_cmap,1)); % ��
                    info_cmap = array2table(info_cmap, 'VariableNames', variableNames);
                    info_cmap.Properties.RowNames = RowNames3;
                    writetable(info_cmap,filename,'Sheet',3,'Range','A5', 'WriteRowNames',true, 'WriteVariableNames', true);

                    %# �����е����� RowNames4���������ַ�Ԫ����������ַ������飻
                    [size_5, size_6] = size(err_avg);
                    if size_5==8
                        RowNames4 = {'err_perf1','err_perf2','err_vperf1','err_vperf2','err_tperf1','err_tperf2','racc1','racc2'};
                    elseif size_5==4
                        RowNames4 = {'err_perf','err_vperf','err_tperf','racc'};
                    end
                    errTable = array2table(err_avg, 'VariableNames', VariableNames);
                    errTable.Properties.RowNames = RowNames4;
                    % Sheet 3�����Ż�30�У�6��������ڵ���5�������㣩ѵ����������err_avg��
                    % ÿһ�ж���20���ظ������ѵ���������ݵ�ƽ��ֵ�����������ķ���׼ȷ�ʣ��Լ�OA, AA, Kappa
                    writetable(errTable,filename,'Sheet',4,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);            
                    %# ���������Ѱ�Ž���������

                    %% �����������ߣ���ѵ��������֤�������Լ��ϵ����ܣ�       
                    %# ���ƴ���������
                    % path = "C:\Matlab��ϰ\Project20191002\���̲���\2022-06-13 00-57-38\Botswana\PCA\GA_TANSIG";
                    % excelPath = "C:\Matlab��ϰ\Project20191002\���̲���\2022-06-13 00-57-38\Botswana\PCA\GA_TANSIG\Botswana_PCA_GA_TANSIG_hLayerOptimization.xlsx";
                    % errTable = readtable(excelPath,'Sheet',4, 'ReadRowNames',true);
                    % ʹ�õ�һ��ά�����Ʒ���������, errTable.Row
                    % ʹ�õڶ���ά�����Ʒ�������, T.Variables ���﷨��Ч�� T{:, :}��
                    errArray = errTable.Variables;
                    [s1, s2] = size(errArray);     % 8��50 double
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

                        %## �������������
                        % plotErr(err_perf, err_vperf, err_tperf, racc, 4);
                        p = figure();
                        plot((1:size_1)',[err_perf, err_vperf, err_tperf], 'LineWidth',1.5);
                        title(['ѵ���������������(hiddenNum=',num2str(hiddenNum(i)),')'],'Interpreter','none');
                        xlabel('����');
                        ylabel('�����');
                            %racc ����ʣ�������
                            %err_perf ѵ����������ܣ���ɫ���ߣ�
                            %err_vperf ��֤��������ܣ���ɫ���ߣ�
                            %err_tperf ���Լ�������ܣ���ɫ���ߣ�
                            %tTest ΪԤ�������ǩ������
                        try %��err�����У����Ż�ǰ������ݸ�ռһ�У��������������������2������
                            legend('err_perf1','err_perf2','err_vperf1','err_vperf2','err_tperf1','err_tperf2','Interpreter','none','Location','best');  
                            %1��ʾ�Ż�ǰ�����ݣ�2��ʾ�Ż��������
                        catch%��err������һ�����ݣ�����һ�е���������ͼ��
                            legend('err_perf','err_vperf','err_tperf','Interpreter','none','Location','best');  
                        end
                        xticks((1:size_1));  % ��x���ϵĿ̶�����Ϊ����
                        filename_2 = fullfile(path, ['��ͬ������������������ѵ����������_�����', '(hiddenNum=',num2str(hiddenNum(i)),')']); %ƴ��·��
                        saveas(gcf, filename_2);        % ����Ϊfig
                        saveas(gcf, filename_2,'jpg'); %����Ϊjpg

                        %## ����׼ȷ������       
                        %plotAcc(1-err_perf, 1-err_vperf, 1-err_tperf);
                        p=figure();
                        plot((1:size_1)',[1-err_perf, 1-err_vperf, 1-err_tperf], 'LineWidth',1.5);
                        title(['ѵ������׼ȷ������','(hiddenNum=',num2str(hiddenNum(i)),')'],'Interpreter','none');
                        xlabel('����');
                        ylabel('׼ȷ��');
                            %racc ����ʣ�������
                            %err_perf ѵ����������ܣ���ɫ���ߣ�
                            %err_vperf ��֤��������ܣ���ɫ���ߣ�
                            %err_tperf ���Լ�������ܣ���ɫ���ߣ�               
                        try %��acc�����У����Ż�ǰ������ݸ�ռһ�У��������������������2������
                            legend('acc_perf1','acc_perf2','acc_vperf1','acc_vperf2','acc_tperf1','acc_tperf2','Interpreter','none','Location','best');  
                            %1��ʾ�Ż�ǰ�����ݣ�2��ʾ�Ż��������
                        catch%��acc������һ�����ݣ�����һ�е���������ͼ��
                            legend('acc_perf','acc_vperf','acc_tperf','Interpreter','none','Location','best');  
                        end
                        xticks((1:size_1));  % ��x���ϵĿ̶�����Ϊ����
                        filename_2 = fullfile(path, ['��ͬ������������������ѵ����������_׼ȷ��', '(hiddenNum=',num2str(hiddenNum(i)),')']); %ƴ��·��
                        saveas(gcf, filename_2);        % ����Ϊfig
                        saveas(gcf, filename_2,'jpg'); %����Ϊjpg
                    end

                    %% �����acc_matrix����������
                    % �ҵ�'OA'���ڵ�������
                    [Lia,Locb] = ismember('OA', accTable.Row);
                    % ��������Lia = logical 1��Locb = 15����N=14, 'OA'ǡ��λ�ڵ�N+1��
                    if Lia
                        size_row = numel(hiddenNum);
                        size_col = stopNum;
                        %## 
                        % acc_avg(N+1, 1+(i-1)*5:5*i)
                        % �Ƚ�acc_avg����acc_avg(N+1, 1+(i-1)*5:5*i)ȡ������ÿһ����Ϊһ�С������5��numel(hiddenNum)�еľ���acc_matrix��
                        % 1. ���ڵĻ�ͼ��ʽ�ǣ���������ڵ����̶����о�������Ĳ�����1�����ӵ�5�������µ��������׼ȷ�ʵı仯��
                        % �����ÿһ�л��Ƴ�һ�����ߡ�������Ϊ׼ȷ�ʣ�������Ϊ�����������legendΪ������ڵ�����
                        % �����˵���������׼ȷ����������ڵ���ֱ�ӵĹ�ϵ��
                        acc_matrix = reshape(accTable{Locb,:}, stopNum, []); %5��10�У�ÿһ�ж���ͬһ��������ڵ�����1~5�������������µķ���׼ȷ��
                        figure()
                        plot((1:stopNum)', acc_matrix, 'LineWidth',1.5);
                        title(['��ͬ������ڵ�����׼ȷ������'],'Interpreter','none');
                        ylabel('׼ȷ��');
                        xlabel('���������');
                        % legend(labels), labelsʹ���ַ�����Ԫ�����顢�ַ�������
                        try
                            legend(["������ڵ���="+string(hiddenNum(1):hiddenNum(2)-hiddenNum(1):hiddenNum(end))],'Interpreter','none','Location','best');
                        catch
                            legend("������ڵ���="+string(hiddenNum(1)),'Interpreter','none','Location','best');
                        end
                        xticks((1:size_1));  % ��x���ϵĿ̶�����Ϊ����

                        try
                            filename_2 = ['��ͬ�ڵ�����������������׼ȷ��','(hiddenNum=',num2str(hiddenNum(1)),'-',num2str(hiddenNum(2)-hiddenNum(1)),'-',num2str(hiddenNum(end)),')'];
                        catch
                            filename_2 = ['��ͬ�ڵ�����������������׼ȷ��','(hiddenNum=',num2str(hiddenNum(1)),')'];
                        end   
                        filename_2 = fullfile(path, filename_2); %ƴ��·��
                        saveas(gcf, filename_2);        % ����Ϊfig
                        saveas(gcf, filename_2,'jpg'); %����Ϊjpg
                        %##
                        % 2. ����һ�ֻ�ͼ��ʽ�����ǣ�������������̶�������£����Ƴ�������ڵ������������׼ȷ�ʵĹ�ϵ���ߡ�
                        % ������������Ĳ�����1�����ӵ�5��ʱ�����ܻ��Ƴ�5�����ߡ�
                        % ��5�����߷���һ��ȷ���׼ȷ�ʵĸߵͣ�����˵��������������׼ȷ�ʵĹ�ϵ��
                        % ����acc_matrix��ת�þ��� 
                        figure()
                        %plot((1:numel(hiddenNum))', acc_matrix');
                        plot(hiddenNum', acc_matrix', 'LineWidth',1.5);
                        title(['��ͬ�����������׼ȷ������'],'Interpreter','none');
                        ylabel('׼ȷ��')
                        xlabel('������ڵ���')
                        legend(["���������="+string(1:stopNum)],'Interpreter','none','Location','best');
                        xticks(hiddenNum);  % ��x���ϵĿ̶�����Ϊ����
                        try
                            xlim([hiddenNum(1) hiddenNum(end)]);
                        catch
                        end
                        % �Ż�ǰ��5������һ��ͼ���Ż����5������һ��ͼ��fcn2()�������Ż���ķ���׼ȷ�ʣ����������Ż�ǰ�ķ���׼ȷ��
                        filename_2 = ['��ͬ������������������׼ȷ��','(hLayerNum=1-1-',num2str(stopNum),')'];
                        filename_2 = fullfile(path, filename_2); %ƴ��·��
                        saveas(gcf, filename_2);        % ����Ϊfig
                        saveas(gcf, filename_2,'jpg'); %����Ϊjpg                    
                    end
				case '��'
            end
        end
            
    %% �������������ϣ�δѡ��[ִ�н�ά]��ֱ��ѡ��[ִ�з���]����ѯ���Ƿ�����classificationLearner
    else  %���ڵ�122�е�if
        
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
                    answer_hiddenNumOptimization = questdlg(quest, dlgtitle, btn1, btn2, opts);

                    % Handle response
					switch answer_hiddenNumOptimization
						
						case '��'
							time_1 = toc(timerVal_1);
							Ni = size(hmenu4_3.UserData.drData, 2); %�����ڵ�����ΪNi��10249x5 double
							No = N; %�����ڵ�����ΪNo
							Nh = []; %������ڵ�����ΪNh        
							gold_point = cell(1,paraTable_c.hiddenLayerNum);%��¼�ƽ�ָ��
							acc_avg = cell(1,paraTable_c.hiddenLayerNum);%��¼�ָ���Ӧ��׼ȷ��
							OA_detail = cell(1,paraTable_c.hiddenLayerNum); %��¼�ڻƽ�ָ�����ظ�����20�λ�õ�20��OAֵ
							%# �����״�������ڵ��Ż�ʱ��var����ΪclassDemo()�������������
							OA_avg = cell(1,paraTable_c.hiddenLayerNum); % ��¼mean(OA_detail{iLayer})
							time_goldSection = zeros(1,paraTable_c.hiddenLayerNum); %��¼ÿһ��ڵ����Ż������ĵ�ʱ��

							t = table2cell(paraTable_c);                             
							k = numel(t);                        % 28
							para = cell(1,2*k);                 % 1��56 cell ����
							for i = 1:k
								para{2*i-1} = paraTable_c.Properties.VariableNames{i};
								para{2*i} = t{i};            
							end                            
							var = cellfun(@string, para(9:end)); 
							for iLayer=1 : paraTable_c.hiddenLayerNum  % ÿ�����ز�һ����ѭ��
								N_1 = n; %ÿ���ƽ�ָ���ϵļ��������
								a = paraTable_c.startNum; % �����½磻����ȡ����������©�κ�һ�����ܵĽڵ���
								b = paraTable_c.stopNum; %�����Ͻ磻 
								acc_avg{iLayer} = [];    %  ���ڵ��������������ݣ�ÿһ�д�����һ���ƽ�ָ����20���ظ�����õ��ķ�����
																		%������20�η�������[������׼ȷ�ʣ�OA,AA,kappa]ȡƽ�����õ���һ�����ݣ�
								OA_detail{iLayer} = []; %  ���ڵ��������������ݣ�ÿһ�д�����һ���ƽ�ָ����20���ظ�����õ���20��OAֵ
								OA_avg{iLayer} = []; % ��¼mean(OA_detail{iLayer})
								% �ҵ�var����Ҫ���µĲ�������ţ�������var�еĵ�LayerNum��������Ľڵ���Ϊx(i), hiddenNumLayerNum
								TF = contains(var, 'hiddenNum');
								if iLayer>1
									TF = contains(var, ['hiddenNum', num2str(iLayer)]);
								end
								str_idx = find(TF);

								flag=1;
								while(flag)
									x_1 = a + 0.382*(b-a); %x_1��x_2����λ�������м�
									x_2 = a + 0.618*(b-a); %����Ϊ�˲�©�����ܵĵ㣬x_1������ֵӦ�þ�������˵�Լֵ��x_2������ֵӦ�þ������Ҷ˵�Լֵ
									x = [floor(x_1), ceil(x_2)];              %ÿ��ȡ�����ƽ�ָ��

									[Lia, Locb] = ismember(x, gold_point{iLayer}); %
									% Lia = 1x2 logical array, ���ܵ�ֵ��[0,0] [1,0] [0,1] [1,1]
									% Locb = 1xnumel(gold_point{iLayer})�����ܵ�ֵ���ٶ�numel(gold_point{iLayer})=5��Ϊ��
									% [0 0 0 0 0], [0 0 1 0 0], [0 0 0 0 1], [0 1 0 1 0]
									% 
									% Lia=[0,0]����ʾx�е�����ֵ��gold_point{iLayer}��û�в�ѯ���ظ������,
									% ��ʱ��Locb = [0 0 0 0 0]
									% Lia=[1,0],
									% ��ʾx�е�һ��ֵ��gold_point{iLayer}�е�ĳ��ֵ�ظ��������ʱLocb=[0 0 1 0 0]
									% ��˵���ظ���gold_point{iLayer}�еĵ����������������gold_point{iLayer}��ֻ��һ��
									% ����С����Ϊ1.
									% Lia=[1,1] ��ʾx�е�����ֵ��gold_point{iLayer}�е�ֵ�ظ��������ʱLocb=[0 1 0 1 0]
									% ��˵���ظ���gold_point{iLayer}�еĵڶ������͵��ĸ���������������gold_point{iLayer}��ֻ������һ��
									% �����С��С������Ϊ1.

									switch Lia(1)*2+Lia(2)

										case 0 % ��x���������ֶ���gold_point��û���ظ����������ƽ�ָ�㶼���㣬����

											for i = 1 : 2
												var(str_idx+1) = string(x(i));
												% ������� (n, N, setsNum, mappedA, lbs, rate, type, var)
												% ���2����������20�η�������ƽ��ֵavgResult_20iter, ��20�η�������OAֵ��OA_20iter
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

										case 1 % ��x�еڶ�������gold_point�еĵ��ظ�����ֻ�����һ���������һ��
											% Lia=[0,1]��
											% ��ʾx�еڶ���ֵ��gold_point{iLayer}�е�ĳ��ֵ�ظ��������ʱLocb=[0 0 1 0 0]
											% ��˵���ظ���gold_point{iLayer}�еĵ����������������gold_point{iLayer}��ֻ��һ��
											% ����С����Ϊ1.
											% ��x�еڶ�������gold_point�еĵ��ظ�����ֻ�����һ���������һ��

											%��¼�����ƽ�ָ����Ϊ��LayerNum������ڵ���ʱ�ķ���׼ȷ���е�OAֵ20��ƽ��׼ȷ��
											var(str_idx+1) = string(x(1));
											% ������� (n, N, setsNum, mappedA, lbs, rate, type, var)
											% ���2����������20�η�������ƽ��ֵavgResult_20iter, ��20�η�������OAֵ��OA_20iter
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

										case 2 % ��x�е�һ������gold_point�еĵ��ظ�����ֻ����ڶ���������ڶ���
											% Lia=[1,0],
											% ��ʾx�е�һ��ֵ��gold_point{iLayer}�е�ĳ��ֵ�ظ��������ʱLocb=[0 0 1 0 0]
											% ��˵���ظ���gold_point{iLayer}�еĵ����������������gold_point{iLayer}��ֻ��һ��
											% ����С����Ϊ1.                                    
											% ��x�е�һ������gold_point�еĵ��ظ�����ֻ����ڶ���������ڶ���	

											var(str_idx+1) = string(x(2));
											% ������� (n, N, setsNum, mappedA, lbs, rate, type, var)
											% ���2����������20�η�������ƽ��ֵavgResult_20iter, ��20�η�������OAֵ��OA_20iter
											[avgResult_20iter, OA_20iter] = fcn1(n, N, setsNum, mappedA, lbs, rate, type, var);                                     
											acc_avg{iLayer} = [acc_avg{iLayer}, avgResult_20iter];
											OA_detail{iLayer} = [OA_detail{iLayer}, OA_20iter];                                   

											if OA_avg{iLayer}(nonzeros(Locb)) >= mean(OA_20iter)%��2�����׼ȷ����acc_avg(Locb)���Ƚ�
												b = ceil(x_2);
											else
												a = floor(x_1);
											end
											OA_avg{iLayer} = [OA_avg{iLayer}, mean(OA_20iter)];
											gold_point{iLayer} = [gold_point{iLayer}, x(2)];
										otherwise
										% ��x���������ֶ���gold_point�ظ��������switch
									end

									% ��round(x_1) == round(x_2)ʱ����round(x_1)Ϊ������ڵ�����������
									% ������ɺ���ֹͣwhile()ѭ��
									if round(x_1) == round(x_2)
										flag = 0;
									end
								end
								%# �����iLayer���������ѽڵ���
								Nh = [Nh, x(1)];
								%# ��startNum��stopNum��Ϊ��LayerNum������ڵ����ļ�����Ҳ��ӽ�acc_avg��OA_detail����
								% ������LayerNum������ڵ������������ȣ������׼ȷ�ʵĹ�ϵ����������
								if paraTable_c.startNum==1 %��startNum==1������startNum=2����Ϊ��LayerNum������ڵ������м���
									startNum = 2;
								else
									startNum = paraTable_c.startNum;
								end
								stopNum = paraTable_c.stopNum;
								x = [startNum, stopNum];
								for i = 1 : 2
									%# ����var�еĵ�LayerNum��������Ľڵ���Ϊx(i), hiddenNumLayerNum
									%TF = contains(str,pattern)
									var(str_idx+1) = string(x(i));
									% ������� (n, N, setsNum, mappedA, lbs, rate, type, var)
									% ���2����������20�η�������ƽ��ֵavgResult_20iter, ��20�η�������OAֵ��OA_20iter
									[avgResult_20iter, OA_20iter] = fcn1(n, N, setsNum, mappedA, lbs, rate, type, var);                                     
									acc_avg{iLayer} = [acc_avg{iLayer}, avgResult_20iter];
									OA_detail{iLayer} = [OA_detail{iLayer}, OA_20iter];
								end
								OA_avg{iLayer} = [OA_avg{iLayer}, mean(OA_20iter)];
								gold_point{iLayer} = [gold_point{iLayer}, x];
								%# �����LayerNum������ڵ���ȡ�ƽ�ָ��ʱ�ķ�����
								% gold_point{iLayer}��acc_avg{iLayer}, OA_detail{iLayer}, OA_avg{iLayer}
								% ���ߵ�����hiddenLayerNum��������ڵ���ȫ���Ż���֮���ٱ���
								d = time_goldSection(end);
								time_goldSection(iLayer) = toc(timerVal_1) - time_1 - d;                                
							end
							% �ƽ�ָѰ�Ž�����

							% ���ҵ��ĸ�������ڵ���������ֵ��ֵ��paraTable_c�е���Ӧ����(����ֻ���ǵ���������)
							if paraTable_c.hiddenLayerNum==1
								paraTable_c.hiddenNum=Nh(1);
								for i = 1:paraTable_c.hiddenLayerNum-1
									estr = ['paraTable_c.hiddenNum', num2str(i), '=Nh(',num2str(i+1),');' ];
									eval(estr);
								end
							end
							% �ƽ�ָѰ�Ž���������
						case '��'
					end
				end

                t = table2cell(paraTable_c);
                
                k = numel(t); 
                para = cell(1,2*k);
                for i = 1:k
                    para{2*i-1} = paraTable_c.Properties.VariableNames{i};
                    para{2*i} = t{i};
                end
                var = cellfun(@string, para(9:end)); %��cell array�е�����cellӦ��string
        
                for k = 1 : n
                    [mA1,mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate); % rate: ��ʹ�õ�ѵ����ռ��
                    XTrain = table2array(mA1(:, 1:end-1))';           %mappedA��mA����ÿһ��Ϊһ����������XTrain��ÿһ��Ϊһ��������
                    TTrain = ind2vec(double(mA1.Class)');
                    %%����ʹ��ϡ�������ʽ����������ѵ�����罫�ᵼ���ڴ�ռ��̫�����Ի��ǻ��������������ʽ��TTrain��
                    % TTrain = double(mA1.Class)';
                    XTest = table2array(mA2(:, 1:end-1))';             %XTestÿһ��Ϊһ������                
                    TTest = ind2vec(double(mA2.Class)');            %TTestÿһ��Ϊһ������ǩ
                    disp(['��',num2str(k),'�μ���']);
                    [netTrained, trainRecord, predictedVector, misclassRate, cmt] = classDemo(XTrain, TTrain, XTest, TTest, type, var);%ǰ3��Ϊ�������������Ϊ��ѡ����
                    %��������ܸ������м�ֵ�ļ������ǣ� net tr tTest c cm 
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
                % load('���̲���\20220517\cmNormalizedValues1.mat','cmt'); %���ڲ���
                % [size1, size2, size3, size4] = size(cmt);   % huston.mat���ݼ��Ļ�������ߴ磺15��15��20��2

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
                    path = fullfile(path, hmenu4_1.UserData.datasetName, [hmenu4_1.UserData.drAlgorithm,'null'], hmenu4_1.UserData.cAlgorithm);
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
                info_1 = hmenu4_1.UserData;
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
                %# ����time_goldSection
                if exist('time_goldSection','var')==1
                    VariableNames = ["iLayer_"+string(1:paraTable_c.hiddenLayerNum)];
                    RowNames = "colapsedTime";
                    timeTable = array2table(time_goldSection, 'VariableNames', VariableNames);
                    timeTable.Properties.RowNames = RowNames;
                    writetable(timeTable,filename,'Sheet',iset+1,'Range','A27', 'WriteRowNames',true, 'WriteVariableNames', true);
                end
                %% ����ѵ�������е���������err_perf, err_vperf, err_tperf, racc��Excel��Sheet
                T1 = createTableForWrite(err_perf, err_vperf, err_tperf, racc);
                errTable = [T1.Variables; mean(T1.Variables); std(T1.Variables)];  % T1.Variables ��20��8 double
                errTable = array2table(errTable, 'VariableNames', T1.Properties.VariableNames);
                errTable.Properties.RowNames = [T1.Properties.RowNames; {'average'}; {'std'}]; %����2�е�������
                filename = "C:\Matlab��ϰ\Project20191002\���̲���\2022-06-04 19-45-16\Botswana\LDA\GA_TANSIG\Botswana_LDA_GA_TANSIG.xlsx";
                errTable.Properties.Description = '����ѵ�������е���������err_perf, err_vperf, err_tperf, racc';
                writetable(errTable,filename,'Sheet',iset+2,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);  

                %% ����������������ڵ������Ż����
                % ��Ѱ�ҵ�����������net��gold_point, acc_avg, OA_detail��Ѱ����ϢhiddenNumInfoһ�𱣴�Ϊmat���ݡ�
                % ֮���Էŵ���������Ϊ������ԭ��
                % 1. ���ֱ����ǰ�桾������������ڵ���Ѱ�š�����������ɴ�ʱ����ļ������Ļ���ʱ����������Excel��д��ʱ�䡣
                % 2. ������������ڵ���Ѱ�ŵĽ�������ݼ�����ά�㷨�������㷨���й�ϵ�������path�����������ļ����ؼ���Ϣ��
                %     ����ֱ���������path��Ϊ[����������������ڵ������Ż����]�Ǹ�����ġ�
                if paraTable_c.hiddenNumOptimization && strcmp(answer_hiddenNumOptimization, '��')
                    gold_point_sorted = cell(1,paraTable_c.hiddenLayerNum);
                    acc_avg_sorted = cell(1,paraTable_c.hiddenLayerNum);
                    OA_detail_sorted = cell(1,paraTable_c.hiddenLayerNum);
                    %## ÿһ������ļ��������浽һ��sheet��
                    for iLayer = 1:paraTable_c.hiddenLayerNum
                        %# �Ե�iLayer������ķ���׼ȷ��gold_point{iLayer}, acc_avg{iLayer}, OA_detail{iLayer}����ά���ϵ���˳��
                        % ����sort()������gold_point{iLayer}�е�������С�������򣬽�����浽gold_point_sorted{iLayer}�У�
                        % ͬʱ���õ�����������I
                        % �̶�������������I, ����ά���϶�acc_avg{iLayer},OA_detail{iLayer}����
                        % ������浽acc_avg_sorted{iLayer}��OA_detail_sorted{iLayer}

                        [B, I] = sort(gold_point{iLayer});
                        gold_point_sorted{iLayer} = B;
                        acc_avg_sorted{iLayer} = acc_avg{iLayer}(:, I);
                        OA_detail_sorted{iLayer} = OA_detail{iLayer}(:, I);
                        %# ������֮��ĵ�iLayer������ķ���׼ȷ�������table��ʽ
                        [size_1, size_2] = size(acc_avg{iLayer});
                        accData = [gold_point{iLayer}; gold_point_sorted{iLayer}; acc_avg_sorted{iLayer};...
                            OA_detail_sorted{iLayer}; mean(OA_detail_sorted{iLayer}); std(OA_detail_sorted{iLayer})];
                        % Ϊcell��ÿһ�д��������� VariableNames
                        VariableNames = cell(1,size_2);
                        for i = 1:size_2
                            VariableNames{i}= ['goldPoint_',num2str(i)];
                        end
                        %# �����е����� RowNames���������ַ�Ԫ������ ��1��(2+size_1+size_3+2) cell��
                        [size_3, size_4] = size(OA_detail{iLayer});
                        RowNames = cell(1, 2+size_1+size_3+2); 
                        RowNames{1} = ['goldPoint{iLayer=',num2str(iLayer),'}'];
                        RowNames{2} = 'goldPoint_sorted';
                        for i = 1+2 : size_1-3+2              % acc_avg���3�зֱ���OA��AA��kappa
                            RowNames{i} = ['class_',num2str(i-2)];
                        end
                        RowNames(i+1 : i+3) = {'OA', 'AA', 'Kappa'};
                        i = i+3;
                        RowNames(i+1: i+size_3) = cellstr("iter_"+string(1:size_3));
                        i = i+size_3;
                        RowNames(i+1 : i+2)  = {'average', 'std'};
                        % path��filename���Ѿ�����
                        accTable = array2table(accData, 'VariableNames', VariableNames);
                        accTable.Properties.RowNames = RowNames;
                        % Sheet 1�����Ż�֮ǰ�ķ�������Sheet 2�����Ż�֮��ķ�������
                        % Sheet 3����ִ�з�����������������Ϣ��Sheet 4����ѵ��������Ϣ��
                        % Sheet iLayer+4���Ա����iLayer������ķ���׼ȷ����Ϣ��
                        writetable(accTable,filename,'Sheet',iLayer + iset+2,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);                

                    end
                end

                %% �������ͼ����                
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
                % f.Children
                % ans = 
                % 3��1 graphics ����:
                % UIControl
                % Legend       (Class 1, Class 2, Class 3, Class 4, Class 5, Class 6, Clas��)
                % Axes         (ROC)       filename_2 = fullfile(path,"net_best{2,2}_"+"originROC");%ƴ��·��
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
                %Ylbs��ʾԤ���lbs��Ϊһ��������
                % ����ͨ����Ylbsͨ��reshape()�ķ�ʽ����Ϊ��ά������ΪYlbs�������������е������ţ�
                % ��������ͼƬ�ϵ��������ص�������
                % ��ȷ�������ǣ���ȫ��������������netBest����ȡYlbs������������
                % �ٽ�������YlbsǶ���ά����gtdata����ȡ�µĶ�ά����Ygtdata

                gtdata = handles.UserData.gtdata;
                gtdata(gtdata~=0)=Ylbs;    %����ǩ�������г�GTͼ
                Ygtdata = gtdata; %Ygtdata��ʾԤ���gtdata
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
                % saveas(gcf, filename_2);        % ����Ϊfig
                % saveas(gcf, filename_2,'jpg'); %����Ϊjpg

                %% ������������       
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
                delete(MyPar) %������ɺ�رղ��д����
                
                %% ����������������Ż� ѯ���Ƿ�Ҫִ���������������������ȣ��Ż�
                [mA1, mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate);  % rate: ��ʹ�õ�ѵ����ռ��
                XTrain = table2array(mA1(:, 1:end-1))';  %mappedA��mA����ÿһ��Ϊһ����������XTrain��ÿһ��Ϊһ��������
				if paraTable_c.hLayerNumOptimization
                    % ѯ���Ƿ�Ҫ�������������������������ֵ����
                    quest = {'\fontsize{10} �Ƿ�Ҫִ����������������Ż���Ѱ�����������������ֵ��'};
                             % \fontsize{10}�������С���η���������ʹ�������ַ���С��Ϊ10����
                    dlgtitle = '�����������������������ȣ��Ż�';
                    btn1 = '��';
                    btn2 = '��';
                    opts.Default = btn2;
                    opts.Interpreter = 'tex';
                    % answer = questdlg(quest,dlgtitle,btn1,btn2,defbtn);
                    answer_hLayerNumOptimization = questdlg(quest, dlgtitle, btn1, btn2, opts);

                    % Handle response
					switch answer_hLayerNumOptimization
						case '��'
							% %## ����ȷ����������Ԫ���������Բ��ù�ʽ�����㣬Ҳ�����ֶ�ָ��
							% time_1 = toc(timerVal_1);
							% [Ni, Ns] = size(XTrain); % XTrainÿһ��Ϊһ��������������Ϊ��ά�����������ڵ���������Ϊѵ����������
							% % ����������ά�����������Ľڵ�����
							% N = hmenu4_1.UserData.M-1;     % �������
							% No = N; %�����ڵ�����ΪNo
							% % Botswana, round(3248*0.2)=650,No=14, 650./(a*(10+14))=[13.5417 2.7083]

							% a = [2, 10]; % ϵ��aͨ��ȡ2~10
							% % ������ڵ������㹫ʽ Nh = Ns/(a*(Ni+No));  %������ڵ�����ΪNh
							% Nhd = Ns./(a*(Ni+No));
							% % ��Ni=5;No=14;Ns=650ʱ��Nhd=[17.1, 3.4];
							% % Ni=10ʱ��No=14;Ns=650ʱ��Nhd=[13.6, 2.7];
							% % �����������Ԫȡֵ�½�ֵ�ɶ�Ϊfloor(Nh(2))=3��
							% % �Ͻ�ֵ�ɶ�Ϊceil(Nh(1)/floor(Nh(2)))*floor(Nh(2))��ѭ������Ϊceil(Nh(1)/floor(Nh(2)))
							% iteration = ceil(Nhd(1)/floor(Nhd(2)));
							% Nhd_min = floor(Nhd(2));
							% Nhd_max = ceil(Nhd(1)/floor(Nhd(2)))*floor(Nhd(2));

							% %# ��ʼ���������������
							% % ����������ڵ���ΪNhd = [18,3]��������У�һ���̶���������ڵ�����1~5�������������½��б���������Եõ�5�з�����
							% % ���ܹ�6��������ڵ��������Եõ�5��6=30�з�����
							% % ���ÿ��sheetֻ����һ���̶���������ڵ�����1~5�������������½��б�����5�н���Ļ�������Ҫ��������6��sheet
							% % ��������̫�˷��ˣ����Խ�30�з��������浽ͬһ��sheet��
							% % �ڶ���sheet����OA_20iter�����һ��sheet�е���һһ��Ӧ��
							% % errTable�Ȳ������ˣ�һ���̶���������ڵ�����������Ĳ����̶�������£��Ϳ��Ի��n=20��err_perf����
							% % ��6��������ڵ�����5������������£�����20��5��6=600�����ݣ�̫���˲��ñ���
							% % ������������Ǵ�1�㵽stopLayerNum+1��

							%## �ֶ�ָ��Ҫ������������ڵ���
							hiddenNum = [150]; %, 120, 125, 130, 135, 140, 145, 150];
							% hiddenNum = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
							% hiddenNum = [55, 60, 65, 70, 75, 80, 85, 90, 95, 100];
							if ~exist('Nhd_min', 'var')
								if exist('hiddenNum', 'var')
									if hiddenNum(:)~=0
										Nhd_min=min(hiddenNum);
									else
										disp(['Nhd_min�����ڣ���min(hiddenNum)Ϊ0���޷���ֵ��Nhd_min']);
									end
								else
									disp(['Nhd_min�����ڣ���hiddenNum�����ڣ��޷���ֵ��Nhd_min']);
								end
							end
							if ~exist('Nhd_max', 'var')
								if exist('hiddenNum', 'var')
									if hiddenNum(:)~=0
										Nhd_max=max(hiddenNum);
									else
										disp(['hiddenNum���в���Ԫ��ֵΪ0���޷���ֵ��Nhd_min']);
									end
								else
									disp(['Nhd_max�����ڣ���hiddenNum�����ڣ��޷���ֵ��Nhd_max']);
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
							% acc��ʾ������������׼ȷ�ʡ�OA��AA��Kappa���ڵ���������׼ȷ�����ݣ�
							% acc_avg��ʾ20���ظ�����õ�����������׼ȷ�ʵ�ƽ��ֵ
							OA_detail = zeros(n, iColomn); %��¼�ڻƽ�ָ�����ظ�����20�λ�õ�20��OAֵ
							OA_avg = zeros(1, iColomn); % ��¼mean(OA_detail)
							time_Layer = zeros(1, iColomn); %��¼ÿһ���ڵ����ڲ�ͬ����ʱ�����ĵ�ʱ��
							%# ������ParametersForDimReduceClassify���趨�����½��������
							% ֻҪ��������½�ֵ���ڵ����趨���½�ֵ���Ҽ�������Ͻ�ֵС�ڵ����趨���Ͻ�ֵ����������Ҫ��
							%if floor(Nhd(2))<=paraTable_c.startLayerNum && ceil(Nhd(1)/floor(Nhd(2)))*floor(Nhd(2))<=paraTable_c.stopLayerNum
							%    disp('��ʼ��������������Ż�');
							%elseif floor(Nhd(2))>paraTable_c.startLayerNum                        
							%    paraTable_c.startLayerNum;
							%    paraTable_c.stopLayerNum;
							%end

							% ��hiddenLayerNum��stopLayerNum������Ѱ�Ų���
							% ��������������Ǵ�1�㵽stopLayerNum+1��
							% hiddenNum = zeros(1,iteration);
							time_start = toc(timerVal_1);
							for i = 1: iteration
								% ������ڵ���ΪNhd_min*i;
								%hiddenNum(i) = Nhd_min*i + 14;
								% �����������paraTable_c
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
									%   1��28 cell ����
									%     {[1]}    {[0.2000]}    {[3]}    {[20]}    {["trainscg"]}    {[20]}    {["tansig"]}    {[0]}    {[0]}
									%     {[0]}    {[0]}    {[0]}    {[0]}    {[2]}    {[20]}    {["tansig"]}    {[20]}    {["tansig"]}    {[20]}
									%     {["tansig"]}    {[20]}    {["tansig"]}    {[1]}    {[1]}    {[100]}  {[1]}    {[1]}    {[4]}
									k = numel(t);                        % 28
									para = cell(1,2*k);                 % 1��56 cell ����
									for iPara = 1:k
										para{2*iPara-1} = paraTable_c.Properties.VariableNames{iPara};
										para{2*iPara} = t{iPara};            
									end
									% para =
									%   1��56 cell ����
									%   �� 1 �� 8
									%     {'dimReduce'}    {[1]}    {'rate'}    {[0.2000]}    {'app'}    {[3]}    {'executionTimes'}    {[20]}    
									%   �� 9 �� 50
									%     {'trainFcn'}  {["trainscg"]}    {'hiddenNum'}    {[20]}    {'transferFcn'}    {["tansig"]}    {'showWindow'}    {[0]}
									%     {'plotperform'}    {[0]}    {'plottrainstate'}    {[0]}    {'ploterrhist'}    {[0]}    {'plotconfusion'}    {[0]}
									%     {'plotroc'}    {[0]}    {'hiddenLayerNum'}    {[2]}    {'hiddenNum1'}    {[20]}    {'transferFcn1'}    {["tansig"]}
									%     {'hiddenNum2'}    {[20]}    {'transferFcn2'}    {["tansig"]}    {'hiddenNum3'}    {[20]}    {'transferFcn3'}
									%     {["tansig"]}    {'hiddenNum4'}    {[20]}    {'transferFcn4'}    {["tansig"]}    
									%     {'hiddenNumOptimi��'}    {[1]}    {'startNum'}    {[1]}    {'stopNum'}    {[100]} 
									%     {'hLayerNumOptimi��'}    {[1]}    {'startLayerNum'}    {[1]}    {'stopLayerNum'}    {[4]} 
									var = cellfun(@string, para(9:end)); %��cell array�е�ÿһ��cellӦ��string
									% var = 
									%   1��48 string ����
									%     "trainFcn"    "trainscg"    "hiddenNum"    "20"    "transferFcn"    "tansig"    "showWindow"    "false"
									%     "plotperform"    "false"    "plottrainstate"    "false"    "ploterrhist"    "false"    "plotconfusion"    "false"
									%     "plotroc"    "false"    "hiddenLayerNum"    "2"    "hiddenNum1"    "20"    "transferFcn1"    "tansig"    "hiddenNum2"
									%     "20"    "transferFcn2"    "tansig"    "hiddenNum3"    "20"    "transferFcn3"    "tansig"    "hiddenNum4"    "20"
									%     "transferFcn4"    "tansig"    "hiddenNumOptimiza��"    "true"    "startNum"    "1"    "stopNum"    "100"
									%     "hLayerNumOptimiza��"    "true"    "startLayerNum"    "1"    "stopLayerNum"    "4"    

									% ���2����������20�η�������ƽ��ֵavgResult_20iter, ��20�η�������OAֵ��OA_20iter
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

							%## �������������Ѱ�Ž��
							%# Ϊcell��ÿһ�д��������� VariableNames
							% hNum1hLayer1~hNum1hLayer5, hNum2hLayer1~hNum2hLayer5, ������hNum6hLayer1~hNum6hLayer5
							VariableNames = cell(1, iColomn);
							for i = 1:iteration
								for iLayer = 1:stopNum
									VariableNames{(i-1)*stopNum+iLayer}= ['hNum=',num2str(hiddenNum(i)),' hLayer=',num2str(iLayer)];
								end
							end
							%# �����е����� RowNames1���������ַ�Ԫ����������ַ������飻
							[size_1, size_2] = size([acc_avg; timeLayer]);
							RowNames1(1:size_1-4) = "class_"+string(1:(size_1-4)); 
							RowNames1(size_1-3) = "OA";
							RowNames1(size_1-2) = "AA";
							RowNames1(size_1-1) = "Kappa";
							RowNames1(size_1) = "time_Layer"; % ÿһ����������ĵ�ʱ��
							%# �����е����� RowNames2���������ַ�Ԫ����������ַ������飻 
							[size_3, size_4] = size(OA_detail);
							RowNames2 = "iter_"+string(1:size_3); 
							RowNames2(size_3+1) = "average";
							RowNames2(size_3+2) = "std";

							%# ����Excel�ļ������ַ
							% �����ļ�������
							path = ['C:\Matlab��ϰ\Project20191002\���̲���\', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS')];
							try
								path = fullfile(path, hmenu4_1.UserData.datasetName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
							catch
							end
							% ������ɵ��ļ������Ʋ����ڣ����ȴ����ļ���
							if ~exist(path, 'dir')
								[status,msg,msgID] = mkdir(path);
							end
							% path�Ѿ����ˣ�filename��������
							filename = [hmenu4_1.UserData.datasetName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'_hLayerOptimization','.xlsx'];
							filename = fullfile(path, filename);
							accTable = array2table([acc_avg; timeLayer], 'VariableNames', VariableNames);
							accTable.Properties.RowNames = RowNames1;
							% Sheet 1�����Ż�30�У�6��������ڵ���5�������㣩������acc_avg��
							% ÿһ�ж���20���ظ�����ķ���׼ȷ�ʵ�ƽ��ֵ�����������ķ���׼ȷ�ʣ��Լ�OA, AA, Kappa
							writetable(accTable,filename,'Sheet',1,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);
							% Sheet 2�����Ż�30�У�6��������ڵ���5�������㣩������OA_detail��   
							% ÿһ����20���ظ������õ�20��OAֵ
							OATable = array2table([OA_detail; OA_avg; std(OA_detail)], 'VariableNames', VariableNames);
							OATable.Properties.RowNames = RowNames2;
							writetable(OATable,filename,'Sheet',2,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);  

							%# ������Ϣ����
							%% �����йط��������������õ���ϸ��Ϣ������Sheet��
							% ���潵ά�������������paraTable_c��Sheet 3�У�
							% ��Ҫ��startNum��stopNum, startLayerNum ��stopLayerNum
							paraTable_c.startNum = Nhd_min;
							paraTable_c.stopNum = Nhd_max;
							writetable(paraTable_c, filename, 'Sheet',3,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);

							%# �������ݼ���Ϣhmenu4_1.UserData��Sheet(iset+1)
							info_1 = hmenu4_1.UserData;
							info_1.x3 = [];
							info_1.lbs2 = [];
							info_1.x2 = [];
							info_1.lbs = [];
							info_1.cmap = [];
							info_1.Nhd_min = Nhd_min;
							info_1.Nhd_max = Nhd_max;
							% info_1.elapsedTimec = toc(timerVal_1)-time1; % �����������ʱ��
							info_1 = struct2table(info_1, 'AsArray',true);
							writetable(info_1, filename, 'Sheet',3,'Range','A3', 'WriteRowNames',true, 'WriteVariableNames', true);
							%# ��������cmap
							info_cmap = hmenu4_1.UserData.cmap;
							variableNames = ["R","G","B"]; %VariableNames����Ϊ�ַ�����Ԫ������{'R','G','B'}��
							% ����ָ������������ƣ������ַ�������["R","G","B"]���ַ�����Ԫ������{'R','G','B'}��ָ����Щ���ơ�
							% �����е����� RowNames3����ʽΪ�ַ�������["1","2","3"]���ַ�����Ԫ������{'1','2','3'}��
							RowNames3 = string(1:size(info_cmap,1)); % ��
							info_cmap = array2table(info_cmap, 'VariableNames', variableNames);
							info_cmap.Properties.RowNames = RowNames3;
							writetable(info_cmap,filename,'Sheet',3,'Range','A5', 'WriteRowNames',true, 'WriteVariableNames', true);

							%# �����е����� RowNames4���������ַ�Ԫ����������ַ������飻
							[size_5, size_6] = size(err_avg);
							if size_5==8
								RowNames4 = {'err_perf1','err_perf2','err_vperf1','err_vperf2','err_tperf1','err_tperf2','racc1','racc2'};
							elseif size_5==4
								RowNames4 = {'err_perf','err_vperf','err_tperf','racc'};
							end
							errTable = array2table(err_avg, 'VariableNames', VariableNames);
							errTable.Properties.RowNames = RowNames4;
							% Sheet 3�����Ż�30�У�6��������ڵ���5�������㣩ѵ����������err_avg��
							% ÿһ�ж���20���ظ������ѵ���������ݵ�ƽ��ֵ�����������ķ���׼ȷ�ʣ��Լ�OA, AA, Kappa
							writetable(errTable,filename,'Sheet',4,'Range','A1', 'WriteRowNames',true, 'WriteVariableNames', true);            
							%# ���������Ѱ�Ž��������� 
						case '��'
					end
				end
            case 'exit'
                disp('ClassDemo�Ѿ��˳�.')
                %dessert = 0;
		end    
       
    end
    %     path = ['C:\Matlab��ϰ\Project20191002\���̲���\', datestr(datetime('now'), 'yyyy-mm-dd HH-MM-SS')];
    %     saveAllFigure(path,handles,'.fig');
    %     gc = gcf; 
    %     closeFigure([2:gc.Number]);
    %     closeFigure([2:13]);
end

%% �Ӻ��������ڻƽ�ָѰ����������ѽڵ�����
function [avgResult_20iter, OA_20iter] = fcn1(n, N, setsNum, mappedA, lbs, rate, type, var)

	%# n,N,sets������������Ҫ���ڱ���������ĸ��������ĳ�ʼ��
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
	acc = zeros(n, setsNum);
	% acc(k,1)�����k�ε��������Ż�ǰ��׼ȷ�ʣ�acc(k,2)�����k�ε��������Ż����׼ȷ�ʣ�
			
	racc = zeros(n, setsNum);        % ���������󷵻�ֵ�еĵ�һ��ֵc������ʣ�����1-acc
	err_perf = zeros(n, setsNum);   % ����trainRecord.best_perf��
	err_vperf = zeros(n, setsNum); %����trainRecord.best_vperf��
	err_tperf = zeros(n, setsNum); %����trainRecord.best_tperf�� 
	
    for k = 1:n
    % ��������
		[mA1, mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate);  % rate: ��ʹ�õ�ѵ����ռ��
		XTrain = table2array(mA1(:, 1:end-1))';   %mappedA��mA����ÿһ��Ϊһ����������XTrain��ÿһ��Ϊһ��������
		TTrain = ind2vec(double(mA1.Class)');
		%%��ʱ�����־���ʹ��ϡ�������ʽ����������ѵ�����罫�ᵼ���ڴ�ռ��̫�����Ի��ǻ��������������ʽ��TTrain?
		% �����Ļ����ʹ������net(XTest)��õ�outputsҲ��һ��������ʽ���������������confusion(targets,outputs)
		% �Զ�����������ݵ���ʽҪ�����Բ���ֱ�����뵽confusion(targets,outputs)��
		% confusion()Ҫ�������targets������S��Q�ľ�����ʽ����ÿһ�б�����one-hot-vector��outputsҲ������S��Q�ľ�����ʽ
		% outputs��Ԫ��ֵ��Сλ��[0,1]֮�䣬��ÿһ�е����ֵ��Ӧ��������S���е�һ����
		% ���ң�����outputs��������ת����ϵ������ʱ�ᱨ��
		% ���Բ��ò�����ʹ��ϡ�������ʽ��TTrain����Ϊѵ��������������ݡ�
		% ������δ�����м�����������û�г��ֹ�����ġ�
		XTest = table2array(mA2(:, 1:end-1))';     %XTestÿһ��Ϊһ������
		TTest = ind2vec(double(mA2.Class)');     %TTestÿһ��Ϊһ������ǩ                            
		disp(['��',num2str(k),'�μ���']);
		[netTrained, trainRecord, predictedVector, misclassRate, cmt] = classDemo(XTrain, TTrain, XTest, TTest, type, var);%ǰ3��Ϊ�������������Ϊ��ѡ����
		%��������ܸ������м�ֵ�ļ������ǣ� [net tr tTest c cm],     
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

	%% ��������������ݻ�������cmNormalizedValues1������OA, AA, Kappa��
	[size1, size2, size3, size4] = size(cmNormalizedValues1);  % 16��16��20��2 double
	cmt = cmNormalizedValues1;
	% load('���̲���\20220517\cmNormalizedValues1.mat','cmt'); %���ڲ���
	% [size1, size2, size3, size4] = size(cmt);   % huston.mat���ݼ��Ļ�������ߴ磺15��15��20��2
	
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
    
    % ���ؽ�����Ż����c�е�averageһ�У��Լ�OA
	avgResult_20iter = c(:,size3+1,end);   % ����c�е�averageһ��
	OA_20iter = c(size2+1,1:n,end)'; % ����c�е�OAһ��
end

%% �Ӻ����������ڹ̶�������ڵ���������¼��㲻ͬ�����ķ���׼ȷ�ʣ�
function [avgResult_20iter, OA_20iter, avgError_20iter] = fcn2(n, N, setsNum, mappedA, lbs, rate, type, var)

	% %# n,N,sets������������Ҫ���ڱ���������ĸ��������ĳ�ʼ��
	% acc_best = zeros(setsNum, setsNum); % ��¼n�ε����µ����׼ȷ��OA��ֵ
	% % acc_best(1,1)�����Ż�ǰ�����accֵ; acc_best(2, 2)�����Ż�������accֵ
	% % acc_best(1,2)�����Ż�ǰ�����accֵ��Ӧ���������Ż����׼ȷ��ֵ
	% % acc_best(2,1)�����Ż�������accֵ��Ӧ���������Ż�ǰ��׼ȷ��ֵ
	% net_best = cell(setsNum, setsNum); % ��¼���׼ȷ����ѵ���õ����磨���ڻ���GTͼ��
	% % net_best{1,1}�����Ż�ǰ�������accֵ������; net_best{2, 2}�����Ż���������accֵ������
	% % net_best{1,2}�����Ż�ǰ�������accֵ���������Ż��������
	% % net_best{2,1}�����Ż���������accֵ���������Ż�ǰ������

	% tTest_best = cell(1, setsNum);
	% tTest_bestҲ���Գ�ʼ��Ϊcell(setsNum, setsNum)�����ǵ��Ἣ�����Ĵ洢�ռ䣬
	% ���ǽ����ʼ��Ϊcell(1, setsNum)��
	% tTest_best{1,1}�����Ż�ǰ�������accֵ������Ԥ���������; 
	% tTest_best{1,2}�����Ż���������accֵ������Ԥ�����������
	cmNormalizedValues1 = zeros(N, N, n, setsNum); %��������˳��Ļ�������
	% cmNormalizedValues1(:, :, k, 1)�����k�ε��������Ż�ǰ���������ܵĻ�������;
	% cmNormalizedValues1(:, :, k, 2)�����k�ε��������Ż�����������ܵĻ�������;
	acc = zeros(n, setsNum);
	% acc(k,1)�����k�ε��������Ż�ǰ��׼ȷ�ʣ�acc(k,2)�����k�ε��������Ż����׼ȷ�ʣ�
			
	racc = zeros(n, setsNum);        % ���������󷵻�ֵ�еĵ�һ��ֵc������ʣ�����1-acc
	err_perf = zeros(n, setsNum);   % ����trainRecord.best_perf��
	err_vperf = zeros(n, setsNum); %����trainRecord.best_vperf��
	err_tperf = zeros(n, setsNum); %����trainRecord.best_tperf�� 
	
    for k = 1:n
    % ��������
		[mA1, mA2, ind1, ind2] = createTwoTable(mappedA, lbs, rate);  % rate: ��ʹ�õ�ѵ����ռ��
		XTrain = table2array(mA1(:, 1:end-1))';   %mappedA��mA����ÿһ��Ϊһ����������XTrain��ÿһ��Ϊһ��������
		TTrain = ind2vec(double(mA1.Class)');
		%%��ʱ�����־���ʹ��ϡ�������ʽ����������ѵ�����罫�ᵼ���ڴ�ռ��̫�����Ի��ǻ��������������ʽ��TTrain?
		% �����Ļ����ʹ������net(XTest)��õ�outputsҲ��һ��������ʽ���������������confusion(targets,outputs)
		% �Զ�����������ݵ���ʽҪ�����Բ���ֱ�����뵽confusion(targets,outputs)��
		% confusion()Ҫ�������targets������S��Q�ľ�����ʽ����ÿһ�б�����one-hot-vector��outputsҲ������S��Q�ľ�����ʽ
		% outputs��Ԫ��ֵ��Сλ��[0,1]֮�䣬��ÿһ�е����ֵ��Ӧ��������S���е�һ����
		% ���ң�����outputs��������ת����ϵ������ʱ�ᱨ��
		% ���Բ��ò�����ʹ��ϡ�������ʽ��TTrain����Ϊѵ��������������ݡ�
		% ������δ�����м�����������û�г��ֹ�����ġ�
		XTest = table2array(mA2(:, 1:end-1))';     %XTestÿһ��Ϊһ������
		TTest = ind2vec(double(mA2.Class)');     %TTestÿһ��Ϊһ������ǩ                            
		disp(['��',num2str(k),'�μ���']);
		[netTrained, trainRecord, predictedVector, misclassRate, cmt] = classDemo(XTrain, TTrain, XTest, TTest, type, var);%ǰ3��Ϊ�������������Ϊ��ѡ����
		%��������ܸ������м�ֵ�ļ������ǣ� [net tr tTest c cm],     
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
            % if acc(k, iset) > acc_best(iset, iset)    
				% % acc_best(1,1)�����Ż�ǰ�����accֵ; acc_best(2, 2)�����Ż�������accֵ
				% % acc_best(1,2)�����Ż�ǰ�����accֵ��Ӧ���������Ż����׼ȷ��ֵ
				% % acc_best(2,1)�����Ż�������accֵ��Ӧ���������Ż�ǰ��׼ȷ��ֵ
				% acc_best(iset, :)=acc(k, :);
				% net_best(iset, :)=netTrained;
				% tTest_best(1, iset)=predictedVector(iset);
				% % tTest_best{1,1}�����Ż�ǰ�������accֵ�������Ԥ�����������
				% % tTest_best{1,2}�����Ż���������accֵ�������Ԥ�����������                  
            % end
        end
    end

	%% ��������������ݻ�������cmNormalizedValues1������OA, AA, Kappa��
	[size1, size2, size3, size4] = size(cmNormalizedValues1);  % 16��16��20��2 double
	cmt = cmNormalizedValues1;
	% load('���̲���\20220517\cmNormalizedValues1.mat','cmt'); %���ڲ���
	% [size1, size2, size3, size4] = size(cmt);   % huston.mat���ݼ��Ļ�������ߴ磺15��15��20��2
	
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
    
    % ���ط��������Ż����c�е�averageһ�У��Լ�OA
	avgResult_20iter = c(:,size3+1,end);   % ����c�е�averageһ��
	OA_20iter = c(size2+1,1:n,end)'; % ����c�е�OAһ��
	% ����ѵ���������� T1
	T1 = createTableForWrite(err_perf, err_vperf, err_tperf, racc);
	avgError_20iter = mean(T1.Variables)';
	% errTable = [T1.Variables; mean(T1.Variables); std(T1.Variables)];  % T1.Variables ��20��8 double
	% errTable = array2table(errTable, 'VariableNames', T1.Properties.VariableNames);
	% errTable.Properties.RowNames = [T1.Properties.RowNames; {'average'}; {'std'}]; %����2�е�������	
	% errTable = T1;
	% 
end
