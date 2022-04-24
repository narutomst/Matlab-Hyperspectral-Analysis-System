%-----------------------------------������-------------------------------------------%
% hObject = 1; handles = 1; customPath = 'D\';

function feedData(hObject, handles)
global x3 lbs2 x2 lbs bkcGT colorBase
hmenu4_1 = findobj(handles,'Text', '��������');

f = figure('Name','ѡ���������㷨','NumberTitle','off', ...
                    'MenuBar', 'none', 'Toolbar', 'none', ...
                    'Position',[403,246,900,410], 'Resize','off',...
                    'WindowStyle','normal');%'WindowStyle','modal'
f.UserData.customPath = handles.UserData.customPath;
f.UserData.currentPath = handles.UserData.currentPath;
f.UserData.mFilePath = handles.UserData.mFilePath;
    vb = uix.VBox('Parent',f);

        %vb��1��
        uix.Empty('Parent',vb);

        %vb��2��
        %% mainLayout 
        mainLayout = uix.Grid('Parent',vb,'Padding',10);
            fSize = 10.0;
            fName = 'Microsoft YaHei';%'FixedWidth';

            % ��1��
            uicontrol('Parent',mainLayout,'Style','text','String','��άmat����', 'FontSize',fSize,...
                            'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
            uicontrol('Parent',mainLayout,'Style','text','String','��άgt����','FontSize',fSize, ...
                           'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
            uicontrol('Parent',mainLayout,'Style','text','String','��ά�㷨','FontName',fName, ...
                            'FontSize',fSize,'HorizontalAlignment','Left','HandleVisibility','off');
%             uix.Empty('Parent',mainLayout); 
            % uix.Empty('Parent',mainLayout); 
            uicontrol('Parent',mainLayout,'Style','text','String','�����㷨','FontName',fName, ...
                            'FontSize',fSize,'HorizontalAlignment','Left','HandleVisibility','off');
            uix.Empty('Parent',mainLayout); 
            
            % ��2��
            edit1 = uicontrol('Parent',mainLayout,'Style','edit','FontName',fName, ...
                           'Tag','edit1', 'HorizontalAlignment','Left');
            edit2 = uicontrol('Parent',mainLayout,'Style','edit','FontName',fName, ...
                           'Tag','edit2','HorizontalAlignment','Left');
            popupmenu1 = uicontrol('Parent',mainLayout,'Style','popupmenu','FontName',fName, ...
                           'FontSize',fSize+0.5,'Tag','popupmenu1','HorizontalAlignment','Left', ...
                           'Callback',{@popupmenu1_Callback, hmenu4_1, handles, f});
                % popupmenu1.String = ['Algorithm 1','Algorithm 2','Algorithm 3','Algorithm 4','Customarized Algorithm'];
                popupmenu1.String = {'PCA','LDA','MDS','ProbPCA','FactorAnalysis',...
                                                    'GPLVM', 'Sammon', 'Isomap', 'LandmarkIsomap', 'LLE', 'Laplacian', 'HessianLLE',...
                                                    'LTSA', 'MVU', 'CCA', 'LandmarkMVU', 'FastMVU', 'DiffusionMaps', 'LPP', 'NPE',...
                                                    'LLTSA', 'SPE', 'LLC', 'KernelPCA', 'GDA', 'SNE', 'SymSNE', 'tSNE', 'Autoencoder',...
                                                    'ManifoldChart', 'CFA', 'NCA', 'MCML', 'LMNN',...
                                                    'Customarized Algorithm','none'};
									
									
                popupmenu1.Value = numel(popupmenu1.String); %ָ����ʼѡ���1��ʾѡ��popupmenu��һ��
            %% 4��4 gird
%             sub1 = uix.Grid('Parent',mainLayout,'Padding',10);
%                 % column 1
% 				text_1 = uicontrol('Parent',sub1,'Style','text','String','����1', 'FontSize',fSize,...
% 								'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_2 = uicontrol('Parent',sub1,'Style','text','String','����2','FontSize',fSize, ...
% 							   'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_3 = uicontrol('Parent',sub1,'Style','text','String','����3', 'FontSize',fSize,...
% 								'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_4 = uicontrol('Parent',sub1,'Style','text','String','����4','FontSize',fSize, ...
% 							   'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_5 = uicontrol('Parent',sub1,'Style','text','String','����5','FontSize',fSize, ...
% 							   'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');                       
%                 % column 2
% 				edit_1 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam1', ...
% 								'HorizontalAlignment','Left');
% 				edit_2 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam2', ...
% 							   'HorizontalAlignment','Left');
% 				edit_3 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam3', ...
% 								'HorizontalAlignment','Left');
% 				edit_4 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam4', ...
% 							   'HorizontalAlignment','Left');
% 				edit_5 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam5', ...
% 							   'HorizontalAlignment','Left');                       
%                 % column 3
%                 uix.Empty('Parent',sub1); 
%                 uix.Empty('Parent',sub1);
%                 uix.Empty('Parent',sub1); 
%                 uix.Empty('Parent',sub1);
%                 uix.Empty('Parent',sub1);                
%                 % column 4
% 				text_6 = uicontrol('Parent',sub1,'Style','text','String','����6', 'FontSize',fSize,...
% 								'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_7 = uicontrol('Parent',sub1,'Style','text','String','����7','FontSize',fSize, ...
% 							   'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_8 = uicontrol('Parent',sub1,'Style','text','String','����8', 'FontSize',fSize,...
% 								'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_9 = uicontrol('Parent',sub1,'Style','text','String','����9','FontSize',fSize, ...
% 							   'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_10 = uicontrol('Parent',sub1,'Style','text','String','����10','FontSize',fSize, ...
% 							   'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
%                 % column 5
% 				edit_6 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam6', ...
% 								'HorizontalAlignment','Left');
% 				edit_7 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam7', ...
% 							   'HorizontalAlignment','Left');
% 				edit_8 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam8', ...
% 								'HorizontalAlignment','Left');
% 				edit_9 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam9', ...
% 							   'HorizontalAlignment','Left'); 
% 				edit_10 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam10', ...
% 							   'HorizontalAlignment','Left');                        
%                 % column 6
%                 uix.Empty('Parent',sub1); 
%                 uix.Empty('Parent',sub1);
%                 uix.Empty('Parent',sub1); 
%                 uix.Empty('Parent',sub1);
%                 uix.Empty('Parent',sub1);                
%                 % column 7
% 
% 				text_11 = uicontrol('Parent',sub1,'Style','text','String','����11', 'FontSize',fSize,...
% 								'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_12 = uicontrol('Parent',sub1,'Style','text','String','����12','FontSize',fSize, ...
% 							   'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_13 = uicontrol('Parent',sub1,'Style','text','String','����13', 'FontSize',fSize,...
% 								'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_14 = uicontrol('Parent',sub1,'Style','text','String','����14','FontSize',fSize, ...
% 							   'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_15 = uicontrol('Parent',sub1,'Style','text','String','����15','FontSize',fSize, ...
% 							   'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');                       
%                 % column 8
% 				edit_11 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam11', ...
% 								'HorizontalAlignment','Left');
% 				edit_12 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam12', ...
% 							   'HorizontalAlignment','Left');
% 				edit_13 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam13', ...
% 								'HorizontalAlignment','Left');
% 				edit_14 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam14', ...
% 							   'HorizontalAlignment','Left');
% 				edit_15 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam15', ...
% 								'HorizontalAlignment','Left');
% 
% %                 uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam10', ...
% %                            'HorizontalAlignment','Left');                       
%                 % column 9
%                 uix.Empty('Parent',sub1); 
%                 uix.Empty('Parent',sub1);
%                 uix.Empty('Parent',sub1); 
%                 uix.Empty('Parent',sub1);
%                 uix.Empty('Parent',sub1);                
%                 % column 10
% 				text_16 = uicontrol('Parent',sub1,'Style','text','String','����16', 'FontSize',fSize,...
% 								'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_17 = uicontrol('Parent',sub1,'Style','text','String','����17','FontSize',fSize, ...
% 							   'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_18 = uicontrol('Parent',sub1,'Style','text','String','����18', 'FontSize',fSize,...
% 								'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_19 = uicontrol('Parent',sub1,'Style','text','String','����19','FontSize',fSize, ...
% 							   'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 				text_20 = uicontrol('Parent',sub1,'Style','text','String','����20','FontSize',fSize, ...
% 							   'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
%                 % column 11
% 				edit_16 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam16', ...
% 								'HorizontalAlignment','Left');
% 				edit_17 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam17', ...
% 							   'HorizontalAlignment','Left');
% 				edit_18 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam18', ...
% 								'HorizontalAlignment','Left');
% 				edit_19 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam19', ...
% 							   'HorizontalAlignment','Left');   
% 				edit_20 = uicontrol('Parent',sub1,'Style','edit','FontName',fName,'Tag','drParam20', ...
% 							   'HorizontalAlignment','Left');                         
%                 sub1.Widths = [60,-1,15,95,-1,15,75,-1,15,60,-1];
%                 s = {'no_dims','k','eig_impl','sigma','kernel','max_iterations','perplexity', ...
% 				'no_analyzers','Polynom_par1','Polynom_par2','lambda','finetune','type','initial_dims', ...
% 				'percentage','t'};
% 				for i = 1:numel(s)
% 					%eval(['text_',num2str(i),'String']) = s{i};
% 					eval(['text_',num2str(i),'.String = s{i};']);
% 				end
            %% sub1����
			
            popupmenu2 = uicontrol('Parent',mainLayout,'Style','popupmenu','FontName',fName, ...
                           'FontSize',fSize+0.5,'Tag','popupmenu2','HorizontalAlignment','Left', ...
                           'Callback',{@popupmenu2_Callback, hmenu4_1, handles, f});
                % ����popupmenu2
                popupmenu2.String = {'TANSIG','RBF','GA_TANSIG','GA_RBF','PSO_TANSIG','PSO_RBF','Customarized Algorithm','none'};
                popupmenu2.Value = numel(popupmenu2.String);%ָ����ʼѡ���1��ʾѡ��popupmenu��һ��
