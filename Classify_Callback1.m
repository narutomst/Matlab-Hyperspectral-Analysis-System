%���û�ѡ�����ܷ��ࡿ����󣬳��������û���Excel�����õĲ�����app����ֵ
%�Լ������Ƿ��Ѿ�������ά�������������ú��ַ�ʽ��ClassDemo\Classification Learner\nprtool�����з��ࡣ
function Classify_Callback1(hObject, eventdata, handles) %��113��
global x3 lbs2 x2 lbs mappedA Inputs Targets Inputs1 Inputs2 Inputs3 t0 t1 t2 mA mA1 mA2
%% ���ݴ�������άmatת��ά����άgtתһά��
% hmenu4 = findobj(handles,'Tag','Analysis');
hmenu4_1 = findobj(handles,'Label','��������');
hmenu4_3 = findobj(handles,'Label','ִ�н�ά');

if isempty(hmenu4_3.UserData) || ~isfield(hmenu4_3.UserData, 'drData') || isempty(hmenu4_3.UserData.drData)
    mappedA = hmenu4_1.UserData.x2;         %������δ����ά
else
    mappedA = hmenu4_3.UserData.drData;  %�������Ѿ����˽�ά
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

workbookFile = fullfile(handles.UserData.mFilePath,"��ά����ͳ��.xlsx");
try
    paraTable_c = importfile2(workbookFile, "Sheet2", dataLines);
catch    
    paraTable_c = importfile2(workbookFile, "Sheet2", [2,2]);
end
t = table2cell(paraTable_c);
ss = table2struct(paraTable_c);
n = numel(t); 
para = cell(1,2*n);
for i = 1:n
	para{2*i} = t{i};
	para{2*i-1} = paraTable_c.Properties.VariableNames{i};
end

% �õ����շ���׼ȷ��acc
% hyperDemo_1(hmenu4_1.UserData.x3);
% hyperDemo_detectors_1(hmenu4_1.UserData.x3);
% һά���෽��
timerVal_1 = tic;
disp('����׼��.......................................................................');

rate = paraTable_c.rate;



%% ׼��������֮�������кü���˼·

Inputs = x2';
while (min(lbs(:))==0)
    lbs = lbs+1;
