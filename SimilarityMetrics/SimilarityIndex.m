clc;
clear;
close all;


% Ruta del directorio de destino
path = 'C:\Users\Andres\Desktop\Segmentaciones\';

[~,str] = xlsread('SegOdont.xlsx','Pacientes');

k=0

for i=1:length(str)
   
    for j=1:2
        
        switch j
           
            case 1
                side = 'Izq';
                name = [str{i},'_',side];
                %disp(name)
                
            case 2
                side = 'Der';
                name = [str{i},'_',side];
                %disp(name)
        end
        k=k+1
        listnames{k,1}=name
        %disp(name)
        
    end 
    
end
%%
k=0

for i=1:length(listnames)
    
    Lnames = listnames{i};
   
    for m=1:2
        switch m
            
            case 1
                
                exp = 'Exp1';
                wholenames=[Lnames,'_',exp,'_mask.jpg'];
%                 name = [str{i},'_',side];
                
            case 2
                
                exp = 'Exp2';
                wholenames=[Lnames,'_',exp,'_mask.jpg'];
                
                
        end
        k=k+1
        disp(wholenames)
        listwholenames{k,1}=wholenames

    end
    
    
end

%%

for ind=1:length(listwholenames)/2-1
   
    a=listwholenames{2*ind-1};
    b=listwholenames{2*ind};
    
    disp(a)
    disp(b)
    
    try        
    [IoU,Dice] = calcularIoU(a,b);
    end
    
    nameimg = a(1:length(a)-14);
    
    IoUList{ind,1}=nameimg;
    
    IoUList{ind,2}=IoU;
    IoUList{ind,3}=Dice;
    
    
    
end



%%

 function [IoU,Dice] = calcularIoU(imname1,imname2)
% Lee la imagen
path = 'C:\Users\Andres\Desktop\Segmentaciones\';
im1 = imread([path,imname1]);
im2 = imread([path,imname2]);

try
    im1 = rgb2gray(im1);
    im2 = rgb2gray(im2);
end
%%
im3=im2;

%im3 = imresize(im2,[265,265])

imBW1 = im1/max(max(im1));
imBW2 = im3/max(max(im3));


% figure, 
% subplot(1,2,1), imshow(imBW1,[]), title ('Segm1')
% subplot(1,2,2), imshow(imBW2,[]), title ('Segm2')

intersec = imBW1 & imBW2;
union = imBW1 | imBW2;

inter=sum(intersec(:));
uni=sum(union(:));

IoU = inter/uni;
Dice = 2*IoU/(IoU+1);

% disp('IoU:');
% disp(IoU)
% 
% 
% 
% %%
% green = [0 1 0];
% black = [0 0 0];
% cyan = [0 1 1];
% blue = [0 0 1];
% % red = [1 0 0];
% 
% kk(:,:,1)=imBW1*255;
% kk(:,:,2)=imBW1*255;
% kk(:,:,3)=imBW1*255;
% 
% imoverlay=labeloverlay(kk,imBW2,'Colormap',[blue;green],'Transparency',0.6);
% 
% 
% 
% figure(1), 
% subplot(1,3,1), imshow(imBW1,[]), title ('Segm1')
% subplot(1,3,2), imshow(imBW2,[]), title ('Segm2')
% subplot(1,3,3), imshow(imoverlay,[]),
% pp=['IoU: ','0.' int2str(IoU*100)]
% % title(pp)
% 
% figure(2),
% imshow(imoverlay)
% title(pp)

 end