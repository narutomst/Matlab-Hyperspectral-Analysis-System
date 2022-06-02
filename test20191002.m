% close all
clear
clc
opengl('save', 'software') 

%----------------------------------------------主界面-------------------------------------------%
global customPath mFilePath bkcGT colorBase
bkcGT = [0.98 0.98 0.98];%GT图背景颜色黑或者白
colorBase = [ [1,0,0]; [0,1,0]; [0,0,1]; [1,1,0]; [1,0,1]; [0,1,1]; ...
                    [0.5,0,0]; [0,0.5,0];[0,0,0.5]; [0.25,0.75,0]; [0.85,0.5,0]; [0.5,0.5,0]; ... 
                    [0.5,0,1]; [1,0,0.5]; [0.5,0,0.5]; [0.35,0.65,0.75]; [0,1,0.5]; [0,0.5,0.5]; ...
                    [0.5,0.5,0.5]; [0.1,0.1,0.1]];
                
global x3 lbs2 x2 lbs Inputs Targets Inputs1 Targets1 Inputs2 Targets2 Inputs3 Targets3 t0 t1 t2 mA mA1 mA2 Inputs_1 Targets_1 Inputs_2 Targets_2

p = mfilename('fullpath'); %%确定当前正在执行的*.m文件的路径
mFilePath = fileparts(p);   %确定*.m文件所在的文件夹路径(即截断最后一级的路径)
p = fileparts(mFilePath);   %继续截断最后一级的路径，即得到C:\Matlab练习
path = fullfile(p,'duogun');%拼接路径
s = what('duogun');
if exist(path, 'dir')
    customPath = path;  %以相对定位的方式生成duogun的路径
elseif ~isempty(s)
    customPath = s.path;%用what()直接查找到duogun
else
    customPath = pwd;%当前工作的路径
end

%自动添加所需工具包
toolPath={'GAOT-master',...
                'GUI Layout Toolbox 2.3.4',...
                'hyperspectralToolbox',...
                'Matlab-Toolbox-for-Dimensionality-Reduction-master'
                };
n = numel(toolPath);
%fullfile(p,toolPath{n})      %'C:\Matlab练习'与toolPath{n}拼接成完整路径
for i = 1:n
    addpath(genpath(fullfile(p,toolPath{i})));
end


pwidthmin = 20; % 左侧panel收起时的宽度为15像素
pwidthmax = -1.5; % 左侧panel展开时的宽度为相对值-1，右侧窗口的宽度也是相对值-5

