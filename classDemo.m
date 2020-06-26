function [racc, best_perf, best_vperf, best_tperf, tTest] = classDemo(XTrain, TTrain, XTest, TTest,  type, varargin)
global hmenu4_1

timerVal_1 = tic;
varargin = varargin{1}; %将cell转换为string数组
p = inputParser;

% p.addRequired();
% p.addRequired( 'XTrain',@(x) validateattributes(x, {'numeric'}, {'2d', 'ncols','>=',2, ...
%     'nrows','>=',2}, 'classDemo', 'XTrain',1));
% 上述写法有语法错误，错误位置在'ncols','>=',2中的'>='，'>='不能紧跟在'ncols'后面，
% 即不能用来判断'ncols'的范围，而只能用来判断x中元素的范围
% 所以，语法上正确的写法是
% p.addRequired( 'XTrain',@(x) validateattributes(x, {'numeric'}, {'2d', 'ncols',11, ...
%     'nrows',20000}, 'classDemo', 'XTrain',1));
% 但是我想让inputParser能判断输入参数的行和列是否大于规定的值，该怎么写？
validationFcn = @(x) (ndims(x) == 2) && isa(x,'numeric') && (size(x,1)>=2) && (size(x,2)>=2); % 不报错
p.addRequired( 'XTrain', validationFcn);
p.addRequired( 'TTrain', validationFcn);
p.addRequired( 'XTest', validationFcn);
p.addRequired( 'TTest', validationFcn);

validStrings = {'BP','RBF','GA-BP','GA-RBF','PSO-BP','PSO-RBF'};
% validStrings = ["BP","RBF","GA-BP","GA-RBF","PSO-BP","PSO-RBF"];
% 报错：'type' 的值无效。数据类型无效。第一个参数必须为数值或逻辑值。
validationFcn = @(x) any(validatestring(x, validStrings, 'classDemo','type',3)); 

% validationFcn = @(x) validatestring(x,validStrings);
% 报错：'type' 的值无效。它必须满足函数: @(x)validatestring(x,validStrings,'classDemo','type',3)。
% p.addRequired('type', @(x) any(validatestring(x, validStrings)));  %该语句也是语法正确的
p.addRequired('type', validationFcn);  

% p.addRequired( 'type',@(x) any(validatestring(x,{'BP','RBF','GA-BP','GA-RBF','PSO-BP',...
%     'PSO-RBF'}, 'classDemo', 'type',3)));

% p.addOptional();
% p.addParameter();
defaultTrainFcn = 'trainscg';
p.addParameter( 'trainFcn',defaultTrainFcn, @(x) any(validatestring(x,{'trainscg','trainrp','traingdx'})));
defaultHiddenLayerNum = 1;
p.addParameter( 'hiddenLayerNum',defaultHiddenLayerNum,@(x) validateattributes(str2num(x),{'numeric'},...
                                     {'integer','positive','>=',1,'<=',5}));
defaultHiddenNum = 10;
p.addParameter( 'hiddenNum',defaultHiddenNum,@(x) validateattributes(str2num(x),{'numeric'},...
                                     {'integer','positive','>=',10,'<=',100}));

defaultHiddenNum1 = 10;
p.addParameter( 'hiddenNum1',defaultHiddenNum1,@(x) validateattributes(str2num(x),{'numeric'},{'integer','positive'}));
defaultHiddenNum2 = 10;
p.addParameter( 'hiddenNum2',defaultHiddenNum2,@(x) validateattributes(str2num(x),{'numeric'},{'integer','positive'}));
defaultHiddenNum3 = 10;
p.addParameter( 'hiddenNum3',defaultHiddenNum3,@(x) validateattributes(str2num(x),{'numeric'},{'integer','positive'}));
defaultHiddenNum4 = 10;
p.addParameter( 'hiddenNum4',defaultHiddenNum4,@(x) validateattributes(str2num(x),{'numeric'},{'integer','positive'}));

