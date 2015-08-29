function QuantRaptorConeImages(Directory,Filename)
% Modified from CC's M-code in 2014
% Example: GetRaptorConeImages_UsingRadianceData('June07_lizards','20150607114429.409_8ms.3d_8.00ms')
% Example: GetRaptorConeImages_UsingRadianceData('Flounders/Blue','20150814104945.840_31ms.3d_31.00ms')
% Example: GetRaptorConeImages_UsingRadianceData('Flounders/Gravel','20150724110559.555_33ms.3d_33.00ms')
% Example: GetRaptorConeImages_UsingRadianceData('Flounders/Sand','20150730101055.833_42ms.3d_42.00ms')

load Buzzard4Cones.dat; % 4x16 (V,S,M,L) % load Buzzard4Cones.dat; % 1x16
load ChickenDoubleCone.dat; % 1x16 (very similar to PekinRobinDoubleCone, but more realistic) 
ChickenDoubleCone = ChickenDoubleCone/100; % make sensitivity range from 0 to 1
WaveNumber = ['360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'];

for i = 1:16
    ImgFileObject = [Directory,'/',Filename,'_',WaveNumber((i-1)*5+1:i*5),'_global.tiff']; 
    RefObjectImg(:,:,i) = imread(ImgFileObject,'tiff');
end

RefObjectImg = double(RefObjectImg)/2^16; % make image between 0 and 1

figure
for i = 1:16
    TempImg = RefObjectImg(:,:,i);
    inx1 = find(TempImg > 1); % find reflectance larger than one
    TempImg(inx1) = 1; % make reflectance larger than one equal 1 
    inx_nan = isnan(TempImg); % find NaN in the image file
    inx2 = find(inx_nan == 1);
    TempImg(inx2) = 0; % make reflectance NaN (because of noise) equal 0
    RefObjectImg(:,:,i) = TempImg; % reflectance range 0-1
    subplot(4,4,i), imshow(RefObjectImg(:,:,i)); title(WaveNumber((i-1)*5+1:i*5));
end
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 1,'\bf Radiance images of 16 bands','HorizontalAlignment','center','VerticalAlignment', 'top');

for i = 1:16
    Uimg(:,:,i) = RefObjectImg(:,:,i)*Buzzard4Cones(1,i); % use Up direction of light field
    Simg(:,:,i) = RefObjectImg(:,:,i)*Buzzard4Cones(2,i);
    Mimg(:,:,i) = RefObjectImg(:,:,i)*Buzzard4Cones(3,i);
    Limg(:,:,i) = RefObjectImg(:,:,i)*Buzzard4Cones(4,i);
    Dimg(:,:,i) = RefObjectImg(:,:,i)*ChickenDoubleCone(i); % double cone
end

Ucone = sum(Uimg,3); % summation across all wavelengths
Scone = sum(Simg,3);
Mcone = sum(Mimg,3);
Lcone = sum(Limg,3);
Dcone = sum(Dimg,3);

figure
RadImg(:,:,1) = Lcone;
RadImg(:,:,2) = Mcone;
RadImg(:,:,3) = Scone;
imshow(RadImg);

% x90 = prctile(Lcone(:),90)
% x50 = prctile(Lcone(:),50)

for i = 1:16
    Background(i) = mean2(RefObjectImg(:,:,i)); % average all reflectance spectra across the entire image
end

WhiteSurface = ones(1,16); % white surface for normalization purpose
BlackSurface = 0.01*ones(1,16); % black surface for normalization purpose

for i = 1:16
    U_bk(i) = Background(i)*Buzzard4Cones(1,i); 
    S_bk(i) = Background(i)*Buzzard4Cones(2,i);
    M_bk(i) = Background(i)*Buzzard4Cones(3,i);
    L_bk(i) = Background(i)*Buzzard4Cones(4,i);
    D_bk(i) = Background(i)*ChickenDoubleCone(i);
    U_White(i) = WhiteSurface(i)*Buzzard4Cones(1,i); 
    S_White(i) = WhiteSurface(i)*Buzzard4Cones(2,i);
    M_White(i) = WhiteSurface(i)*Buzzard4Cones(3,i);
    L_White(i) = WhiteSurface(i)*Buzzard4Cones(4,i);
    D_White(i) = WhiteSurface(i)*ChickenDoubleCone(i);
    U_Black(i) = BlackSurface(i)*Buzzard4Cones(1,i); 
    S_Black(i) = BlackSurface(i)*Buzzard4Cones(2,i);
    M_Black(i) = BlackSurface(i)*Buzzard4Cones(3,i);
    L_Black(i) = BlackSurface(i)*Buzzard4Cones(4,i);
    D_Black(i) = BlackSurface(i)*ChickenDoubleCone(i);
