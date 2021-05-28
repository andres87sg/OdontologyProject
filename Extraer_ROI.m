%%%%%%%%%%%%%%%%%%%%%
% Autor:    Andres Sandino
% e-mail:   asandino@unal.edu.co
% github:   asandino87
% Script:   Segmentación de imagenes de Rx 
% Versión:  2.0
% Fecha:    28/05/2021
% Matlab versión 2020b
%%%%%%%%%%%%%%%%%%%%%
a=0;
clc;
clear;
close all;

% Ruta del directorio
path = 'C:\Users\Andres\Documents\Maestria UN\En proceso\Programas_Tesis_Maestria\';

% Nombre del archivo (debe incluir extensión. Ej: jpg,png,tiff.
filename = 'P4.jpg';

% Ruta del directorio de destino
destpath = 'C:\Users\Andres\Documents\Maestria UN\En proceso\Programas_Tesis_Maestria\mascaras\';

% Lee la imagen
im1 = imread([path,filename]);

% Convierte imagen RGB a Escala de grises
im1 = rgb2gray(im1); 

% Muestra la imagen
figure, imshow(im1,[],'InitialMagnification','fit'),
title(['Imagen Original ','(',filename,')']);

% Segmentación a mano alzada (freehand)
im1_freehand =  drawfreehand(gca);

% Crea una máscara de segmentación
im_bw = createMask(im1_freehand);

% Convierte la imágen de un tipo de dato bool a double
im_bw=double(im_bw);

% Si se genera una máscara pasa al segundo paso
if (max(im_bw(:))==1)
    
    % Genera un BoundingBox de la región de interés
    bb_im_bw=regionprops(im_bw,'BoundingBox');
    
    % Calcula el centroide de la máscara
    centroid=regionprops(im_bw,'centroid');
    coord=round(bb_im_bw.BoundingBox);
    max_long=round(max(coord(1,3),coord(1,4))/2);
    centroid=round(centroid.Centroid);
    x_centroid=centroid(1,1);
    y_centroid=centroid(1,2);
    
    patch_bw=imcrop(im_bw,[x_centroid-max_long-35 ... 
                            y_centroid-max_long-35 ...
                            2*(max_long+35) ...
                            2*(max_long+35)]);
                        
    % Recorta la imagen original al tamaño de la Region de Interés (ROI)
    imzoom=imcrop(im1,[x_centroid-max_long-35 y_centroid-max_long-35 ...
                    2*(max_long+35) 2*(max_long+35)]);
    
    % Muestra la región de interés 
    figure, imshow(imzoom,[]);
    
    condition=true;
    
    while condition
        
        figure(2), imshow(imzoom,[],'InitialMagnification','fit'),
        title(['Imagen Magnificada ','(',filename,')']);
        im1_freehand =  drawfreehand(gca);
        
        % Crea una máscara de segmentación en la imágen "imzoom"
        mask = createMask(im1_freehand);
        
        % Elemento estructurante
        se = strel('disk',10); 
        
        %Dilata la máscara de segmentación
        maskdilate = imdilate(mask,se);
        
        %Reduce la máscara de segmentación
        maskerode = imerode(mask,se);
        
        %Máscaras sobrepuestas en la imagen "imzoom"
        maskoverlay=labeloverlay(imzoom,double(mask),'Colormap',...
                                [0 0 1],'Transparency',0.8);

        maskdilateoverlay=labeloverlay(imzoom,double(maskdilate),'Colormap',...
                                        [0 0 1],'Transparency',0.8);
                
        maskerodeoverlay=labeloverlay(imzoom,double(maskerode),'Colormap',...
                                        [0 0 1],'Transparency',0.8);

        % Figura con las imagenes en gris, los boxplot e histogramas
        figurasubplot=figure(1);
        
        
        subplot(3,3,1), imshow(maskoverlay), title('Original')
        subplot(3,3,2), imshow(maskdilateoverlay), title ('Dilatada')
        subplot(3,3,3), imshow(maskerodeoverlay), title ('Reducida')
        
        subplot(3,3,4), boxplot(imzoom(mask==0)),
        subplot(3,3,5), boxplot(imzoom(maskdilate==0)),
        subplot(3,3,6), boxplot(imzoom(maskerode==0)),
        
        nbins=50; %Número de bins del histograma
        
        subplot(3,3,7), histogram(imzoom(mask==0),nbins),
        subplot(3,3,8), histogram(imzoom(maskdilate==0),nbins),
        subplot(3,3,9), histogram(imzoom(maskerode==0),nbins),
        
        saveas(figurasubplot,[destpath,filename(1:length(filename)-4),'_figura.png'])
        
        imoverl=labeloverlay(imzoom,double(mask),'Colormap',[0 0 1],'Transparency',0.8);


        prompt = 'Es correcta la segmentacion? Si[1]  No[0] ';
        condition=input(prompt);
        condition=~condition;
        close all;
        clc;
        
    end
        
    % Nombre del archivo
    filename = filename(1:length(filename)-4);

    imwrite(imzoom,[destpath,filename,'imzoom.jpg'])
    imwrite(mask,[destpath,filename,'mask.jpg'])
    imwrite(maskdilate,[destpath,filename,'maskdilate.jpg'])
    imwrite(maskerode,[destpath,filename,'maskerode.jpg'])
    disp(['Se ha guardado la imagen de ', filename,' en el directorio'])
        
 
else
    
    close all;
    disp('No ha seleccionado nada')
   
end

