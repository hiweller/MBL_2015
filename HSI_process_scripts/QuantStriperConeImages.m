function [AvgTetraDist_AllImage, AvgTetraDist_AnimalVsBackground] = QuantStriperConeImages(Directory,GlobalRefImg)
% Modified from CC's M-code in 2014
% Example: QuantBuzzardConeImages('ConeImages', 'GlobalRefFile')

load Striper2Cones.dat; % 4x16 (V,S,M,L) % load Striper2Cones.dat; % 1x16
% load ChickenDoubleCone.dat; % 1x16 (very similar to PekinRobinDoubleCone, but more realistic) 
% ChickenDoubleCone = ChickenDoubleCone/100; % make sensitivity range from 0 to 1
WaveNumber = ['360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'];
RefObjectImg = importdata([Directory, '/', GlobalRefImg], 1);

% figure
for i = 1:16
    TempImg = RefObjectImg(:,:,i);
    inx1 = find(TempImg > 1); % find reflectance larger than one
    TempImg(inx1) = 1; % make reflectance larger than one equal 1 
    TempImg(isnan(TempImg)) = 0; % find NaN in the image file
    % make reflectance NaN (because of noise) equal 0
    RefObjectImg(:,:,i) = TempImg; % reflectance range 0-1
end

for i = 1:16
    Simg(:,:,i) = RefObjectImg(:,:,i)*Striper2Cones(1,i); % use Up direction of light field
    Limg(:,:,i) = RefObjectImg(:,:,i)*Striper2Cones(2,i);
%     Mimg(:,:,i) = RefObjectImg(:,:,i)*Striper2Cones(3,i);
%     Limg(:,:,i) = RefObjectImg(:,:,i)*Striper2Cones(4,i);
%     Dimg(:,:,i) = RefObjectImg(:,:,i)*ChickenDoubleCone(i); % double cone
end

Scone = sum(Simg,3); % summation across all wavelengths
Lcone = sum(Limg,3);
% Mcone = sum(Mimg,3);
% Lcone = sum(Limg,3);
% Dcone = sum(Dimg,3);

figure
RadImg(:,:,1) = Lcone;
RadImg(:,:,2) = Lcone;
RadImg(:,:,3) = Scone;
imshow(RadImg);

for i = 1:16
    Background(i) = mean2(RefObjectImg(:,:,i)); % average all reflectance spectra across the entire image
end

WhiteSurface = ones(1,16); % white surface for normalization purpose
BlackSurface = 0.01*ones(1,16); % black surface for normalization purpose

for i = 1:16
    S_bk(i) = Background(i)*Striper2Cones(1,i); 
    L_bk(i) = Background(i)*Striper2Cones(2,i);
%     M_bk(i) = Background(i)*Striper2Cones(3,i);
%     L_bk(i) = Background(i)*Striper2Cones(4,i);
%     D_bk(i) = Background(i)*ChickenDoubleCone(i);
    S_White(i) = WhiteSurface(i)*Striper2Cones(1,i); 
    L_White(i) = WhiteSurface(i)*Striper2Cones(2,i);
%     M_White(i) = WhiteSurface(i)*Striper2Cones(3,i);
%     L_White(i) = WhiteSurface(i)*Striper2Cones(4,i);
%     D_White(i) = WhiteSurface(i)*ChickenDoubleCone(i);
    S_Black(i) = BlackSurface(i)*Striper2Cones(1,i); 
    L_Black(i) = BlackSurface(i)*Striper2Cones(2,i);
%     M_Black(i) = BlackSurface(i)*Striper2Cones(3,i);
%     L_Black(i) = BlackSurface(i)*Striper2Cones(4,i);
%     D_Black(i) = BlackSurface(i)*ChickenDoubleCone(i);
end

