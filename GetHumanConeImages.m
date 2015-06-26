function GetHumanConeImages(DateImg,DirImg,DateLight,LightNum,LightDirection)
% Example: GetHumanConeImages('Aug21','2014-08-21-10hr36min06sec-HLgain','Aug7',1,1)
% LightDirection = [up, north, east, south, west, north45, east45, south45, west45]

load StilesBurch10degCMFs.dat; % 3x16, L,M,S

ImgFilename = [DateImg,'/',DirImg,'/',DirImg,'_Global_Ref'];
LightFilename = ['../OceanOptics/',DateLight,'/LightField',num2str(LightNum)];
load(ImgFilename);
load(LightFilename);

figure
for i = 1:16
    TempImg = RefObjectImg(:,:,i);
    inx1 = find(TempImg > 1); % find reflectance larger than one
    x1 = length(inx1);
    TempImg(inx1) = 1; % make reflectance larger than one equal 1 
    inx_nan = isnan(TempImg); % find NaN in the image file
    inx2 = find(inx_nan == 1);
    x2 = length(inx2);
%     OutLierNumber = [x1, x2] % report the number of outliers 
    TempImg(inx2) = 0; % make reflectance NaN (because of noise) equal 0
    RefObjectImg(:,:,i) = TempImg; % reflectance range 0-1
    subplot(4,4,i), imshow(RefObjectImg(:,:,i));
end
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 1,'\bf Reflectance images of 16 bands','HorizontalAlignment','center','VerticalAlignment', 'top');

for i = 1:16
    Simg(:,:,i) = RefObjectImg(:,:,i)*LightField(1,i)*StilesBurch10degCMFs(3,i); % use Up direction of light field
    Mimg(:,:,i) = RefObjectImg(:,:,i)*LightField(1,i)*StilesBurch10degCMFs(2,i);
    Limg(:,:,i) = RefObjectImg(:,:,i)*LightField(1,i)*StilesBurch10degCMFs(1,i);
end

Scone = sum(Simg,3); % summation across all wavelengths
Mcone = sum(Mimg,3);
Lcone = sum(Limg,3);

Scone = Scone/(LightField(1,:)*StilesBurch10degCMFs(3,:)'); % normalized to white surface (reflectance = 1)
Mcone = Mcone/(LightField(1,:)*StilesBurch10degCMFs(2,:)');
Lcone = Lcone/(LightField(1,:)*StilesBurch10degCMFs(1,:)');

LMSimg(:,:,1) = Lcone; LMSimg(:,:,2) = Mcone; LMSimg(:,:,3) = Scone;

figure
subplot(2,2,1), imshow(Scone); title('S cone');
subplot(2,2,2), imshow(Mcone); title('M cone');
subplot(2,2,3), imshow(Lcone); title('L cone');
subplot(2,2,4), imshow(LMSimg); title('LMS');

if LightDirection == 1
    OutFilename = [DateImg,'/',DirImg,'/Human_LMSimg_up.tiff']; imwrite(LMSimg,OutFilename,'tiff');
else
    ['NOTE: Files have not been saved. Other lighting direction?']
end

IsoScone = Scone - (Scone+Mcone+Lcone)/3;
IsoMcone = Mcone - (Scone+Mcone+Lcone)/3;
IsoLcone = Lcone - (Scone+Mcone+Lcone)/3;
IsoLMSimg(:,:,1) = (IsoLcone+2/3)/(4/3); IsoLMSimg(:,:,2) = (IsoMcone+2/3)/(4/3); IsoLMSimg(:,:,3) = (IsoScone+2/3)/(4/3);

figure
imshow(IsoLMSimg); title('Isoluminant image');

if LightDirection == 1
    OutFilename = [DateImg,'/',DirImg,'/Human_IsoLMSimg_up.tiff']; imwrite(IsoLMSimg,OutFilename,'tiff');
else
end

end