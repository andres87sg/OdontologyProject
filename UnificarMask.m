clc;
clear;
close all;


path = 'C:\Users\Andres\Documents\ProyectoInvestigacion\DatasetOdont\ImagenesOriginales\';
destpath = 'C:\Users\Andres\Documents\ProyectoInvestigacion\DatasetOdont\SegmDer\';
filenames = dir([path,'/*.png']);

listfiles={};

% Crea una lista con los pacientes
for i=1:length(filenames)
   
    listfiles{i,1}=filenames(i).name;
%     disp(listfiles);
    
end

% Fusiona las máscaras de segmentación de ambos pacientes

for i=1:length(filenames)

    try
    pathmask = 'C:\Users\Andres\Documents\ProyectoInvestigacion\DatasetOdont\Segmentaciones\';

    imgname = listfiles{i,1};
    patientname = imgname(1:length(imgname)-4);

    maskDer1 = [patientname,'_Der_exp1_mask','.jpg'];
    maskDer2 = [patientname,'_Der_exp2_mask','.jpg'];

    mask1 = imread([pathmask,maskDer1]);
    mask2 = imread([pathmask,maskDer2]);

    mask1 = mask1/max(mask1(:));
    mask2 = mask2/max(mask2(:));

    maskfinal = (mask1 .* mask2)*255;

    newfilename = [patientname,'_Der_mask'];

    imwrite(maskfinal,[destpath,newfilename,'.jpg']);
    
    catch 
        disp (patientname)
    
    end
end
 
% JACSON1_Der_exp1_mask
% JACSON1_Der_exp2_mask

