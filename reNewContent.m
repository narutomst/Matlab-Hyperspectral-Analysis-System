function h = reNewContent(hObject,handles,axes1)
% 点击目录中的某一项，如果该项下面的子项目已经展开，则收起；
% 这将会收起全部的下级子项目（不管有多少个层级）
% 如果该项目未展开，则展开下一级目录。

hObject.UserData.stringOld = hObject.UserData.stringNew;
hObject.UserData.levelOld = hObject.UserData.levelNew;
hObject.UserData.valueOld = hObject.UserData.valueNew;
hObject.UserData.isFolderOld = hObject.UserData.isFolderNew;

    val = hObject.Value;        %当前在listbox中点击的项目序号（行号）
    string = hObject.String;    %当前listbox中显示的内容
    input_level = hObject.UserData.levelOld;%当前listbox中显示文件夹/文件的输入等级，1表示最高级
    isFolder = hObject.UserData.isFolderOld; %当前listbox中显示的内容是否是文件夹

    selectedPath = hObject.UserData.selectedPath; %【打开路径】所选择的文件夹
    
    %而点在文件夹上时，isFolder(val)==1，即便该文件夹是一个空文件夹，依然是1
    %如果直接点在文件上，则既不执行展开也不执行收起。此时isFolder(val)==0
if isFolder(val) %    
    if val<numel(input_level) && input_level(val)<input_level(val+1)
        %val<numel(input_level)说明点中的不是最后一个，则(val+1)不会超input_level的边界
        %input_level(val)<input_level(val+1)则说明被选中项下还存在已经展开的子项目
    % 则执行收起子目录操作
        %先生成当前路径
        %1.拼接路径
        current_path = string{val}(input_level(val)*2+1:end);
        currentLevel = input_level(val);
        count = 0;
        if val > 1 
            for k = val-1 : -1 :1      %向上寻找包含当前文件夹的更高一级的文件夹名称
                %层级：input_level(val)-1 : 1
                if input_level(k) == 1
                    count = count + 1;%如果输入等级为1，则说明已经到达最顶级文件夹
                end
                if count == 2
                    break
                end
                if (input_level(k)<currentLevel)  %向上寻找过程中，若输入等级小于当前选中的文件夹的输入等级，
                                                                %则说明找到的文件夹为父级文件夹，因此需要将该文件夹名称拼接到
                                                                %current_path的前面
                    current_path = fullfile(string{k}(input_level(k)*2+1:end), current_path);
                    currentLevel = input_level(k);  %地址拼接完成后，新地址的输入等级也更新，再寻找更高等级的文件夹名称来拼接
                else
                    continue
                end               
            end
        end
        
% %在拼接地址前面再添上selectedPath，则是完整地址
        currentPath = fullfile(selectedPath, current_path);
        %再统计该项目下有多少项展开的子项目，例如从val开始的值是1,2,3,4,3,4,5,2,1
        %只要不是最后一个，就不会出现索引超界错误
        try
            i = 1;
            while(input_level(val)<input_level(val+i))
                i = i+1;
            end
            % 引起错误的原始是，如果点击的是最后一个文件，且该文件夹下有若干展开的子项
            % 则input_level(val+i)会引发索引超出边界的错误
        catch
            n = numel(input_level);
            i = 1;
            while(input_level(val)<input_level(n+1-i))
                i = i+1;
            end
        end
        N2 = i-1;
        N1 = numel(string);
        
        N = N1- N2;
        string1 = cell(N,1);
        
        % 更新string
        for i = 1 : val
        string1{i} = string{i};
        end
        for i = 1 : N-val
            string1{i+val} = string{val+N2+i};
        end
        string = string1;
        
        % 更新level
        level = zeros(N,1);
        level(1 : val) = input_level(1 : val);
        level(val+1 : N) = input_level(val+N2+1 : N1);
        % 更新isFolder
        oldContent = hObject.UserData.isFolderOld;
        is_folder = false(N,1);
        is_folder(1 : val) = oldContent(1 : val);
        is_folder(val+1 : N) = oldContent(val+N2+1 : N1);
    else 
        
    % 则执行展开子目录操作  
        
        %获取下一级子目录
%当前点击的文件夹名称是current_path
        current_path = string{val}(input_level(val)*2+1:end);
        currentLevel = input_level(val);
        count = 0;
        if val > 1 
            for k = val-1 : -1 :1      %向上寻找包含当前文件夹的更高一级的文件夹名称
                %层级：input_level(val)-1 : 1
                if input_level(k) == 1
                    count = count + 1;%如果输入等级为1，则说明已经到达最顶级文件夹
                end
                if count == 2
                    break
                end
                if (input_level(k)<currentLevel)  %向上寻找过程中，若输入等级小于当前选中的文件夹的输入等级，
                                                                %则说明找到的文件夹为父级文件夹，因此需要将该文件夹名称拼接到
                                                                %current_path的前面
                    current_path = fullfile(string{k}(input_level(k)*2+1:end), current_path);
                    currentLevel = input_level(k);  %地址拼接完成后，新地址的输入等级也更新，再寻找更高等级的文件夹名称来拼接
                else
                    continue
                end               
            end
        end
        
