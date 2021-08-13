%%%%%%%%%%%%%%%%%%%%%
% Autor:    Andres Sandino
% e-mail:   asandino@unal.edu.co
% github:   asandino87
% Script:   Segmentación de imagenes de Rx 
% Versión:  2.0
% Fecha:    22/07/2021
% Matlab versión 2020b
%%%%%%%%%%%%%%%%%%%%%
a=0;
b=0;
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

imzoom = im1;

graph_grid(imzoom,200,1,'r')

condition=true;
    
    while condition
        figure('units','normalized','outerposition',[0 0 1 1]),
        %figure(2), 
        imshow(imzoom,[],'InitialMagnification','fit'), grid on,
        title(['Rx Paciente: ',filename]);
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
    filename = [filename(1:length(filename)-4),'b'];

    imwrite(maskoverlay,[destpath,filename,'imzoom.jpg'])
    imwrite(mask,[destpath,filename,'mask.jpg'])
    imwrite(maskdilate,[destpath,filename,'maskdilate.jpg'])
    imwrite(maskerode,[destpath,filename,'maskerode.jpg'])
    disp(['Se ha guardado la imagen de ', filename,' en el directorio'])
    
    function im_out=graph_grid(im_in,patchsize,esc,color)


[m,n] = size(im_in);

% tam_vent=200;    % El tamaño real es 10 veces más (2000 pix)
winsize=patchsize/esc;

col=floor(n/winsize);
row=floor(m/winsize);

im_in=imcrop(im_in,[1 1 winsize*col-1 winsize*row-1]);
% figure(1);
im_out=imshow(im_in,[],'InitialMagnification','fit');

hold on;

    for j=1:col

        % Grafica lineas verticales
        y=[1 m];
        x=[j*winsize j*winsize];
        hold on; plot(x,y,color);

    end

    for i=1:row
        % Grafica lineas horizontales
        x=[1 n];
        y=[i*winsize i*winsize];
        hold on; plot(x,y,color);
    end

end


        
 

