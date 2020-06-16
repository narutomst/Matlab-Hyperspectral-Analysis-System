%% 子程序：function
% 功能：1.解码x并给网络net赋值
%           2. 计算适应度的值val
function [val, net] = fun(x, inputNum, hiddenNum, outputNum, net, p_train, t_train)
	%提取BP神经网络初始权值和阈值，x为个体
	% 对x解码
    sumNet = [inputNum, hiddenNum, outputNum];
    k = numel(sumNet);
    W = cell(1,k-1);  
    B = cell(1,k-1);
    for i = 1:k-1
        ind = sumNet(i)*sumNet(i+1);
        e1str = ['W{',num2str(i),'}=x(1 : ind);']; %写成cell array的形式W{1}要比W1这种形式用起来方便
        eval(e1str);
        x = x(ind+1:end); %抛掉已经截取的部分
        ind = sumNet(i+1);
        e1str = ['B{',num2str(i),'}=x(1 : ind);'];
        eval(e1str); 
        x = x(ind+1:end); %抛掉已经截取的部分        
        net.b{i} = B{i}';
    end
    
   %网络权值赋值
    net.iw{1,1}=reshape(W{1},sumNet(2),sumNet(1));
% net.lw{2,1} = reshape(W{2}, sumNet(3), sumNet(2));
% net.lw{3,2} = reshape(W{3}, sumNet(4), sumNet(3));
    for i = 2:k-1  
        net.lw{i, i-1} = reshape(W{i},sumNet(i+1),sumNet(i));
    end
    
	y=sim(net,p_train);

	% 返回根据net.performcn和net.performram属性值计算的网络性能。 
	%perf = perform(net,t,y); t-训练数据的标签，y-预测输出的结果
	%perf = perform(net, t_train, y);
    perf = crossentropy(net, t_train, y);
	val = 1/perf;
end
