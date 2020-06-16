function [W,B,val] = gadecod(x)
global Var sumNet sumTransferFcn 
%Var是一个struct，保存有Excel中的所有设置信息，当然也包括了网络结构信息
%sumNet是一个array，保存着网络的各层神经元数量
%sumTransferFcn是一个字符串cell array，保存了网络各层的传递函数


%% II. 声明全局变量
global p     % 训练集输入数据
global t     % 训练集输出数据
global inputNum     % 输入神经元个数
global outputNum    % 输出神经元个数
global S1    % 隐层1神经元个数(至少有1个隐层)
global S2    % 隐层2神经元个数
global S3    % 隐层3神经元个数
global S4    % 隐层4神经元个数
global S5    % 隐层5神经元个数
% 前inputNum*S1个编码为W1

% 根据Var.hiddenLayerNum的数值来确定有几个隐层
n = Var.hiddenLayerNum;
endIndex1 = [1,sumNet].*[sumNet,1];
endIndex = endIndex1(2:end-1); %[200,400,340]
cutIndex = endIndex+1;              %[201,401,341]
% W1 = x(1:endIndex(1));
% W2 = x(endIndex(1)+1:endIndex(2));
% W3 = x(endIndex(2)+1:endIndex(3));
% x每次给W赋值之后就会被截断

%将x转置为一列
x = x';
    %即 Wk = x(1:endIndex(k));
    W = cell(1,n+1); %W用于返回全部的权重矩阵
for k = 1:n+1
    estr = ['W{',num2str(k),'} = x(1 : endIndex(',num2str(k),'));']; %截取一定长度的数值
    eval(estr);
    %Wk = reshape(Wk,sumNet(k),sumNet(k+1))';                   %将一列数值排列为2维矩阵
    estr = ['W{',num2str(k),'} = transpose(reshape(W{',num2str(k),'}, sumNet(',num2str(k),'), sumNet(',num2str(k+1),')));'];
    eval(estr);
    x = x(cutIndex(k):end);   %截断x
end

endIndex = sumNet(2:end);
cutIndex = endIndex+1;
    B = cell(1,n+1); %B用于返回全部的偏置向量
for k = 1:n+1
    estr = ['B{',num2str(k),'} = x(1 : endIndex(',num2str(k),'));'];
    eval(estr);    
    x = x(cutIndex(k):end);   %截断x
end

%% W1 = x(1:inputNum*S1);
% for i = 1 : S1
%     for k = 1 : inputNum
%         W1(i,k) = x(inputNum*(i-1)+k);
%     end
% end
% 接着的S1*S2个编码(即第inputNum*S1个后的编码)为W2
%% W2 = x(inputNum*S1+1 : inputNum*S1+S1*S2);
% for i = 1 : S2
%     for k = 1 : S1
%         W2(i,k) = x(S1*(i-1)+k+inputNum*S1);
%     end
% end
% 接着的S1个编码(即第inputNum*S1+S1*S2个后的编码)为B1
%% B1 = x(inputNum*S1+S1*S2+1 : inputNum*S1+S1*S2+S1);
% for i = 1 : S1
%     B1(i,1) = x((inputNum*S1+S1*S2)+i);
% end
% 接着的S2个编码(即第inputNum*S1+S1*S2+S1个后的编码)为B2
%% B2 = x(inputNum*S1+S1*S2+S1+1 : inputNum*S1+S1*S2+S1+S2)
% for i = 1 : S2
%     B2(i,1) = x((inputNum*S1+S1*S2+S1)+i);
% end

%% 计算S1与S2层的输出
% A1 = tansig(W1*p+B1);    % A1处于[-1,1]之间
% A2 = purelin(W2*A1+B2); % A2
% 获取网络所有层的传递函数

A = p;
for k = 1:n+1
    estr1 = ['A','=',sumTransferFcn{k},'(W{',num2str(k),'}*A+B{',num2str(k),'});'];
    eval(estr1);
    estr2 = ['C{',num2str(k),'}= A;',];%C用于保存网络每一层的计算结果，
    eval(estr2);                                %即C{1}就是上面的A1，C{2}就是上面的A2，以此类推
end



%% 计算误差平方和
% SE = sumsqr(t-A2);
% SE = sumsqr(t-softmax(A));
A = softmax(A);
% A4 = vec2ind(A3);
% A5 = ind2vec(A4);
cross = -t.*log(A)+(1-t).*log(1-A);
SE = sum(cross(:));
% 遗传算法的适应值
val = 1/SE;
end