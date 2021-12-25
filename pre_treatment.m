%% 读取图像
%clear;
Figure = dir(path{2,1});
files = dir(fullfile(path{2,1},'*.jpg'));
lengthFiles = length(files);
F = cell(lengthFiles+1,1);
for i = 1:lengthFiles
    Img1 = imread(strcat(path{2,1},files(i).name));
    Img = imresize(Img1,[413,295]);
    F{i,1} = Img;
    %disp(strcat(path{2,1},files(i).name));
    %figure;imshow(Img);
end

%% 化为灰度图像
for j=1:lengthFiles %转化为二维矩阵灰度图
    if length(size(F{j,1}))==3
        F{j,1}=F{j}(:,:,1);
        %figure;imshow(F{j,1});
    end
end
%% 去除噪声：中值滤波,均值滤波
for k=1:lengthFiles %转化为二维矩阵灰度图
    F{k,1} = medfilt2(F{k,1},[3,3]);
    F{k,1} = imfilter(F{k,1},fspecial('average',[3,3]));
    %figure;imshow(F{k,1});
end


%% 快速pca图像数据整合（特征脸空间）
%快速pca相对于一般pca，针对样本量少，但每个样本数据大的情况，本例中每个特征脸维数为413*295，样本数量为10
%正常pca的结构导致matlab内存不足，呈现一个（413*295）*（413*295）维度的协方差矩阵，而用快速pca则只有10*10，极大简化数据量

special_face = [];
face_all = [];
[m,n] = size(F{1,1});   %行数、列数

for i1 = 1:lengthFiles
    for i2 = 1:m
       for i3 = 1:n
           special_face = [special_face,F{i1,1}(i2,i3)];
       end
    end
    face_all = [face_all;special_face];
    special_face = []; 
end


%% PCA降维\协方差\特征值
%这个第二次备份尝试采用矩阵的转置进行操作 也就是我们假设要寻找的为转置矩阵的特征值 之后在测试中也同理 采用转置
%以此尝试绕过大矩阵运算；另外对于协方差表示数据展开关系，其特征不会发生改变，只是发生空间分布的变化

[r c] = size(face_all);
meanVec = mean(face_all); %求数组的均值，对矩阵则返回每列均值的行向量，即平均脸空间
Z = face_all; %减去均值
for j1 = 1:r
   for j2 = 1:c
       Z(j1,j2) = face_all(j1,j2) - meanVec(1,j2);
   end
end
Z1 = Z';
Z1 = im2double(Z1);
Z = im2double(Z);
%分块计算，每次计算121835*3000个，直到计算完所有的矩阵，之后合并，分块后有41个
% for num  = 1:40
%     covMat{num,1} = small_list(Z1,Z,num);    
% end
% for i  = 1:121835
%     for j  = 120001:121835
%         covMat{41,1}(i,j) =  Z1(i,1)*Z(1,j)+Z1(i,2)*Z(2,j)+Z1(i,3)*Z(3,j)+Z1(i,4)*Z(4,j)+Z1(i,5)*Z(5,j)+Z1(i,6)*Z(6,j)+Z1(i,7)*Z(7,j)+Z1(i,8)*Z(8,j)+Z1(i,9)*Z(9,j)+Z1(i,10)*Z(10,j);
%     end
% end
covMat = Z*Z1;%计算协方差矩阵  该矩阵太大，需要采用特殊的方法进行操作
%计算协方差矩阵的特征值和特征向量  只取前k个，此维度会影响识别精度
%matlab way https://www.jianshu.com/p/4dd141589a20
k = 10;%训练的特征值数量一般不会超过样本个数，多余的是没有意义的
[V,~] = eigs(covMat,k);%得到特征值对应的特征向量
Vector = Z1 * V;%特征向量和原样本进行乘法，即可得到降维样本
Voc = Vector(:);
disp('prepare one ready!')
%meanVector = mean(Vector');
%单位化特征向量  也就是主成分  看和不同图片的匹配度
% for i4 = 1:k
% Vector(:,i4) = Vector(:,i4)/norm(Vector(:,i4));
% end
