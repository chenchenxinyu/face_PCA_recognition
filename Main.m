%%��ȡ����bi
clear;
p = genpath('F:\���¿ƴ�ʵ������ѧ��\���Դ���������ʶ��\PCA\���ݿ�'); 
% ������ݿ��������ļ���·������Щ·�������ַ���p�У���';'�ָ�
length_p = size(p,2);%�ַ�������Ҳ�����ļ��и���
path = {};%������Ԫ����
temp = [];
Voc_all = {};
Vector_all = {};
V_all = {};
meanVec_all = {};
for i = 1:length_p  %Ѱ�ҷָ�� ';'��һ���ҵ�����·�� tempд�� path������
    if p(i) ~= ';'
        temp = [temp p(i)];
    else 
        temp = [temp '\']; 
        path = [path ; temp];
        temp = [];
    end
end  
clear p length_p temp;
%% ����ִ��Ԥ����õ���������
for npm = 1: 22
    path{2,1} = path{npm+1,1};
    pre_treatment;
    meanVec_all{npm,1} = meanVec;
    Voc_all{npm,1} = Voc;
    Vector_all{npm,1} = Vector;
    V_all{npm,1} = V;
end
disp('all data finish')