%                         uix.Empty('Parent',mainLayout,'HandleVisibility','off');
            uix.Empty('Parent',mainLayout,'HandleVisibility','off');
                %% sub2 ��ʼ
            %% 4��4 gird
%             sub2 = uix.Grid('Parent',mainLayout,'Padding',10);
%                 % column 1
%                 uicontrol('Parent',sub2,'Style','text','String','����1', 'FontSize',fSize,...
%                             'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
%                 uicontrol('Parent',sub2,'Style','text','String','����2','FontSize',fSize, ...
%                            'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
%                 uicontrol('Parent',sub2,'Style','text','String','����3', 'FontSize',fSize,...
%                             'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
%                 uicontrol('Parent',sub2,'Style','text','String','����4','FontSize',fSize, ...
%                            'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
%                 % column 2
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam1', ...
%                             'HorizontalAlignment','Left');
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam2', ...
%                            'HorizontalAlignment','Left');
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam3', ...
%                             'HorizontalAlignment','Left');
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam4', ...
%                            'HorizontalAlignment','Left');       
%                 % column 3
%                 uix.Empty('Parent',sub2); 
%                 uix.Empty('Parent',sub2);
%                 uix.Empty('Parent',sub2); 
%                 uix.Empty('Parent',sub2);
%                 % column 4
%                 uicontrol('Parent',sub2,'Style','text','String','����5', 'FontSize',fSize,...
%                             'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
%                 uicontrol('Parent',sub2,'Style','text','String','����6','FontSize',fSize, ...
%                            'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
%                 uicontrol('Parent',sub2,'Style','text','String','����7', 'FontSize',fSize,...
%                             'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
%                 uicontrol('Parent',sub2,'Style','text','String','����8','FontSize',fSize, ...
%                            'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 
%                 % column 5
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam5', ...
%                             'HorizontalAlignment','Left');
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam6', ...
%                            'HorizontalAlignment','Left');
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam7', ...
%                             'HorizontalAlignment','Left');
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam8', ...
%                            'HorizontalAlignment','Left');
%                 % column 6
%                 uix.Empty('Parent',sub2); 
%                 uix.Empty('Parent',sub2);
%                 uix.Empty('Parent',sub2); 
%                 uix.Empty('Parent',sub2);
%                 % column 7
%                 uicontrol('Parent',sub2,'Style','text','String','����9', 'FontSize',fSize,...
%                             'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
%                 uicontrol('Parent',sub2,'Style','text','String','����10','FontSize',fSize, ...
%                            'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
%                 uicontrol('Parent',sub2,'Style','text','String','����11', 'FontSize',fSize,...
%                             'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
%                 uicontrol('Parent',sub2,'Style','text','String','����12','FontSize',fSize, ...
%                            'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 
%                 % column 8
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam9', ...
%                             'HorizontalAlignment','Left');
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam10', ...
%                            'HorizontalAlignment','Left');
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam11', ...
%                             'HorizontalAlignment','Left');
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam12', ...
%                            'HorizontalAlignment','Left');
%                 % column 9
%                 uix.Empty('Parent',sub2); 
%                 uix.Empty('Parent',sub2);
%                 uix.Empty('Parent',sub2); 
%                 uix.Empty('Parent',sub2);
%                 % column 10
%                 uicontrol('Parent',sub2,'Style','text','String','����13', 'FontSize',fSize,...
%                             'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
%                 uicontrol('Parent',sub2,'Style','text','String','����14','FontSize',fSize, ...
%                            'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
%                 uicontrol('Parent',sub2,'Style','text','String','����15', 'FontSize',fSize,...
%                             'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
%                 uicontrol('Parent',sub2,'Style','text','String','����16','FontSize',fSize, ...
%                            'FontName',fName,'HorizontalAlignment','Left','HandleVisibility','off');
% 
%                 % column 11
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam13', ...
%                             'HorizontalAlignment','Left');
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam14', ...
%                            'HorizontalAlignment','Left');
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam15', ...
%                             'HorizontalAlignment','Left');
%                 uicontrol('Parent',sub2,'Style','edit','FontName',fName,'Tag','cParam16', ...
%                            'HorizontalAlignment','Left');                       
%                 sub2.Widths = [45,-1,15,45,-1,15,45,-1,15,45,-1];
            %% sub2����           
            % ��3��
            pushbutton1 = uicontrol('Parent',mainLayout,'Style','pushbutton','String','���',...
                                                    'FontSize',fSize,'FontName',fName,'Tag','pushbutton1',...
                                                    'Callback',{@pushbutton1_Callback, hmenu4_1, handles, f});
            pushbutton2 = uicontrol('Parent',mainLayout,'Style','pushbutton','String','���',...
                                                    'FontSize',fSize,'FontName',fName,'Tag','pushbutton2',...
                                                    'Callback',@(o,e)pushbutton2_Callback(hmenu4_1,handles,f));                                    
            % pushbutton3 = uicontrol('Parent',mainLayout,'Style','pushbutton','String','���',...
            %                                         'FontSize',fSize,'FontName',fName,'Tag','pushbutton3',...
            %                                         'Callback',@(o,e)pushbutton3_Callback(o,e,gcf));
            uix.Empty('Parent',mainLayout,'HandleVisibility','off');
            uix.Empty('Parent',mainLayout,'HandleVisibility','off');            
            % ��4��
            uix.Empty('Parent',mainLayout,'HandleVisibility','off');
            uix.Empty('Parent',mainLayout,'HandleVisibility','off');
