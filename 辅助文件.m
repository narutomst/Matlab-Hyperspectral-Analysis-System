【适应窗口】部分启用hObject(即hmenu3_1)对象，hObject.UserData.imgGT用来记录执行该操作时，窗口中显示的是普通图片(imgGT=0)还是原始大小的GT图片(imgGT=1)
目的是为了指导【原始大小】命令显示原图时，能知道是普通图片还是GT图片

[hbox, himage] = newPlotGT(double(x), handles);

分为当前图窗中有colorbar和无colorbar的情形来考虑各种情况。
既不存在colorbar，imgGT又不等于1，则说明当前窗口中为普通图片。
否则就按GT图片原始大小在新的figure中显示。经过测试，【单独绘制(原始大小)】功能正常。

%设置标志值
hmenu3_1 = findobj(handles,'Label','适应窗口');
hmenu3_1.UserData.imgGT=0;
%显示选中文件的地址
text = findobj(handles,'Style','edit');
text.String = hObject.UserData.currentPath;

racc = [racc,err1];
best_perf = [best_perf, err2]; 
best_vperf = [best_vperf, err3]; 
best_tperf = [best_tperf, err4];




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

p = inputParser;
p.parse(varargin{:});
p.Results

VN = [VN, {'varargin{',num2str(i),'}'}];

racc = hmenu4_4_2.UserData.racc;
best_perf = hmenu4_4_2.UserData.best_perf;
best_vperf = hmenu4_4_2.UserData.best_vperf;
best_tperf = hmenu4_4_2.UserData.best_tperf;
acc = 1-racc;                   %acc准确率；racc 误分率，错误率
acc_perf = 1-best_perf;    %best_perf 训练集最佳性能（蓝色曲线）
acc_vperf = 1-best_vperf; %best_vperf 验证集最佳性能（绿色曲线）
acc_tperf = 1-best_tperf;  %


colorBase = [[1,0,0]; [0,1,0]; [0,0,1]; [1,1,0]; [1,0,1]; [0,1,1]; ...
                        [0.5,0,0]; [0,0.5,0];[0,0,0.5]; [0.25,0.75,0]; [0.85,0.5,0]; [0.5,0.5,0]; ... 
                        [0.5,0,1]; [1,0,0.5]; [0.5,0,0.5]; [0.35,0.65,0.75]; [0,1,0.5]; [0,0.5,0.5]; ...
                        [0.5,0.5,0.5];[0.1,0.1,0.1]];
bkcGT = [0.98 0.98 0.98];
colorMap = [bkcGT;colorBase];   %添加背景像素的颜色
cmap = colormap(colorMap);	



图号
预测结果双图 49
confusion matrix 51
准确率曲线 53

%预测结果双图的处理 					
img = figure(2).Children.Children(5).Children.CData;
figure()
himage = imshow(img,hList.UserData.cmap);
himage = imshow(img‘,hList.UserData.cmap);%将原图横着绘制出来        
M = hfig.UserData.M;
c = colorbar;
c.Label.String = '地物类别对应颜色';
c.Label.FontWeight = 'bold'; 

c.Ticks = 0.5:1:M+0.5;       %刻度线位置
c.TicksMode = 'Manual';
c.TickLabels = num2str([-1:M-1]'); %刻度线值
c.Limits = [1,M+1]; 
  
% 准确率曲线的处理
figure(2).Children(1)  %Legend    (acc_perf1, acc_perf2, acc_vperf1, acc_vperf2, acc_tperf1, acc_tperf2, acc1, ac…)
figure(2).Children(2)  %Axes      (训练性能（acc_perf,acc_vperf,acc_tperf）与泛化性能（acc))
figure(2).Children(2).Children
ans = 
  12×1 graphics 数组:
  Text    (acc2:0.94277)
  Line
  Text    (acc1:0.9403)
  Line
  Line    (acc2)
  Line    (acc1)
  Line    (acc_tperf2)
  Line    (acc_tperf1)
  Line    (acc_vperf2)
  Line    (acc_vperf1)
  Line    (acc_perf2)
  Line    (acc_perf1)
figure(2).Children(2).Children(1).String  % 'acc2:0.94277' 
figure(2).Children(2).Children(1).Position %[1.0500 0.9710 0]

figure(2).Children(2).Children(5).DisplayName % 'acc2'
figure(2).Children(2).Children(5).YData %

% 对于_53.fig的处理从这里开始
%给以acc_开头的变量赋值
f = figure(2);
for i = 5:12
	eval([f.Children(2).Children(i).DisplayName,'=f.Children(2).Children(',num2str(i),').YData;'])
end
figure()
%单独绘制优化前和优化后的准确率
a=0.01
plotErr1([acc_perf1'-a,acc_perf2'], [acc_vperf1'-a,acc_vperf2'], [acc_tperf1'-a,acc_tperf2'], [acc1'-a,acc2'])

%调整文字位置及xlim
f = figure(3);
xlim([1 20]);
f.Children(2).Children(1).Position(2)


% Botswana 横着绘制，并且要将两头裁剪掉
img = figure(2).Children.Children(5).Children.CData;
img = img';
k = find(img-1);
col1 = floor(min(k)/size(img,1));
col2 = ceil(max(k)/size(img,1)); 
himage = imshow(img(:,col1-5:col2+5),hList.UserData.cmap);%将原图横着绘制出来        
M = hfig.UserData.M;
c = colorbar;
c.Label.String = '地物类别对应颜色';
c.Label.FontWeight = 'bold'; 

c.Ticks = 0.5:1:M+0.5;       %刻度线位置
c.TicksMode = 'Manual';
c.TickLabels = num2str([-1:M-1]'); %刻度线值
c.Limits = [1,M+1]; 

清缓存
hfig.UserData.matdata = [];
hfig.UserData.gtdata = [];

