% clear,close%绘制光谱反射率的曲线，即取同一像素点的所有通道绘制成一条曲线
% clc

function spectralReflectivity(hmenu4_1)  %即'加载数据'
    timerVal_1 = tic;
    disp('光谱分析启动.....................................................');
try
    cmap = hmenu4_1.UserData.cmap;
catch
        cmap = handles.UserData.cmap;   
end

    N = hmenu4_1.UserData.M-1;
    x2 = hmenu4_1.UserData.x2;
    lbs = hmenu4_1.UserData.lbs;
    chs = size(x2,2);
    
%% 每一种光谱绘制一张figure    
    for i = 1 : N 
        row = find(lbs==i);
        %这里为什么非要用find？因为需要统计个数
        % 如果不用统计个数的话就不用find，直接用逻辑值索引
        if numel(row)>50
            row = row(1:50);
        end
        figure
        plot(1:chs, x2(row,:), 'color', cmap(i+1,:));
        xlabel('Channels');
        ylabel('Reflective coeff');
        xlim([1,chs]);
    %     saveas(gcf,['Class_',num2str(i),'.png']);
    end


%% 以subplot子图的形式将所有光谱绘制在一张figure上
    M = ceil(sqrt(N));
    if N == M^2
        d = [M,M];
    elseif N>(M-1)*M
        d = [M-1,M+1];
    else
        d = [M-1,M];
    end
    figure
    for i = 1:N 
        row = find(lbs==i);
        if numel(row)>50
            row = row(1:50);
        end
        ax = subplot(d(1),d(2),i);
        plot(ax, 1:chs, x2(row,:), 'color', cmap(i+1,:));
%         xlabel('Channels');
%         ylabel('Reflective coeff');
        xlim([1,chs]); 
    end
%     saveas(gcf,['Class_1~',num2str(N),'.bmp']);
    time1 = toc(timerVal_1);
    disp(['光谱分析完成！历时',num2str(time1),'秒.']);
end