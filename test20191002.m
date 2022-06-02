% close all
clear
clc
opengl('save', 'software') 

%----------------------------------------------������-------------------------------------------%
global customPath mFilePath bkcGT colorBase
bkcGT = [0.98 0.98 0.98];%GTͼ������ɫ�ڻ��߰�
colorBase = [ [1,0,0]; [0,1,0]; [0,0,1]; [1,1,0]; [1,0,1]; [0,1,1]; ...
                    [0.5,0,0]; [0,0.5,0];[0,0,0.5]; [0.25,0.75,0]; [0.85,0.5,0]; [0.5,0.5,0]; ... 
                    [0.5,0,1]; [1,0,0.5]; [0.5,0,0.5]; [0.35,0.65,0.75]; [0,1,0.5]; [0,0.5,0.5]; ...
                    [0.5,0.5,0.5]; [0.1,0.1,0.1]];
                
global x3 lbs2 x2 lbs Inputs Targets Inputs1 Targets1 Inputs2 Targets2 Inputs3 Targets3 t0 t1 t2 mA mA1 mA2 Inputs_1 Targets_1 Inputs_2 Targets_2

p = mfilename('fullpath'); %%ȷ����ǰ����ִ�е�*.m�ļ���·��
mFilePath = fileparts(p);   %ȷ��*.m�ļ����ڵ��ļ���·��(���ض����һ����·��)
p = fileparts(mFilePath);   %�����ض����һ����·�������õ�C:\Matlab��ϰ
path = fullfile(p,'duogun');%ƴ��·��
s = what('duogun');
if exist(path, 'dir')
    customPath = path;  %����Զ�λ�ķ�ʽ����duogun��·��
elseif ~isempty(s)
    customPath = s.path;%��what()ֱ�Ӳ��ҵ�duogun
else
    customPath = pwd;%��ǰ������·��
end

%�Զ�������蹤�߰�
toolPath={'GAOT-master',...
                'GUI Layout Toolbox 2.3.4',...
                'hyperspectralToolbox',...
                'Matlab-Toolbox-for-Dimensionality-Reduction-master'
                };
n = numel(toolPath);
%fullfile(p,toolPath{n})      %'C:\Matlab��ϰ'��toolPath{n}ƴ�ӳ�����·��
for i = 1:n
    addpath(genpath(fullfile(p,toolPath{i})));
end


pwidthmin = 20; % ���panel����ʱ�Ŀ��Ϊ15����
pwidthmax = -1.5; % ���panelչ��ʱ�Ŀ��Ϊ���ֵ-1���Ҳര�ڵĿ��Ҳ�����ֵ-5

