function saveAllFigure(varargin)

%保存所有图片
if nargin==3
    gc = gcf;
    ik = gc.Number;
    for i = ik:-1:2
        figure(i)
%         filename = generateFilename('20200627', handles, ['_',num2str(i),'.fig']);
        filename = generateFilename(varargin{1}, varargin{2}, ['_',num2str(i),varargin{3}]);
        saveas(gcf, filename);              
    end
end

%保存从当前图片gcf算起的k张图片
if nargin==4
    
    in = varargin{4};
    gc = gcf;
    ik = gc.Number+1-in;
    for i = ik:(ik+in-1)
        figure(i)
        gc = gcf;
        filename = generateFilename(varargin{1}, varargin{2}, ['_',num2str(i),varargin{3}]);
        try
            saveas(gc, filename);    
        catch
        end
        
    end
end