%             uix.Empty('Parent',mainLayout,'HandleVisibility','off');
%             uix.Empty('Parent',mainLayout,'HandleVisibility','off');
            % ����mainLayout
            mainLayout.Widths = [80,-1,80,20];
            mainLayout.Heights = [25,25,25,25,4*25];

        %% 
        %vb��3��
        uix.Empty('Parent',vb,'HandleVisibility','off');

        %vb��4��
        boxLayout = uix.HBox('Parent',vb,'Spacing',10);
            %��1��
            uix.Empty('Parent',boxLayout,'HandleVisibility','off');
            %��2��
            pushbutton4 = uicontrol('Parent',boxLayout,'Style','pushbutton','String','���',...
                                                    'FontSize',fSize,'FontName',fName,'Tag','pushbutton4',...
                                                    'Callback',@(o,e)pushbutton4_Callback(hmenu4_1, handles, f));
            %��3��
            pushbutton5 = uicontrol('Parent',boxLayout,'Style','pushbutton','String','ȡ��',...
                                                    'FontSize',fSize,'FontName',fName,'Tag','pushbutton5',...
                                                    'Callback',@(o,e)pushbutton5_Callback(f));
            %��4��
            uix.Empty('Parent',boxLayout);
            % ����boxLayout�Ŀ��
            boxLayout.Widths = [-1,80,80,20];
            