end
% vector_lbs2 = ind2vec(lbs2); % �����������ֻ����һά
Targets = ind2vec(lbs');

% 1. nnstart >> nprtool��Pattern Recognition and Classification��
% ��Ϊÿ��App׼�����ʵ�"���ݽṹ"������GUI�����н����ܿ�������ѡ�ı���
% �����������ÿһ��Ϊһ������
% �ŵ㣺
% nprtool��ȱ�㣺ֻ��һ�������㣬��ִ��ѵ����ʱ��ֻ���ǵ��߳�
if paraTable_c.app==1
    Inputs1= mappedA';
    Inputs2 = table2array(mA1(:, 1:end-1))';  %��������ֵ�Ӽ�(���ų�categorical�м�����ֵ��)ת��Ϊ����
    Inputs3 = table2array(mA2(:, 1:end-1))';
    nprtool;

% 2. classificationLearner
% ��Ϊÿ��App׼�����ʵ�"���ݽṹ"������GUI�����н����ܿ�������ѡ�ı���
% ��������Ϊtable���ͣ�ÿһ��Ϊһ�����ԣ����һ��Ϊcategorical���͵�����

% �ŵ㣺a.�����ֶ�ѡ��Ҫ������ģ���е�Ԥ�������b.�����������ɷַ�����ת��������ɾ������ά��
% c.����ָ������Ӧ��Ĵ���Ԥ��ķ���
% ȱ�㣺�������ݱ���Ϊһά������ִ�ж�ά���ݵķ���
elseif paraTable_c.app==2
    if ~exist('t0','var') || isempty(t0) || size(x2,1)~=size(t0,1)    
        t0 = createTable(x2, lbs);
        [t1,t2] = createTwoTable(x2,lbs,rate);
        mA = createTable(mappedA, lbs);
        [mA1,mA2] = createTwoTable(mappedA,lbs,rate);
    end
    str = {'��������δ��ά��table���͵�����t0,t1,t2�ͽ�ά��mA,mA1,mA2'; ...
        't0Ϊ�ܱ�������ȫ�����ݣ�t1��t2Ϊ��rate��ָ���ı���rate��ֵ��ӱ�.';
        'mAΪ�ܱ�����Ӧ�ڽ�ά���t0��mA1��mA2Ϊ��rate��ָ���ı�������ӱ�.';
        '����6�����ݾ���������Classification App����ѵ����������Ԥ����';
        '�������ݿɷ���hmenu4_4.UserData.t0,hmenu4_4.UserData.t1��hmenu4_4.UserData.t2';
        'hmenu4_4.UserData.mA,hmenu4_4.UserData.mA1��hmenu4_4.UserData.mA2';
        '��Ҫ���²�����ݣ�����������ִ�У�[mA1,mA2] = createTwoTable(mappedA,lbs,rate); [t1,t2] = createTwoTable(x2,lbs,rate);��'};
    disp(str);
    classificationLearner

% ������ʹ��δ��ά����ֱ�ӷ��࣬��Ϊ��ʱ�����ʱ��̫���ˡ�����4Сʱ
else
% 3. ClassDemo
% ���� '��ά����ͳ��.xlsx' sheet2 �еĲ������ǰ����ǳ��������������
% �ŵ㣺�������ö�������㣬�������ø���Ĵ��ݺ�������Ԫ����
% ȱ�㣺����Բ�������Ҫ�Լ���������������
    validateattributes(paraTable_c.hiddenLayerNum,{'numeric'},{'integer','positive','>=',1,'<=',5},'','hiddenLayerNum',12)

    time1 = toc(timerVal_1);
    disp({['����׼����ϣ���ʱ',num2str(time1),'��.',...
    hmenu4_1.UserData.matPath,' ��ʼִ�з���']});

    var = cellfun(@string, para(9:end)); %��cell array�е�����cellӦ��string

    if paraTable_c.dimReduce && ~isempty(hmenu4_3.UserData) && isfield(hmenu4_3.UserData, 'drData') && ~isempty(hmenu4_3.UserData.drData)

        % ִ��20�η��࣬�ͻ���20�����ݣ���������Ϊ�˾����ܵ�ʹ���ݻ��־���
        % ��ΪĿǰ��������pca��ά��������ص�������б������1���ɷ���ռ�ı���̫����
        % �����Ļ���������ڷ�����
        n = paraTable_c.executionTimes;
        racc = zeros(1,n);
        best_perf =  zeros(1,n); 
        best_vperf =zeros(1,n); 
        best_tperf = zeros(1,n);
        
        try
            MyPar = parpool; %������г�δ��������򿪲��д�����
        catch
            MyPar = gcp; %������г��Ѿ��������򽫵�ǰ���гظ�ֵ��MyPar
        end
        
        racc = [];
        best_perf = []; 
        best_vperf = []; 
        best_tperf = [];        
        for k = 1 : n
            [mA1,mA2, ind1, ind2] = createTwoTable(mappedA,lbs,rate);
            XTrain = table2array(mA1(:, 1:end-1))';
        %     TTrain = dummyvar(double(mA1.Class))';
            TTrain = ind2vec(double(mA1.Class)');
            XTest = table2array(mA2(:, 1:end-1))';
        %     TTest = dummyvar(double(mA2.Class))';
            TTest = ind2vec(double(mA2.Class)');
            disp(['��',num2str(k),'�μ���']);
            [err1, err2, err3, err4, tTest] = classDemo(XTrain, TTrain, XTest, TTest, type, var);%ǰ3��Ϊ�������������Ϊ��ѡ����
        %  [racc, best_perf, best_vperf, best_tperf]     
            racc = [racc,err1];
            best_perf = [best_perf, err2]; 
            best_vperf = [best_vperf, err3]; 
            best_tperf = [best_tperf, err4];
        end
        %acc1��������Ϊ�ṹ���Ƿ���ʣ�
    %         time1 = toc(timerVal_1);
    %         disp({['����׼����ϣ���ʱ',num2str(time1),'��.'];...
    %         [hmenu4_1.UserData.matPath,' ��ʼִ�з���']});
        hObject.UserData.racc = racc;
        hObject.UserData.best_perf = best_perf;
        hObject.UserData.best_vperf = best_vperf;
        hObject.UserData.best_tperf = best_tperf;
%         hObject.UserData.lbsOrigin = lbs;
        lbsTest = lbs;
        lbsTest(ind2) = tTest;
        hObject.UserData.lbsTest = lbsTest;
        lbsNew = reshape(lbsTest, size(lbs2,1), size(lbs2,2));
        hObject.UserData.lbsNew = lbsNew;
        % ������Ԥ��ı�ǩͼ
        if ~isa(lbsNew,'double')
            img = double(lbsNew);  
        else
            img = lbsNew;
        end
        hObject.UserData.imgNew = img;
        handles.UserData.imgNew = hObject.UserData.imgNew;

        SeparatePlot3_Callback(img, handles.UserData.cmap, handles.UserData.M);
        SeparatePlot3_Callback(handles.UserData.img, handles.UserData.cmap, handles.UserData.M);
        delete(MyPar) %������ɺ�رղ��д�����
        
        figure
        plot(1:n,[best_perf; best_vperf; best_tperf; racc],'LineWidth',1.5);
        title('ѵ�����ܣ�best_perf,best_vperf,best_tperf���뷺�����ܣ�racc)','Interpreter','none');
        hold on
        racc = racc'; %mean()����������ƽ�������Խ�����ʽת��������ʽ
        plot([1, n],[mean(racc(:,1)), mean(racc(:,1))],'--','LineWidth',1.5);
        text(0,mean(racc(:,1))*1.025,['racc1:',num2str(mean(racc(:,1)))]);

        try %��racc�����У����Ż�ǰ������ݸ�ռһ�У���������������������2������
            plot([1, n],[mean(racc(:,2)), mean(racc(:,2))],'--','LineWidth',1.5);
            text(0,mean(racc(:,2))*1.025,['racc2:',num2str(mean(racc(:,2)))]);
            legend('best_perf1','best_perf2','best_vperf1','best_vperf2','best_tperf1','best_tperf2','racc1','racc2','Interpreter','none','Location','best');  
            %1��ʾ�Ż�ǰ�����ݣ�2��ʾ�Ż��������
        catch%��racc������һ�����ݣ�����һ�е���������ͼ��
            legend('best_perf','best_vperf','best_tperf','racc','Interpreter','none','Location','best');  
        end
        hold off
        %��ʾ���շ�������racc��ʾ����Ĵ����ʣ�1-racc��ʾ����׼ȷ�ʡ�
        hmenu4_4 = findobj(handles,'Label','ִ�з���');    
        hmenu4_4.UserData
        
        % ��ʾ������ʱ
        time2 = toc(timerVal_1);
        disp({[hmenu4_1.UserData.matPath, ' �������! ��ʱ',num2str(time2-time1),'��.']});

    else  % �������������ϣ�δѡ��[ִ�н�ά]��ֱ��ѡ��[ִ�з���]��������classificationLearner
        if ~exist('t0','var') || isempty(t0) || size(x2,1)~=size(t0,1)
            t0 = createTable(x2, lbs);
            [t1,t2] = createTwoTable(x2,lbs,rate);
            mA = createTable(mappedA, lbs);
            [mA1,mA2] = createTwoTable(mappedA,lbs,rate);
        end
        classificationLearner
    end
end

end