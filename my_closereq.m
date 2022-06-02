function my_closereq(src,callbackdata)
% Close request function 
% to display a question dialog box 
    % 询问是否要退出高光谱分析系统
    quest = {'\fontsize{10} \bf退出高光谱分析系统\rm？'};
             % \fontsize{10}：字体大小修饰符，作用是使其后面的字符大小都为10磅；
    dlgtitle = '退出程序';         
    btn1 = '是';
    btn2 = '否';
    opts.Default = btn2;
    opts.Interpreter = 'tex';
    % answer = questdlg(quest,dlgtitle,btn1,btn2,defbtn);
    answer = questdlg(quest, dlgtitle, btn1, btn2, opts);
    switch answer 
      case '是'
         delete(gcf)
      case '否'
      return 
    end
end