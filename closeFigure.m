function closeFigure(varargin)%输入Figure的编号，关闭指定的Figure，可以输入多个编号
if ~isempty(varargin)
    n = numel(varargin{1});
    for i = 1:n
        close(figure(varargin{1}(i)));
    end
end
end