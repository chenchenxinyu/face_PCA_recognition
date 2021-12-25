function varargout = GUI_cxy(varargin)
% GUI_CXY MATLAB code for GUI_cxy.fig
%      GUI_CXY, by itself, creates a new GUI_CXY or raises the existing
%      singleton*.
%
%      H = GUI_CXY returns the handle to a new GUI_CXY or the handle to
%      the existing singleton*.
%
%      GUI_CXY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CXY.M with the given input arguments.
%
%      GUI_CXY('Property','Value',...) creates a new GUI_CXY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_cxy_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_cxy_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_cxy

% Last Modified by GUIDE v2.5 24-Dec-2021 23:46:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_cxy_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_cxy_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



% --- Executes just before GUI_cxy is made visible.
function GUI_cxy_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_cxy (see VARARGIN)

% Choose default command line output for GUI_cxy
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_cxy wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global V_all Voc_all Vector_all meanVec_all Rboy;
    V_all = {};
    Voc_all = {};
    Vector_all = {};
    meanVec_all = {};
    Rboy = 0;


% --- Outputs from this function are returned to the command line.
function varargout = GUI_cxy_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% read image to be recognize
global im;
[filename, pathname] = uigetfile({'*.jpg'},'choose photo');
str = [pathname, filename];
im = imread(str);
axes( handles.axes1);
imshow(im);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im  %图像
%global id
global path
global Rboy
global min_D
global Voc_all
global Vector_all
global V_all
global meanVec_all
% Voc_all1 = get(ui_handle1,'UserData');
% Vector_all1 = get(ui_handle2,'UserData');
% V_all1 = get(ui_handle3,'UserData');
% meanVec1 = get(ui_handle4,'UserData');
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
%Rboy = 0;%表示最接近准确度的值，越趋于0，表示图像的相似程度越高，准确度为1-该值
min_D = 9999999;
for i = 1:22
%     %disp(V_all{1,1});
    V_all = evalin('base','V_all');
    Vector_all = evalin('base','Vector_all');
    Voc_all = evalin('base','Voc_all');
    meanVec_all = evalin('base','meanVec_all');
    path = evalin('base','path');
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
        id = i;
        min_D = D;
    end
end

%Figure = dir(path{id+1,1});
files = dir(fullfile(path{id+1,1},'*.jpg'));
Img = imread(strcat(path{id+1,1},files(1).name));
axes( handles.axes2 )
imshow(Img);

% 显示测试结果
% aimpath = strcat(pathname, '/', img_path_list(aimone).name);
% axes( handles.axes2 )
% imshow(aimpath)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%5--------5%
global Voc_all
global Vector_all
global V_all
global meanVec_all
% set(ui_handle1,'UserData',Voc_all);
% set(ui_handle2,'UserData',Vector_all);
% set(ui_handle3,'UserData',V_all);
% set(ui_handle4,'UserData',meanVec_all);
% global meanVec_all_one
% Main;
p = genpath('F:\明月科创实验班第三学期\线性代数，人脸识别\PCA\数据库'); 
% 获得数据库所有子文件的路径，这些路径存在字符串p中，以';'分割
length_p = size(p,2);%字符串长度也就是文件夹个数
path = {};%建立单元数组
temp = [];
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
%调用执行预处理得到特征向量
for npm = 1: 22
    path{2,1} = path{npm+1,1};
    %pre_treatment;
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
    for j=1:lengthFiles %转化为二维矩阵灰度图
        if length(size(F{j,1}))==3
            F{j,1}=F{j}(:,:,1);
            %figure;imshow(F{j,1});
        end
    end
    for k=1:lengthFiles %转化为二维矩阵灰度图
        F{k,1} = medfilt2(F{k,1},[3,3]);
        %figure;imshow(F{k,1});
    end
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
    covMat = Z*Z1;%计算协方差矩阵  该矩阵太大，需要采用特殊的方法进行操作
    %计算协方差矩阵的特征值和特征向量  只取前k个，此维度会影响识别精度
    %matlab way https://www.jianshu.com/p/4dd141589a20
    k = 10;%训练的特征值数量一般不会超过样本个数，多余的是没有意义的
    [V,~] = eigs(covMat,k);%得到特征值对应的特征向量
    Vector = Z1 * V;%特征向量和原样本进行乘法，即可得到降维样本
    Voc = Vector(:);
    disp('prepare one ready!')

    Voc_all{npm,1} = Voc;
    Vector_all{npm,1} = Vector;
    V_all{npm,1} = V;
    meanVec_all{npm,1} = meanVec; 
    %meanVec_all_one = meanVec+meanVec_all_one;
end

disp('all data finish')






% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 选择测试集

global Rboy
%Rboy = evalin('base','Rboy');

accuracy = 1 - Rboy;
msgbox(['分类器准确率:                   ',num2str(accuracy)],'accuracy')


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton2.

