%% 子程序：function
function [val, net] = fun(x, inputNum, hiddenNum, outputNum, net, p_train, t_train)
	%提取BP神经网络初始权值和阈值，x为个体
	% 对x解码
    sumNet = [inputNum, hiddenNum, outputNum];
    k = numel(sumNet);

    for i = 1:k-1
        ind = sumNet(i)*sumNet(i+1);
        e1str = ['W',num2str(i),'=x(1 : ind);'];
        eval(e1str);
        x = x(ind+1:end); %抛掉已经截取的部分
        ind = sumNet(i+1);
        e1str = ['B',num2str(i),'=x(1 : ind);'];
        eval(e1str); 
        x = x(ind+1:end); %抛掉已经截取的部分,原版少了这一句        
        e1str = ['net.b{',num2str(i),'} = reshape(B',num2str(i),',sumNet(',num2str(i+1),'),1);'];
        eval(e1str);

    end
    
   %网络权值赋值
    net.iw{1,1}=reshape(W1,sumNet(2),sumNet(1));
    sumNet = sumNet(2:end);
    k = numel(sumNet);
    for i = 1:k-1  
        e1str = ['net.lw{',num2str(i+1),',',num2str(i),'} = reshape(W',num2str(i+1),',sumNet(',num2str(i+1),'),sumNet(',num2str(i),'));'];	
        eval(e1str);
    end
    
	y=sim(net,p_train);

	% 返回根据net.performcn和net.performram属性值计算的网络性能。 
	%perf = perform(net,t,y); t-训练数据的标签，y-预测输出的结果
	%perf = perform(net, t_train, y);
    perf = crossentropy(net, t_train, y);
	val = 1/perf;
end