end

% make the quantal catch 0 equal the black surface quantal catch (to avoid log problem)
inxU = find(Ucone == 0);
Ucone(inxU) = sum(U_Black);
inxS = find(Scone == 0);
Scone(inxS) = sum(S_Black);
inxM = find(Mcone == 0);
Mcone(inxM) = sum(M_Black);
inxL = find(Lcone == 0);
Lcone(inxL) = sum(L_Black);
inxD = find(Dcone == 0);
Dcone(inxD) = sum(D_Black);

UconeAdp = log(Ucone/sum(U_bk)); % adapted to background and log-transformed (Ln)
SconeAdp = log(Scone/sum(S_bk)); 
MconeAdp = log(Mcone/sum(M_bk)); 
LconeAdp = log(Lcone/sum(L_bk)); 
DconeAdp = log(Dcone/sum(D_bk)); 

% normalized to a range from 0 to 1 (for display purpose), using black and white surfaces
UconeAdpNorm = (UconeAdp - log(sum(U_Black)/sum(U_bk)))/(log(sum(U_White)/sum(U_bk)) - log(sum(U_Black)/sum(U_bk)));
SconeAdpNorm = (SconeAdp - log(sum(S_Black)/sum(S_bk)))/(log(sum(S_White)/sum(S_bk)) - log(sum(S_Black)/sum(S_bk)));
MconeAdpNorm = (MconeAdp - log(sum(M_Black)/sum(M_bk)))/(log(sum(M_White)/sum(M_bk)) - log(sum(M_Black)/sum(M_bk)));
LconeAdpNorm = (LconeAdp - log(sum(L_Black)/sum(L_bk)))/(log(sum(L_White)/sum(L_bk)) - log(sum(L_Black)/sum(L_bk)));
DconeAdpNorm = (DconeAdp - log(sum(D_Black)/sum(D_bk)))/(log(sum(D_White)/sum(D_bk)) - log(sum(D_Black)/sum(D_bk)));

% % normalized to a range no larger than 1 (for display purpose), using only white surface
% UconeAdpNorm = UconeAdp/log(sum(U_White)/sum(U_bk));
% SconeAdpNorm = SconeAdp/log(sum(S_White)/sum(S_bk));
% MconeAdpNorm = MconeAdp/log(sum(M_White)/sum(M_bk));
% LconeAdpNorm = LconeAdp/log(sum(L_White)/sum(L_bk));
% DconeAdpNorm = DconeAdp/log(sum(D_White)/sum(D_bk));

figure
imshow(DconeAdpNorm); title('Double cone');

% if LightDirection == 1
%     OutFilename = [DateImg,'/',DirImg,'/PekinRobin_DCimg_up.tiff'];
%     imwrite(DconeAdpNorm,OutFilename,'tiff');
% else
%     ['NOTE: Files have not been saved. Other lighting direction?']
% end

