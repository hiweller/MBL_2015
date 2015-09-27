function [TetraDist, AnimalOnly] = QuantBuzzardConeImages(Directory,Rad4Umat)
% Modified from CC's M-code in 2014
% Example: QuantBuzzardConeImages('ConeImages', 'GlobalRefFile')
load('BadPixelMask.mat');
load Buzzard4Cones.dat; % 4x16 (V,S,M,L) % load Buzzard4Cones.dat; % 1x16
load ChickenDoubleCone.dat; % 1x16 (very similar to PekinRobinDoubleCone, but more realistic) 
ChickenDoubleCone = ChickenDoubleCone/100; % make sensitivity range from 0 to 1
WaveNumber = ['360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'];
% RefObjectImg = importdata([Directory, '/', GlobalRefImg], 1);
load([Directory, '/', Rad4Umat]);
RefObjectImg = BandImg;

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

rect = importdata(['Masks/BGMask_SegImg_', Rad4Umat]);
rect = rect.*BadPixelMask;
BW_Animal = importdata(['Masks/AnimalMask_SegImg_', Rad4Umat]);
BW_Animal = BW_Animal.*BadPixelMask;

BK_U_Comp = mean2(UconeAdp.*rect);
BK_S_Comp = mean2(SconeAdp.*rect);
BK_M_Comp = mean2(MconeAdp.*rect);
BK_L_Comp = mean2(LconeAdp.*rect);

df1 = UconeAdp - BK_U_Comp; 
df2 = SconeAdp - BK_S_Comp;
df3 = MconeAdp - BK_M_Comp;
df4 = LconeAdp - BK_L_Comp;

TetraDist = sqrt(((w1*w2)^2*(df4-df3).^2+(w1*w3)^2*(df4-df2).^2+(w1*w4)^2*(df3-df2).^2+(w2*w3)^2*(df4-df1).^2+(w2*w4)^2*(df3-df1).^2+(w3*w4)^2*(df2-df1).^2)/((w1*w2*w3)^2+(w1*w2*w4)^2+(w1*w3*w4)^2+(w2*w3*w4)^2));
TetraDist(find(TetraDist > 10)) = 10;% get rid of image artifacts (JND value above 10)
TetraDist = TetraDist.*BadPixelMask;

figure
% colormap(gray)
imagesc(TetraDist); axis off; axis image;

colorbar;

% AvgTetraDist_SelectedBackground = mean(TetraDist(:))

AnimalOnly = TetraDist.*BW_Animal;
AvgTetraDist_AnimalVsBackground = sum(AnimalOnly(:))/sum(BW_Animal(:))
save([Directory, '/JND/Raptor_', Rad4Umat], 'TetraDist');

end