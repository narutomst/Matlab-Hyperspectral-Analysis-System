function plotAcc(varargin) % ������������>>>׼ȷ��
acc_perf = varargin{1};     % ��1-err_perf������err_perf = trainRecord.best_perf��
acc_vperf = varargin{2};  % ��1-err_vperf������err_vperf = trainRecord.best_vperf����
acc_tperf = varargin{3};  % ��1-err_tperf������err_tperf = trainRecord.best_tperf����
                                    % ��best_perf��best_vperf��best_tperf����һЩ��С��ֵ������0.0054��0.0117��0.0137��
                                    % ��������ѵ�������л�õ�������ݣ�
acc = varargin{4};
[n, m] = size(acc_perf);

if nargin==4 
    %������plotAcc(acc_perf, acc_vperf, acc_tperf, acc)���ַ�ʽ���á�
    %ÿһ�����ݻ���һ��ͼ�������Ż�ǰ����������ݸ�����acc_perf��һ�У�
    %�򱾺����Ὣ�Ż�ǰ���Ż�������ݸ�����һ��ͼ��    
    for i = 1:m  
        figure()
        plot((1:n)',[acc_perf(:, i), acc_vperf(:, i), acc_tperf(:, i), acc(:, i)],'LineWidth',1.5);
            %acc ׼ȷ��
            %acc_perf ѵ����������ܣ���ɫ���ߣ�
            %acc_vperf ��֤��������ܣ���ɫ���ߣ�
            %acc_tperf ���Լ�������ܣ���ɫ���ߣ�
            %tTest ΪԤ�������ǩ������        
        title('ѵ�����ܣ�acc_perf,acc_vperf,acc_tperf���뷺�����ܣ�acc)','Interpreter','none');
        xlabel('����');
        ylabel('׼ȷ��');

        hold on
        %mean()����������ƽ�������Խ�����ʽת��������ʽ
        plot([1, n],[mean(acc(:, i)), mean(acc(:, i))],'--','LineWidth',1.5);
%         y = mean(acc(:,1))+sign(mean(acc(:,2))-mean(acc(:,1)))*0.033*(i-1);
%         text(1.05,y,['acc', num2str(i), ':', num2str(mean(acc(:, i)))]);
        text(1.05, mean(acc(:,i))*1.031, ['acc', num2str(i), ':', num2str(mean(acc(:, i)))]);
        legend({['acc_perf', num2str(i)],['acc_vperf', num2str(i)],['acc_tperf', num2str(i)],['acc', num2str(i)]},...
            'Interpreter','none','Location','best');  
        hold off
    end
elseif nargin==5
    %������plotAcc(acc_perf, acc_vperf, acc_tperf, acc, K)���ַ�ʽ���á�
    %ÿһ�����ݻ���һ�����ߣ������Ż�ǰ����������ݸ�����acc_perf��һ�У�
    %�򱾺����Ὣ�Ż�ǰ���Ż�������ݻ�����ͬһ��ͼ�ϡ�
    K = varargin{5};
    %% ֻ���Ʒ�������acc
    if K==1       
        %figure()
        plot((1:n)',acc,'LineWidth',1.5);
            %acc ׼ȷ��
            %acc_perf ѵ����������ܣ���ɫ���ߣ�
            %acc_vperf ��֤��������ܣ���ɫ���ߣ�
            %acc_tperf ���Լ�������ܣ���ɫ���ߣ�
            %tTest ΪԤ�������ǩ������        
        title('�������ܣ�acc)','Interpreter','none');
        xlabel('����');
        ylabel('׼ȷ��');
        
        hold on
        %mean()����������ƽ�������Խ�����ʽת��������ʽ
        plot([1, n],[mean(acc(:,1)), mean(acc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(acc(:,1))*1.030,['acc1:',num2str(mean(acc(:,1)))]);
        try %��acc�����У����Ż�ǰ������ݸ�ռһ�У��������������������2������
            plot([1, n],[mean(acc(:,2)), mean(acc(:,2))],'--','LineWidth',1.5);
            y2 = mean(acc(:,1))+sign(mean(acc(:,2))-mean(acc(:,1)))*0.033;
            text(1.05,y2,['acc2:',num2str(mean(acc(:,2)))]);
            legend('acc1','acc2','Interpreter','none','Location','best');  
            %1��ʾ�Ż�ǰ�����ݣ�2��ʾ�Ż��������
        catch%��acc������һ�����ݣ�����һ�е���������ͼ��
            legend('acc','Interpreter','none','Location','best');  
        end 
        hold off 
    %% ������ѵ��������acc_perf �ͷ������� acc   
    elseif K==2
        %figure()
        plot((1:n)',[acc_perf, acc],'LineWidth',1.5);
            %acc ׼ȷ��
            %acc_perf ѵ����������ܣ���ɫ���ߣ�
            %acc_vperf ��֤��������ܣ���ɫ���ߣ�
            %acc_tperf ���Լ�������ܣ���ɫ���ߣ�
            %tTest ΪԤ�������ǩ������        
        title('ѵ�����ܣ�acc_perf���뷺�����ܣ�acc)','Interpreter','none');
        xlabel('����');
        ylabel('׼ȷ��');
        
        hold on
        %mean()����������ƽ�������Խ�����ʽת��������ʽ
        plot([1, n],[mean(acc(:,1)), mean(acc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(acc(:,1))*1.030,['acc1:',num2str(mean(acc(:,1)))]);
        try %��acc�����У����Ż�ǰ������ݸ�ռһ�У��������������������2������
            plot([1, n],[mean(acc(:,2)), mean(acc(:,2))],'--','LineWidth',1.5);
            y2 = mean(acc(:,1))+sign(mean(acc(:,2))-mean(acc(:,1)))*0.033;
            text(1.05,y2,['acc2:',num2str(mean(acc(:,2)))]);
            legend('acc_perf1','acc_perf2','acc1','acc2','Interpreter','none','Location','best');  
            %1��ʾ�Ż�ǰ�����ݣ�2��ʾ�Ż��������
        catch%��acc������һ�����ݣ�����һ�е���������ͼ��
            legend('acc_perf','acc','Interpreter','none','Location','best');  
        end 
        hold off 
    %% ����ѵ������ acc_perf �������� acc_tperf �ͷ������� acc    
    elseif K==3
        %figure()
        plot((1:n)',[acc_perf, acc_tperf, acc],'LineWidth',1.5);
            %acc ׼ȷ��
            %acc_perf ѵ����������ܣ���ɫ���ߣ�
            %acc_vperf ��֤��������ܣ���ɫ���ߣ�
            %acc_tperf ���Լ�������ܣ���ɫ���ߣ�
            %tTest ΪԤ�������ǩ������        
        title('ѵ�����ܣ�acc_perf, acc_tperf���뷺�����ܣ�acc)','Interpreter','none');
        xlabel('����');
        ylabel('׼ȷ��');
        
        hold on
        %mean()����������ƽ�������Խ�����ʽת��������ʽ
        plot([1, n],[mean(acc(:,1)), mean(acc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(acc(:,1))*1.030,['acc1:',num2str(mean(acc(:,1)))]);
        try %��acc�����У����Ż�ǰ������ݸ�ռһ�У��������������������2������
            plot([1, n],[mean(acc(:,2)), mean(acc(:,2))],'--','LineWidth',1.5);
            y2 = mean(acc(:,1))+sign(mean(acc(:,2))-mean(acc(:,1)))*0.033;
            text(1.05,y2,['acc2:',num2str(mean(acc(:,2)))]);
            legend('acc_perf1','acc_perf2', 'acc_tperf1','acc_tperf2','acc1','acc2','Interpreter','none','Location','best');  
            %1��ʾ�Ż�ǰ�����ݣ�2��ʾ�Ż��������
        catch%��acc������һ�����ݣ�����һ�е���������ͼ��
            legend('acc_perf','acc_tperf','acc','Interpreter','none','Location','best');  
        end 
        hold off
   %% ����ѵ������ acc_perf ��֤���� acc_vperf �������� acc_tperf �ͷ������� acc     
    elseif K==4
        %figure()
        plot((1:n)',[acc_perf, acc_vperf, acc_tperf, acc],'LineWidth',1.5);
            %acc ׼ȷ��
            %acc_perf ѵ����������ܣ���ɫ���ߣ�
            %acc_vperf ��֤��������ܣ���ɫ���ߣ�
            %acc_tperf ���Լ�������ܣ���ɫ���ߣ�
            %tTest ΪԤ�������ǩ������        
        title('ѵ�����ܣ�acc_perf,acc_vperf,acc_tperf���뷺�����ܣ�acc)','Interpreter','none');
        xlabel('����');
        ylabel('׼ȷ��');
        
        hold on
        %mean()����������ƽ�������Խ�����ʽת��������ʽ
        plot([1, n],[mean(acc(:,1)), mean(acc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(acc(:,1))*1.030,['acc1:',num2str(mean(acc(:,1)))]);
        try %��acc�����У����Ż�ǰ������ݸ�ռһ�У��������������������2������
            plot([1, n],[mean(acc(:,2)), mean(acc(:,2))],'--','LineWidth',1.5);
            y2 = mean(acc(:,1))+sign(mean(acc(:,2))-mean(acc(:,1)))*0.033;
            text(1.05,y2,['acc2:',num2str(mean(acc(:,2)))]);
            legend('acc_perf1','acc_perf2','acc_vperf1','acc_vperf2','acc_tperf1','acc_tperf2','acc1','acc2','Interpreter','none','Location','best');  
            %1��ʾ�Ż�ǰ�����ݣ�2��ʾ�Ż��������
        catch%��acc������һ�����ݣ�����һ�е���������ͼ��
            legend('acc_perf','acc_vperf','acc_tperf','acc','Interpreter','none','Location','best');  
        end 
        hold off
        %��ʾ���շ�������acc��ʾ����Ĵ����ʣ�1-acc��ʾ����׼ȷ�ʡ�
    end
end