% ����vb���еĳߴ�
h = mainLayout.Heights(1);
vb.set('Heights',[h*0.7,h*13+14, h*0.6,h]);
% popupmenu1.Position(4) = 38;
a = sum(vb.Heights(:));% �����ܸ߶�

% ��ʾ��һ����ѡ������ݼ��㷨
hmenu4_1 = findobj(handles,'Text','��������');
% �ȶ�hmenu4_1��һ����ʼ��
if isempty(hmenu4_1.UserData)
    hmenu4_1.UserData.matPath = [];
    hmenu4_1.UserData.gtPath = [];
    hmenu4_1.UserData.drAlgorithm = [];
    hmenu4_1.UserData.drValue = numel(popupmenu1.String);
    hmenu4_1.UserData.cAlgorithm = [];
    hmenu4_1.UserData.cValue = numel(popupmenu2.String);
    hmenu4_1.UserData.x3 = [];
    hmenu4_1.UserData.lbs2 = [];
    hmenu4_1.UserData.x2 = [];
    hmenu4_1.UserData.lbs = []; 
elseif ~isempty(hmenu4_1.UserData.matPath) && strcmp(hObject.Text, '����ѡ���㷨')
    % ������feedData���ڵĲ˵��ǡ�����ѡ���㷨�������������������ť
    pushbutton1.Enable = 'off';
    pushbutton2.Enable = 'off';    
