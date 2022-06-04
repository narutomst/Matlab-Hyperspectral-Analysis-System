function plotErr(varargin) % 绘制性能曲线>>>误差率
err_perf = varargin{1};    % trainRecord.best_perf
err_vperf = varargin{2};  % trainRecord.best_vperf
err_tperf = varargin{3};  % trainRecord.best_tperf
racc = varargin{4};          % racc是1-acc，是误分率
% 实际上这些值来自于
% err_perf = cellfun(@(x) x.best_perf, trainRecord);
% err_vperf = cellfun(@(x) x.best_vperf, trainRecord);
% err_tperf = cellfun(@(x) x.best_tperf, trainRecord);
% 这些值都是一些很小的正值，如0.0054，0.0117，0.0137，是在网络训练过程中获得的误差数据，
% 因此这些变量以err开头更合适

[n, m] = size(err_perf);

if nargin==4 
    %即按照plotErr(err_perf, err_vperf, err_tperf, racc)这种方式调用。
    %每一列数据绘制一张图，例如优化前后的性能数据各放在err_perf的一列，
    %则本函数会将优化前和优化后的数据各绘制一张图。    
    for i = 1:m  
        figure()
        plot((1:n)',[err_perf(:, i), err_vperf(:, i), err_tperf(:, i), racc(:, i)],'LineWidth',1.5);
            %racc 误分率，错误率
            %err_perf 即trainRecord.best_perf，训练集最佳性能（蓝色曲线）
            %err_vperf 即trainRecord.best_vperf，验证集最佳性能（绿色曲线）
            %err_tperf 即trainRecord.best_tperf，测试集最佳性能（红色曲线）
            %tTest 为预测的类别标签列向量        
        title('训练性能（err_perf,err_vperf,err_tperf）与泛化性能（racc)','Interpreter','none');
        xlabel('次数');
        ylabel('错误率');

        hold on
        %mean()函数按列求平均，所以将行形式转换成列形式
        plot([1, n],[mean(racc(:, i)), mean(racc(:, i))],'--','LineWidth',1.5);

        text(1.05,mean(racc(:, i))*1.030,['racc', num2str(i), ':', num2str(mean(racc(:, i)))]);
        legend({['err_perf', num2str(i)],['err_vperf', num2str(i)],['err_tperf', num2str(i)],['racc', num2str(i)]},...
            'Interpreter','none','Location','best');  
        hold off
    end
elseif nargin==5
    %即按照plotErr(err_perf, err_vperf, err_tperf, racc, K)这种方式调用。
    %每一列数据绘制一条曲线，例如优化前后的性能数据各放在err_perf的一列，
    %则本函数会将优化前和优化后的数据绘制在同一张图上。
    K = varargin{5};
    %% 只绘制泛化性能racc
    if K==1       
        %figure()
        plot((1:n)',racc,'LineWidth',1.5);
            %racc 误分率，错误率
            %err_perf 即trainRecord.best_perf，训练集最佳性能（蓝色曲线）
            %err_vperf 即trainRecord.best_vperf，验证集最佳性能（绿色曲线）
            %err_tperf 即trainRecord.best_tperf，测试集最佳性能（红色曲线）
            %tTest 为预测的类别标签列向量        
        title('泛化性能（racc)','Interpreter','none');
        xlabel('次数');
        ylabel('错误率');
        
        hold on
        %mean()函数按列求平均，所以将行形式转换成列形式
        plot([1, n],[mean(racc(:,1)), mean(racc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(racc(:,1))*1.030,['racc1:',num2str(mean(racc(:,1)))]);
        try %若racc有两列，即优化前后的数据各占一列，则下面的语句会继续处理第2列数据
            plot([1, n],[mean(racc(:,2)), mean(racc(:,2))],'--','LineWidth',1.5);
            text(1.05,mean(racc(:,2))*1.030,['racc2:',num2str(mean(racc(:,2)))]);
            legend('racc1','racc2','Interpreter','none','Location','best');  
            %1表示优化前的数据，2表示优化后的数据
        catch%若racc仅含有一列数据，则按照一列的情形设置图例
            legend('racc','Interpreter','none','Location','best');  
        end 
        hold off 
    %% 仅绘制训练集性能err_perf（即trainRecord.best_perf） 和泛化性能 racc   
    elseif K==2
        %figure()
        plot((1:n)',[err_perf, racc],'LineWidth',1.5);
            %racc 误分率，错误率
            %err_perf 即trainRecord.best_perf，训练集最佳性能（蓝色曲线）
            %err_vperf 即trainRecord.best_vperf，验证集最佳性能（绿色曲线）
            %err_tperf 即trainRecord.best_tperf，测试集最佳性能（红色曲线）
            %tTest 为预测的类别标签列向量        
        title('训练性能（err_perf）与泛化性能（racc)','Interpreter','none');
        xlabel('次数');
        ylabel('错误率');
        
        hold on
        %mean()函数按列求平均，所以将行形式转换成列形式
        plot([1, n],[mean(racc(:,1)), mean(racc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(racc(:,1))*1.030,['racc1:',num2str(mean(racc(:,1)))]);
        try %若racc有两列，即优化前后的数据各占一列，则下面的语句会继续处理第2列数据
            plot([1, n],[mean(racc(:,2)), mean(racc(:,2))],'--','LineWidth',1.5);
            text(1.05,mean(racc(:,2))*1.030,['racc2:',num2str(mean(racc(:,2)))]);
            legend('err_perf1','err_perf2','racc1','racc2','Interpreter','none','Location','best');  
            %1表示优化前的数据，2表示优化后的数据
        catch%若racc仅含有一列数据，则按照一列的情形设置图例
            legend('err_perf','racc','Interpreter','none','Location','best');  
        end 
        hold off 
    %% 绘制训练性能 err_perf（即trainRecord.best_perf） 测试性能 err_tperf（即trainRecord.best_tperf） 和泛化性能 racc    
    elseif K==3
        %figure()
        plot((1:n)',[err_perf, err_tperf, racc],'LineWidth',1.5);
            %racc 误分率，错误率
            %err_perf 即trainRecord.best_perf，训练集最佳性能（蓝色曲线）
            %err_vperf 即trainRecord.best_vperf，验证集最佳性能（绿色曲线）
            %err_tperf 即trainRecord.best_tperf，测试集最佳性能（红色曲线）
            %tTest 为预测的类别标签列向量        
        title('训练性能（err_perf, err_tperf）与泛化性能（racc)','Interpreter','none');
        xlabel('次数');
        ylabel('错误率');
        
        hold on
        %mean()函数按列求平均，所以将行形式转换成列形式
        plot([1, n],[mean(racc(:,1)), mean(racc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(racc(:,1))*1.030,['racc1:',num2str(mean(racc(:,1)))]);
        try %若racc有两列，即优化前后的数据各占一列，则下面的语句会继续处理第2列数据
            plot([1, n],[mean(racc(:,2)), mean(racc(:,2))],'--','LineWidth',1.5);
            text(1.05,mean(racc(:,2))*1.030,['racc2:',num2str(mean(racc(:,2)))]);
            legend('err_perf1','err_perf2', 'err_tperf1','err_tperf2','racc1','racc2','Interpreter','none','Location','best');  
            %1表示优化前的数据，2表示优化后的数据
        catch%若racc仅含有一列数据，则按照一列的情形设置图例
            legend('err_perf','err_tperf','racc','Interpreter','none','Location','best');  
        end 
        hold off
   %% 绘制训练性能 err_perf（即trainRecord.best_perf） 验证性能 err_vperf（即trainRecord.best_vperf） 测试性能 err_tperf（即trainRecord.best_tperf） 和泛化性能 racc     
    elseif K==4
        %figure()
        plot((1:n)',[err_perf, err_vperf, err_tperf, racc],'LineWidth',1.5);
            %racc 误分率，错误率
            %err_perf 即trainRecord.best_perf，训练集最佳性能（蓝色曲线）
            %err_vperf 即trainRecord.best_vperf，验证集最佳性能（绿色曲线）
            %err_tperf 即trainRecord.best_tperf，测试集最佳性能（红色曲线）
            %tTest 为预测的类别标签列向量        
        title('训练性能（err_perf,err_vperf,err_tperf）与泛化性能（racc)','Interpreter','none');
        xlabel('次数');
        ylabel('错误率');
        
        hold on
        %mean()函数按列求平均，所以将行形式转换成列形式
        plot([1, n],[mean(racc(:,1)), mean(racc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(racc(:,1))*1.030,['racc1:',num2str(mean(racc(:,1)))]);
        try %若racc有两列，即优化前后的数据各占一列，则下面的语句会继续处理第2列数据
            plot([1, n],[mean(racc(:,2)), mean(racc(:,2))],'--','LineWidth',1.5);
            text(1.05,mean(racc(:,2))*1.030,['racc2:',num2str(mean(racc(:,2)))]);
            legend('err_perf1','err_perf2','err_vperf1','err_vperf2','err_tperf1','err_tperf2','racc1','racc2','Interpreter','none','Location','best');  
            %1表示优化前的数据，2表示优化后的数据
        catch%若racc仅含有一列数据，则按照一列的情形设置图例
            legend('err_perf','err_vperf','err_tperf','racc','Interpreter','none','Location','best');  
        end 
        hold off
        %显示最终分类结果：racc表示分类的错误率，1-racc表示分类准确率。
    end
end