% make the quantal catch 0 equal the black surface quantal catch (to avoid log problem)
inxS = find(Scone == 0);
Scone(inxS) = sum(S_Black);
inxL = find(Lcone == 0);
Lcone(inxL) = sum(L_Black);
% inxM = find(Mcone == 0);
% Mcone(inxM) = sum(M_Black);
% inxL = find(Lcone == 0);
% Lcone(inxL) = sum(L_Black);
% inxD = find(Dcone == 0);
% Dcone(inxD) = sum(D_Black);

SconeAdp = log(Scone/sum(S_bk)); % adapted to background and log-transformed (Ln)
LconeAdp = log(Lcone/sum(L_bk)); 
% MconeAdp = log(Mcone/sum(M_bk)); 
% LconeAdp = log(Lcone/sum(L_bk)); 
% DconeAdp = log(Dcone/sum(D_bk)); 

% normalized to a range from 0 to 1 (for display purpose), using black and white surfaces
SconeAdpNorm = (SconeAdp - log(sum(S_Black)/sum(S_bk)))/(log(sum(S_White)/sum(S_bk)) - log(sum(S_Black)/sum(S_bk)));
LconeAdpNorm = (LconeAdp - log(sum(L_Black)/sum(L_bk)))/(log(sum(L_White)/sum(L_bk)) - log(sum(L_Black)/sum(L_bk)));
% MconeAdpNorm = (MconeAdp - log(sum(M_Black)/sum(M_bk)))/(log(sum(M_White)/sum(M_bk)) - log(sum(M_Black)/sum(M_bk)));
% LconeAdpNorm = (LconeAdp - log(sum(L_Black)/sum(L_bk)))/(log(sum(L_White)/sum(L_bk)) - log(sum(L_Black)/sum(L_bk)));
% DconeAdpNorm = (DconeAdp - log(sum(D_Black)/sum(D_bk)))/(log(sum(D_White)/sum(D_bk)) - log(sum(D_Black)/sum(D_bk)));

figure
imshow(LconeAdpNorm); title('Double cone');

