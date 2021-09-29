%{

Comparación entre T1,T2 y T3 en el mismo lado (Izq o Der)

%}

clc;
clear;
close all;

pathmaskIzq = 'C:\Users\Andres\Documents\ProyectoInvestigacion\DatasetOdont\SegmIzq\';
pathmaskDer = 'C:\Users\Andres\Documents\ProyectoInvestigacion\DatasetOdont\SegmDer\';
path = 'C:\Users\Andres\Documents\ProyectoInvestigacion\DatasetOdont\ImagenesOriginales\';

imname = 'SERGIO3';

maskname1 = [imname ,'_Izq_mask.jpg'];
maskname2 = [imname ,'_Der_mask.jpg'];

im1 = imread([path,imname,'.png']);
im1 = double(im1)/double(max(im1(:)));

%%

mask1 = imread([pathmaskIzq,maskname1]);
mask2 = imread([pathmaskDer,maskname2]);

mask1 = mask1/max(mask1(:));
mask2 = mask2/max(mask2(:));

%%

data1 = double(im1(mask1==1));
data2 = double(im1(mask2==1));

%%
% 
% x1 = randn(600,1);
% x2 = randn(1440,1);
% x3 = randn(500, 1);

r1 = unique(randi([0 12000],1,370));
r2 = unique(randi([0 12000],1,370));
data1=data1(r1);
data2=data2(r2);

%%

x = [data1; data2];
g = [zeros(length(data1), 1); ones(length(data2), 1)];
boxplot(x, g)


[h,pval] = ttest2(data1,data2);
[p,h] = ranksum(data1,data2)



