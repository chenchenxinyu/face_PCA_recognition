%%获取长度bi
clear;
p = genpath('F:\明月科创实验班第三学期\线性代数，人脸识别\PCA\数据库'); 
% 获得数据库所有子文件的路径，这些路径存在字符串p中，以';'分割
length_p = size(p,2);%字符串长度也就是文件夹个数
path = {};%建立单元数组
temp = [];
Voc_all = {};
Vector_all = {};
V_all = {};
meanVec_all = {};
for i = 1:length_p  %寻找分割符 ';'，一旦找到，则将路径 temp写入 path数组中
    if p(i) ~= ';'
        temp = [temp p(i)];
    else 
        temp = [temp '\']; 
        path = [path ; temp];
        temp = [];
    end
end  
clear p length_p temp;
%% 调用执行预处理得到特征向量
for npm = 1: 22
    path{2,1} = path{npm+1,1};
    pre_treatment;
    meanVec_all{npm,1} = meanVec;
    Voc_all{npm,1} = Voc;
    Vector_all{npm,1} = Vector;
    V_all{npm,1} = V;
end
disp('all data finish')