% hfig = figure('Name','高光谱分析系统','Tag','mainFigure',...
hfig = figure('Name','高光谱分析系统','Tag','mainFigure',...
                    'NumberTitle','off','DockControls','on',...
                    'MenuBar','none','ToolBar','none', ...
                    'Position',[304,50,800,400], ...
                    'SelectionType','normal', ...
                    'CloseRequestFcn',@my_closereq);%最佳值[304,50,760,620]，测试值[566,371,369,151]
% WindowState - 窗口状态
% 'normal' （默认） | 'minimized' | 'maximized' | 'fullscreen'
% SelectionType - 鼠标选择类型
% 'normal' （默认） | 'extend' | 'alt' | 'open'


%% 自定义菜单栏
%首先创建菜单,其'Callback'赋值为'disp('New MenuItem is clicked')'，等全部创建完毕后再考虑回调函数的问题
%第1列菜单(但是，自定义菜单和原有菜单可以共存哦！)

%-------------------------------------------第1列菜单--------------------------------------------------%

% HandleVisibility - 对象句柄的可见性
% 'on' （默认） | 'callback' | 'off'
hmenu1 = uimenu(hfig,'Label','文件(F)','Tag','File','HandleVisibility','off');

%Tag的用途：use findobj function to search for the uimenu based on the Tag value
%@(o,e)New_Callback(o,e) 

%快捷键 'Accelerator','N'表示Ctrl + N
% hmenu1_1 = uimenu(hmenu1,'Label','新建','Accelerator','N', 'HandleVisibility','off', ...
%     'Callback',@(hObject,eventdata,handles)New_Callback(hObject,eventdata,gcf));
hmenu1_1 = uimenu(hmenu1,'Label','新建', 'HandleVisibility','off', ...
    'Callback',@(hObject,eventdata,handles)New_Callback(hObject,eventdata,gcf));
hmenu1_2 = uimenu(hmenu1,'Label','打开Mat', 'HandleVisibility','off', ...
    'Callback',{@Open1_Callback,gcf});
hmenu1_3 = uimenu(hmenu1,'Label','打开Gt', 'HandleVisibility','off', ...
    'Callback',{@Open2_Callback,gcf});
hmenu1_4 = uimenu(hmenu1,'Label','关闭', 'HandleVisibility','off', ...
    'Callback',{@Close_Callback,gcf});
hmenu1_5 = uimenu(hmenu1,'Label','保存',  'HandleVisibility','off', ...
    'Callback',{@Save_Callback,gcf},'Separator','on');
hmenu1_6 = uimenu(hmenu1,'Label','另存为',   'HandleVisibility','off', ...
    'Callback',{@SaveAs_Callback,gcf});
hmenu1_7 = uimenu(hmenu1,'Label','生成报告','Separator','on','Visible','on','Enable','on',... 
           'HandleVisibility','off','Callback',{@Report_Callback,gcf});
hmenu1_8 = uimenu(hmenu1,'Label','导出数据','Visible','on','Enable','on', ...
    'HandleVisibility','off', 'Callback',{@ExportAsMat_Callback,gcf});
hmenu1_9 = uimenu(hmenu1,'Label','保留项','Callback',{@New_Callback,gcf},... 
            'Visible','off','Enable','off','HandleVisibility','off');       
hfig.MenuBar = 'None';%暂时关闭原有菜单

%---------------------------------------第2列菜单
hmenu2 = uimenu(hfig,'Label','编辑(E)','Tag','Edit','HandleVisibility','on');
hmenu2_1 = uimenu(hmenu2,'Label','撤销', 'HandleVisibility','off', ...
    'Callback',{@Undo_Callback,gcf});
hmenu2_2 = uimenu(hmenu2,'Label','重做', 'HandleVisibility','off', ...
    'Callback',{@Redo_Callback,gcf});
hmenu2_3 = uimenu(hmenu2,'Label','重新合成', 'Separator','on', ...
    'HandleVisibility','on', 'Callback',{@Synth_Callback,gcf});
hmenu2_4 = uimenu(hmenu2,'Label','重新着色', 'Separator','off', ...
    'HandleVisibility','on', 'Callback',{@Recolor_Callback,gcf});
hmenu2_5 = uimenu(hmenu2,'Label','复制','Callback','disp(''exit'')',  ...
    'HandleVisibility','off', 'Callback',{@Copy_Callback,gcf});
hmenu2_6 = uimenu(hmenu2,'Label','清除剪切板','HandleVisibility','off', ...
    'Callback',{@ClearClipboard_Callback,gcf});
hmenu2_7 = uimenu(hmenu2,'Label','删除','HandleVisibility','off', ...
    'Callback',{@Delete_Callback,gcf}, ... 
            'Visible','on','Enable','on');
hmenu2_8 = uimenu(hmenu2,'Label','保留项','Visible','off','Enable','off', ...
      'HandleVisibility','off', 'Callback',{@New_Callback,gcf});
%---------------------------------------第3列菜单
hmenu3 = uimenu(hfig,'Label','查看(V)','Tag','View', 'HandleVisibility','on');        %(o,e)FitWindow_Callback(o,e)
hmenu3_1 = uimenu(hmenu3,'Label','适应窗口', 'HandleVisibility','on', ...
    'Callback',{@FitWindow_Callback, gcf});
hmenu3_2 = uimenu(hmenu3,'Label','原始大小', 'HandleVisibility','on', ...
    'Callback',{@OriginSize_Callback,gcf});
hmenu3_3 = uimenu(hmenu3,'Label','单独绘图(自适应)', 'HandleVisibility','on', ...
    'Enable','on','Callback',{@SeparatePlot1_Callback,gcf});
hmenu3_4 = uimenu(hmenu3,'Label','单独绘图(原始大小)', 'HandleVisibility','on', ...
    'Enable','on','Callback',{@SeparatePlot2_Callback,gcf});
hmenu3_5 = uimenu(hmenu3,'Label','保留项', 'Visible','off', ...
    'Enable','off', 'HandleVisibility','off', 'Callback',{@New_Callback,gcf});

%---------------------------------------第4列菜单------------回调680行
hmenu4 = uimenu(hfig,'Label','分析(A)','Tag','Analysis');
hmenu4_1 = uimenu(hmenu4,'Label','加载数据', 'HandleVisibility','on', ...
    'Callback',{@FeedData_Callback,gcf});
hmenu4_2 = uimenu(hmenu4,'Label','光谱分析', 'HandleVisibility','on', ...
    'Callback',{@SpectrumPlot_Callback,gcf},'Enable','off');
hmenu4_3 = uimenu(hmenu4,'Label','执行降维', 'HandleVisibility','on', 'Separator','on',...
    'Callback',{@ReduceDim_Callback,gcf},... 
            'Visible','on','Enable','off');
hmenu4_4 = uimenu(hmenu4,'Label','执行分类',  'Visible','on', ...
    'Enable','off','HandleVisibility','on');%, 'Callback',{@Classify_Callback,gcf});  %第888行
	hmenu4_4_1 = uimenu(hmenu4_4,'Label','智能分类', 'Visible','on', ...
    'Enable','off','HandleVisibility','on', 'Callback',{@Classify_Callback1,gcf});
	hmenu4_4_2 = uimenu(hmenu4_4,'Label','ClassDemo', 'Visible','on', ...
    'Enable','off','HandleVisibility','on', 'Callback',{@Classify_Callback2,gcf});
	hmenu4_4_3 = uimenu(hmenu4_4,'Label','Classification Learner', 'Visible','on', ...
    'Enable','off','HandleVisibility','on', 'Callback',{@Classify_Callback3,gcf});
	hmenu4_4_4 = uimenu(hmenu4_4,'Label','nprtool', 'Visible','on', ...
    'Enable','off','HandleVisibility','on', 'Callback',{@Classify_Callback4,gcf});
	hmenu4_4_5 = uimenu(hmenu4_4,'Label','保留项', 'Visible','off', ...
    'Enable','off','HandleVisibility','off', 'Callback',{@Classify_Callback3,gcf});
	hmenu4_4_6 = uimenu(hmenu4_4,'Label','保留项', 'Visible','off', ...
    'Enable','off','HandleVisibility','off', 'Callback',{@Classify_Callback4,gcf});
