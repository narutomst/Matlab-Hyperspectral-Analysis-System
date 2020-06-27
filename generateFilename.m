%
function filename = generateFilename(path, handles, fmt)
        %path = 'C:\Matlab练习\20200627';
        hmenu4_1 = findobj(handles,'Label','加载数据');
        try            %拼接路径
            path = fullfile('C:\Matlab练习',path, hmenu4_1.UserData.matName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
        catch
        end
            filename = [hmenu4_1.UserData.matName, '_', hmenu4_1.UserData.drAlgorithm, '_', hmenu4_1.UserData.cAlgorithm, fmt];
        try
            filename = fullfile(path,filename);%拼接路径
        catch
        end
end