function lineObj = lineFormat(lineObj)
% lineObj�����������󣬱���lineObj������p, p= plot(x,y,'LineWidth',1.5);
% �ٶ����� pΪ10��1 Line
% Line��������Color, RGB ��Ԫ��, [0.4 0.6 0.7]; ʮ��������ɫ����'#FF8800' ��'#ff8800'��'#F80' �� '#f80' ; 
% ������ɫ�����ַ�����������ƣ���'red', 'green', 'blue', 'r', 'g', 'b'
% LineStyle��['-'	ʵ�ߣ�'--'	���ߣ�':'	���ߣ�'-.'	�㻮�ߣ�]; 4��
% Marker, ['none'	�ޱ��; "." ��; 'x'	���; '+'	�Ӻ�; '*'	�Ǻ�; 'o'	ԲȦ; square' �� 's'	����; 'diamond'��'d'	����; ]; 8��
% ["none", ".", "x", "+", "*", "o", "square", "diamond", ];  %8��
% �ڲ�������ɫ������¿�����ϳ�4��8=32��
% ���������10�����߽��и�ʽ������
LineStyleStr = ["-", "--", ":", "-."];  % 4��
MarkerStr = ["none", ".", "x", "+", "*", "o", "square", "diamond", ];  %7��
LineStyleNum = numel(LineStyleStr);
MarkerNum = numel(MarkerStr);
LineNum = numel(lineObj);
%# ��[��������]ת��Ϊ[�±�����]
[I, J] = ind2sub([LineStyleNum, MarkerNum], 1:LineNum);
for iLine = 1:LineNum
    lineObj(iLine).LineStyle = LineStyleStr(I(iLine));
    lineObj(iLine).Marker = MarkerStr(J(iLine));
end
% ��LineNum=10ʱ��I=[1,2,3,4,1,2,3,4,1,2]; J=[1,1,1,1,2,2,2,2,3,3];
% ��������Ŀ���Ǿ�����LineStyleStr��4����ʽȫ���ϣ�
% ��������MarkerStr�����"*", "o", "square", "diamond"�⼸����ʽ��
% ��Ϊ��Щ��ǵ������ݵ��ܼ��ĵط����װ����ݵ㵲ס�ˣ��Ӿ�Ч�����Ǻ���
end