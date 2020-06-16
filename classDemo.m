function [racc, best_perf, best_vperf, best_tperf, tTest] = classDemo(XTrain, TTrain, XTest, TTest,  type, varargin)
global hmenu4_1

timerVal_1 = tic;
varargin = varargin{1}; %��cellת��Ϊstring����
p = inputParser;

% p.addRequired();
% p.addRequired( 'XTrain',@(x) validateattributes(x, {'numeric'}, {'2d', 'ncols','>=',2, ...
%     'nrows','>=',2}, 'classDemo', 'XTrain',1));
% ����д�����﷨���󣬴���λ����'ncols','>=',2�е�'>='��'>='���ܽ�����'ncols'���棬
% �����������ж�'ncols'�ķ�Χ����ֻ�������ж�x��Ԫ�صķ�Χ
% ���ԣ��﷨����ȷ��д����
% p.addRequired( 'XTrain',@(x) validateattributes(x, {'numeric'}, {'2d', 'ncols',11, ...
%     'nrows',20000}, 'classDemo', 'XTrain',1));
% ����������inputParser���ж�����������к����Ƿ���ڹ涨��ֵ������ôд��
validationFcn = @(x) (ndims(x) == 2) && isa(x,'numeric') && (size(x,1)>=2) && (size(x,2)>=2); % ������
p.addRequired( 'XTrain', validationFcn);
p.addRequired( 'TTrain', validationFcn);
p.addRequired( 'XTest', validationFcn);
p.addRequired( 'TTest', validationFcn);

validStrings = {'BP','RBF','GA-BP','GA-RBF','PSO-BP','PSO-RBF'};
% validStrings = ["BP","RBF","GA-BP","GA-RBF","PSO-BP","PSO-RBF"];
% ������'type' ��ֵ��Ч������������Ч����һ����������Ϊ��ֵ���߼�ֵ��
validationFcn = @(x) any(validatestring(x, validStrings, 'classDemo','type',3)); 

% validationFcn = @(x) validatestring(x,validStrings);
% ������'type' ��ֵ��Ч�����������㺯��: @(x)validatestring(x,validStrings,'classDemo','type',3)��
% p.addRequired('type', @(x) any(validatestring(x, validStrings)));  %�����Ҳ���﷨��ȷ��
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
% %��������Ϊvarargin��cell���͵ģ����Ϸ�������ֻ�����ַ������������ַ�����
% p.parse(tableTrain, tableTest, type); % ������

% ������������ϣ��������Ϊһ���ṹ�壬��p.Results��������ʾ��

% p.Results 
% ans =  
%   ���������ֶε� struct:
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
%              TTest: [15��264499 double]
%             TTrain: [15��113357 double]
%               type: 'BP'
%              XTest: [10��264499 double]
%             XTrain: [10��113357 double]

% ���Ҹýṹ����ֶ���ͬʱ����������һ����p.Parameters�У�1��N cell���飩
% �����и�С���⣬
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
%     disp({['����׼����ϣ���ʱ',num2str(time1),'��.'];...
%     [hmenu4_1.UserData.matPath,' ��ʼִ�з���']});
%     
switch p.Results.type
    case 'BP'
        % ���ú���
        % ���в���Ϊ4��array���һ��struct
        [racc, best_perf, best_vperf, best_tperf, tTest] = f_BP(XTrain, TTrain, XTest, TTest, Var);
        %tTestΪԤ�������ǩ
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