hmenu4_5 = uimenu(hmenu4,'Label','重新选择算法', 'Visible','on','Enable','off', ...
    'HandleVisibility','on','Callback',{@ReChoose_Callback,gcf});
hmenu4_6 = uimenu(hmenu4,'Label','Frobenius分析', 'Visible','on','Enable','off',...
    'Separator','on','HandleVisibility','on','Callback',{@Frobenius_Callback,gcf});
% 以下项可以设置为目标检测相关的菜单项，回调函数在855行
hmenu4_7 = uimenu(hmenu4,'Label','目标检测1', 'Visible','on','Enable','off', ...
    'Separator','on','HandleVisibility','on','Callback',{@Detect1_Callback,gcf});
hmenu4_8 = uimenu(hmenu4,'Label','目标检测2', 'Visible','on','Enable','off', ...
    'HandleVisibility','on','Callback',{@Detect2_Callback,gcf});
hmenu4_9 = uimenu(hmenu4,'Label','目标检测3', 'Visible','on','Enable','off', ...
    'HandleVisibility','on','Callback',{@Detect3_Callback,gcf});
hmenu4_10 = uimenu(hmenu4,'Label','目标检测4', 'Visible','on','Enable','off', ...
    'HandleVisibility','on','Callback',{@Detect4_Callback,gcf});
hmenu4_11 = uimenu(hmenu4,'Label','保留项', 'Visible','off','Enable','off', ...
    'HandleVisibility','off','Callback',{@New_Callback,gcf});

%---------------------------------------第5列菜单
hmenu5 = uimenu(hfig,'Label','窗口(W)','Tag','Window','HandleVisibility','off');
hmenu5_1 = uimenu(hmenu5,'Label','样式1',  'HandleVisibility','off', ...
    'Callback',{@feedData,gcf});
hmenu5_2 = uimenu(hmenu5,'Label','样式2',  'HandleVisibility','off', ...
    'Callback',{@New_Callback,gcf});
hmenu5_3 = uimenu(hmenu5,'Label','保留项',  'Visible','off','Enable','off', ...
    'HandleVisibility','off','Callback',{@New_Callback,gcf});
hmenu5_4 = uimenu(hmenu5,'Label','保留项', 'Visible','off','Enable','off', ...
    'HandleVisibility','off','Callback',{@New_Callback,gcf});
%---------------------------------------第6列菜单
hmenu6 = uimenu(hfig,'Label','帮助(H)','Tag','Help','HandleVisibility','off');
hmenu6_1 = uimenu(hmenu6,'Label','使用说明',  'HandleVisibility','off', ...
    'Callback',{@New_Callback,gcf});
hmenu6_2 = uimenu(hmenu6,'Label','关于软件',  'HandleVisibility','off', ...
    'Callback',{@New_Callback,gcf});
hmenu6_3 = uimenu(hmenu6,'Label','保留项',  'Visible','off','Enable','off', ...
    'HandleVisibility','off','Callback',{@New_Callback,gcf});
hmenu6_4 = uimenu(hmenu6,'Label','保留项', 'Visible','off','Enable','off', ...
    'HandleVisibility','off', 'Callback',{@New_Callback,gcf});



% movegui(gcf,'center')
vbox = uix.VBox('Parent',hfig,'Spacing',2,'Tag','vbox', 'HandleVisibility','on');
%% 第1行
hbox1 = uix.HBox('Parent',vbox,'Tag','hbox1');
pushbutton1 = uicontrol('Parent',hbox1,'Style','pushbutton','Tag','pushbutton1', ...
                                    'String','打开路径：','FontName','Microsoft YaHei','FontSize',8.0, ...
                                    'Callback',{@pushbutton1_Callback, gcf});
