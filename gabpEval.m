function[sol,val]=gabpEval(sol,options)
% 这个函数费这么大劲，就是为了计算val，第115列的值
% 具体来说，将sol的前S个变量取出来赋值给x，
% 然后将x传递给gadecod()来做编码处理，
% 所谓编码就是从x中依次取出元素把空矩阵W1，W2，B1，B2填满。步骤：
% 将x前S1*R个编码为W1；接着的S2*S1个(即第S1*R个后的)编码为W2；
% 接着的S1个(即第S1*R+S2*S1个后的)编码为B1；
% 接着的S2个(即第S1*R+S2*S1+S1个后的)编码为B2；
%% 计算S1与S2层的输出
% A1 = tansig(W1*p+B1);                     %原句是A1 = tansig(W1*p,B1); 
% 注意：tansig()是双曲正切s型传递函数，不过tansig()只有一个输入参数
% 所以原句的B1完全是没有用到的！
% 
% A2 = purelin(W2*A1+B2);    %原句是A2 = purelin(W2*A1,B2);
%% 计算误差平方和
% SE = sumsqr(t-A2);
%% 遗传算法的适应值
% val = 1/SE;
%[ pop(i,:), pop(i,xZomeLength)] = gabpEval(pop(i,:),[0 evalOps]);

%Var是一个struct，保存有Excel中的所有设置信息，当然也包括了网络结构信息
%sumNet是一个array，保存着网络的各层神经元数量
% for i = 1 : S     % S: 114
%     x(i) = sol(i);
% end;
x = sol(1:end-1);
[W,B,val]=gadecod(x);
end
