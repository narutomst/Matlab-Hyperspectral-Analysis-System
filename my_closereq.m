function my_closereq(src,callbackdata)
% Close request function 
% to display a question dialog box 
    % ѯ���Ƿ�Ҫ�˳��߹��׷���ϵͳ
    quest = {'\fontsize{10} \bf�˳��߹��׷���ϵͳ\rm��'};
             % \fontsize{10}�������С���η���������ʹ�������ַ���С��Ϊ10����
    dlgtitle = '�˳�����';         
    btn1 = '��';
    btn2 = '��';
    opts.Default = btn2;
    opts.Interpreter = 'tex';
    % answer = questdlg(quest,dlgtitle,btn1,btn2,defbtn);
    answer = questdlg(quest, dlgtitle, btn1, btn2, opts);
    switch answer 
      case '��'
         delete(gcf)
      case '��'
      return 
    end
end