% hfig = figure('Name','�߹��׷���ϵͳ','Tag','mainFigure',...
hfig = figure('Name','�߹��׷���ϵͳ','Tag','mainFigure',...
                    'NumberTitle','off','DockControls','on',...
                    'MenuBar','none','ToolBar','none', ...
                    'Position',[304,50,800,400], ...
                    'SelectionType','normal', ...
                    'CloseRequestFcn',@my_closereq);%���ֵ[304,50,760,620]������ֵ[566,371,369,151]
% WindowState - ����״̬
% 'normal' ��Ĭ�ϣ� | 'minimized' | 'maximized' | 'fullscreen'
% SelectionType - ���ѡ������
% 'normal' ��Ĭ�ϣ� | 'extend' | 'alt' | 'open'


%% �Զ���˵���
%���ȴ����˵�,��'Callback'��ֵΪ'disp('New MenuItem is clicked')'����ȫ��������Ϻ��ٿ��ǻص�����������
%��1�в˵�(���ǣ��Զ���˵���ԭ�в˵����Թ���Ŷ��)

%-------------------------------------------��1�в˵�--------------------------------------------------%

% HandleVisibility - �������Ŀɼ���
% 'on' ��Ĭ�ϣ� | 'callback' | 'off'
hmenu1 = uimenu(hfig,'Label','�ļ�(F)','Tag','File','HandleVisibility','off');

%Tag����;��use findobj function to search for the uimenu based on the Tag value
%@(o,e)New_Callback(o,e) 

%��ݼ� 'Accelerator','N'��ʾCtrl + N
% hmenu1_1 = uimenu(hmenu1,'Label','�½�','Accelerator','N', 'HandleVisibility','off', ...
%     'Callback',@(hObject,eventdata,handles)New_Callback(hObject,eventdata,gcf));
hmenu1_1 = uimenu(hmenu1,'Label','�½�', 'HandleVisibility','off', ...
    'Callback',@(hObject,eventdata,handles)New_Callback(hObject,eventdata,gcf));
hmenu1_2 = uimenu(hmenu1,'Label','��Mat', 'HandleVisibility','off', ...
    'Callback',{@Open1_Callback,gcf});
hmenu1_3 = uimenu(hmenu1,'Label','��Gt', 'HandleVisibility','off', ...
    'Callback',{@Open2_Callback,gcf});
hmenu1_4 = uimenu(hmenu1,'Label','�ر�', 'HandleVisibility','off', ...
    'Callback',{@Close_Callback,gcf});
hmenu1_5 = uimenu(hmenu1,'Label','����',  'HandleVisibility','off', ...
    'Callback',{@Save_Callback,gcf},'Separator','on');
hmenu1_6 = uimenu(hmenu1,'Label','���Ϊ',   'HandleVisibility','off', ...
    'Callback',{@SaveAs_Callback,gcf});
hmenu1_7 = uimenu(hmenu1,'Label','���ɱ���','Separator','on','Visible','on','Enable','on',... 
           'HandleVisibility','off','Callback',{@Report_Callback,gcf});
hmenu1_8 = uimenu(hmenu1,'Label','��������','Visible','on','Enable','on', ...
    'HandleVisibility','off', 'Callback',{@ExportAsMat_Callback,gcf});
hmenu1_9 = uimenu(hmenu1,'Label','������','Callback',{@New_Callback,gcf},... 
            'Visible','off','Enable','off','HandleVisibility','off');       
hfig.MenuBar = 'None';%��ʱ�ر�ԭ�в˵�

%---------------------------------------��2�в˵�
hmenu2 = uimenu(hfig,'Label','�༭(E)','Tag','Edit','HandleVisibility','on');
hmenu2_1 = uimenu(hmenu2,'Label','����', 'HandleVisibility','off', ...
    'Callback',{@Undo_Callback,gcf});
hmenu2_2 = uimenu(hmenu2,'Label','����', 'HandleVisibility','off', ...
    'Callback',{@Redo_Callback,gcf});
hmenu2_3 = uimenu(hmenu2,'Label','���ºϳ�', 'Separator','on', ...
    'HandleVisibility','on', 'Callback',{@Synth_Callback,gcf});
hmenu2_4 = uimenu(hmenu2,'Label','������ɫ', 'Separator','off', ...
    'HandleVisibility','on', 'Callback',{@Recolor_Callback,gcf});
hmenu2_5 = uimenu(hmenu2,'Label','����','Callback','disp(''exit'')',  ...
    'HandleVisibility','off', 'Callback',{@Copy_Callback,gcf});
hmenu2_6 = uimenu(hmenu2,'Label','������а�','HandleVisibility','off', ...
    'Callback',{@ClearClipboard_Callback,gcf});
hmenu2_7 = uimenu(hmenu2,'Label','ɾ��','HandleVisibility','off', ...
    'Callback',{@Delete_Callback,gcf}, ... 
            'Visible','on','Enable','on');
hmenu2_8 = uimenu(hmenu2,'Label','������','Visible','off','Enable','off', ...
      'HandleVisibility','off', 'Callback',{@New_Callback,gcf});
%---------------------------------------��3�в˵�
hmenu3 = uimenu(hfig,'Label','�鿴(V)','Tag','View', 'HandleVisibility','on');        %(o,e)FitWindow_Callback(o,e)
hmenu3_1 = uimenu(hmenu3,'Label','��Ӧ����', 'HandleVisibility','on', ...
    'Callback',{@FitWindow_Callback, gcf});
hmenu3_2 = uimenu(hmenu3,'Label','ԭʼ��С', 'HandleVisibility','on', ...
    'Callback',{@OriginSize_Callback,gcf});
hmenu3_3 = uimenu(hmenu3,'Label','������ͼ(����Ӧ)', 'HandleVisibility','on', ...
    'Enable','on','Callback',{@SeparatePlot1_Callback,gcf});
hmenu3_4 = uimenu(hmenu3,'Label','������ͼ(ԭʼ��С)', 'HandleVisibility','on', ...
    'Enable','on','Callback',{@SeparatePlot2_Callback,gcf});
hmenu3_5 = uimenu(hmenu3,'Label','������', 'Visible','off', ...
    'Enable','off', 'HandleVisibility','off', 'Callback',{@New_Callback,gcf});

%---------------------------------------��4�в˵�------------�ص�680��
hmenu4 = uimenu(hfig,'Label','����(A)','Tag','Analysis');
hmenu4_1 = uimenu(hmenu4,'Label','��������', 'HandleVisibility','on', ...
    'Callback',{@FeedData_Callback,gcf});
hmenu4_2 = uimenu(hmenu4,'Label','���׷���', 'HandleVisibility','on', ...
    'Callback',{@SpectrumPlot_Callback,gcf},'Enable','off');
hmenu4_3 = uimenu(hmenu4,'Label','ִ�н�ά', 'HandleVisibility','on', 'Separator','on',...
    'Callback',{@ReduceDim_Callback,gcf},... 
            'Visible','on','Enable','off');
hmenu4_4 = uimenu(hmenu4,'Label','ִ�з���',  'Visible','on', ...
    'Enable','off','HandleVisibility','on');%, 'Callback',{@Classify_Callback,gcf});  %��888��
	hmenu4_4_1 = uimenu(hmenu4_4,'Label','���ܷ���', 'Visible','on', ...
    'Enable','off','HandleVisibility','on', 'Callback',{@Classify_Callback1,gcf});
	hmenu4_4_2 = uimenu(hmenu4_4,'Label','ClassDemo', 'Visible','on', ...
    'Enable','off','HandleVisibility','on', 'Callback',{@Classify_Callback2,gcf});
	hmenu4_4_3 = uimenu(hmenu4_4,'Label','Classification Learner', 'Visible','on', ...
    'Enable','off','HandleVisibility','on', 'Callback',{@Classify_Callback3,gcf});
	hmenu4_4_4 = uimenu(hmenu4_4,'Label','nprtool', 'Visible','on', ...
    'Enable','off','HandleVisibility','on', 'Callback',{@Classify_Callback4,gcf});
	hmenu4_4_5 = uimenu(hmenu4_4,'Label','������', 'Visible','off', ...
    'Enable','off','HandleVisibility','off', 'Callback',{@Classify_Callback3,gcf});
	hmenu4_4_6 = uimenu(hmenu4_4,'Label','������', 'Visible','off', ...
    'Enable','off','HandleVisibility','off', 'Callback',{@Classify_Callback4,gcf});
hmenu4_5 = uimenu(hmenu4,'Label','����ѡ���㷨', 'Visible','on','Enable','off', ...
    'HandleVisibility','on','Callback',{@ReChoose_Callback,gcf});
hmenu4_6 = uimenu(hmenu4,'Label','Frobenius����', 'Visible','on','Enable','off',...
    'Separator','on','HandleVisibility','on','Callback',{@Frobenius_Callback,gcf});
% �������������ΪĿ������صĲ˵���ص�������855��
hmenu4_7 = uimenu(hmenu4,'Label','Ŀ����1', 'Visible','on','Enable','off', ...
    'Separator','on','HandleVisibility','on','Callback',{@Detect1_Callback,gcf});
hmenu4_8 = uimenu(hmenu4,'Label','Ŀ����2', 'Visible','on','Enable','off', ...
    'HandleVisibility','on','Callback',{@Detect2_Callback,gcf});
hmenu4_9 = uimenu(hmenu4,'Label','Ŀ����3', 'Visible','on','Enable','off', ...
    'HandleVisibility','on','Callback',{@Detect3_Callback,gcf});
hmenu4_10 = uimenu(hmenu4,'Label','Ŀ����4', 'Visible','on','Enable','off', ...
    'HandleVisibility','on','Callback',{@Detect4_Callback,gcf});
hmenu4_11 = uimenu(hmenu4,'Label','������', 'Visible','off','Enable','off', ...
    'HandleVisibility','off','Callback',{@New_Callback,gcf});

%---------------------------------------��5�в˵�
hmenu5 = uimenu(hfig,'Label','����(W)','Tag','Window','HandleVisibility','off');
hmenu5_1 = uimenu(hmenu5,'Label','��ʽ1',  'HandleVisibility','off', ...
    'Callback',{@feedData,gcf});
hmenu5_2 = uimenu(hmenu5,'Label','��ʽ2',  'HandleVisibility','off', ...
    'Callback',{@New_Callback,gcf});
hmenu5_3 = uimenu(hmenu5,'Label','������',  'Visible','off','Enable','off', ...
    'HandleVisibility','off','Callback',{@New_Callback,gcf});
hmenu5_4 = uimenu(hmenu5,'Label','������', 'Visible','off','Enable','off', ...
    'HandleVisibility','off','Callback',{@New_Callback,gcf});
