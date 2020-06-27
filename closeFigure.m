function closeFigure(varargin)
if ~isempty(varargin)
    n = numel(varargin{1});
    for i = 1:n
        close(figure(varargin{1}(i)));
    end
end
end