p.addParameter('transferFcn',@(x) any(validatestring(x,{'tansig','radbas','purelin'})));
p.addParameter('transferFcn1',@(x) any(validatestring(x,{'tansig','radbas','purelin'})));
p.addParameter('transferFcn2',@(x) any(validatestring(x,{'tansig','radbas','purelin'})));
p.addParameter('transferFcn3',@(x) any(validatestring(x,{'tansig','radbas','purelin'})));
p.addParameter('transferFcn4',@(x) any(validatestring(x,{'tansig','radbas','purelin'})));

p.addParameter('showWindow',@(x) validateattributes(x,{'logical'}));
p.addParameter('plotperform',@(x) validateattributes(x,{'logical'}));
p.addParameter('plottrainstate',@(x) validateattributes(x,{'logical'}));
p.addParameter('ploterrhist',@(x) validateattributes(x,{'logical'}));
p.addParameter('plotconfusion',@(x) validateattributes(x,{'logical'}));
p.addParameter('plotroc',@(x) validateattributes(x,{'logical'}));

p.parse(XTrain, TTrain, XTest, TTest, type, varargin{:});
% %报错：因为varargin是cell类型的，而合法的类型只能是字符串标量或者字符向量
% p.parse(tableTrain, tableTest, type); % 不报错

% 输入参数检查完毕，结果保存为一个结构体，即p.Results，如下所示：

% p.Results 
% ans =  
%   包含以下字段的 struct:
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
%              TTest: [15×264499 double]
%             TTrain: [15×113357 double]
%               type: 'BP'
%              XTest: [10×264499 double]
%             XTrain: [10×113357 double]

% 并且该结构体的字段名同时被单独保存一份在p.Parameters中（1×N cell数组）
% 但是有个小问题，
% isa(p.Results.hiddenNum,'numeric')
% ans = 
%   logical
%    0
% 
% isa(p.Results.hiddenNum,'char')
% ans =
%   logical 
%    1
Var = p.Results;
Var.hiddenLayerNum = str2double(p.Results.hiddenLayerNum);
Var.hiddenNum = str2double(p.Results.hiddenNum);
Var.hiddenNum1 = str2double(p.Results.hiddenNum1);
Var.hiddenNum2 = str2double(p.Results.hiddenNum2);
Var.hiddenNum3 = str2double(p.Results.hiddenNum3);
Var.hiddenNum4 = str2double(p.Results.hiddenNum4);
 
%     time1 = toc(timerVal_1);
%     disp({['数据准备完毕，历时',num2str(time1),'秒.'];...
%     [hmenu4_1.UserData.matPath,' 开始执行分类']});
%     
switch p.Results.type
    case 'BP'
        % 调用函数
        % 现有参数为4个array外加一个struct
        [racc, best_perf, best_vperf, best_tperf, tTest] = f_BP(XTrain, TTrain, XTest, TTest, Var);
        %racc 误分率，错误率
        %best_perf 训练集最佳性能（蓝色曲线）
        %best_vperf 验证集最佳性能（绿色曲线）
        %best_tperf 测试集最佳性能（红色曲线）
        %tTest 为预测的类别标签列向量
        
    case 'RBF'
        [racc, best_perf, best_vperf, best_tperf, tTest] = f_RBF(XTrain, TTrain, XTest, TTest, Var);        
    case 'GA-BP'
        [racc, best_perf, best_vperf, best_tperf, tTest] = f_GA_BP(XTrain, TTrain, XTest, TTest, Var);
    case 'GA-RBF'
        [racc, best_perf, best_vperf, best_tperf, tTest] = f_GA_RBF(XTrain, TTrain, XTest, TTest, Var);
    case 'PSO-BP'
        [racc, best_perf, best_vperf, best_tperf, tTest] = f_PSO_BP(XTrain, TTrain, XTest, TTest, Var);
    case 'PSO-RBF'
        [racc, best_perf, best_vperf, best_tperf, tTest] = f_PSO_RBF(XTrain, TTrain, XTest, TTest, Var);
    otherwise
end
% acc = struct();
% acc.racc = racc;
% acc.best_perf = best_perf;
% acc.best_vperf = best_vperf;
% acc.best_tperf = best_tperf;
end

% function acc = f1()
% 
% end