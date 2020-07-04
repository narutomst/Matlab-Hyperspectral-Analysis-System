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
t = table2cell(paraTable_c);
ss = table2struct(paraTable_c);
k = numel(t); 
para = cell(1,2*k);
for i = 1:k
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

if min(lbs(:))==0
    lbs = lbs(lbs~=0);
end
% vector_lbs2 = ind2vec(lbs2); % �����������ֻ����һά

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
%         racc = zeros(n,1);
%         best_perf =  zeros(n,1); 
%         best_vperf =zeros(n,1); 
%         best_tperf = zeros(n,1);
        
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
            XTrain = table2array(mA1(:, 1:end-1))';
        %     TTrain = dummyvar(double(mA1.Class))';
            TTrain = ind2vec(double(mA1.Class)');
            XTest = table2array(mA2(:, 1:end-1))';
        %     TTest = dummyvar(double(mA2.Class))';
            TTest = ind2vec(double(mA2.Class)');
            disp(['��',num2str(k),'�μ���']);
            [err1, err2, err3, err4, tTest] = classDemo(XTrain, TTrain, XTest, TTest, type, var);%ǰ3��Ϊ�������������Ϊ��ѡ����
            %racc ����ʣ�������
            %best_perf ѵ����������ܣ���ɫ���ߣ�
            %best_vperf ��֤��������ܣ���ɫ���ߣ�
            %best_tperf ���Լ�������ܣ���ɫ���ߣ�
            %tTest ΪԤ�������ǩ������ 
        
            racc = [racc; err1];%racc ����ʣ�������
            best_perf = [best_perf; err2]; %best_perf ѵ����������ܣ���ɫ���ߣ�
            best_vperf = [best_vperf; err3]; %best_vperf ��֤��������ܣ���ɫ���ߣ�
            best_tperf = [best_tperf; err4];%best_tperf ���Լ�������ܣ���ɫ���ߣ�
            
            % ��ѡ�����ŷ��������µ�tTest;
            [m,i] = min(err1); %������Сֵ��������
            if m<raccBest
                raccBest = m;
                tTestBest = tTest(:, i);
                ind2Best = ind2';
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
    T = createTableForWrite(best_perf, best_vperf, best_tperf, racc)
    
        %T = table(best_perf, best_vperf, best_tperf, racc, 'RowNames',arrayfun(@string, [1:nn]'),...
        %    'VariableNames',VN);
        %
        % ���ñ���·��
        path = 'C:\Matlab��ϰ\20200627';
        try
            path = fullfile(path, hmenu4_1.UserData.matName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
        catch
        end
        if ~exist(path, 'dir')
            [status,msg,msgID] = mkdir(path);
        end
            filename = [hmenu4_1.UserData.matName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
        try
            filename = fullfile(path,filename);%ƴ��·��
        catch
        end
        
        writetable(T,filename,'Sheet',1,'Range','A1', 'WriteRowNames',true);
        
        %T1 = table(acc_perf, acc_vperf, acc_tperf, acc, 'RowNames',arrayfun(@string, [1:numel(acc)]'))
        %filename = [hmenu4_1.UserData.matName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
        T1 = createTableForWrite(acc_perf, acc_vperf, acc_tperf, acc)
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
        
        %delete(MyPar) %������ɺ�رղ��д����
        
    % �������������ϣ�δѡ��[ִ�н�ά]��ֱ��ѡ��[ִ�з���]����ѯ���Ƿ�����classificationLearner    
    else  
            answer = questdlg('����δִ�н�ά��������������ַ�ʽִ�з���?', ...
            '���෽ʽѡ��', ...
            'Clssification Learner','ClassDemo','exit','exit');
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
                        TTrain = ind2vec(double(mA1.Class)');            %XTrainÿһ��Ϊһ������ǩ
                        XTest = table2array(mA2(:, 1:end-1))';             %XTestÿһ��Ϊһ������                
                        TTest = ind2vec(double(mA2.Class)');            %TTestÿһ��Ϊһ������ǩ
                        disp(['��',num2str(k),'�μ���']);
                        [err1, err2, err3, err4, tTest] = classDemo(XTrain, TTrain, XTest, TTest, type, var);%ǰ3��Ϊ�������������Ϊ��ѡ����
                        %racc ����ʣ�������
                        %best_perf ѵ����������ܣ���ɫ���ߣ�
                        %best_vperf ��֤��������ܣ���ɫ���ߣ�
                        %best_tperf ���Լ�������ܣ���ɫ���ߣ�
                        %tTest ΪԤ�������ǩ������ 

                        racc = [racc; err1];%racc ����ʣ�������
                        best_perf = [best_perf; err2]; %best_perf ѵ����������ܣ���ɫ���ߣ�
                        best_vperf = [best_vperf; err3]; %best_vperf ��֤��������ܣ���ɫ���ߣ�
                        best_tperf = [best_tperf; err4];%best_tperf ���Լ�������ܣ���ɫ���ߣ�

                        % ��ѡ�����ŷ��������µ�tTest;
                        [m,i] = min(err1); %������Сֵ��������
                        if m<raccBest
                            raccBest = m;
                            tTestBest = tTest(:, i);
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
                    path = 'C:\Matlab��ϰ\20200627';
                    try
                        path = fullfile(path, hmenu4_1.UserData.matName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
                    catch
                    end
                    if ~exist(path, 'dir')
                        [status,msg,msgID] = mkdir(path);
                    end
                        filename = [hmenu4_1.UserData.matName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
                    try
                        filename = fullfile(path,filename);%ƴ��·��
                    catch
                    end
                    writetable(T,filename,'Sheet',1,'Range','A1', 'WriteRowNames',true);
                    T1 = createTableForWrite(acc_perf, acc_vperf, acc_tperf, acc)
                    %T1 = table(acc_perf, acc_vperf, acc_tperf, acc, 'RowNames',arrayfun(@string, [1:numel(acc)]'))
                    %filename = [hmenu4_1.UserData.matName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
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
    saveAllFigure('20200627',handles,'.fig');
    gc = gcf; 
    closeFigure([2:gc.Number]);
%     closeFigure([2:13]);
end