Text1 = uicontrol('Parent',hbox1,'Style','edit','Tag','Text1','HorizontalAlignment','Left');
hbox1.Widths = [70,-1];
%% 第2行
hbox = uix.HBoxFlex('Parent', vbox, 'Spacing',3,'Tag','hbox');
% hfig1 = figure('Parent',hbox,'Name','当前文件夹','Tag','currentFolder',...
%                     'NumberTitle','off','DockControls','on',...
%                     'MenuBar','none','ToolBar','none');
panel = uix.BoxPanel('Parent', hbox,'Title', '当前文件夹','FontSize',8.0, ...
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

% char(9650) ▲
% char(9658) or char(hex2dec('25BA')) : 实心右三角
% char(9660) ▼
% char(9668) or char(hex2dec('25C4'))：实心左三角
% char(9651) △
% char(9661) ▽
% char(9698) ◢ or char(hex2dec('25E2'))
% 在word中点击【插入】【符号】字体[普通文本]or[拉丁文本]，查到某个字符的字符代码，
% 比如▲的字符代码为'25B2'，则在Matlab中是：char(hex2dec('25B2'))

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

%-----------------------------------回调函数---------------------------------------------------%
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

%----------------------------------------回调函数----------------------------------------------------%
% --- Executes on button press in pushbutton1.
%-------【选择路径】
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = [uigetdir(handles.UserData.customPath)];
if path % 如果点击对话框的[取消]或者关闭对话框，则path==0。此时不做任何处理动作
    handles.UserData.currentPath = path; %考虑使用selectedPath变量
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
% val=get(hObject,'value');     %点击【MA毕业论文】28
% % string=get(hObject,'string');% 74×1 cell
% % hbox = findobj(handles.Children,'Type','HBoxFlex');
% hbox = findobj(handles.Children,'Tag','hbox');
% if ~isempty(findobj(hbox,'Tag','imscrollpanel'))
%     delete(findobj(hbox,'Tag','imscrollpanel'));%更新目录
%     axes1 = axes('Parent',hbox);
% else
%     axes1 = findobj(hbox,'Tag','axes1');
% end
% boxpanel = findobj(handles.Children,'Tag','boxpanel');
% listbox1 = findobj(boxpanel,'Tag','listbox1');
h = reNewContent(hObject,handles);  

%显示选中文件的地址
text = findobj(handles,'Style','edit');
text.String = hObject.UserData.currentPath;
% B = repmat(string{val},varargin);%输入 varargin=[160, 1];
% b = space(ones(1,n));%输入 n = 5;

% 点击listbox中的某项，则其展开子项目（如果有的话），再次点击则收起
% 子项目的名称前面带有缩进s
% 以上两项我的还有问题
end

function updatatree(selectedPath,handles)
global customPath mFilePath bkcGT colorBase

%显示选中文件的地址
text = findobj(handles,'Style','edit');
text.String = selectedPath;

a=dir(selectedPath); % 76×1 struct
% a(1) =   
% 包含以下字段的 struct:
%        name: '$360Section'
%      folder: 'D:\'
%        date: '30-八月-2019 01:08:48'
%       bytes: 0
%       isdir: 1
%     datenum: 7.3767e+05
%  
% a(2) =  
%   包含以下字段的 struct:
%        name: '$RECYCLE.BIN'
%      folder: 'D:\'
%        date: '23-五月-2012 18:09:43'
%       bytes: 0
%       isdir: 1
%     datenum: 7.3501e+05

%[a.isdir]' 76×1 logical 数组

contentname={a.name}';
n = numel(contentname);%排除以$开头的文件，再排除.和..
%先统计以$开头的文件名数量
count = 0;
k = 1;
while strcmp(contentname{k}(1),'$')
    count = count + 1;
    k = k+1;
end   
contentname=contentname(count+3:end);
isFolder=[a.isdir]';
isFolder=isFolder(count+3:end);
%74×1 cell
% global_isFolder=isFolder;
% global_contentname=contentname;

CN=length(isFolder);
level=ones(CN,1);
% global_path=repmat(customPath,CN,1);
[string]=changeToContent(isFolder,contentname,level);
% 输入参数：global_isFolder
% global_isFolder(9:12)
% ans =
%      1
%      0
%      1
%      1
% global_contentname(9:12)
%     '360极速浏览器下载'
%     '360浏览器缓存目录.txt'
%     '360驱动大师目录'
%     '795'

% 输出结果
% string 74×1 cell
% string(9:12)
%     '>>360极速浏览器下载'
%     '360浏览器缓存目录.txt'
%     '>>360驱动大师目录'
%     '>>795'
% boxpanel = findobj(handles.Children,'Tag','boxpanel');
listbox1 = findobj(handles.Children,'Tag','listbox1');
listbox1.ListboxTop = 1;%若重新选择了目录，则需要将ListboxTop重置为1
listbox1.Value = 1;       % 若重新选择了目录，则需要将Value重置为1
listbox1.String = string;

%存储数据string和level到listbox1
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
data.cmap = [data.bkcGT;colorBase]; %添加背景像素的颜色，此处定义背景像素的颜色为黑色
data.imgMat = []; %存储Mat伪彩色图像
data.imgGT = [];   %存储GT图像标志
data.imgStack = [];%存储Mat和GT的堆叠图像
data.img = []; %存储普通2维图像
data.himage = [];
listbox1.UserData = data;

% 初始化handles.UserData
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
data.imgNew = []; %保存分类算法预测的GT图像
data.img = listbox1.UserData.img; %存储普通2维图像
data.M = listbox1.UserData.M;
data.himage = listbox1.UserData.himage;

%以下是实现可视化功能以外的其他功能可能所需要的变量
data.x2=[];%
data.lbs=[];

handles.UserData = data;

end


% --------------------------------------第1列菜单---------------------------初始化在31行--------------
% 【新建】
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

% 详解各输入参数的含义：

%     hObject
                        %   hObject = 
                        %   Menu (新建) (具有属性):
                        % 
                        %           Label: '新建'
                        %     Accelerator: 'N'
                        %        Callback: [function_handle]
                        %       Separator: 'off'
                        %         Checked: 'off'
                        
%     eventdata     %matlab.ui.eventdata.ActionData
                        %  eventdata =  
                        %   ActionData (具有属性): 
                        %        Source: [1×1 Menu]
                        %     EventName: 'Action'
%     handles
                        %   handles = 
                        % 
                        %   Figure (mainFigure) (具有属性):
                        % 
                        %       Number: 1
                        %         Name: '高光谱分析系统'
                        %        Color: [0.9400 0.9400 0.9400]
                        %     Position: [403 246 560 420]
                        %        Units: 'pixels'
    %% 使用每个控件自身的UserData属性来存储其被第几次点击？
%     fig = openfig('test1.fig');
% %     fig = f.copy(); %控件没有任何反应
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
%【打开Mat】
% function Open1_Callback(hObject, eventdata, handles)
% 已经写成单独函数
% end

%【打开Gt】
% function Open2_Callback(hObject, eventdata, handles)
% 已经写成单独函数
% end


% --------------------------------------------------------------------
function Close_Callback(hObject, eventdata, handles)

    selection = questdlg('退出当前窗口?',...
    'Confirmation',...
    '是','否','否');
    switch selection
        case '是'
            delete(handles);
            clear,close all
            clc           
        case '否'
            return
    end
end

% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% 发现一个问题，ColorBar的父级对象只能是容器类的figure,panel,
% 而不是axes。例如，此时ColorBar.Parent是imscrollpanel。
% 所以直接用imsave保存的话，只能保存axes区域内的内容，不能保存
% axes以外的内容，所以保存的图像上ColorBar都是丢失的
% 解决方法1：getframe
% 解决方法2：print
% 解决方法3：重新创建一个figure重新画一次再保存

% f=getframe(gcf);%取得当前figure的快照
% figure;
% imshow(f.cdata);%在另一个figure中显示取得的快照
% 
% 保存可以用imwrite函数，将f.cdata保存到指定文件即可。

% f = getframe(findobj(handles,'Tag','imscrollpanel'));
% % 错误使用 getframe (line 48)
% % 必须指定有效的图形句柄或轴句柄
%     figure
%     imshow(f.cdata);
%     imsave(f.cdata);
% 结论：解决方法1失败
% print('SurfacePlot','-djpeg','-noui')
% 结论：解决方法2失败，虽然保存了ColorBar，但是只是图像的
% 一部分，未保存屏幕外的部分。
%

% figure(1)不可用！因为handles==figure(1)
% 既有imscrollpanel又有gt图像，才做特殊处理，否则直接保存
if ~isempty(findobj(handles,'Tag','imscrollpanel'))&&~isempty(findobj(handles,'Type','image'))...
        && handles.UserData.dim == 2
    
    img = handles.UserData.img;
    cmap = handles.UserData.cmap;
    M = handles.UserData.M;
    hfig2 = figure(2);
    imshow(img,cmap,'InitialMagnification','fit');
    c = colorbar;
    c.Label.String = '地物类别对应颜色';
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
% 生成当前窗口所显示的图像的各种信息，txt格式，并自动打开
%
%
%
%
%
end

function ExportAsMat_Callback(hObject, eventdata, handles)
% 将绘制当前窗口所显示的图像所需的各种信息(合成通道编号ind和colormap+NumInClass)，
% 保存到一个struct中，将该struct与原始数据保存到同一个*.mat
% 并生成一个报告，txt格式，并自动打开
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



% --------------------------------------第2列菜单--------------------------------------------------

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
% 只有当界面当中有图的时候才会执行。
%1 用户点击【编辑】【重新合成】，则显示对话框，让用户输入3个通道编号
    if ~isempty(findobj(handles,'Type','image'))&&~isempty(handles.UserData.imgMat)...
            &&~isempty(handles.UserData.matdata) && size(handles.UserData.matdata,3) >3
        
        %当前窗口中有图像且相应的按钮中的UserData.imgMat不为空，则说明当前窗口中显示的图像是Mat图像。
        
        x2 = handles.UserData.matdata; 
        prompt = ['Enter the space-separated channel numbers of blue, green and red. '...
            'Input range: Min : 1, Max : ',num2str(size(x2,3)), '. Default index are:',num2str(handles.UserData.ind),'. Current index are:',num2str(hObject.UserData.ind)];
        dlg_title = 'Customerize channel numbers';
        an = inputdlg(prompt,dlg_title,1);%resize属性设置为on
        try
            ind = str2num(an{:}); 
            img = synthesize_image(x2,ind);
            
        % 如果是有ScrollBar的，删除重绘制
            [hbox, himage] = newPlot(img,handles);
            %设置标志值
            hmenu3_1 = findobj(handles,'Label','适应窗口');
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
    hObject.UserData.ind = ind;        %保存用户设置的通道编号
    handles.UserData.imgMat = hObject.UserData.imgMat;
    
end


function Recolor_Callback(hObject, eventdata, handles)
    
    if ~isempty(handles.UserData.gtdata)
        x = handles.UserData.gtdata;
        % 改变colormap
        temp = handles.UserData.cmap;
        cmap = temp;
        cmap(2:end-1, :) = temp(3:end, :);
        cmap(end, :) = temp(2, :);
        c = colormap(cmap);
        handles.UserData.cmap = c;
%             hObject.UserData.cmap = handles.UserData.cmap;
        [hbox, himage] = newPlotGT(double(x), handles);
        %恢复cmap到原来的值。%但是，为了实现颜色能滚动，就不能恢复
%         handles.UserData.cmap = temp;

        %设置标志值
        hmenu3_1 = findobj(handles,'Label','适应窗口');
        hmenu3_1.UserData.imgGT=1;
    else
        ms = 'Open a *_gt.mat file first!';
        errordlg(ms);
    end
    %设置colormap   
end

function Delete_Callback(hObject, eventdata, handles)
    % 有ScrollBar，就删除handles.UserData.scrollpanelH
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
% 将当前图窗中的图像复制到剪切板
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

% --------------------------------------第3列菜单--------------------------------------------------

function FitWindow_Callback(hObject, eventdata, handles)
    % 【查看】【适应窗口】
    %只有当前图窗口既带有ScrollBar又显示有图片，我们才执行。否则啥也不干。
    if ~isempty(findobj(handles,'Tag','imscrollpanel'))&&~isempty(findobj(handles,'Type','image'))
        %必须知道当前窗口显示的是什么内容！
        himage = findobj(handles,'Type','image');  %这里的img就是himage，其属性CData可以使用
        hObject.UserData.imgGT=0;
        if ndims(himage.CData) == 2 &&  ~isempty(findobj(handles,'Type','colorbar'))
            %在这里还是无法知道当前窗口中显示的是GT图还是某个灰度图。
            %探查当前窗口中是否存在colorbar
%             colorb = findobj(findobj(handles,'Type','colorbar'));
%             strcmp(colorb.Label,'地物类别对应颜色');            

            img = handles.UserData.gtdata;
            cmap = handles.UserData.cmap;
            M = handles.UserData.M;
            hfig2 = figure();
%             figure(hfig2);
            set(hfig2,'Visible', 'off'); %调试的时候可以设置为'on'
            axes1 = axes('Parent',hfig2,'Visible', 'on');           
%             imshow(img,'Parent',axes1,'InitialMagnification','fit');
            
            %
            himage2 = imshow(img,cmap,'InitialMagnification','fit');
            c = colorbar;
            c.Label.String = '地物类别对应颜色';
            c.Label.FontWeight = 'bold'; 

            c.Ticks = 0.5:1:M+0.5;       %刻度线位置
            c.TicksMode = 'Manual';
            c.TickLabels = num2str([-1:M-1]'); %刻度线值
            c.Limits = [1,M+1];
% 为什么要采取截屏的方式？因为在其他方式下颜色条colorBar无法正常显示，
% 尤其是拉动测边框的条件下
            f=getframe(hfig2);
            close(hfig2);        
            himage.CData = f.cdata;
            hObject.UserData.imgGT=1; 
            %hObject就是hmenu3_1，置为1表示处理的是一张GT图，
            %用于指导【原始大小】进行原图显示
        end
            
            %普通的2维图片，例如灰度图
            [hbox, himage] = newPlotFit(himage.CData, handles);
    end
end


% --------------------------------------------------------------------
function OriginSize_Callback(hObject, eventdata, handles)
    %【查看】【原始大小】
    % 显示方式从''适应窗口''状态转换为'原始大小'
    % 只有图像而没有ScrollBar，这种情况下才执行。否则不执行
    if isempty(findobj(handles,'Tag','imscrollpanel'))&&~isempty(findobj(handles,'Type','image'))
        himage = findobj(handles,'Type','image');
%         hmenu3_1 = findobj(handles,'Label','适应窗口');
        hmenu3_1 = hObject.Parent.Children(4);%也是[适应窗口]
        if ~hmenu3_1.UserData.imgGT     %查询【适应窗口】操作的对象是普通图还是GT图
            
%             显示普通图片
            [hbox, himage] = newPlot(himage.CData, handles);
            
        else %显示GT图片
%             ndims(img) == 2 && ~isempty(findobj(handles,'Type','colorbar'))
            x = handles.UserData.gtdata;
            [hbox, himage] = newPlotGT(double(x), handles);
        end
    end
end

%【查看】【单独绘图(自适应)】单独脚本函数
% function SeparatePlot1_Callback(hObject, handles)
% end
%【查看】【单独绘图(原始大小)】单独脚本函数
% function SeparatePlot2_Callback(hObject, handles)
% end
% --------------------------------------第4列菜单------------------------初始化在83行--------------------
function FeedData_Callback(hObject, eventdata, handles)
% 出现一个对话框，让用户选择*.mat，*_gt.mat，分类算法等
        feedData(hObject,handles);
%         [x3,x2,lbs2,lbs] = dataProcess2(handles);
%         hObject.UserData.x3 = x3;  
%         hObject.UserData.x2 = x2;
%         hObject.UserData.lbs2 = lbs2;
%         hObject.UserData.lbs = lbs;
%         %直接保存数据到hObject，则后续处理步骤不用再load

        % hmenu4_1 = findobj(handles,'Label','加载数据');
        
        hmenu4_2 = findobj(handles,'Label','光谱分析');
        hmenu4_2.Enable = 'on';
        
        hmenu4_3 = findobj(handles,'Label','执行降维');
        hmenu4_3.Enable = 'on';
        % 将前一次在【执行降维】各个子项下保存的数据清除掉。
        hmenu4_3.UserData.drData = []; % hmenu4_3
        
        hmenu4_4 = findobj(handles,'Label','执行分类');
        hmenu4_4.Enable = 'on';
        hmenu4_4_1 = findobj(handles,'Label','智能分类');
        hmenu4_4_1.Enable = 'on';
        % 将前一次在【智能分类】各个子项下保存的数据清除掉。
        
        hmenu4_4_2 = findobj(handles,'Label','ClassDemo');
        hmenu4_4_2.Enable = 'on';
        % 将前一次在【ClassDemo】各个子项下保存的数据清除掉。
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
        
        
        hmenu4_5 = findobj(handles,'Label','重新选择算法');
        hmenu4_5.Enable = 'on';
        hmenu4_6 = findobj(handles,'Label','Frobenius分析');
        % 将前一次在【Frobenius分析】各个子项下保存的数据清除掉。
        hObject.UserData.F2=[];
        hObject.UserData.channelSelected = [];
        hObject.UserData.x2Selected = [];
        hmenu4_6.Enable = 'on';
        
        
        
        hmenu4_7 = findobj(handles,'Label','目标检测1');
        hmenu4_7.Enable = 'on';  
        hmenu4_8 = findobj(handles,'Label','目标检测2');
        hmenu4_8.Enable = 'on';
        hmenu4_9 = findobj(handles,'Label','目标检测3');
        hmenu4_9.Enable = 'on';  
        hmenu4_10 = findobj(handles,'Label','目标检测4');
        hmenu4_10.Enable = 'on';
end

function SpectrumPlot_Callback(hObject, eventdata, handles)
% 绘制出各个类别的光谱反射率曲线
    timerVal_1 = tic;
    disp('光谱分析启动.....................................................');
    %handles.UserData
    hmenu4_1 = findobj(handles,'Label','加载数据');
   
    spectralReflectivity(hmenu4_1);%handles仅用于传递cmap
    
    time1 = toc(timerVal_1);
    disp(['光谱分析完成！历时',num2str(time1),'秒.']);
end

function ReduceDim_Callback(hObject, eventdata, handles)
global x3 lbs2 x2 lbs mappedA
% 调用数据降维工具包来实现
% D:\MA毕业论文\Matlab-Toolbox-for-Dimensionality-Reduction-master
% 降维方法非常丰富，那么要为【分析】单独创建一个页面吗？

hmenu4_1 = findobj(handles,'Label','加载数据');
x2 = hmenu4_1.UserData.x2;
lbs = hmenu4_1.UserData.lbs; 

A = x2;
% 所选择的算法名称及序号
type = hmenu4_1.UserData.drAlgorithm;
val = hmenu4_1.UserData.drValue;
% type = 'PCA';

% For the supervised techniques ('LDA', 'GDA', 'NCA','MCML', and 'LMNN'),  
% the labels of the instances should be specified in the first column of A (using numeric labels).
%  
if ismember(type, {'LDA', 'GDA', 'NCA', 'MCML', 'LMNN'})
    A = [lbs,x2];
end
% 根据序号分配默认参数
% paraTable_dr = importfile1(workbookFile, sheetName, dataLines)
%  示例:
%  Untitled = importfile1("D:\MA毕业论文\ATrain_Record\20191002\降维参数统计.xlsx", "Sheet1", [2, 35]);

dataLines = [val+1, val+1];%第val个算法对应于excel的第val+1行
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
% no_dims = 10;在外部Excel中设置(默认值从这里读取)
hmenu4_1.UserData.drDims = para{2};
    timerVal_1 = tic;
    disp('---------------执行降维---------------');
    disp(paraTable_dr);
%     disp([type, para,'执行降维..........']);
    
    try
%     [mappedA, mapping] = compute_mapping(A, type, para{2}, para(3:end));
%     以这种Name-Value参数输入方式的是不行的，因为在查看tsne.m文件时，发现其参数要求是：仅限值输入
% ydata = tsne(X, labels, no_dims, initial_dims, perplexity)
% 错误示例
% [mappedA, mapping] = compute_mapping(A, type, para{2}, 'perplexity',[10], 'initial_dims',[30], 'eig_impl', "JDQR")
% 正确示例
% [mappedA, mapping] = compute_mapping(A, type, para{2}, 10, 30, "JDQR");

        [mappedA, mapping] = compute_mapping(A, type, para{2}, t{2:end});
    catch
        [mappedA, mapping] = compute_mapping(A, type, para{2});
    end

% % 使用Matlab的pca()函数进行降维
% [coeff,score,latent,~,explained,mu] = pca(x2);
% mappedA = score(:, 1: para{2});


% 使用matlab里面的pca算法做对比    


% end
% mappedA = compute_mapping(A, type, t(1));
% mappedA = compute_mapping(A, type, no_dims);
% mappedA = compute_mapping(A, type, no_dims, ...);
% mappedA = compute_mapping(A, type, no_dims, parameters);
% mappedA = compute_mapping(A, type, no_dims, parameters, eig_impl);
time1 = toc(timerVal_1);
disp(['降维完成！历时',num2str(time1),'秒.']);
hmenu4_1.UserData.drElapsedTime = time1;
%% 绘制降维后的结果
ldaPlot(mappedA,lbs,handles); %普通散点图的方式显示降维后的效果
% ldaPlot1(mappedA,lbs,handles); %去除背景点（因为背景点覆盖住了其他点）
%% 保存降维后的结果
% mapping;
% mapping = 
% 
%   包含以下字段的 struct:
% 
%       mean: [1×146 double]
%          M: [146×10 double]
%     lambda: [10×1 double]
%       name: 'PCA'
hObject.UserData.drData = mappedA; % hmenu4_3
% hObject.UserData.drAlgorithm = mapping.name; % hmenu4_1

    %使能【分析】>>【执行分类】>>【ClassDemo】命令选项
    hmenu4_4_2 = findobj(handles,'Label','ClassDemo');
    hmenu4_4_2.Enable = 'on';    
end


function ReChoose_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 显示feedData的界面，但是数据选择区域是锁定的，edit1和edit2中显示之前已经选择好的数据地址
% 从handles获取
% '降维算法'框显示之前已经选择的算法，从handles下的hmenu4_1获取
% '分类算法'框显示之前已经选择的算法，从handles下的hmenu4_1获取
% 用户只能重新选择'降维算法'或'分类算法'
% 或者两者都重新选择
% 所以feedData的启动界面已经加一个'显示上一次选择情况'的功能
% 如果feedData界面是第一次启动，则所有的框都显示的是'空'
% 如果feedData界面是第N次启动，则所有的框都显示上一次所选择的结果
% 所以需要对feedData进行改进

feedData(hObject,handles);

% 将前一次在【执行降维】各个子项下保存的数据清除掉。
hmenu4_3 = findobj(handles,'Label','执行降维');
hmenu4_3.UserData.drData = []; % hmenu4_3

% 将前一次在【ClassDemo】各个子项下保存的数据清除掉。
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

% 计算出每个光谱通道上的F范数，并绘制出F范数平方的曲线
% 从而根据F范数大小来选择通道，通常舍弃F范数小的通道。
    hObject.UserData.thresholdDefault = 0.1;
    hObject.UserData.thresholdCustom = 0;
%1 用户点击【分析】【Frobenius分析】，则显示对话框，让用户输入阈值threshold，范围为[0,1]
    prompt = ['1. Normalized threshold, the range is [0,1], the default value is ',...
        num2str(hObject.UserData.thresholdDefault),'.   2. Absolute threshold, the range is [0, N]',...
        'N is Maximun of Frobenius Analysis and usually unknown before analysis. This is just use when'...
        'you have known the finally analysis result'];
    % 1.相对值阈值，最常用；2.绝对值的阈值，只用于验证别人已知的结论
    dlg_title = 'Enter the threshold';
    an = inputdlg(prompt, dlg_title, 1);%resize属性设置为on
    try
        hObject.UserData.thresholdCustom = str2double(an{:}); 
    catch
        hObject.UserData.thresholdCustom = hObject.UserData.thresholdDefault;
    end

    timerVal_1 = tic;
    disp('F范数分析启动.....................................................');
    hObject.UserData;
    hmenu4_1 = findobj(handles,'Label','加载数据');
    x2 = hmenu4_1.UserData.x2;
    
%     F = sqrt(sum(x2.^2)); % F范数
    F2 = sum(x2.^2);           % 计算每个通道上的(即x2的每一列的)F范数的平方
%     F2 = norm(x2,'fro');       % F范数
%    F2 = norm(x2,'fro')^2;   % F范数的平方
    hObject.UserData.F2 = F2;
    
    figure
    plot(F2,'LineWidth',1.5);
    xlabel('Channels');
    ylabel('Square of Frobenius');
    
    % 设置并显示阈值线
    hold on
    if isnan(hObject.UserData.thresholdCustom)  % NaN的情形。无输入直接点确定
        threshold = hObject.UserData.thresholdDefault*max(F2);
    elseif hObject.UserData.thresholdCustom<=1 
        threshold = hObject.UserData.thresholdCustom*max(F2);  %相对阈值的情       
    else                                       %绝对阈值的情形
        threshold = hObject.UserData.thresholdCustom; %PaviaU绝对阈值为2.0e11
    end
        
    n = numel(F2);
    plot([1, n],[threshold, threshold],'--','LineWidth',1.5);
    text(0,threshold*1.025,[num2str(threshold)]);
    legend(hmenu4_1.UserData.matName,'Threshold','Interpreter','none','Location','best');  % 数据以及数据的信息都保存在【载入数据】的UserData中
    hold off
%     F2_new = F2(F2>=threshold);        % 保留F范数平方大于等于threshold的部分
%     hObject.UserData.F2_new = F2_new;
% 保留的通道编号保存于channelSelected
    hObject.UserData.channelSelected = find(F2>=threshold);
    % 按照较优通道从x2中选择出来的数据x2Selected。
    hObject.UserData.x2Selected = x2(:, hObject.UserData.channelSelected);
    hObject.UserData
    threshold
    time1 = toc(timerVal_1);
    disp(['F范数分析完成！历时',num2str(time1),'秒.']);
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

% --------------------------------------第5列菜单--------------------------------------------------
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

% --------------------------------------第6列菜单--------------------------------------------------
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

%-------------------------------------Controller部分-----------------------------------------