% Edge detection (Laplacian of Gaussian (Stevens and Cuthill, PRSB 2006)
img1=edge_Otsu(DconeAdpNorm,'log',[],0.5); % adaptive thresholding (Otsu, 1979)
img2=edge_Otsu(DconeAdpNorm,'log',[],1);
img3=edge_Otsu(DconeAdpNorm,'log',[],1.5);
img4=edge_Otsu(DconeAdpNorm,'log',[],2);
img5=edge_Otsu(DconeAdpNorm,'log',[],2.5);
img6=edge_Otsu(DconeAdpNorm,'log',[],3);
img7=edge_Otsu(DconeAdpNorm,'log',[],3.5);
img8=edge_Otsu(DconeAdpNorm,'log',[],4);
img9=edge_Otsu(DconeAdpNorm,'log',[],4.5);
img10=edge_Otsu(DconeAdpNorm,'log',[],5);
img11=edge_Otsu(DconeAdpNorm,'log',[],5.5);
imgp1 = img1 & img2;
imgp2 = img2 & img3;
imgp3 = img3 & img4;
imgp4 = img4 & img5;
imgp5 = img5 & img6;
imgp6 = img6 & img7;
imgp7 = img7 & img8;
imgp8 = img8 & img9;
imgp9 = img9 & img10;
imgp10 = img10 & img11;
Dcone_img = double(imgp1+imgp2+imgp3+imgp4+imgp5+imgp6+imgp7+imgp8+imgp9+imgp10)./10;

figure
imshow(Dcone_img); title('Edge detection using Laplacian of Gaussian model');

% if LightDirection == 1
%     OutFilename = [DateImg,'/',DirImg,'/PekinRobin_DCimg_LoG_up.tiff'];
%     imwrite(Dcone_img,OutFilename,'tiff');
% else
% end

LMSimg(:,:,1) = LconeAdpNorm; LMSimg(:,:,2) = MconeAdpNorm; LMSimg(:,:,3) = SconeAdpNorm;
MSUimg(:,:,1) = MconeAdpNorm; MSUimg(:,:,2) = SconeAdpNorm; MSUimg(:,:,3) = UconeAdpNorm;
% UMSimg(:,:,1) = UconeAdpNorm; UMSimg(:,:,2) = MconeAdpNorm; UMSimg(:,:,3) = SconeAdpNorm;
% LUSimg(:,:,1) = LconeAdpNorm; LUSimg(:,:,2) = UconeAdpNorm; LUSimg(:,:,3) = SconeAdpNorm; 
% LMUimg(:,:,1) = LconeAdpNorm; LMUimg(:,:,2) = MconeAdpNorm; LMUimg(:,:,3) = UconeAdpNorm;

figure
subplot(2,2,1), imshow(UconeAdpNorm); title('V cone');
subplot(2,2,2), imshow(SconeAdpNorm); title('S cone');
subplot(2,2,3), imshow(MconeAdpNorm); title('M cone');
subplot(2,2,4), imshow(LconeAdpNorm); title('L cone');

figure
subplot(2,2,1), imshow(LMSimg); title('LMS');
subplot(2,2,2), imshow(MSUimg); title('MSV (Pseudo-UV image)');
% subplot(2,2,3), imshow(LUSimg); title('LUS');
% subplot(2,2,4), imshow(LMUimg); title('LMU');

% if LightDirection == 1
%     OutFilename1 = [DateImg,'/',DirImg,'/PekinRobin_LMSimg_up.tiff']; imwrite(LMSimg,OutFilename1,'tiff');
%     OutFilename2 = [DateImg,'/',DirImg,'/PekinRobin_UMSimg_up.tiff']; imwrite(UMSimg,OutFilename2,'tiff');
%     OutFilename3 = [DateImg,'/',DirImg,'/PekinRobin_LUSimg_up.tiff']; imwrite(LUSimg,OutFilename3,'tiff');
%     OutFilename4 = [DateImg,'/',DirImg,'/PekinRobin_LMUimg_up.tiff']; imwrite(LMUimg,OutFilename4,'tiff');
% else
% end

IsoUconeAdpNorm = UconeAdpNorm - (UconeAdpNorm+SconeAdpNorm+MconeAdpNorm+LconeAdpNorm)/4;
IsoSconeAdpNorm = SconeAdpNorm - (UconeAdpNorm+SconeAdpNorm+MconeAdpNorm+LconeAdpNorm)/4;
IsoMconeAdpNorm = MconeAdpNorm - (UconeAdpNorm+SconeAdpNorm+MconeAdpNorm+LconeAdpNorm)/4;
IsoLconeAdpNorm = LconeAdpNorm - (UconeAdpNorm+SconeAdpNorm+MconeAdpNorm+LconeAdpNorm)/4;

IsoLMSimg(:,:,1) = (IsoLconeAdpNorm+3/4)/(6/4); IsoLMSimg(:,:,2) = (IsoMconeAdpNorm+3/4)/(6/4); IsoLMSimg(:,:,3) = (IsoSconeAdpNorm+3/4)/(6/4);
IsoMSUimg(:,:,1) = (IsoMconeAdpNorm+3/4)/(6/4); IsoMSUimg(:,:,2) = (IsoSconeAdpNorm+3/4)/(6/4); IsoMSUimg(:,:,3) = (IsoUconeAdpNorm+3/4)/(6/4);
% IsoUMSimg(:,:,1) = (IsoUconeAdpNorm+3/4)/(6/4); IsoUMSimg(:,:,2) = (IsoMconeAdpNorm+3/4)/(6/4); IsoUMSimg(:,:,3) = (IsoSconeAdpNorm+3/4)/(6/4);
% IsoLUSimg(:,:,1) = (IsoLconeAdpNorm+3/4)/(6/4); IsoLUSimg(:,:,2) = (IsoUconeAdpNorm+3/4)/(6/4); IsoLUSimg(:,:,3) = (IsoSconeAdpNorm+3/4)/(6/4);
% IsoLMUimg(:,:,1) = (IsoLconeAdpNorm+3/4)/(6/4); IsoLMUimg(:,:,2) = (IsoMconeAdpNorm+3/4)/(6/4); IsoLMUimg(:,:,3) = (IsoUconeAdpNorm+3/4)/(6/4);

figure
subplot(2,2,1), imshow(IsoLMSimg); title('Iso-LMS');
subplot(2,2,2), imshow(IsoMSUimg); title('Iso-MSV (Pseudo-UV image)');
% subplot(2,2,3), imshow(IsoLUSimg); title('Iso-LUS');
% subplot(2,2,4), imshow(IsoLMUimg); title('Iso-LMU');

% if LightDirection == 1
%     OutFilename1 = [DateImg,'/',DirImg,'/PekinRobin_IsoLMSimg_up.tiff']; imwrite(IsoLMSimg,OutFilename1,'tiff');
%     OutFilename2 = [DateImg,'/',DirImg,'/PekinRobin_IsoUMSimg_up.tiff']; imwrite(IsoUMSimg,OutFilename2,'tiff');
%     OutFilename3 = [DateImg,'/',DirImg,'/PekinRobin_IsoLUSimg_up.tiff']; imwrite(IsoLUSimg,OutFilename3,'tiff');
%     OutFilename4 = [DateImg,'/',DirImg,'/PekinRobin_IsoLMUimg_up.tiff']; imwrite(IsoLMUimg,OutFilename4,'tiff');
% else
% end

% Edge detection (Laplacian of Gaussian (Stevens and Cuthill, PRSB 2006)
img1=edge_Otsu(IsoUconeAdpNorm,'log',[],0.5); % adaptive thresholding (Otsu, 1979)
img2=edge_Otsu(IsoUconeAdpNorm,'log',[],1);
img3=edge_Otsu(IsoUconeAdpNorm,'log',[],1.5);
img4=edge_Otsu(IsoUconeAdpNorm,'log',[],2);
img5=edge_Otsu(IsoUconeAdpNorm,'log',[],2.5);
img6=edge_Otsu(IsoUconeAdpNorm,'log',[],3);
img7=edge_Otsu(IsoUconeAdpNorm,'log',[],3.5);
img8=edge_Otsu(IsoUconeAdpNorm,'log',[],4);
img9=edge_Otsu(IsoUconeAdpNorm,'log',[],4.5);
img10=edge_Otsu(IsoUconeAdpNorm,'log',[],5);
img11=edge_Otsu(IsoUconeAdpNorm,'log',[],5.5);
imgp1 = img1 & img2;
imgp2 = img2 & img3;
imgp3 = img3 & img4;
imgp4 = img4 & img5;
imgp5 = img5 & img6;
imgp6 = img6 & img7;
imgp7 = img7 & img8;
imgp8 = img8 & img9;
imgp9 = img9 & img10;
imgp10 = img10 & img11;
IsoUconeEdge_img = double(imgp1+imgp2+imgp3+imgp4+imgp5+imgp6+imgp7+imgp8+imgp9+imgp10)./10;

img1=edge_Otsu(IsoSconeAdpNorm,'log',[],0.5); % adaptive thresholding (Otsu, 1979)
img2=edge_Otsu(IsoSconeAdpNorm,'log',[],1);
img3=edge_Otsu(IsoSconeAdpNorm,'log',[],1.5);
img4=edge_Otsu(IsoSconeAdpNorm,'log',[],2);
img5=edge_Otsu(IsoSconeAdpNorm,'log',[],2.5);
img6=edge_Otsu(IsoSconeAdpNorm,'log',[],3);
img7=edge_Otsu(IsoSconeAdpNorm,'log',[],3.5);
img8=edge_Otsu(IsoSconeAdpNorm,'log',[],4);
img9=edge_Otsu(IsoSconeAdpNorm,'log',[],4.5);
img10=edge_Otsu(IsoSconeAdpNorm,'log',[],5);
img11=edge_Otsu(IsoSconeAdpNorm,'log',[],5.5);
imgp1 = img1 & img2;
imgp2 = img2 & img3;
imgp3 = img3 & img4;
imgp4 = img4 & img5;
imgp5 = img5 & img6;
imgp6 = img6 & img7;
imgp7 = img7 & img8;
imgp8 = img8 & img9;
imgp9 = img9 & img10;
imgp10 = img10 & img11;
IsoSconeEdge_img = double(imgp1+imgp2+imgp3+imgp4+imgp5+imgp6+imgp7+imgp8+imgp9+imgp10)./10;

img1=edge_Otsu(IsoMconeAdpNorm,'log',[],0.5); % adaptive thresholding (Otsu, 1979)
img2=edge_Otsu(IsoMconeAdpNorm,'log',[],1);
img3=edge_Otsu(IsoMconeAdpNorm,'log',[],1.5);
img4=edge_Otsu(IsoMconeAdpNorm,'log',[],2);
img5=edge_Otsu(IsoMconeAdpNorm,'log',[],2.5);
img6=edge_Otsu(IsoMconeAdpNorm,'log',[],3);
img7=edge_Otsu(IsoMconeAdpNorm,'log',[],3.5);
img8=edge_Otsu(IsoMconeAdpNorm,'log',[],4);
img9=edge_Otsu(IsoMconeAdpNorm,'log',[],4.5);
img10=edge_Otsu(IsoMconeAdpNorm,'log',[],5);
img11=edge_Otsu(IsoMconeAdpNorm,'log',[],5.5);
imgp1 = img1 & img2;
imgp2 = img2 & img3;
imgp3 = img3 & img4;
imgp4 = img4 & img5;
imgp5 = img5 & img6;
imgp6 = img6 & img7;
imgp7 = img7 & img8;
imgp8 = img8 & img9;
imgp9 = img9 & img10;
imgp10 = img10 & img11;
IsoMconeEdge_img = double(imgp1+imgp2+imgp3+imgp4+imgp5+imgp6+imgp7+imgp8+imgp9+imgp10)./10;

img1=edge_Otsu(IsoLconeAdpNorm,'log',[],0.5); % adaptive thresholding (Otsu, 1979)
img2=edge_Otsu(IsoLconeAdpNorm,'log',[],1);
img3=edge_Otsu(IsoLconeAdpNorm,'log',[],1.5);
img4=edge_Otsu(IsoLconeAdpNorm,'log',[],2);
img5=edge_Otsu(IsoLconeAdpNorm,'log',[],2.5);
img6=edge_Otsu(IsoLconeAdpNorm,'log',[],3);
img7=edge_Otsu(IsoLconeAdpNorm,'log',[],3.5);
img8=edge_Otsu(IsoLconeAdpNorm,'log',[],4);
img9=edge_Otsu(IsoLconeAdpNorm,'log',[],4.5);
img10=edge_Otsu(IsoLconeAdpNorm,'log',[],5);
img11=edge_Otsu(IsoLconeAdpNorm,'log',[],5.5);
imgp1 = img1 & img2;
imgp2 = img2 & img3;
imgp3 = img3 & img4;
imgp4 = img4 & img5;
imgp5 = img5 & img6;
imgp6 = img6 & img7;
imgp7 = img7 & img8;
imgp8 = img8 & img9;
imgp9 = img9 & img10;
imgp10 = img10 & img11;
IsoLconeEdge_img = double(imgp1+imgp2+imgp3+imgp4+imgp5+imgp6+imgp7+imgp8+imgp9+imgp10)./10;

figure
subplot(2,2,1), imshow(IsoUconeEdge_img); title('Iso V-cone');
subplot(2,2,2), imshow(IsoSconeEdge_img); title('Iso S-cone'); 
subplot(2,2,3), imshow(IsoMconeEdge_img); title('Iso M-cone');
subplot(2,2,4), imshow(IsoLconeEdge_img); title('Iso L-cone');

% if LightDirection == 1
%     OutFilename1 = [DateImg,'/',DirImg,'/PekinRobin_IsoUcone_LoG_up.tiff']; imwrite(IsoUconeEdge_img,OutFilename1,'tiff');
%     OutFilename2 = [DateImg,'/',DirImg,'/PekinRobin_IsoScone_LoG_up.tiff']; imwrite(IsoSconeEdge_img,OutFilename2,'tiff');
%     OutFilename3 = [DateImg,'/',DirImg,'/PekinRobin_IsoMcone_LoG_up.tiff']; imwrite(IsoMconeEdge_img,OutFilename3,'tiff');
%     OutFilename4 = [DateImg,'/',DirImg,'/PekinRobin_IsoLcone_LoG_up.tiff']; imwrite(IsoLconeEdge_img,OutFilename4,'tiff');
% else
% end

% Compute tetrachromatic distances in bird color space
% Source: Equation 8 in Vorobyev et al JCPA 1998
% Model assumptions (Leiothrix lutea UV, S, M, L at 1:2:2:4, Maier and Bowmaker 1993)
Pc1 = 1; % Estimated proportion of U Cone
Pc2 = 2; % Estimated proportion of S Cone
Pc3 = 2; % Estimated proportion of M Cone
Pc4 = 4; % Estimated proportion of L Cone
w4 = 0.1; % Weber fraction estimate of L Cone (the data based on Leiothrix lutea, Maier 1992)
w1 = w4/(sqrt(Pc1)/sqrt(Pc4)); % Weber fraction estimate of U Cone
w2 = w4/(sqrt(Pc2)/sqrt(Pc4)); % Weber fraction estimate of S Cone
w3 = w4/(sqrt(Pc2)/sqrt(Pc4)); % Weber fraction estimate of M Cone

% compare to average of the image
df1 = UconeAdp - mean2(UconeAdp); 
df2 = SconeAdp - mean2(SconeAdp);
df3 = MconeAdp - mean2(MconeAdp);
df4 = LconeAdp - mean2(LconeAdp);

TetraDist = sqrt(((w1*w2)^2*(df4-df3).^2+(w1*w3)^2*(df4-df2).^2+(w1*w4)^2*(df3-df2).^2+(w2*w3)^2*(df4-df1).^2+(w2*w4)^2*(df3-df1).^2+(w3*w4)^2*(df2-df1).^2)/((w1*w2*w3)^2+(w1*w2*w4)^2+(w1*w3*w4)^2+(w2*w3*w4)^2));
TetraDist(find(TetraDist > 10)) = 10; % get rid of image artifacts (JND value above 10)

figure
% colormap(gray)
imagesc(TetraDist); axis off; axis image;
colorbar;

AvgTetraDist_AllImage = mean(TetraDist(:))

% compare to specific background
figure
colormap(gray)
imagesc(MconeAdp); % display the image for selecting BACKGROUND area

rect = getrect; % get the rectangle region as a background
h = imfreehand;
BW_Animal = createMask(h);
close(gcf);
BK_U_Comp = mean2(UconeAdp(round(rect(2)):round(rect(2))+round(rect(4)),round(rect(1)):round(rect(1))+round(rect(3))));
BK_S_Comp = mean2(SconeAdp(round(rect(2)):round(rect(2))+round(rect(4)),round(rect(1)):round(rect(1))+round(rect(3))));
BK_M_Comp = mean2(MconeAdp(round(rect(2)):round(rect(2))+round(rect(4)),round(rect(1)):round(rect(1))+round(rect(3))));
BK_L_Comp = mean2(LconeAdp(round(rect(2)):round(rect(2))+round(rect(4)),round(rect(1)):round(rect(1))+round(rect(3))));
df1 = UconeAdp - BK_U_Comp; 
df2 = SconeAdp - BK_S_Comp;
df3 = MconeAdp - BK_M_Comp;
df4 = LconeAdp - BK_L_Comp;

TetraDist = sqrt(((w1*w2)^2*(df4-df3).^2+(w1*w3)^2*(df4-df2).^2+(w1*w4)^2*(df3-df2).^2+(w2*w3)^2*(df4-df1).^2+(w2*w4)^2*(df3-df1).^2+(w3*w4)^2*(df2-df1).^2)/((w1*w2*w3)^2+(w1*w2*w4)^2+(w1*w3*w4)^2+(w2*w3*w4)^2));
TetraDist(find(TetraDist > 10)) = 10; % get rid of image artifacts (JND value above 10)

figure
% colormap(gray)
imagesc(TetraDist); axis off; axis image;
colorbar;

% AvgTetraDist_SelectedBackground = mean(TetraDist(:))

AnimalOnly = TetraDist.*BW_Animal;
AvgTetraDist_AnimalVsBackground = sum(AnimalOnly(:))/sum(BW_Animal(:))


end