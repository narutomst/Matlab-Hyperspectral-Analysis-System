function plotErr(varargin) % ������������>>>�����
err_perf = varargin{1};    % trainRecord.best_perf
err_vperf = varargin{2};  % trainRecord.best_vperf
err_tperf = varargin{3};  % trainRecord.best_tperf
racc = varargin{4};          % racc��1-acc���������
% ʵ������Щֵ������
% err_perf = cellfun(@(x) x.best_perf, trainRecord);
% err_vperf = cellfun(@(x) x.best_vperf, trainRecord);
% err_tperf = cellfun(@(x) x.best_tperf, trainRecord);
% ��Щֵ����һЩ��С����ֵ����0.0054��0.0117��0.0137����������ѵ�������л�õ�������ݣ�
% �����Щ������err��ͷ������

[n, m] = size(err_perf);

if nargin==4 
    %������plotErr(err_perf, err_vperf, err_tperf, racc)���ַ�ʽ���á�
    %ÿһ�����ݻ���һ��ͼ�������Ż�ǰ����������ݸ�����err_perf��һ�У�
    %�򱾺����Ὣ�Ż�ǰ���Ż�������ݸ�����һ��ͼ��    
    for i = 1:m  
        figure()
        plot((1:n)',[err_perf(:, i), err_vperf(:, i), err_tperf(:, i), racc(:, i)],'LineWidth',1.5);
            %racc ����ʣ�������
            %err_perf ��trainRecord.best_perf��ѵ����������ܣ���ɫ���ߣ�
            %err_vperf ��trainRecord.best_vperf����֤��������ܣ���ɫ���ߣ�
            %err_tperf ��trainRecord.best_tperf�����Լ�������ܣ���ɫ���ߣ�
            %tTest ΪԤ�������ǩ������        
        title('ѵ�����ܣ�err_perf,err_vperf,err_tperf���뷺�����ܣ�racc)','Interpreter','none');
        xlabel('����');
        ylabel('������');

        hold on
        %mean()����������ƽ�������Խ�����ʽת��������ʽ
        plot([1, n],[mean(racc(:, i)), mean(racc(:, i))],'--','LineWidth',1.5);

        text(1.05,mean(racc(:, i))*1.030,['racc', num2str(i), ':', num2str(mean(racc(:, i)))]);
        legend({['err_perf', num2str(i)],['err_vperf', num2str(i)],['err_tperf', num2str(i)],['racc', num2str(i)]},...
            'Interpreter','none','Location','best');  
        hold off
    end
elseif nargin==5
    %������plotErr(err_perf, err_vperf, err_tperf, racc, K)���ַ�ʽ���á�
    %ÿһ�����ݻ���һ�����ߣ������Ż�ǰ����������ݸ�����err_perf��һ�У�
    %�򱾺����Ὣ�Ż�ǰ���Ż�������ݻ�����ͬһ��ͼ�ϡ�
    K = varargin{5};
    %% ֻ���Ʒ�������racc
    if K==1       
        %figure()
        plot((1:n)',racc,'LineWidth',1.5);
            %racc ����ʣ�������
            %err_perf ��trainRecord.best_perf��ѵ����������ܣ���ɫ���ߣ�
            %err_vperf ��trainRecord.best_vperf����֤��������ܣ���ɫ���ߣ�
            %err_tperf ��trainRecord.best_tperf�����Լ�������ܣ���ɫ���ߣ�
            %tTest ΪԤ�������ǩ������        
        title('�������ܣ�racc)','Interpreter','none');
        xlabel('����');
        ylabel('������');
        
        hold on
        %mean()����������ƽ�������Խ�����ʽת��������ʽ
        plot([1, n],[mean(racc(:,1)), mean(racc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(racc(:,1))*1.030,['racc1:',num2str(mean(racc(:,1)))]);
        try %��racc�����У����Ż�ǰ������ݸ�ռһ�У��������������������2������
            plot([1, n],[mean(racc(:,2)), mean(racc(:,2))],'--','LineWidth',1.5);
            text(1.05,mean(racc(:,2))*1.030,['racc2:',num2str(mean(racc(:,2)))]);
            legend('racc1','racc2','Interpreter','none','Location','best');  
            %1��ʾ�Ż�ǰ�����ݣ�2��ʾ�Ż��������
        catch%��racc������һ�����ݣ�����һ�е���������ͼ��
            legend('racc','Interpreter','none','Location','best');  
        end 
        hold off 
    %% ������ѵ��������err_perf����trainRecord.best_perf�� �ͷ������� racc   
    elseif K==2
        %figure()
        plot((1:n)',[err_perf, racc],'LineWidth',1.5);
            %racc ����ʣ�������
            %err_perf ��trainRecord.best_perf��ѵ����������ܣ���ɫ���ߣ�
            %err_vperf ��trainRecord.best_vperf����֤��������ܣ���ɫ���ߣ�
            %err_tperf ��trainRecord.best_tperf�����Լ�������ܣ���ɫ���ߣ�
            %tTest ΪԤ�������ǩ������        
        title('ѵ�����ܣ�err_perf���뷺�����ܣ�racc)','Interpreter','none');
        xlabel('����');
        ylabel('������');
        
        hold on
        %mean()����������ƽ�������Խ�����ʽת��������ʽ
        plot([1, n],[mean(racc(:,1)), mean(racc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(racc(:,1))*1.030,['racc1:',num2str(mean(racc(:,1)))]);
        try %��racc�����У����Ż�ǰ������ݸ�ռһ�У��������������������2������
            plot([1, n],[mean(racc(:,2)), mean(racc(:,2))],'--','LineWidth',1.5);
            text(1.05,mean(racc(:,2))*1.030,['racc2:',num2str(mean(racc(:,2)))]);
            legend('err_perf1','err_perf2','racc1','racc2','Interpreter','none','Location','best');  
            %1��ʾ�Ż�ǰ�����ݣ�2��ʾ�Ż��������
        catch%��racc������һ�����ݣ�����һ�е���������ͼ��
            legend('err_perf','racc','Interpreter','none','Location','best');  
        end 
        hold off 
    %% ����ѵ������ err_perf����trainRecord.best_perf�� �������� err_tperf����trainRecord.best_tperf�� �ͷ������� racc    
    elseif K==3
        %figure()
        plot((1:n)',[err_perf, err_tperf, racc],'LineWidth',1.5);
            %racc ����ʣ�������
            %err_perf ��trainRecord.best_perf��ѵ����������ܣ���ɫ���ߣ�
            %err_vperf ��trainRecord.best_vperf����֤��������ܣ���ɫ���ߣ�
            %err_tperf ��trainRecord.best_tperf�����Լ�������ܣ���ɫ���ߣ�
            %tTest ΪԤ�������ǩ������        
        title('ѵ�����ܣ�err_perf, err_tperf���뷺�����ܣ�racc)','Interpreter','none');
        xlabel('����');
        ylabel('������');
        
        hold on
        %mean()����������ƽ�������Խ�����ʽת��������ʽ
        plot([1, n],[mean(racc(:,1)), mean(racc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(racc(:,1))*1.030,['racc1:',num2str(mean(racc(:,1)))]);
        try %��racc�����У����Ż�ǰ������ݸ�ռһ�У��������������������2������
            plot([1, n],[mean(racc(:,2)), mean(racc(:,2))],'--','LineWidth',1.5);
            text(1.05,mean(racc(:,2))*1.030,['racc2:',num2str(mean(racc(:,2)))]);
            legend('err_perf1','err_perf2', 'err_tperf1','err_tperf2','racc1','racc2','Interpreter','none','Location','best');  
            %1��ʾ�Ż�ǰ�����ݣ�2��ʾ�Ż��������
        catch%��racc������һ�����ݣ�����һ�е���������ͼ��
            legend('err_perf','err_tperf','racc','Interpreter','none','Location','best');  
        end 
        hold off
   %% ����ѵ������ err_perf����trainRecord.best_perf�� ��֤���� err_vperf����trainRecord.best_vperf�� �������� err_tperf����trainRecord.best_tperf�� �ͷ������� racc     
    elseif K==4
        %figure()
        plot((1:n)',[err_perf, err_vperf, err_tperf, racc],'LineWidth',1.5);
            %racc ����ʣ�������
            %err_perf ��trainRecord.best_perf��ѵ����������ܣ���ɫ���ߣ�
            %err_vperf ��trainRecord.best_vperf����֤��������ܣ���ɫ���ߣ�
            %err_tperf ��trainRecord.best_tperf�����Լ�������ܣ���ɫ���ߣ�
            %tTest ΪԤ�������ǩ������        
        title('ѵ�����ܣ�err_perf,err_vperf,err_tperf���뷺�����ܣ�racc)','Interpreter','none');
        xlabel('����');
        ylabel('������');
        
        hold on
        %mean()����������ƽ�������Խ�����ʽת��������ʽ
        plot([1, n],[mean(racc(:,1)), mean(racc(:,1))],'--','LineWidth',1.5);

        text(1.05,mean(racc(:,1))*1.030,['racc1:',num2str(mean(racc(:,1)))]);
        try %��racc�����У����Ż�ǰ������ݸ�ռһ�У��������������������2������
            plot([1, n],[mean(racc(:,2)), mean(racc(:,2))],'--','LineWidth',1.5);
            text(1.05,mean(racc(:,2))*1.030,['racc2:',num2str(mean(racc(:,2)))]);
            legend('err_perf1','err_perf2','err_vperf1','err_vperf2','err_tperf1','err_tperf2','racc1','racc2','Interpreter','none','Location','best');  
            %1��ʾ�Ż�ǰ�����ݣ�2��ʾ�Ż��������
        catch%��racc������һ�����ݣ�����һ�е���������ͼ��
            legend('err_perf','err_vperf','err_tperf','racc','Interpreter','none','Location','best');  
        end 
        hold off
        %��ʾ���շ�������racc��ʾ����Ĵ����ʣ�1-racc��ʾ����׼ȷ�ʡ�
    end
end