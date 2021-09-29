%{

Comparación entre T1,T2 y T3 en el mismo lado (Izq o Der)

%}

clc;
clear;
close all;

pathmask = 'C:\Users\Andres\Documents\ProyectoInvestigacion\DatasetOdont\SegmIzq\';
path = 'C:\Users\Andres\Documents\ProyectoInvestigacion\DatasetOdont\ImagenesOriginales\';

imname1 = 'PAULA2.png';
imname2 = 'PAULA3.png';

maskname1 = 'PAULA1_Izq_mask.jpg';
maskname2 = 'PAULA2_Izq_mask.jpg';

im1 = imread([path,imname1]);
im2 = imread([path,imname2]);

mask1 = imread([pathmask,maskname1]);
mask2 = imread([pathmask,maskname2]);

mask1 = mask1/max(mask1(:));
mask2 = mask2/max(mask2(:));

data1 = double(im1(mask1==1));
data2 = double(im2(mask2==1));

%%

x1 = randn(600,1);
x2 = randn(1440,1);
% x3 = randn(500, 1);
x = [data1; data2];
g = [zeros(length(data1), 1); ones(length(data2), 1)];
boxplot(x, g)

[h,pval] = ttest2(data1,data2);
[p,h] = ranksum(data1,data2)