%---------------------------------------��6�в˵�
hmenu6 = uimenu(hfig,'Label','����(H)','Tag','Help','HandleVisibility','off');
hmenu6_1 = uimenu(hmenu6,'Label','ʹ��˵��',  'HandleVisibility','off', ...
    'Callback',{@New_Callback,gcf});
hmenu6_2 = uimenu(hmenu6,'Label','�������',  'HandleVisibility','off', ...
    'Callback',{@New_Callback,gcf});
hmenu6_3 = uimenu(hmenu6,'Label','������',  'Visible','off','Enable','off', ...
    'HandleVisibility','off','Callback',{@New_Callback,gcf});
hmenu6_4 = uimenu(hmenu6,'Label','������', 'Visible','off','Enable','off', ...
    'HandleVisibility','off', 'Callback',{@New_Callback,gcf});



% movegui(gcf,'center')
vbox = uix.VBox('Parent',hfig,'Spacing',2,'Tag','vbox', 'HandleVisibility','on');
%% ��1��
hbox1 = uix.HBox('Parent',vbox,'Tag','hbox1');
pushbutton1 = uicontrol('Parent',hbox1,'Style','pushbutton','Tag','pushbutton1', ...
                                    'String','��·����','FontName','Microsoft YaHei','FontSize',8.0, ...
                                    'Callback',{@pushbutton1_Callback, gcf});
Text1 = uicontrol('Parent',hbox1,'Style','edit','Tag','Text1','HorizontalAlignment','Left');
hbox1.Widths = [70,-1];
%% ��2��
hbox = uix.HBoxFlex('Parent', vbox, 'Spacing',3,'Tag','hbox');
% hfig1 = figure('Parent',hbox,'Name','��ǰ�ļ���','Tag','currentFolder',...
%                     'NumberTitle','off','DockControls','on',...
%                     'MenuBar','none','ToolBar','none');
panel = uix.BoxPanel('Parent', hbox,'Title', '��ǰ�ļ���','FontSize',8.0, ...
                                'FontName','Microsoft YaHei','Tag','boxpanel' );%,'String','>'
