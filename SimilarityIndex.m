clc;
clear;
close all;


filename = 'P4.jpg';

% Ruta del directorio de destino
path = 'C:\Users\Andres\Documents\ProyectoInvestigacion\ProyectoOdontologia\';

% Lee la imagen
% im1 = imread([path,'P4bmask.jpg']);
% im2 = imread([path,'P4mask.jpg']);
im1 = imread([path,'Imagen1.jpg']);
im2 = imread([path,'Imagen2.jpg']);

im1 = rgb2gray(im1);
im2 = rgb2gray(im2);

%%
im3=im2;

%im3 = imresize(im2,[265,265])

imBW1 = im1/max(max(im1));
imBW2 = im3/max(max(im3));


figure, 
subplot(1,2,1), imshow(imBW1,[]), title ('Segm1')
subplot(1,2,2), imshow(imBW2,[]), title ('Segm2')

intersec = imBW1 & imBW2;
union = imBW1 | imBW2;

inter=sum(intersec(:));
uni=sum(union(:));

IoU = inter/uni;

disp('IoU:');
disp(IoU)



%%
green = [0 1 0];
black = [0 0 0];
cyan = [0 1 1];
blue = [0 0 1];
% red = [1 0 0];

kk(:,:,1)=imBW1*255;
kk(:,:,2)=imBW1*255;
kk(:,:,3)=imBW1*255;

imoverlay=labeloverlay(kk,imBW2,'Colormap',[blue;green],'Transparency',0.6);



figure, 
subplot(1,3,1), imshow(imBW1,[]), title ('Segm1')
subplot(1,3,2), imshow(imBW2,[]), title ('Segm2')
subplot(1,3,3), imshow(imoverlay,[]),
pp=['IoU: ','0.' int2str(IoU*100)]
title(pp)