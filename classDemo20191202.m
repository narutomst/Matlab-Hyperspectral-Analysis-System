function acc = classDemo(tableTrain, tableTest, type, varargin)

varargin = varargin{1}; %将cell转换为string数组
p = inputParser;

% p.addRequired();
% p.addRequired( 'tableTrain',@(x) validateattributes(x, {'table'}, {'2d', 'ncols','>=',2, ...
%     'nrows','>=',2}, 'classDemo', 'tableTrain',1));
% 上述写法有语法错误，错误位置在'ncols','>=',2中的'>='，'>='不能紧跟在'ncols'后面，
% 即不能用来判断'ncols'的范围，而只能用来判断x中元素的范围
% 所以，语法上正确的写法是
% p.addRequired( 'tableTrain',@(x) validateattributes(x, {'table'}, {'2d', 'ncols',11, ...
%     'nrows',20000}, 'classDemo', 'tableTrain',1));
% 但是我想让inputParser能判断输入参数的行和列是否大于规定的值，该怎么写？
validationFcn = @(x) (ndims(x) == 2) && isa(x,'table') && (size(x,1)>=2) && (size(x,2)>=2); % 不报错
p.addRequired( 'tableTrain', validationFcn);

% validationFcn = @(x) validateattributes(x, {'table'}, {'2d'}, 'classDemo', 'tableTest',2);%不报错
% validationFcn = @(x) (size(x,1)>=2) && (size(x,2)>=2); %不报错
validationFcn = @(x) (ndims(x) == 2) && isa(x,'table') && (size(x,1)>=2) && (size(x,2)>=2); % 不报错
p.addRequired( 'tableTest', validationFcn);

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

p.parse(tableTrain, tableTest, type, varargin{:});
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
%          tableTest: [264499×11 table]
%         tableTrain: [113357×11 table]
%           trainFcn: 'trainscg'
%        transferFcn: 'tansig'
%       transferFcn1: 'tansig'
%       transferFcn2: 'tansig'
%       transferFcn3: 'tansig'
%       transferFcn4: 'tansig'
%               type: 'BP'

% 并且该结构体的字段名同时被单独保存一份在p.Parameters中（1×N cell数组）

switch p.Results.type
    case 'BP'
        % 调用函数
        % 现有参数为两个table外加一个struct
        f_BP(tableTrain, tableTest,)
        acc = [];
    case 'RBF'
    case 'GA-BP'
    case 'GA-RBF'
    case 'PSO-BP'
    case 'PSO-RBF'
    otherwise
end
end

% function acc = f1()
% 
% end