end
% edit1��edit2��ʾ��һ����ѡ�������
    edit1.String = hmenu4_1.UserData.matPath;
    edit1.FontSize = fSize;
    edit2.String = hmenu4_1.UserData.gtPath;
    edit2.FontSize = fSize;
% popupmenu1��popupmenu2��ʾ��һ��ѡ����㷨
    popupmenu1.Value = hmenu4_1.UserData.drValue;
    popupmenu2.Value = hmenu4_1.UserData.cValue;  
    
feedResult = f;
end

%-------------------------------------�ص�����---------------------------------------------------%
function pushbutton1_Callback(src, event, hObject, handles, f)  %��һ�С������
    disp(hObject.Label);
%     customPath = [];
try
    customPath = handles.UserData.currentPath;
catch
    customPath = handles.UserData.customPath;
end

    edit1 = findobj(f,'Tag','edit1');
%Ĭ�ϴ򿪵�ַ����MVC_test.m�����ļ���
%�Զ���򿪵�ַ��uigetfile��һ����������Ϊ��{'D:\MA��ҵ����\ATrain_Record\20190909\*.mat'}
    if isempty(customPath)
        customPath = pwd;
    end    
%     uigetdir
%     customPath = {'C:\Matlab��ϰ\duogun\*.mat'};
    [matfilename, matpathname, FilterIndex] = uigetfile([customPath,'\*.mat'], 'Select a mat file');
    if (~isempty(matfilename) && (FilterIndex==1))
        %ѡ�����ļ������ҵ����ȷ�������ǲŻ�����������ʲôҲ������
        hObject.UserData.matPath = [matpathname,matfilename];
        handles.UserData.matPath = [matpathname,matfilename];    
        edit1.String = [matpathname,matfilename];
        edit1.FontSize = src.FontSize;
    end
    f.UserData.currentPath = matpathname;
