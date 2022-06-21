function T = createTableForWrite(varargin)
 % 为了将分类结果写入Excel表格，就必须将结果改写成table
% 调用形式  T = createTableForWrite(best_perf, best_vperf, best_tperf, racc)
    % 为什么要这么复杂？因为table()函数比较复杂！具体来说就是
    % T=table(best_perf, best_vperf, best_tperf, racc)，Matlab认定这种形式形成的表中变量只有4个
    % 即T.Properties.VariableNames={'Var1'}    {'Var2'}    {'Var3'}    {'Var4'}
    % 无论best_perf有几列，这些列只有一个变量名，即{'Var1'}，显然这不是我们想要的！
    % 我们想实现给每一列变量都起一个名字，那怎么办？
    % 那就要用程序来自动命名，即让4个变量变成4n个变量，这里以4n==8为例说明
    % 即变量名 best_perf, best_vperf, best_tperf, racc变成
    % {'best_perf1'}    {'best_perf2'}    {'best_vperf1'}    {'best_vperf2'}    {'best_tperf1'}   {'best_tperf2'}    {'racc1'}    {'racc2'}
    % 变量调用部分由  best_perf, best_vperf, best_tperf, racc，变成
    % {'best_perf(:,1),'} {'best_perf(:,2),'} {'best_vperf(:,1),'} {'best_vperf(:,2),'} {'best_tperf(:,1),'} {'best_tperf(:,2),'} {'racc(:,1),'} {'racc(:,2),'}
    
    %varargin
    inputname(1);  %char
    inputname(nargin);
    [nn, mm] = size(varargin{1});
    VN = {};
    vn = {};
    for i = 1 : nargin
        VN = [VN, inputname(i)];
        vn = [vn, ['varargin{',num2str(i),'}']];
    end
    
    VN1 = {};
    Temp = cell(size(VN));
    vn1 = {};
    temp = cell(size(VN));
    if mm>=2
        for i = 1:mm
            for j = 1:nargin
                Temp{j} =[VN{j} , num2str(i)];
                temp{j}=[vn{j},'(:,',num2str(i),'),'];
            end
            VN1 = [VN1; Temp];
            vn1 = [vn1; temp];
        end
        VN1 = reshape(VN1,1,[]);
        vn1 = reshape(vn1,1,[]);
    end
    %VN2=[{''},VN1];

    kk = numel(vn1);
    vnString = [];
    for i = 1:kk
        vnString = [vnString, vn1{i}];
    end
    %vnString
    vnString = ['T = table(' vnString(1:end-1) ');'];
    %T = table(varargin{1},varargin{2},varargin{3},varargin{4});%这样语法正确，但是只有4个变量
    %T = table(varargin{1}(:,1), varargin{1}(:,2), varargin{2}(:,1), varargin{2}(:,2), varargin{3}(:,1), varargin{3}(:,2), varargin{4}(:, 1), varargin{4}(:, 2));
    % 这个也是语法正确的
    eval(vnString);
    T.Properties.RowNames = string(1:nn);
    T.Properties.VariableNames = VN1;
end