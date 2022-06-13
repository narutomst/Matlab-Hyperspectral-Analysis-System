function lineObj = lineFormat(lineObj)
% lineObj，即线条对象，比如lineObj可以是p, p= plot(x,y,'LineWidth',1.5);
% 假定这里 p为10×1 Line
% Line的属性有Color, RGB 三元组, [0.4 0.6 0.7]; 十六进制颜色代码'#FF8800' 与'#ff8800'、'#F80' 与 '#f80' ; 
% 或者颜色名称字符向量与短名称，如'red', 'green', 'blue', 'r', 'g', 'b'
% LineStyle，['-'	实线；'--'	虚线；':'	点线；'-.'	点划线；]; 4种
% Marker, ['none'	无标记; "." 点; 'x'	叉号; '+'	加号; '*'	星号; 'o'	圆圈; square' 或 's'	方形; 'diamond'或'd'	菱形; ]; 8种
% ["none", ".", "x", "+", "*", "o", "square", "diamond", ];  %8种
% 在不考虑颜色的情况下可以组合出4×8=32种
% 则可以满足10条曲线进行格式化需求
LineStyleStr = ["-", "--", ":", "-."];  % 4种
MarkerStr = ["none", ".", "x", "+", "*", "o", "square", "diamond", ];  %7种
LineStyleNum = numel(LineStyleStr);
MarkerNum = numel(MarkerStr);
LineNum = numel(lineObj);
%# 将[线性索引]转换为[下标索引]
[I, J] = ind2sub([LineStyleNum, MarkerNum], 1:LineNum);
for iLine = 1:LineNum
    lineObj(iLine).LineStyle = LineStyleStr(I(iLine));
    lineObj(iLine).Marker = MarkerStr(J(iLine));
end
% 当LineNum=10时，I=[1,2,3,4,1,2,3,4,1,2]; J=[1,1,1,1,2,2,2,2,3,3];
% 这样做的目的是尽量把LineStyleStr的4种样式全用上，
% 而不想用MarkerStr后面的"*", "o", "square", "diamond"这几种样式，
% 因为这些标记点在数据点密集的地方容易把数据点挡住了，视觉效果就是糊了
end