end


function pushbutton2_Callback(hObject, handles, f)   % �ڶ��С������
    disp(hObject.Label);
%     customPath = [];
try
    customPath = f.UserData.currentPath;
catch
    customPath = handles.UserData.customPath;
end
    
    pushbutton1 = findobj(f,'Tag','pushbutton1');
    edit2 = findobj(f,'Tag','edit2');
    if isempty(customPath)
        customPath = {'C:\Matlab��ϰ\duogun\*.mat'};
    end    

    [matfilename, matpathname, FilterIndex] = uigetfile([customPath,'\*.mat'], 'Select a groundtruth file');
    if (~isempty(matfilename) && (FilterIndex==1))
        %ѡ�����ļ������ҵ����ȷ�������ǲŻ�����������ʲôҲ������
        hObject.UserData.gtPath = [matpathname,matfilename];
        handles.UserData.gtPath = [matpathname,matfilename];
        edit2.String = [matpathname,matfilename];
        edit2.FontSize = pushbutton1.FontSize;        
    end
end    


function popupmenu1_Callback(src, event, hObject, handles, f )  %��ά�㷨�����б�
    disp(hObject.Label);
    val = src.Value;
    hObject.UserData.drAlgorithm = src.String{val};
    hObject.UserData.drValue = val;
end
function popupmenu2_Callback(src, event, hObject, handles, f )% �����㷨�����б�
    disp(hObject.Label);
    val = src.Value;
    hObject.UserData.cAlgorithm = src.String{val};
    hObject.UserData.cValue = val;
end

function pushbutton4_Callback(hObject, handles, fig)   % ����ɡ���ť
    if ~isempty(hObject.UserData)
    %     pop1 = findobj(fig, 'Tag', 'popupmenu1');
    %     val = pop1.Value;
    %     num = numel(pop1.String);
        matPath = hObject.UserData.matPath;
        gtPath = hObject.UserData.gtPath;
        drAlgorithm = hObject.UserData.drAlgorithm;
        cAlgorithm = hObject.UserData.cAlgorithm;
        if ~isempty(matPath) 
            if ~isempty(gtPath)
                if ~isempty(drAlgorithm) && ~strcmp(drAlgorithm, 'none')
                    if ~isempty(cAlgorithm) && ~strcmp(cAlgorithm, 'none')
                    % ����hObject��handles
                        
                        pushbutton5_Callback(fig);  % �ȹرնԻ����ͷ�figure(2)�ٻ�ͼ����ͼ��ŷֱ���figure2��figure3
                        reNew(hObject,handles); % �����ȹرնԻ���ֱ�ӻ�ͼ����ͼ��ŷֱ���figure3��figure4
                    else
                        msg = 'Forget to choose a Classification Algorithm!';
                        warndlg(msg);
                    end
                else
                    msg = 'Forget to choose a Dimension Reduction Algorithm!';
                    warndlg(msg);
                end
            else
                msg = 'Forget to choose a ground truth mat file!';
                warndlg(msg);            
            end
        else
            msg = 'Forget to choose a mat file!';
            warndlg(msg);
        end
    end
end

function pushbutton5_Callback(fig) %��ȡ������ť
    close(fig);
end

