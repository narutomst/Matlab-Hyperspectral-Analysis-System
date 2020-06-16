function table_data = createTable(x,y)
% 输入数据：x, 2维矩阵，每一行为一个样本，每一列为一个属性
%                 y,列向量，为x每个样本所属的类的值
%% 准备训练数据表table1
		% 为每个观测样本n个属性生成变量名
	n = size(x, 2);
	VarNames = cell(1, n);
	for j = 1 : n
		% 下面两句等效，但是访问方式不一样    
% 		VarNames(j) = {['Input_all',num2str(j)]};  % 访问cell array当中的第i个cell（数据类型是1×1 cell）
		VarNames{j} = ['Input_all',num2str(j)];% 访问cell array当中的第i个cell的内容(数据类型是1×10 char)
	end
		%VarNames(i)，1×1 cell
		%VarNames{i}，1×10 char
	table_data = array2table(x); %数组转换为表
	table_data.Properties.VariableNames = VarNames;%给表设置属性VariableNames
		% 为table增加最后一列
	table_data.Class = categorical(y);
		% table.Class = (y); 如果把数值型的y直接赋值给table.Class，
        % 则在Classification Learner中导入数据时会有提示：
		% Response variable is numeric. Distinct values will be interpreted as class labels
end      