% %在拼接地址前面再添上selectedPath，则是完整地址
        currentPath = fullfile(selectedPath, current_path);
        a=dir(currentPath);
        %根据是否为空文件夹分为两种情况
        if ~isempty(a)
            contentname={a.name}';
            n = numel(contentname);%排除以$开头的文件，再排除.和..
            %先统计以$开头的文件名数量
            try
                count = 0;
                k = 1;
                while strcmp(contentname{k}(1),'$')
                    count = count + 1;
                    k = k+1;
                end   
                contentname=contentname(count+3:end);
                isFolder=[a.isdir]';
                isFolder=isFolder(count+3:end);
            catch
            end
            % 目录字符修饰
            % 生成新的level
            % 更新level
            N1 = numel(string);           %父目录中的项目数量
            N2 = numel(contentname);%子目录中的文件夹/文件名的数量
            N = N1 + N2;

            level = zeros(N,1);
            level(1 : val) = input_level(1 : val);
            level(val+1 : val+N2) = input_level(val)+1; 
            level(val+N2+1 : N) = input_level(val+1 : N1);
            % 更新isFolder
            oldContent = hObject.UserData.isFolderOld;
            is_folder = false(N,1);
            is_folder(1 : val) = oldContent(1 : val);
            is_folder(val+1 : val+N2) = isFolder; 
            is_folder(val+N2+1 : N) = oldContent(val+1 : N1);

            str = changeToContent(isFolder, contentname, level);

            % 更新string
            string1 = cell(N,1); 

            for i = 1 : val
                string1{i} = string{i};
            end

            for i = 1 : N2    % 加入空格
                string1{i+val} = [repmat(char(32),1,input_level(val)*2),str{i}];
            end

            for i = 1 : N1-val
                string1{val+N2+i} = string{val+i};
            end
            string = string1;
            t = hObject.ListboxTop;
            rowWidth = 352.9692/25;   %listbox每一行在高度上所占的像素值
            n1 = hObject.Position(4)/rowWidth;%listbox显示区域可以显示的行数
            if n1<=N2+1 %即listbox显示窗口小于将要展开的子目录的内容 
                hObject.ListboxTop = val;
            elseif n1<N-1  %即listbox显示窗口不能显示下展开之后的总内容
                hObject.ListboxTop = t+N2;
            end    
    %         elseif isa(isFolder,'logical') % isFolder, 0×1 logical
    %             disp('空文件夹！');
    %         else

    %             % 如果已经选中了，而且在选中状态下再次点击。
    %             % 则按照文件的格式，使用相应的方式显示。
    %             %*.jpg, *.bmp, *.gif, *.fig, *.mat
    %              

    %             
    %         end
        end
    
    end
else
%% 所点击目录项为最内层文件，则获取该文件的完整路径并打开
        %获取下一级子目录
%     currentPath = [handles.UserData.customPath];
    currentFileName = string{val}(input_level(val)*2+1-2:end);
    currentLevel = input_level(val);
    count = 0;
    if val > 1 
        for k = val-1 : -1 :1
            %层级：input_level(val)-1 : 1
            if input_level(k) == 1
                count = count + 1;
            end
            if count == 2
                break
            end
            if (input_level(k)<currentLevel)
                currentFileName = fullfile(string{k}(input_level(k)*2+1:end), currentFileName);
                currentLevel = input_level(k);
            else
                continue
            end               
        end
    end
        
        currentPath = fullfile(selectedPath, currentFileName);
        hObject.UserData.currentPath = currentPath;

    if (hObject.UserData.valueOld ~= val)
        disp('选中文件！');
    else
        disp('打开文件！');
        openFileInContent(hObject,handles);
        h = hObject;
        return 
    end    
end


    hObject.UserData.valueNew = val;
    hObject.Value = val;
    
try %当所点击项为最内层文件时，直接跳到第157行执行，
    % 此时不生成level和is_folder，所以这里会报错，
    % 所以放在try当中   
    hObject.UserData.levelNew = level;
    hObject.UserData.isFolderNew = is_folder;
    % 此时hObject.UserData.stringNew == string
    hObject.UserData.stringNew = string;
    % 此时hObject.String == string;
    hObject.String = string;

catch
    
end
h = hObject;
end