function pushbutton6_Callback(hObject, eventdata, handles)
    disp('pushbutton 6');
end

function reNew(hObject,handles)
global x2 lbs bkcGT colorBase
    timerVal_1 = tic;
    disp('����Ԥ������...............');
    [~,x2,~,lbs,matInfo,gtInfo] = dataProcess2(handles);
%     [~,x2,~,lbs] = dataProcess2(handles);    
%     hObject.UserData.x3 = x3;  
    hObject.UserData.x2 = x2;
%     hObject.UserData.lbs2 = lbs2;
    hObject.UserData.lbs = lbs;
    hObject.UserData.matName = matInfo.name;
    hObject.UserData.gtName = gtInfo.name;
    time1 = toc(timerVal_1);
    disp(['���ݼ��سɹ�����ʱ',num2str(time1),'��.']);
    %ֱ�ӱ������ݵ�hObject������������費����load
    % hmenu4_1 = findobj(handles,'Label','��������');

%     hm = findobj(handles,'Tag','Analysis');
%     hmenu4_2 = findobj(handles,'Label','���׷���');
%     hmenu4_2.Enable = 'on';
%     hmenu4_3 = findobj(handles,'Label','ִ�н�ά');
%     hmenu4_3.Enable = 'on';
%     hmenu4_4 = findobj(handles,'Label','ִ�з���');
%     hmenu4_4.Enable = 'on';
%     hmenu4_5 = findobj(handles,'Label','����ѡ���㷨');
%     hmenu4_5.Enable = 'on';
%     hmenu4_6 = findobj(handles,'Label','�����㷨');
%     hmenu4_6.Enable = 'on';

% ���ӻ���ʾ
l = findobj(handles,'Style', 'listbox');
ind = l.UserData.ind;
hObject.UserData.ind = ind;
handles.UserData.ind = ind;
% handles.UserData.matdata = x3;% hObject.UserData.matdata = x3;
% handles.UserData.gtdata = lbs2;% hObject.UserData.gtdata = lbs2;

hObject.UserData.cmap = l.UserData.cmap;
handles.UserData.cmap = [bkcGT;colorBase];
% ���Ȼ��ƺϳ�ͼ��
imgMat = synthesize_image(handles.UserData.matdata, ind);   
% hObject.UserData.imgMat = imgMat;
% handles.UserData.imgMat = hObject.UserData.imgMat;
% SeparatePlot3_Callback(imgMat, handles.UserData.cmap,0);
p = figure();
himage = imshow(imgMat);
hscrollpanel = imscrollpanel(p, himage); 

% Ȼ�����GTͼ
p = figure();
himage = plot1(handles);
hscrollpanel = imscrollpanel(p, himage); 

imgGT = double(handles.UserData.gtdata);   
% hObject.UserData.imgGT = imgGT;
% handles.UserData.imgGT = hObject.UserData.imgGT;
if ndims(imgGT)==2
    M = numel(unique(imgGT(:)));
end
hObject.UserData.M = M;
handles.UserData.M = hObject.UserData.M;   
    
if isempty(hObject.UserData.cmap)
    hObject.UserData.cmap = [bkcGT;colorBase];
end
% handles.UserData.cmap = hObject.UserData.cmap;
% 
% SeparatePlot3_Callback(imgGT, handles.UserData.cmap,M);

%�����ƶѵ�ͼ��������ݼ��سɹ�����˵��ͬʱ�߱���Matͼ��GTͼ����������²��ܻ��ƶѵ�ͼ��
% id1 = imgGT~=0;    %512��614 logical
% id2 = imgGT~=[0,0,0];  %�ᱨ������ά�ȱ���һ�¡�
% id3 = imgGT(:)~=0; %314368��1 logical
% id4 = imgGT(:)~=[0,0,0]; %314368��3 logical
stack_image(imgMat,imgGT,handles.UserData.cmap,M);

if 0
saveAllFigure('20200627', handles, '.fig');                     
end

end