% Edge detection (Laplacian of Gaussian (Stevens and Cuthill, PRSB 2006)
for i = 1:11
    img(:,:,i) = edge_Otsu(LconeAdpNorm, 'log', [], (i/2)); % adaptive thresholding (Otsu, 1979)
end
for i = 1:10
    imgp(:,:,i) = img(:,:,i) & img(:,:,(i+1));
end
Lcone_img = double(imgp(:,:,1)+imgp(:,:,2)+imgp(:,:,3)+imgp(:,:,4)+imgp(:,:,5)+imgp(:,:,6)+imgp(:,:,7)+imgp(:,:,8)+imgp(:,:,9)+imgp(:,:,10))./10;

figure
imshow(Lcone_img); title('Edge detection using Laplacian of Gaussian model');

LMSimg(:,:,1) = LconeAdpNorm; LMSimg(:,:,2) = LconeAdpNorm; LMSimg(:,:,3) = SconeAdpNorm;
% MSUimg(:,:,1) = MconeAdpNorm; MSUimg(:,:,2) = SconeAdpNorm; MSUimg(:,:,3) = UconeAdpNorm;

% figure
% subplot(2,2,1), imshow(UconeAdpNorm); title('V cone');
% subplot(2,2,2), imshow(SconeAdpNorm); title('S cone');
% subplot(2,2,3), imshow(MconeAdpNorm); title('M cone');
% subplot(2,2,4), imshow(LconeAdpNorm); title('L cone');

% figure
% subplot(1,2,1), imshow(LMSimg); title('LMS');
% subplot(1,2,2), imshow(MSUimg); title('MSV (Pseudo-UV image)');

% IsoUconeAdpNorm = UconeAdpNorm - (UconeAdpNorm+SconeAdpNorm+MconeAdpNorm+LconeAdpNorm)/4;
IsoSconeAdpNorm = SconeAdpNorm - (SconeAdpNorm+LconeAdpNorm)/2;
% IsoMconeAdpNorm = MconeAdpNorm - (UconeAdpNorm+SconeAdpNorm+MconeAdpNorm+LconeAdpNorm)/4;
IsoLconeAdpNorm = LconeAdpNorm - (SconeAdpNorm+LconeAdpNorm)/2;

IsoLMSimg(:,:,1) = (IsoLconeAdpNorm+3/4)/(6/4); IsoLMSimg(:,:,2) = (IsoLconeAdpNorm+3/4)/(6/4); IsoLMSimg(:,:,3) = (IsoSconeAdpNorm+3/4)/(6/4);
% IsoMSUimg(:,:,1) = (IsoMconeAdpNorm+3/4)/(6/4); IsoMSUimg(:,:,2) = (IsoSconeAdpNorm+3/4)/(6/4); IsoMSUimg(:,:,3) = (IsoUconeAdpNorm+3/4)/(6/4);

% figure
% subplot(1,2,1), imshow(IsoLMSimg); title('Iso-LMS');
% subplot(1,2,2), imshow(IsoMSUimg); title('Iso-MSV (Pseudo-UV image)');

% Edge detection (Laplacian of Gaussian (Stevens and Cuthill, PRSB 2006)
for i = 1:11 % adaptive thresholding (Otsu, 1979)
%     imgU(:,:,i) = edge_Otsu(IsoUconeAdpNorm, 'log', [], (i/2));
    imgS(:,:,i) = edge_Otsu(IsoSconeAdpNorm, 'log', [], (i/2));
%     imgM(:,:,i) = edge_Otsu(IsoMconeAdpNorm, 'log', [], (i/2));
    imgL(:,:,i) = edge_Otsu(IsoLconeAdpNorm, 'log', [], (i/2));
end
for i = 1:10
%     imgpU(:,:,i) = imgU(:,:,i) & imgU(:,:,(i+1));
    imgpS(:,:,i) = imgS(:,:,i) & imgS(:,:,(i+1));
%     imgpM(:,:,i) = imgM(:,:,i) & imgM(:,:,(i+1));
    imgpL(:,:,i) = imgL(:,:,i) & imgL(:,:,(i+1));
end
% IsoUconeEdge_img = double(imgpU(:,:,1)+imgpU(:,:,2)+imgpU(:,:,3)+imgpU(:,:,4)+imgpU(:,:,5)+imgpU(:,:,6)+imgpU(:,:,7)+imgpU(:,:,8)+imgpU(:,:,9)+imgpU(:,:,10))./10;
% IsoMconeEdge_img = double(imgpM(:,:,1)+imgpM(:,:,2)+imgpM(:,:,3)+imgpM(:,:,4)+imgpM(:,:,5)+imgpM(:,:,6)+imgpM(:,:,7)+imgpM(:,:,8)+imgpM(:,:,9)+imgpM(:,:,10))./10;
IsoSconeEdge_img = double(imgpS(:,:,1)+imgpS(:,:,2)+imgpS(:,:,3)+imgpS(:,:,4)+imgpS(:,:,5)+imgpS(:,:,6)+imgpS(:,:,7)+imgpS(:,:,8)+imgpS(:,:,9)+imgpS(:,:,10))./10;
IsoLconeEdge_img = double(imgpL(:,:,1)+imgpL(:,:,2)+imgpL(:,:,3)+imgpL(:,:,4)+imgpL(:,:,5)+imgpL(:,:,6)+imgpL(:,:,7)+imgpL(:,:,8)+imgpL(:,:,9)+imgpL(:,:,10))./10;

figure
% subplot(2,2,1), imshow(IsoUconeEdge_img); title('Iso V-cone');
subplot(2,2,2), imshow(IsoSconeEdge_img); title('Iso S-cone'); 
% subplot(2,2,3), imshow(IsoMconeEdge_img); title('Iso M-cone');
subplot(2,2,4), imshow(IsoLconeEdge_img); title('Iso L-cone');

% Compute tetrachromatic distances in bird color space
% Source: Equation 8 in Vorobyev et al JCPA 1998
% Model assumptions (Leiothrix lutea UV, S, M, L at 1:2:2:4, Maier and Bowmaker 1993)
Pc1 = 1; % Estimated proportion of U Cone
Pc2 = 1; % Estimated proportion of S Cone
% Pc3 = 2; % Estimated proportion of M Cone
% Pc4 = 4; % Estimated proportion of L Cone
w4 = 0.1; % Weber fraction estimate of L Cone (the data based on Leiothrix lutea, Maier 1992)
% w1 = w4/(sqrt(Pc1)/sqrt(Pc4)); % Weber fraction estimate of U Cone
w2 = w4/(sqrt(Pc2)/sqrt(Pc2)); % Weber fraction estimate of S Cone
% w3 = w4/(sqrt(Pc2)/sqrt(Pc4)); % Weber fraction estimate of M Cone

noart = importdata(['Masks/GeneralMask_SegImg_', GlobalRefImg, '.png.mat']);

% compare to average of the image
% df1 = SconeAdp - mean2(SconeAdp.*noart); 
df2 = SconeAdp - mean2(SconeAdp.*noart);
% df3 = MconeAdp - mean2(MconeAdp.*noart);
df4 = LconeAdp - mean2(LconeAdp.*noart);

% TetraDist = sqrt(((w1*w2)^2*(df4-df3).^2+(w1*w3)^2*(df4-df2).^2+(w1*w4)^2*(df3-df2).^2+(w2*w3)^2*(df4-df1).^2+(w2*w4)^2*(df3-df1).^2+(w3*w4)^2*(df2-df1).^2)/((w1*w2*w3)^2+(w1*w2*w4)^2+(w1*w3*w4)^2+(w2*w3*w4)^2));
TetraDist = sqrt((df2-df4).^2/(w2^2+w4^2));
TetraDist(find(TetraDist > 10)) = 10; % get rid of image artifacts (JND value above 10)

figure
% colormap(gray)
imagesc(TetraDist); axis off; axis image;
colorbar;

AvgTetraDist_AllImage = mean(TetraDist(:))

rect = importdata(['Masks/BGMask_SegImg_', GlobalRefImg, '.png.mat']);
BW_Animal = importdata(['Masks/AnimalMask_SegImg_', GlobalRefImg, '.png.mat']);

% BK_U_Comp = mean2(SconeAdp.*rect);
BK_S_Comp = mean2(SconeAdp.*rect);
% BK_M_Comp = mean2(MconeAdp.*rect);
BK_L_Comp = mean2(LconeAdp.*rect);

% df1 = SconeAdp - BK_U_Comp; 
df2 = SconeAdp - BK_S_Comp;
% df3 = MconeAdp - BK_M_Comp;
df4 = LconeAdp - BK_L_Comp;

% TetraDist = sqrt(((w1*w2)^2*(df4-df3).^2+(w1*w3)^2*(df4-df2).^2+(w1*w4)^2*(df3-df2).^2+(w2*w3)^2*(df4-df1).^2+(w2*w4)^2*(df3-df1).^2+(w3*w4)^2*(df2-df1).^2)/((w1*w2*w3)^2+(w1*w2*w4)^2+(w1*w3*w4)^2+(w2*w3*w4)^2));
TetraDist = sqrt((df2-df4).^2/(w2^2+w4^2));
TetraDist(find(TetraDist > 10)) = 10; % get rid of image artifacts (JND value above 10)

figure
% colormap(gray)
imagesc(TetraDist); axis off; axis image;

colorbar;

% AvgTetraDist_SelectedBackground = mean(TetraDist(:))

AnimalOnly = TetraDist.*BW_Animal;
AvgTetraDist_AnimalVsBackground = sum(AnimalOnly(:))/sum(BW_Animal(:))


end