data = struct();
data.pwidthmin = pwidthmin;
data.pwidthmax = pwidthmax;
panel.UserData = data;
set( panel, 'MinimizeFcn', {@nMinimize, gcf} );
d = dir;
hList = uicontrol( 'Style', 'listbox', 'Parent', panel, ...
    'String', num2str([1:100]'), 'BackgroundColor', 'w', ...
    'Tag','listbox1', 'Callback',{@listbox1_Callback, gcf});
% scrollPanel = uix.ScrollingPanel( 'Parent', hbox ); %ScrollingPanel
% axes1 = axes( 'Parent', uicontainer('Parent',scrollPanel),'Tag','axes1' );
axes1 = axes( 'Parent', hbox,'Tag','axes1');

% set( scrollPanel, 'Widths', 600, 'Heights', 600, 'HorizontalOffsets', 100, 'VerticalOffsets', 100 )

set( hbox, 'Widths', [pwidthmax,-5] );
vbox.Heights = [25;-1];

% char(9650) ��
% char(9658) or char(hex2dec('25BA')) : ʵ��������
% char(9660) ��
% char(9668) or char(hex2dec('25C4'))��ʵ��������
% char(9651) ��
% char(9661) ��
% char(9698) �� or char(hex2dec('25E2'))
% ��word�е�������롿�����š�����[��ͨ�ı�]or[�����ı�]���鵽ĳ���ַ����ַ����룬
% ��������ַ�����Ϊ'25B2'������Matlab���ǣ�char(hex2dec('25B2'))

updatatree(customPath,gcf);

data = struct();
data.imgMat = [];
data.ind = [];
data.imgGT = [];

data.cmap = [];
data.M = [];
hmenu2_3.UserData = data;
hmenu2_3.UserData.ind = hfig.UserData.ind;

hmenu2_4.UserData = data;

hmenu3_1.UserData = data;
hmenu3_2.UserData = data;
hmenu3_3.UserData = data;
hmenu3_4.UserData = data;

% guidata(hObject, handles);

%-----------------------------------�ص�����---------------------------------------------------%
function nMinimize( eventSource, eventData, handles) %#ok<INUSL>
    % A panel has been maximized/minimized
    hbox = findobj(handles.Children, 'Tag', 'hbox');
    s = hbox.Widths;
    boxpanel = findobj(hbox.Contents,'Tag','boxpanel');
%     pos = get( fig, 'Position' );
    boxpanel.Minimized = ~boxpanel.Minimized;
    if boxpanel.Minimized  %true or false
        s(1) = boxpanel.UserData.pwidthmin;
    else
        s(1) = boxpanel.UserData.pwidthmax;
    end
    set(hbox, 'Widths', s );

    % Resize the figure, keeping the top stationary
%     delta_height = pos(1,4) - sum( box.Heights );
%     set( fig, 'Position', pos(1,:) + [0 delta_height 0 -delta_height] );
end % nMinimize

%----------------------------------------�ص�����----------------------------------------------------%
% --- Executes on button press in pushbutton1.
%-------��ѡ��·����
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = [uigetdir(handles.UserData.customPath)];
if path % �������Ի����[ȡ��]���߹رնԻ�����path==0����ʱ�����κδ�����
    handles.UserData.currentPath = path; %����ʹ��selectedPath����
    text = findobj(handles,'Style','edit');
    text.String = handles.UserData.currentPath;
    updatatree(handles.UserData.currentPath,handles)
end
end

function listbox1_Callback(hObject, eventdata, handles)
% % hObject    handle to listbox1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from listbox1
% val=get(hObject,'value');     %�����MA��ҵ���ġ�28
% % string=get(hObject,'string');% 74��1 cell
% % hbox = findobj(handles.Children,'Type','HBoxFlex');
% hbox = findobj(handles.Children,'Tag','hbox');
% if ~isempty(findobj(hbox,'Tag','imscrollpanel'))
%     delete(findobj(hbox,'Tag','imscrollpanel'));%����Ŀ¼
%     axes1 = axes('Parent',hbox);
% else
%     axes1 = findobj(hbox,'Tag','axes1');
% end
% boxpanel = findobj(handles.Children,'Tag','boxpanel');
% listbox1 = findobj(boxpanel,'Tag','listbox1');
h = reNewContent(hObject,handles);  

%��ʾѡ���ļ��ĵ�ַ
text = findobj(handles,'Style','edit');
text.String = hObject.UserData.currentPath;
% B = repmat(string{val},varargin);%���� varargin=[160, 1];
% b = space(ones(1,n));%���� n = 5;

% ���listbox�е�ĳ�����չ������Ŀ������еĻ������ٴε��������
% ����Ŀ������ǰ���������s
% ���������ҵĻ�������
end

function updatatree(selectedPath,handles)
global customPath mFilePath bkcGT colorBase

%��ʾѡ���ļ��ĵ�ַ
text = findobj(handles,'Style','edit');
text.String = selectedPath;

a=dir(selectedPath); % 76��1 struct
% a(1) =   
% ���������ֶε� struct:
%        name: '$360Section'
%      folder: 'D:\'
%        date: '30-����-2019 01:08:48'
%       bytes: 0
%       isdir: 1
%     datenum: 7.3767e+05
%  
% a(2) =  
%   ���������ֶε� struct:
%        name: '$RECYCLE.BIN'
%      folder: 'D:\'
%        date: '23-����-2012 18:09:43'
%       bytes: 0
%       isdir: 1
%     datenum: 7.3501e+05

%[a.isdir]' 76��1 logical ����

contentname={a.name}';
n = numel(contentname);%�ų���$��ͷ���ļ������ų�.��..
%��ͳ����$��ͷ���ļ�������
count = 0;
k = 1;
while strcmp(contentname{k}(1),'$')
    count = count + 1;
    k = k+1;
end   
contentname=contentname(count+3:end);
isFolder=[a.isdir]';
isFolder=isFolder(count+3:end);
%74��1 cell
% global_isFolder=isFolder;
% global_contentname=contentname;

CN=length(isFolder);
level=ones(CN,1);
% global_path=repmat(customPath,CN,1);
[string]=changeToContent(isFolder,contentname,level);
% ���������global_isFolder
% global_isFolder(9:12)
% ans =
%      1
%      0
%      1
%      1
% global_contentname(9:12)
%     '360�������������'
%     '360���������Ŀ¼.txt'
%     '360������ʦĿ¼'
%     '795'

% ������
% string 74��1 cell
% string(9:12)
%     '>>360�������������'
%     '360���������Ŀ¼.txt'
%     '>>360������ʦĿ¼'
%     '>>795'
% boxpanel = findobj(handles.Children,'Tag','boxpanel');
listbox1 = findobj(handles.Children,'Tag','listbox1');
listbox1.ListboxTop = 1;%������ѡ����Ŀ¼������Ҫ��ListboxTop����Ϊ1
listbox1.Value = 1;       % ������ѡ����Ŀ¼������Ҫ��Value����Ϊ1
listbox1.String = string;

%�洢����string��level��listbox1
data = struct();
data.stringOld = string;
data.stringNew = string;
data.levelOld = level;
data.levelNew = level;
data.isFolderOld = isFolder;
data.isFolderNew = isFolder;
data.valueOld = 1;
data.valueNew =1;
data.customPath = customPath;%currentPath(1:3)
data.currentPath = selectedPath;
data.selectedPath = selectedPath;
data.mFilePath = mFilePath;
data.matdata = [];
data.ind = [13, 33, 63]; %
data.gtdata = [];
data.M = [];
% colorBase = [ [1,0,0]; [0,1,0]; [0,0,1]; [1,1,0]; [1,0,1]; [0,1,1]; ...
%                     [0.5,0,0]; [0,0.5,0];[0,0,0.5]; [0.25,0.75,0]; [0.85,0.5,0]; [0.5,0.5,0]; ... 
%                     [0.5,0,1]; [1,0,0.5]; [0.5,0,0.5]; [0.35,0.65,0.75]; [0,1,0.5]; [0,0.5,0.5]; ...
%                     [0.5,0.5,0.5]; [0.1,0.1,0.1]];
data.bkcGT = bkcGT;                
data.cmap = [data.bkcGT;colorBase]; %��ӱ������ص���ɫ���˴����屳�����ص���ɫΪ��ɫ
data.imgMat = []; %�洢Matα��ɫͼ��
data.imgGT = [];   %�洢GTͼ���־
data.imgStack = [];%�洢Mat��GT�Ķѵ�ͼ��
data.img = []; %�洢��ͨ2άͼ��
data.himage = [];
listbox1.UserData = data;

% ��ʼ��handles.UserData
data = struct();
data.mFilePath = mFilePath;
data.customPath = customPath;%currentPath(1:3)
data.currentPath = selectedPath;
data.selectedPath = selectedPath;

data.matdata = listbox1.UserData.matdata;
data.gtdata = listbox1.UserData.gtdata;
data.ind = listbox1.UserData.ind;
data.bkcGT = listbox1.UserData.bkcGT;
data.cmap = listbox1.UserData.cmap;
data.imgMat = listbox1.UserData.imgMat;
data.imgGT = listbox1.UserData.imgGT;
data.imgStack = listbox1.UserData.imgStack;
data.imgNew = []; %��������㷨Ԥ���GTͼ��
data.img = listbox1.UserData.img; %�洢��ͨ2άͼ��
data.M = listbox1.UserData.M;
data.himage = listbox1.UserData.himage;

%������ʵ�ֿ��ӻ�����������������ܿ�������Ҫ�ı���
data.x2=[];%
data.lbs=[];

handles.UserData = data;

end


% --------------------------------------��1�в˵�---------------------------��ʼ����31��--------------
% ���½���
function New_Callback(hObject, eventdata, handles)
%     global is_first_time_to_open newOpenTimes
% 
%     is_first_time_to_open = 1;
%     newOpenTimes = 0;
%     newOpenTimes = newOpenTimes + 1;
%     hfig = ancestor(hObject,type,'toplevel');
%     hfig = ancestor(hObject,'figure');
%     fig = figure('WindowStyle', get(hfig, 'WindowStyle'));
%     fig = openfig('test1.fig','visible');

% ������������ĺ��壺

%     hObject
                        %   hObject = 
                        %   Menu (�½�) (��������):
                        % 
                        %           Label: '�½�'
                        %     Accelerator: 'N'
                        %        Callback: [function_handle]
                        %       Separator: 'off'
                        %         Checked: 'off'
                        
%     eventdata     %matlab.ui.eventdata.ActionData
                        %  eventdata =  
                        %   ActionData (��������): 
                        %        Source: [1��1 Menu]
                        %     EventName: 'Action'
%     handles
                        %   handles = 
                        % 
                        %   Figure (mainFigure) (��������):
                        % 
                        %       Number: 1
                        %         Name: '�߹��׷���ϵͳ'
                        %        Color: [0.9400 0.9400 0.9400]
                        %     Position: [403 246 560 420]
                        %        Units: 'pixels'
    %% ʹ��ÿ���ؼ������UserData�������洢�䱻�ڼ��ε����
%     fig = openfig('test1.fig');
% %     fig = f.copy(); %�ؼ�û���κη�Ӧ
%     fig.NumberTitle = 'off';
%     fig.Tag = ['New',num2str(newOpenTimes)];
%     fig.Position = [(1+0.03*newOpenTimes)*fig.Position(1),(1-0.03*newOpenTimes)*fig.Position(2),fig.Position(3),fig.Position(4)];
%     fig.Name = ['New',num2str(newOpenTimes),' ',handles.Name];
%     newOpenTimes = newOpenTimes+1;
%     p1 = mfilename('fullpath');
    p = mfilename();
    status = copyfile([p,'.m'], [p,'_1.m']);
    eval(p);
end

% --------------------------------------------------------------------
%����Mat��
% function Open1_Callback(hObject, eventdata, handles)
% �Ѿ�д�ɵ�������
% end

%����Gt��
% function Open2_Callback(hObject, eventdata, handles)
% �Ѿ�д�ɵ�������
% end


% --------------------------------------------------------------------
function Close_Callback(hObject, eventdata, handles)

    selection = questdlg('�˳���ǰ����?',...
    'Confirmation',...
    '��','��','��');
    switch selection
        case '��'
            delete(handles);
            clear,close all
            clc           
        case '��'
            return
    end
end

% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% ����һ�����⣬ColorBar�ĸ�������ֻ�����������figure,panel,
% ������axes�����磬��ʱColorBar.Parent��imscrollpanel��
% ����ֱ����imsave����Ļ���ֻ�ܱ���axes�����ڵ����ݣ����ܱ���
% axes��������ݣ����Ա����ͼ����ColorBar���Ƕ�ʧ��
% �������1��getframe
% �������2��print
% �������3�����´���һ��figure���»�һ���ٱ���

% f=getframe(gcf);%ȡ�õ�ǰfigure�Ŀ���
% figure;
% imshow(f.cdata);%����һ��figure����ʾȡ�õĿ���
% 
% ���������imwrite��������f.cdata���浽ָ���ļ����ɡ�

% f = getframe(findobj(handles,'Tag','imscrollpanel'));
% % ����ʹ�� getframe (line 48)
% % ����ָ����Ч��ͼ�ξ��������
%     figure
%     imshow(f.cdata);
%     imsave(f.cdata);
% ���ۣ��������1ʧ��
% print('SurfacePlot','-djpeg','-noui')
% ���ۣ��������2ʧ�ܣ���Ȼ������ColorBar������ֻ��ͼ���
% һ���֣�δ������Ļ��Ĳ��֡�
%

% figure(1)�����ã���Ϊhandles==figure(1)
% ����imscrollpanel����gtͼ�񣬲������⴦������ֱ�ӱ���
if ~isempty(findobj(handles,'Tag','imscrollpanel'))&&~isempty(findobj(handles,'Type','image'))...
        && handles.UserData.dim == 2
    
    img = handles.UserData.img;
    cmap = handles.UserData.cmap;
    M = handles.UserData.M;
    hfig2 = figure(2);
    imshow(img,cmap,'InitialMagnification','fit');
    c = colorbar;
    c.Label.String = '��������Ӧ��ɫ';
    c.Limits = [1 M+1];
    c.Ticks = 1:1:M;
    f=getframe(hfig2);
    [filename,ext,user_canceled] = imputfile;
    if ~user_canceled
        imwrite(f.cdata, filename);
    end
    close(hfig2);
else
        imsave();
end
end

% --------------------------------------------------------------------
function SaveAs_Callback(hObject, eventdata, handles)
    imsave();
end

% --------------------------------------------------------------------
function Report_Callback(hObject, eventdata, handles)
% ���ɵ�ǰ��������ʾ��ͼ��ĸ�����Ϣ��txt��ʽ�����Զ���
%
%
%
%
%
end

function ExportAsMat_Callback(hObject, eventdata, handles)
% �����Ƶ�ǰ��������ʾ��ͼ������ĸ�����Ϣ(�ϳ�ͨ�����ind��colormap+NumInClass)��
% ���浽һ��struct�У�����struct��ԭʼ���ݱ��浽ͬһ��*.mat
% ������һ�����棬txt��ʽ�����Զ���
%
%
%
%
end

% --------------------------------------------------------------------
function ImportData_Callback(hObject, eventdata, handles)
% hObject    handle to ImportData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end



% --------------------------------------��2�в˵�--------------------------------------------------

function Undo_Callback(hObject, eventdata, handles)
% hObject    handle to Undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function Redo_Callback(hObject, eventdata, handles)
% hObject    handle to Redo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

function Synth_Callback(hObject, eventdata, handles)
% ֻ�е����浱����ͼ��ʱ��Ż�ִ�С�
%1 �û�������༭�������ºϳɡ�������ʾ�Ի������û�����3��ͨ�����
    if ~isempty(findobj(handles,'Type','image'))&&~isempty(handles.UserData.imgMat)...
            &&~isempty(handles.UserData.matdata) && size(handles.UserData.matdata,3) >3
        
        %��ǰ��������ͼ������Ӧ�İ�ť�е�UserData.imgMat��Ϊ�գ���˵����ǰ��������ʾ��ͼ����Matͼ��
        
        x2 = handles.UserData.matdata; 
        prompt = ['Enter the space-separated channel numbers of blue, green and red. '...
            'Input range: Min : 1, Max : ',num2str(size(x2,3)), '. Default index are:',num2str(handles.UserData.ind),'. Current index are:',num2str(hObject.UserData.ind)];
        dlg_title = 'Customerize channel numbers';
        an = inputdlg(prompt,dlg_title,1);%resize��������Ϊon
        try
            ind = str2num(an{:}); 
            img = synthesize_image(x2,ind);
            
        % �������ScrollBar�ģ�ɾ���ػ���
            [hbox, himage] = newPlot(img,handles);
            %���ñ�־ֵ
            hmenu3_1 = findobj(handles,'Label','��Ӧ����');
            hmenu3_1.UserData.imgGT=0;
        catch
%             ind = hObject.UserData.ind;
        end


    else
        ms = ['Open a mat-file whose 3th dimension must be '...
            'great than 2 , then you can execute synthesize! '] ;
        errordlg(ms,'Invalid operation');
        return
    end
    hObject.UserData.imgMat = img;
    hObject.UserData.ind = ind;        %�����û����õ�ͨ�����
    handles.UserData.imgMat = hObject.UserData.imgMat;
    
end


function Recolor_Callback(hObject, eventdata, handles)
    
    if ~isempty(handles.UserData.gtdata)
        x = handles.UserData.gtdata;
        % �ı�colormap
        temp = handles.UserData.cmap;
        cmap = temp;
        cmap(2:end-1, :) = temp(3:end, :);
        cmap(end, :) = temp(2, :);
        c = colormap(cmap);
        handles.UserData.cmap = c;
%             hObject.UserData.cmap = handles.UserData.cmap;
        [hbox, himage] = newPlotGT(double(x), handles);
        %�ָ�cmap��ԭ����ֵ��%���ǣ�Ϊ��ʵ����ɫ�ܹ������Ͳ��ָܻ�
%         handles.UserData.cmap = temp;

        %���ñ�־ֵ
        hmenu3_1 = findobj(handles,'Label','��Ӧ����');
        hmenu3_1.UserData.imgGT=1;
    else
        ms = 'Open a *_gt.mat file first!';
        errordlg(ms);
    end
    %����colormap   
end

function Delete_Callback(hObject, eventdata, handles)
    % ��ScrollBar����ɾ��handles.UserData.scrollpanelH
    ims = findobj(handles,'Tag','imscrollpanel');
    clb = findobj(handles,'Type','colorBar');
    himage = findobj(handles,'Type','image');
    
    hbox = findobj(handles, 'Tag','hbox');
    %get( hbox, 'Widths', [pwidthmax,-5] );
    hw = hbox.Widths;
    if ~isempty(ims)
        delete(ims);     
    elseif ~isempty(clb)
        delete(clb);
        delete(himage);
    elseif ~isempty(himage)
        delete(himage.Parent);
    end
    axes1 = axes('Parent',hbox,'Tag','axes1');
    set( hbox, 'Widths', hw );
end
% --------------------------------------------------------------------
function SelectAll_Callback(hObject, eventdata, handles)
% hObject    handle to SelectAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function CopyFigure_Callback(hObject, eventdata, handles)
% ����ǰͼ���е�ͼ���Ƶ����а�
%
%
%
end

% --------------------------------------------------------------------
function CopyOption_Callback(hObject, eventdata, handles)
% hObject    handle to CopyOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function Copy_Callback(hObject, eventdata, handles)
% hObject    handle to Copy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function Paste_Callback(hObject, eventdata, handles)
% hObject    handle to Paste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function Untitled_20_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------��3�в˵�--------------------------------------------------

function FitWindow_Callback(hObject, eventdata, handles)
    % ���鿴������Ӧ���ڡ�
    %ֻ�е�ǰͼ���ڼȴ���ScrollBar����ʾ��ͼƬ�����ǲ�ִ�С�����ɶҲ���ɡ�
    if ~isempty(findobj(handles,'Tag','imscrollpanel'))&&~isempty(findobj(handles,'Type','image'))
        %����֪����ǰ������ʾ����ʲô���ݣ�
        himage = findobj(handles,'Type','image');  %�����img����himage��������CData����ʹ��
        hObject.UserData.imgGT=0;
        if ndims(himage.CData) == 2 &&  ~isempty(findobj(handles,'Type','colorbar'))
            %�����ﻹ���޷�֪����ǰ��������ʾ����GTͼ����ĳ���Ҷ�ͼ��
            %̽�鵱ǰ�������Ƿ����colorbar
%             colorb = findobj(findobj(handles,'Type','colorbar'));
%             strcmp(colorb.Label,'��������Ӧ��ɫ');            

            img = handles.UserData.gtdata;
            cmap = handles.UserData.cmap;
            M = handles.UserData.M;
            hfig2 = figure();
%             figure(hfig2);
            set(hfig2,'Visible', 'off'); %���Ե�ʱ���������Ϊ'on'
            axes1 = axes('Parent',hfig2,'Visible', 'on');           
%             imshow(img,'Parent',axes1,'InitialMagnification','fit');
            
            %
            himage2 = imshow(img,cmap,'InitialMagnification','fit');
            c = colorbar;
            c.Label.String = '��������Ӧ��ɫ';
            c.Label.FontWeight = 'bold'; 

            c.Ticks = 0.5:1:M+0.5;       %�̶���λ��
            c.TicksMode = 'Manual';
            c.TickLabels = num2str([-1:M-1]'); %�̶���ֵ
            c.Limits = [1,M+1];
% ΪʲôҪ��ȡ�����ķ�ʽ����Ϊ��������ʽ����ɫ��colorBar�޷�������ʾ��
% ������������߿��������
            f=getframe(hfig2);
            close(hfig2);        
            himage.CData = f.cdata;
            hObject.UserData.imgGT=1; 
            %hObject����hmenu3_1����Ϊ1��ʾ�������һ��GTͼ��
            %����ָ����ԭʼ��С������ԭͼ��ʾ
        end
            
            %��ͨ��2άͼƬ������Ҷ�ͼ
            [hbox, himage] = newPlotFit(himage.CData, handles);
    end
end


% --------------------------------------------------------------------
function OriginSize_Callback(hObject, eventdata, handles)
    %���鿴����ԭʼ��С��
    % ��ʾ��ʽ��''��Ӧ����''״̬ת��Ϊ'ԭʼ��С'
    % ֻ��ͼ���û��ScrollBar����������²�ִ�С�����ִ��
    if isempty(findobj(handles,'Tag','imscrollpanel'))&&~isempty(findobj(handles,'Type','image'))
        himage = findobj(handles,'Type','image');
%         hmenu3_1 = findobj(handles,'Label','��Ӧ����');
        hmenu3_1 = hObject.Parent.Children(4);%Ҳ��[��Ӧ����]
        if ~hmenu3_1.UserData.imgGT     %��ѯ����Ӧ���ڡ������Ķ�������ͨͼ����GTͼ
            
%             ��ʾ��ͨͼƬ
            [hbox, himage] = newPlot(himage.CData, handles);
            
        else %��ʾGTͼƬ
%             ndims(img) == 2 && ~isempty(findobj(handles,'Type','colorbar'))
            x = handles.UserData.gtdata;
            [hbox, himage] = newPlotGT(double(x), handles);
        end
    end
end

%���鿴����������ͼ(����Ӧ)�������ű�����
% function SeparatePlot1_Callback(hObject, handles)
% end
%���鿴����������ͼ(ԭʼ��С)�������ű�����
% function SeparatePlot2_Callback(hObject, handles)
% end
% --------------------------------------��4�в˵�------------------------��ʼ����83��--------------------
function FeedData_Callback(hObject, eventdata, handles)
% ����һ���Ի������û�ѡ��*.mat��*_gt.mat�������㷨��
        feedData(hObject,handles);
%         [x3,x2,lbs2,lbs] = dataProcess2(handles);
%         hObject.UserData.x3 = x3;  
%         hObject.UserData.x2 = x2;
%         hObject.UserData.lbs2 = lbs2;
%         hObject.UserData.lbs = lbs;
%         %ֱ�ӱ������ݵ�hObject������������費����load

        % hmenu4_1 = findobj(handles,'Label','��������');
        
        hmenu4_2 = findobj(handles,'Label','���׷���');
        hmenu4_2.Enable = 'on';
        
        hmenu4_3 = findobj(handles,'Label','ִ�н�ά');
        hmenu4_3.Enable = 'on';
        % ��ǰһ���ڡ�ִ�н�ά�����������±���������������
        hmenu4_3.UserData.drData = []; % hmenu4_3
        
        hmenu4_4 = findobj(handles,'Label','ִ�з���');
        hmenu4_4.Enable = 'on';
        hmenu4_4_1 = findobj(handles,'Label','���ܷ���');
        hmenu4_4_1.Enable = 'on';
        % ��ǰһ���ڡ����ܷ��ࡿ���������±���������������
        
        hmenu4_4_2 = findobj(handles,'Label','ClassDemo');
        hmenu4_4_2.Enable = 'on';
        % ��ǰһ���ڡ�ClassDemo�����������±���������������
        hmenu4_4_2.UserData.racc = [];
        hmenu4_4_2.UserData.best_perf = [];
        hmenu4_4_2.UserData.best_vperf = [];
        hmenu4_4_2.UserData.best_tperf = [];
        hmenu4_4_2.UserData.lbsTest = [];
        hmenu4_4_2.UserData.imgNew = [];
        handles.UserData.imgNew = [];
        
        
        hmenu4_4_3 = findobj(handles,'Label','Classification Learner');
        hmenu4_4_3.Enable = 'on';
        hmenu4_4_4 = findobj(handles,'Label','nprtool');
        hmenu4_4_4.Enable = 'on';        
        
        
        hmenu4_5 = findobj(handles,'Label','����ѡ���㷨');
        hmenu4_5.Enable = 'on';
        hmenu4_6 = findobj(handles,'Label','Frobenius����');
        % ��ǰһ���ڡ�Frobenius���������������±���������������
        hObject.UserData.F2=[];
        hObject.UserData.channelSelected = [];
        hObject.UserData.x2Selected = [];
        hmenu4_6.Enable = 'on';
        
        
        
        hmenu4_7 = findobj(handles,'Label','Ŀ����1');
        hmenu4_7.Enable = 'on';  
        hmenu4_8 = findobj(handles,'Label','Ŀ����2');
        hmenu4_8.Enable = 'on';
        hmenu4_9 = findobj(handles,'Label','Ŀ����3');
        hmenu4_9.Enable = 'on';  
        hmenu4_10 = findobj(handles,'Label','Ŀ����4');
        hmenu4_10.Enable = 'on';
end

function SpectrumPlot_Callback(hObject, eventdata, handles)
% ���Ƴ��������Ĺ��׷���������
    timerVal_1 = tic;
    disp('���׷�������.....................................................');
    %handles.UserData
    hmenu4_1 = findobj(handles,'Label','��������');
   
    spectralReflectivity(hmenu4_1);%handles�����ڴ���cmap
    
    time1 = toc(timerVal_1);
    disp(['���׷�����ɣ���ʱ',num2str(time1),'��.']);
end

function ReduceDim_Callback(hObject, eventdata, handles)
global x3 lbs2 x2 lbs mappedA
% �������ݽ�ά���߰���ʵ��
% D:\MA��ҵ����\Matlab-Toolbox-for-Dimensionality-Reduction-master
% ��ά�����ǳ��ḻ����ôҪΪ����������������һ��ҳ����

hmenu4_1 = findobj(handles,'Label','��������');
x2 = hmenu4_1.UserData.x2;
lbs = hmenu4_1.UserData.lbs; 

A = x2;
% ��ѡ����㷨���Ƽ����
type = hmenu4_1.UserData.drAlgorithm;
val = hmenu4_1.UserData.drValue;
% type = 'PCA';

% For the supervised techniques ('LDA', 'GDA', 'NCA','MCML', and 'LMNN'),  
% the labels of the instances should be specified in the first column of A (using numeric labels).
%  
if ismember(type, {'LDA', 'GDA', 'NCA', 'MCML', 'LMNN'})
    A = [lbs,x2];
end
% ������ŷ���Ĭ�ϲ���
% paraTable_dr = importfile1(workbookFile, sheetName, dataLines)
%  ʾ��:
%  Untitled = importfile1("D:\MA��ҵ����\ATrain_Record\20191002\��ά����ͳ��.xlsx", "Sheet1", [2, 35]);

dataLines = [val+1, val+1];%��val���㷨��Ӧ��excel�ĵ�val+1��
% dataLines = val+1;

workbookFile = fullfile(handles.UserData.mFilePath,"ParametersForDimReduceClassify.xlsx");
try
    paraTable_dr = importfile1(workbookFile, "Sheet1", dataLines);
catch
    paraTable_dr = importfile1(workbookFile, "Sheet1", [2,2]);
end
t = table2cell(paraTable_dr);
n = numel(t); 
para = cell(1,2*n);
for i = 1:n
	para{2*i} = t{i};
	para{2*i-1} = paraTable_dr.Properties.VariableNames{i};
end
% no_dims = 10;���ⲿExcel������(Ĭ��ֵ�������ȡ)
hmenu4_1.UserData.drDims = para{2};
    timerVal_1 = tic;
    disp('---------------ִ�н�ά---------------');
    disp(paraTable_dr);
%     disp([type, para,'ִ�н�ά..........']);
    
    try
%     [mappedA, mapping] = compute_mapping(A, type, para{2}, para(3:end));
%     ������Name-Value�������뷽ʽ���ǲ��еģ���Ϊ�ڲ鿴tsne.m�ļ�ʱ�����������Ҫ���ǣ�����ֵ����
% ydata = tsne(X, labels, no_dims, initial_dims, perplexity)
% ����ʾ��
% [mappedA, mapping] = compute_mapping(A, type, para{2}, 'perplexity',[10], 'initial_dims',[30], 'eig_impl', "JDQR")
% ��ȷʾ��
% [mappedA, mapping] = compute_mapping(A, type, para{2}, 10, 30, "JDQR");

        [mappedA, mapping] = compute_mapping(A, type, para{2}, t{2:end});
    catch
        [mappedA, mapping] = compute_mapping(A, type, para{2});
    end

% % ʹ��Matlab��pca()�������н�ά
% [coeff,score,latent,~,explained,mu] = pca(x2);
% mappedA = score(:, 1: para{2});


% ʹ��matlab�����pca�㷨���Ա�    


% end
% mappedA = compute_mapping(A, type, t(1));
% mappedA = compute_mapping(A, type, no_dims);
% mappedA = compute_mapping(A, type, no_dims, ...);
% mappedA = compute_mapping(A, type, no_dims, parameters);
% mappedA = compute_mapping(A, type, no_dims, parameters, eig_impl);
time1 = toc(timerVal_1);
disp(['��ά��ɣ���ʱ',num2str(time1),'��.']);
hmenu4_1.UserData.drElapsedTime = time1;
%% ���ƽ�ά��Ľ��
ldaPlot(mappedA,lbs,handles); %��ͨɢ��ͼ�ķ�ʽ��ʾ��ά���Ч��
% ldaPlot1(mappedA,lbs,handles); %ȥ�������㣨��Ϊ�����㸲��ס�������㣩
%% ���潵ά��Ľ��
% mapping;
% mapping = 
% 
%   ���������ֶε� struct:
% 
%       mean: [1��146 double]
%          M: [146��10 double]
%     lambda: [10��1 double]
%       name: 'PCA'
hObject.UserData.drData = mappedA; % hmenu4_3
% hObject.UserData.drAlgorithm = mapping.name; % hmenu4_1

    %ʹ�ܡ�������>>��ִ�з��ࡿ>>��ClassDemo������ѡ��
    hmenu4_4_2 = findobj(handles,'Label','ClassDemo');
    hmenu4_4_2.Enable = 'on';    
end


function ReChoose_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ��ʾfeedData�Ľ��棬��������ѡ�������������ģ�edit1��edit2����ʾ֮ǰ�Ѿ�ѡ��õ����ݵ�ַ
% ��handles��ȡ
% '��ά�㷨'����ʾ֮ǰ�Ѿ�ѡ����㷨����handles�µ�hmenu4_1��ȡ
% '�����㷨'����ʾ֮ǰ�Ѿ�ѡ����㷨����handles�µ�hmenu4_1��ȡ
% �û�ֻ������ѡ��'��ά�㷨'��'�����㷨'
% �������߶�����ѡ��
% ����feedData�����������Ѿ���һ��'��ʾ��һ��ѡ�����'�Ĺ���
% ���feedData�����ǵ�һ�������������еĿ���ʾ����'��'
% ���feedData�����ǵ�N�������������еĿ���ʾ��һ����ѡ��Ľ��
% ������Ҫ��feedData���иĽ�

feedData(hObject,handles);

% ��ǰһ���ڡ�ִ�н�ά�����������±���������������
hmenu4_3 = findobj(handles,'Label','ִ�н�ά');
hmenu4_3.UserData.drData = []; % hmenu4_3

% ��ǰһ���ڡ�ClassDemo�����������±���������������
hmenu4_4_2 = findobj(handles,'Label','ClassDemo');

hmenu4_4_2.UserData.racc = [];
hmenu4_4_2.UserData.best_perf = [];
hmenu4_4_2.UserData.best_vperf = [];
hmenu4_4_2.UserData.best_tperf = [];
hmenu4_4_2.UserData.lbsTest = [];
hmenu4_4_2.UserData.imgNew = [];
handles.UserData.imgNew = [];
end

function Frobenius_Callback(hObject, eventdata, handles)

% �����ÿ������ͨ���ϵ�F�����������Ƴ�F����ƽ��������
% �Ӷ�����F������С��ѡ��ͨ����ͨ������F����С��ͨ����
    hObject.UserData.thresholdDefault = 0.1;
    hObject.UserData.thresholdCustom = 0;
%1 �û��������������Frobenius������������ʾ�Ի������û�������ֵthreshold����ΧΪ[0,1]
    prompt = ['1. Normalized threshold, the range is [0,1], the default value is ',...
        num2str(hObject.UserData.thresholdDefault),'.   2. Absolute threshold, the range is [0, N]',...
        'N is Maximun of Frobenius Analysis and usually unknown before analysis. This is just use when'...
        'you have known the finally analysis result'];
    % 1.���ֵ��ֵ����ã�2.����ֵ����ֵ��ֻ������֤������֪�Ľ���
    dlg_title = 'Enter the threshold';
    an = inputdlg(prompt, dlg_title, 1);%resize��������Ϊon
    try
        hObject.UserData.thresholdCustom = str2double(an{:}); 
    catch
        hObject.UserData.thresholdCustom = hObject.UserData.thresholdDefault;
    end

    timerVal_1 = tic;
    disp('F������������.....................................................');
    hObject.UserData;
    hmenu4_1 = findobj(handles,'Label','��������');
    x2 = hmenu4_1.UserData.x2;
    
%     F = sqrt(sum(x2.^2)); % F����
    F2 = sum(x2.^2);           % ����ÿ��ͨ���ϵ�(��x2��ÿһ�е�)F������ƽ��
%     F2 = norm(x2,'fro');       % F����
%    F2 = norm(x2,'fro')^2;   % F������ƽ��
    hObject.UserData.F2 = F2;
    
    figure
    plot(F2,'LineWidth',1.5);
    xlabel('Channels');
    ylabel('Square of Frobenius');
    
    % ���ò���ʾ��ֵ��
    hold on
    if isnan(hObject.UserData.thresholdCustom)  % NaN�����Ρ�������ֱ�ӵ�ȷ��
        threshold = hObject.UserData.thresholdDefault*max(F2);
    elseif hObject.UserData.thresholdCustom<=1 
        threshold = hObject.UserData.thresholdCustom*max(F2);  %�����ֵ����       
    else                                       %������ֵ������
        threshold = hObject.UserData.thresholdCustom; %PaviaU������ֵΪ2.0e11
    end
        
    n = numel(F2);
    plot([1, n],[threshold, threshold],'--','LineWidth',1.5);
    text(0,threshold*1.025,[num2str(threshold)]);
    legend(hmenu4_1.UserData.matName,'Threshold','Interpreter','none','Location','best');  % �����Լ����ݵ���Ϣ�������ڡ��������ݡ���UserData��
    hold off
%     F2_new = F2(F2>=threshold);        % ����F����ƽ�����ڵ���threshold�Ĳ���
%     hObject.UserData.F2_new = F2_new;
% ������ͨ����ű�����channelSelected
    hObject.UserData.channelSelected = find(F2>=threshold);
    % ���ս���ͨ����x2��ѡ�����������x2Selected��
    hObject.UserData.x2Selected = x2(:, hObject.UserData.channelSelected);
    hObject.UserData
    threshold
    time1 = toc(timerVal_1);
    disp(['F����������ɣ���ʱ',num2str(time1),'��.']);
end

function Detect1_Callback(hObject, eventdata, handles)

hyperDemo_2
end

function Detect2_Callback(hObject, eventdata, handles)

hyperDemo_detectors_2
end

function Detect3_Callback(hObject, eventdata, handles)

hyperDemo_mams_RIT_data_2
end

function Detect4_Callback(hObject, eventdata, handles)

hyperDemo_RIT_data_2
end

function Untitled8_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

function Untitled1Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

function Untitled2Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------��5�в˵�--------------------------------------------------
function Untitled9_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

function Untitled10_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------��6�в˵�--------------------------------------------------
function Untitled11_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

function Untitled12_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

%-------------------------------------Controller����-----------------------------------------
