%% in GUI
%load('F:\明月科创实验班第三学期\线性代数，人脸识别\PCA\import.mat');
%^%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 预处理新数据
%RunShow;

disp('show time!');
img = imresize(im ,[413,295]);
%ImgRun = deal_test(img);
F{1,1} = img;
if length(size(F{1,1})) == 3
    F{1,1} = F{1}(:,:,1); %get into the grew 2D
end
F{1,1} = medfilt2(F{1,1},[3,3]);%中值滤波
[m,n] = size(F{1,1});
ImgRun = zeros(1,m*n);
%face_all_test = zeros(10,m*n);
for i = 1:m
    for j = 1:n
        ImgRun(1,(i-1)*n+j) = F{1,1}(i,j);
    end
end
Rboy = 0;%表示最接近准确度的值，越趋于0，表示图像的相似程度越高，准确度为1-该值
min_D = 9999999;
for i = 1:22
    V_now = V_all{i,1};
    Vector_now = Vector_all{i,1};
    Voc_now = Voc_all{i,1};
    %data = result(ImgRun,V_now,Vector_now);
    data = [ImgRun;ImgRun;ImgRun;ImgRun;ImgRun;ImgRun;ImgRun;ImgRun;ImgRun;ImgRun]'* V_now - Vector_now;    
    voc = data(:);
    %R = cosDeal(voc,Voc_now);
    R = dot( voc,Voc_now )/( sqrt( sum( voc.*voc ) ) * sqrt( sum( Voc_now.*Voc_now)));    
    if R > Rboy%一旦有新的值小于该值，立刻进行替换，并保存编号以之后显示图像
        Rboy = R;
        id = i;
    end
    S = ImgRun - meanVec_all{i,1};
    D = sqrt(dot(S,S));
    if D < min_D
        id = i
        min_D = D;
    end
end
files = dir(fullfile(path{id+1,1},'*.jpg'));
Img = imread(strcat(path{id+1,1},files(1).name));
%axes( handles.axes2 )
imshow(Img);



%% 图像测试比较
disp('show time!');
testImg = imresize(im,[413,295]);
ImgRun = deal_test(testImg);
Rboy = 1;%表示最接近准确度的值，越趋于0，表示图像的相似程度越高，准确度为1-该值
for i = 1:22
    V_now = V_all{i,1};
    Vector_now = Vector_all{i,1};
    data = result(ImgRun,V_now,Vector_now);
    voc = data(:);
    R = cosDeal(voc,Voc_all{i,1});
    if R < Rboy%一旦有新的值小于该值，立刻进行替换，并保存编号以之后显示图像
        Rboy = R;
        id = i;
    end
end
function [special_face_test] = deal_test(img)
    %face_all_test = face_all;
    %lengthFiles = 10;    
    F{1,1} = img;
    if length(size(F{1,1})) == 3      
        F{1,1} = F{1}(:,:,1); %get into the grew 2D
    end
    F{1,1} = medfilt2(F{1,1},[3,3]);%中值滤波   
    [m,n] = size(F{1,1});
    special_face_test = zeros(1,m*n);
    %face_all_test = zeros(10,m*n);
    for i = 1:m
        for j = 1:n
            special_face_test(1,(i-1)*n+j) = F{1,1}(i,j);
        end
    end
    %test_v = fastpca(special_face_test);
end

function [covMat] = small_list(Z1,Z,num)
    covMat = zeros(121835,3000);
    for i  = 1:121835
        for j  = 1:3000
            covMat(i,j) =  Z1(i,1)*Z(1,(num-1)*3000+j)+Z1(i,2)*Z(2,(num-1)*3000+j)+Z1(i,3)*Z(3,(num-1)*3000+j)+Z1(i,4)*Z(4,(num-1)*3000+j)+Z1(i,5)*Z(5,(num-1)*3000+j)+Z1(i,6)*Z(6,(num-1)*3000+j)+Z1(i,7)*Z(7,(num-1)*3000+j)+Z1(i,8)*Z(8,(num-1)*3000+j)+Z1(i,9)*Z(9,(num-1)*3000+j)+Z1(i,10)*Z(10,(num-1)*3000+j);
        end
    end
end
function data1 = result(testImgRun1,V,Vector)
    data1 = [testImgRun1;testImgRun1;testImgRun1;testImgRun1;testImgRun1;testImgRun1;testImgRun1;testImgRun1;testImgRun1;testImgRun1]'* V - Vector;
end
function R = cosDeal(voc1,Voc)
    R = dot( voc1,Voc )/( sqrt( sum( voc1.*voc1 ) ) * sqrt( sum( Voc.*Voc)));
    %利用空间矢量下面的余弦定理来比较两个矩阵的相似程度
end 

