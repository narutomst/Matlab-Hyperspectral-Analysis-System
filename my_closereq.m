function my_closereq(src,callbackdata)
% Close request function 
% to display a question dialog box 

   selection = questdlg('�˳��߹��׷���ϵͳ?',...
      'Close Request Function',...
      '��','��','��'); 
   switch selection 
      case '��'
         delete(gcf)
      case '��'
      return 
   end
end