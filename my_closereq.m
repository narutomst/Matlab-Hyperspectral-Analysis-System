function my_closereq(src,callbackdata)
% Close request function 
% to display a question dialog box 

   selection = questdlg('退出高光谱分析系统?',...
      'Close Request Function',...
      '是','否','否'); 
   switch selection 
      case '是'
         delete(gcf)
      case '否'
      return 
   end
end