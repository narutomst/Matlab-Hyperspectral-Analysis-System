%
function filename = generateFilename(path, handles, fmt)
        path = 'C:\Matlab练习\20200627';
        try            %拼接路径
            path = fullfile(path, hmenu4_1.UserData.matName, hmenu4_1.UserData.drAlgorithm, hmenu4_1.UserData.cAlgorithm);
        catch
        end
            filename = [hmenu4_1.UserData.matName,'_',hmenu4_1.UserData.drAlgorithm,'_',hmenu4_1.UserData.cAlgorithm,'.xlsx'];
        try
            filename = fullfile(path,filename);%拼接路径
        catch
        end
end