function T = createTableForWrite(varargin)
 % Ϊ�˽�������д��Excel��񣬾ͱ��뽫�����д��table
% ������ʽ  T = createTableForWrite(best_perf, best_vperf, best_tperf, racc)
    % ΪʲôҪ��ô���ӣ���Ϊtable()�����Ƚϸ��ӣ�������˵����
    % T=table(best_perf, best_vperf, best_tperf, racc)��Matlab�϶�������ʽ�γɵı��б���ֻ��4��
    % ��T.Properties.VariableNames={'Var1'}    {'Var2'}    {'Var3'}    {'Var4'}
    % ����best_perf�м��У���Щ��ֻ��һ������������{'Var1'}����Ȼ�ⲻ��������Ҫ�ģ�
    % ������ʵ�ָ�ÿһ�б�������һ�����֣�����ô�죿
    % �Ǿ�Ҫ�ó������Զ�����������4���������4n��������������4n==8Ϊ��˵��
    % �������� best_perf, best_vperf, best_tperf, racc���
    % {'best_perf1'}    {'best_perf2'}    {'best_vperf1'}    {'best_vperf2'}    {'best_tperf1'}   {'best_tperf2'}    {'racc1'}    {'racc2'}
    % �������ò�����  best_perf, best_vperf, best_tperf, racc�����
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
    %T = table(varargin{1},varargin{2},varargin{3},varargin{4});%�����﷨��ȷ������ֻ��4������
    %T = table(varargin{1}(:,1), varargin{1}(:,2), varargin{2}(:,1), varargin{2}(:,2), varargin{3}(:,1), varargin{3}(:,2), varargin{4}(:, 1), varargin{4}(:, 2));
    % ���Ҳ���﷨��ȷ��
    eval(vnString);
    T.Properties.RowNames = string(1:nn);
    T.Properties.VariableNames = VN1;
end