function plotAcc(varargin) % 绘制性能曲线>>>准确率
acc_perf = varargin{1};     % 即1-err_perf，其中err_perf = trainRecord.best_perf，
acc_vperf = varargin{2};  % 即1-err_vperf，其中err_vperf = trainRecord.best_vperf，而
acc_tperf = varargin{3};  % 即1-err_tperf，其中err_tperf = trainRecord.best_tperf，而
                                    % 而best_perf、best_vperf、best_tperf都是一些很小的值，比如0.0054，0.0117，0.0137，
                                    % 是在网络训练过程中获得的误差数据，
acc = varargin{4};
[n, m] = size(acc_perf);

if nargin==4 
    %即按照plotAcc(acc_perf, acc_vperf, acc_tperf, acc)这种方式调用。
    %每一列数据绘制一张图，例如优化前后的性能数据各放在acc_perf的一列，
    %则本函数会将优化前和优化后的数据各绘制一张图。    
    for i = 1:m  
        figure()
        plot((1:n)',[acc_perf(:, i), acc_vperf(:, i), acc_tperf(:, i), acc(:, i)],'LineWidth',1.5);
            %acc 准确率
            %acc_perf 训练集最佳性能（蓝色曲线）
            %acc_vperf 验证集最佳性能（绿色曲线）
            %acc_tperf 测试集最佳性能（红色曲线）
            %tTest 为预测的类别标签列向量        
        title('训练性能（acc_perf,acc_vperf,acc_tperf）与泛化性能（acc)','Interpreter','none');
        xlabel('次数');
        ylabel('准确率');

        hold on
        %mean()函数按列求平均，所以将行形式转换成列形式
        plot([1, n],[mean(acc(:, i)), mean(acc(:, i))],'--','LineWidth',1.5);
%         y = mean(acc(:,1))+sign(mean(acc(:,2))-mean(acc(:,1)))*0.033*(i-1);
%         text(1.05,y,['acc', num2str(i), ':', num2str(mean(acc(:, i)))]);
        text(1.05, mean(acc(:,i))*1.031, ['acc', num2str(i), ':', num2str(mean(acc(:, i)))]);
        legend({['acc_perf', num2str(i)],['acc_vperf', num2str(i)],['acc_tperf', num2str(i)],['acc', num2str(i)]},...
            'Interpreter','none','Location','best');  
        hold off
    end
elseif nargin==5
    %即按照plotAcc(acc_perf, acc_vperf, acc_tperf, acc, K)这种方式调用。
    %每一列数据绘制一条曲线，例如优化前后的性能数据各放在acc_perf的一列，
    %则本函数会将优化前和优化后的数据绘制在同一张图上。
    K = varargin{5};
    %% 只绘制泛化性能acc
    if K==1       
        %figure()
        plot((1:n)',acc,'LineWidth',1.5);
            %acc 准确率
            %acc_perf 训练集最佳性能（蓝色曲线）
            %acc_vperf 验证集最佳性能（绿色曲线）
            %acc_tperf 测试集最佳性能（红色曲线）
            %tTest 为预测的类别标签列向量        
        title('泛化性能（acc)','Interpreter','none');
        xlabel('次数');
        ylabel('准确率');
        
        hold on
        %mean()函数按列求平均，所以将行形式转换成列形式
        plot([1, n],[mean(acc(:,1)), mean(acc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(acc(:,1))*1.030,['acc1:',num2str(mean(acc(:,1)))]);
        try %若acc有两列，即优化前后的数据各占一列，则下面的语句会继续处理第2列数据
            plot([1, n],[mean(acc(:,2)), mean(acc(:,2))],'--','LineWidth',1.5);
            y2 = mean(acc(:,1))+sign(mean(acc(:,2))-mean(acc(:,1)))*0.033;
            text(1.05,y2,['acc2:',num2str(mean(acc(:,2)))]);
            legend('acc1','acc2','Interpreter','none','Location','best');  
            %1表示优化前的数据，2表示优化后的数据
        catch%若acc仅含有一列数据，则按照一列的情形设置图例
            legend('acc','Interpreter','none','Location','best');  
        end 
        hold off 
    %% 仅绘制训练集性能acc_perf 和泛化性能 acc   
    elseif K==2
        %figure()
        plot((1:n)',[acc_perf, acc],'LineWidth',1.5);
            %acc 准确率
            %acc_perf 训练集最佳性能（蓝色曲线）
            %acc_vperf 验证集最佳性能（绿色曲线）
            %acc_tperf 测试集最佳性能（红色曲线）
            %tTest 为预测的类别标签列向量        
        title('训练性能（acc_perf）与泛化性能（acc)','Interpreter','none');
        xlabel('次数');
        ylabel('准确率');
        
        hold on
        %mean()函数按列求平均，所以将行形式转换成列形式
        plot([1, n],[mean(acc(:,1)), mean(acc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(acc(:,1))*1.030,['acc1:',num2str(mean(acc(:,1)))]);
        try %若acc有两列，即优化前后的数据各占一列，则下面的语句会继续处理第2列数据
            plot([1, n],[mean(acc(:,2)), mean(acc(:,2))],'--','LineWidth',1.5);
            y2 = mean(acc(:,1))+sign(mean(acc(:,2))-mean(acc(:,1)))*0.033;
            text(1.05,y2,['acc2:',num2str(mean(acc(:,2)))]);
            legend('acc_perf1','acc_perf2','acc1','acc2','Interpreter','none','Location','best');  
            %1表示优化前的数据，2表示优化后的数据
        catch%若acc仅含有一列数据，则按照一列的情形设置图例
            legend('acc_perf','acc','Interpreter','none','Location','best');  
        end 
        hold off 
    %% 绘制训练性能 acc_perf 测试性能 acc_tperf 和泛化性能 acc    
    elseif K==3
        %figure()
        plot((1:n)',[acc_perf, acc_tperf, acc],'LineWidth',1.5);
            %acc 准确率
            %acc_perf 训练集最佳性能（蓝色曲线）
            %acc_vperf 验证集最佳性能（绿色曲线）
            %acc_tperf 测试集最佳性能（红色曲线）
            %tTest 为预测的类别标签列向量        
        title('训练性能（acc_perf, acc_tperf）与泛化性能（acc)','Interpreter','none');
        xlabel('次数');
        ylabel('准确率');
        
        hold on
        %mean()函数按列求平均，所以将行形式转换成列形式
        plot([1, n],[mean(acc(:,1)), mean(acc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(acc(:,1))*1.030,['acc1:',num2str(mean(acc(:,1)))]);
        try %若acc有两列，即优化前后的数据各占一列，则下面的语句会继续处理第2列数据
            plot([1, n],[mean(acc(:,2)), mean(acc(:,2))],'--','LineWidth',1.5);
            y2 = mean(acc(:,1))+sign(mean(acc(:,2))-mean(acc(:,1)))*0.033;
            text(1.05,y2,['acc2:',num2str(mean(acc(:,2)))]);
            legend('acc_perf1','acc_perf2', 'acc_tperf1','acc_tperf2','acc1','acc2','Interpreter','none','Location','best');  
            %1表示优化前的数据，2表示优化后的数据
        catch%若acc仅含有一列数据，则按照一列的情形设置图例
            legend('acc_perf','acc_tperf','acc','Interpreter','none','Location','best');  
        end 
        hold off
   %% 绘制训练性能 acc_perf 验证性能 acc_vperf 测试性能 acc_tperf 和泛化性能 acc     
    elseif K==4
        %figure()
        plot((1:n)',[acc_perf, acc_vperf, acc_tperf, acc],'LineWidth',1.5);
            %acc 准确率
            %acc_perf 训练集最佳性能（蓝色曲线）
            %acc_vperf 验证集最佳性能（绿色曲线）
            %acc_tperf 测试集最佳性能（红色曲线）
            %tTest 为预测的类别标签列向量        
        title('训练性能（acc_perf,acc_vperf,acc_tperf）与泛化性能（acc)','Interpreter','none');
        xlabel('次数');
        ylabel('准确率');
        
        hold on
        %mean()函数按列求平均，所以将行形式转换成列形式
        plot([1, n],[mean(acc(:,1)), mean(acc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(acc(:,1))*1.030,['acc1:',num2str(mean(acc(:,1)))]);
        try %若acc有两列，即优化前后的数据各占一列，则下面的语句会继续处理第2列数据
            plot([1, n],[mean(acc(:,2)), mean(acc(:,2))],'--','LineWidth',1.5);
            y2 = mean(acc(:,1))+sign(mean(acc(:,2))-mean(acc(:,1)))*0.033;
            text(1.05,y2,['acc2:',num2str(mean(acc(:,2)))]);
            legend('acc_perf1','acc_perf2','acc_vperf1','acc_vperf2','acc_tperf1','acc_tperf2','acc1','acc2','Interpreter','none','Location','best');  
            %1表示优化前的数据，2表示优化后的数据
        catch%若acc仅含有一列数据，则按照一列的情形设置图例
            legend('acc_perf','acc_vperf','acc_tperf','acc','Interpreter','none','Location','best');  
        end 
        hold off
        %显示最终分类结果：acc表示分类的错误率，1-acc表示分类准确率。
    end
end