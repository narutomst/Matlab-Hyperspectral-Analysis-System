function string = changeToContent(isContent, contentName, level)
    M = numel(isContent);
    string = cell(size(isContent));
    %'>>'
    for i = 1 : M
%     string(i) = strcat(string1(i),global_contentName{i});
        if isContent(i)
            %string{i} = [char(9658),global_contentName{i}];
            string{i} = ['>>',contentName{i}];
        else
            string{i} = contentName{i};
        end
    end
end