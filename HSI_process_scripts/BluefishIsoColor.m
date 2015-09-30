function [PctUconeEdge, PctSconeEdge, PctMconeEdge, PctLconeEdge] = BluefishIsoColor(Directory, Rad4Umat)
load Bluefish4Cones.dat % 4x16 (UV, S, M, L)
load BadPixelMask.mat;
load([Directory, '/', Rad4Umat]);
RefObjectImg = BandImg;
AniMask = importdata(['Masks/AnimalMask_SegImg_', Rad4Umat]);
% plot 16 channels individually

for i = 1:16
    TempImg = RefObjectImg(:,:,i);
    inx1 = find(TempImg > 1); % find reflectance larger than one
    TempImg(inx1) = 1;% make reflectance larger than one equal 1 
    TempImg(isnan(TempImg)) = 0; % set NaNs equal to 0 (because of noise)
    RefObjectImg(:,:,i) = TempImg; % reflectance range 0-1
end

% get color information for bluefish cones
for i = 1:16
    Uimg(:,:,i) = RefObjectImg(:,:,i)*Bluefish4Cones(1,i);
    Simg(:,:,i) = RefObjectImg(:,:,i)*Bluefish4Cones(2,i);
    Mimg(:,:,i) = RefObjectImg(:,:,i)*Bluefish4Cones(3,i);
    Limg(:,:,i) = RefObjectImg(:,:,i)*Bluefish4Cones(4,i);
end

Ucone = sum(Uimg,3); % summation across all wavelengths
Scone = sum(Simg,3);
Mcone = sum(Mimg,3);
Lcone = sum(Limg,3);

for i = 1:16
    Background(i) = mean2(RefObjectImg(:,:,i)); % average all reflectance spectra across the entire image
end

WhiteSurface = ones(1,16); % white surface for normalization purpose
BlackSurface = 0.01*ones(1,16); % black surface for normalization purpose

for i = 1:16
    U_bk(i) = Background(i)*Bluefish4Cones(1,i); 
    S_bk(i) = Background(i)*Bluefish4Cones(2,i);
    M_bk(i) = Background(i)*Bluefish4Cones(3,i);
    L_bk(i) = Background(i)*Bluefish4Cones(4,i);
    U_White(i) = WhiteSurface(i)*Bluefish4Cones(1,i); 
    S_White(i) = WhiteSurface(i)*Bluefish4Cones(2,i);
    M_White(i) = WhiteSurface(i)*Bluefish4Cones(3,i);
    L_White(i) = WhiteSurface(i)*Bluefish4Cones(4,i);
    U_Black(i) = BlackSurface(i)*Bluefish4Cones(1,i); 
    S_Black(i) = BlackSurface(i)*Bluefish4Cones(2,i);
    M_Black(i) = BlackSurface(i)*Bluefish4Cones(3,i);
    L_Black(i) = BlackSurface(i)*Bluefish4Cones(4,i);
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

UconeAdp = log(Ucone/sum(U_bk)); % adapted to background and log-transformed (Ln)
SconeAdp = log(Scone/sum(S_bk)); 
MconeAdp = log(Mcone/sum(M_bk)); 
LconeAdp = log(Lcone/sum(L_bk));  

% normalized to a range from 0 to 1 (for display purpose), using black and white surfaces
UconeAdpNorm = (UconeAdp - log(sum(U_Black)/sum(U_bk)))/(log(sum(U_White)/sum(U_bk)) - log(sum(U_Black)/sum(U_bk)));
SconeAdpNorm = (SconeAdp - log(sum(S_Black)/sum(S_bk)))/(log(sum(S_White)/sum(S_bk)) - log(sum(S_Black)/sum(S_bk)));
MconeAdpNorm = (MconeAdp - log(sum(M_Black)/sum(M_bk)))/(log(sum(M_White)/sum(M_bk)) - log(sum(M_Black)/sum(M_bk)));
LconeAdpNorm = (LconeAdp - log(sum(L_Black)/sum(L_bk)))/(log(sum(L_White)/sum(L_bk)) - log(sum(L_Black)/sum(L_bk)));

ConeNorm = (UconeAdpNorm+SconeAdpNorm+MconeAdpNorm+LconeAdpNorm)/4;

IsoUconeAdpNorm = UconeAdpNorm - ConeNorm;
IsoSconeAdpNorm = SconeAdpNorm - ConeNorm;
IsoMconeAdpNorm = MconeAdpNorm - ConeNorm;
IsoLconeAdpNorm = LconeAdpNorm - ConeNorm;

IsoLMSimg(:,:,1) = (IsoLconeAdpNorm+3/4)/(6/4); IsoLMSimg(:,:,2) = (IsoMconeAdpNorm+3/4)/(6/4); IsoLMSimg(:,:,3) = (IsoSconeAdpNorm+3/4)/(6/4);
IsoMSUimg(:,:,1) = (IsoMconeAdpNorm+3/4)/(6/4); IsoMSUimg(:,:,2) = (IsoSconeAdpNorm+3/4)/(6/4); IsoMSUimg(:,:,3) = (IsoUconeAdpNorm+3/4)/(6/4);
% Edge detection (Laplacian of Gaussian (Stevens and Cuthill, PRSB 2006)

for i = 1:11
    imgU(:,:,i) = edge_Otsu(IsoUconeAdpNorm, 'log', [], (i/2)); % adaptive thresholding (Otsu, 1979)
    imgS(:,:,i) = edge_Otsu(IsoSconeAdpNorm, 'log', [], (i/2));
    imgM(:,:,i) = edge_Otsu(IsoMconeAdpNorm, 'log', [], (i/2));
    imgL(:,:,i) = edge_Otsu(IsoLconeAdpNorm, 'log', [], (i/2));
end
for i = 1:10
    imgpU(:,:,i) = imgU(:,:,i) & imgU(:,:,(i+1));
    imgpS(:,:,i) = imgS(:,:,i) & imgS(:,:,(i+1));
    imgpM(:,:,i) = imgM(:,:,i) & imgM(:,:,(i+1));
    imgpL(:,:,i) = imgL(:,:,i) & imgL(:,:,(i+1));
end

IsoUconeEdge_img = double(imgpU(:,:,1)+imgpU(:,:,2)+imgpU(:,:,3)+imgpU(:,:,4)+imgpU(:,:,5)+imgpU(:,:,6)+imgpU(:,:,7)+imgpU(:,:,8)+imgpU(:,:,9)+imgpU(:,:,10))./10;
IsoSconeEdge_img = double(imgpS(:,:,1)+imgpS(:,:,2)+imgpS(:,:,3)+imgpS(:,:,4)+imgpS(:,:,5)+imgpS(:,:,6)+imgpS(:,:,7)+imgpS(:,:,8)+imgpS(:,:,9)+imgpS(:,:,10))./10;
IsoMconeEdge_img = double(imgpM(:,:,1)+imgpM(:,:,2)+imgpM(:,:,3)+imgpM(:,:,4)+imgpM(:,:,5)+imgpM(:,:,6)+imgpM(:,:,7)+imgpM(:,:,8)+imgpM(:,:,9)+imgpM(:,:,10))./10;
IsoLconeEdge_img = double(imgpL(:,:,1)+imgpL(:,:,2)+imgpL(:,:,3)+imgpL(:,:,4)+imgpL(:,:,5)+imgpL(:,:,6)+imgpL(:,:,7)+imgpL(:,:,8)+imgpL(:,:,9)+imgpL(:,:,10))./10;

IsoUconeEdge_img = IsoUconeEdge_img.*BadPixelMask;
IsoSconeEdge_img = IsoSconeEdge_img.*BadPixelMask;
IsoMconeEdge_img = IsoMconeEdge_img.*BadPixelMask;
IsoLconeEdge_img = IsoLconeEdge_img.*BadPixelMask;

BWoutline = bwperim(AniMask,8);  % get animal outline
BWoutline = BWoutline.*BadPixelMask;
% 
% figure
% subaxis(2,2,1, 'Spacing', 0.03), imshow(IsoUconeEdge_img); title('Iso U-cone');
% subaxis(2,2,2, 'Spacing', 0.03), imshow(IsoSconeEdge_img); title('Iso S-cone'); 
% subaxis(2,2,3, 'Spacing', 0.03), imshow(IsoMconeEdge_img); title('Iso M-cone');
% subaxis(2,2,4, 'Spacing', 0.03), imshow(IsoLconeEdge_img); title('Iso L-cone');

DetectedUconeEdge = (BWoutline + IsoUconeEdge_img) > 1;
DetectedSconeEdge = (BWoutline + IsoSconeEdge_img) > 1;  % detected edge segments fall on the animal outline
DetectedMconeEdge = (BWoutline + IsoMconeEdge_img) > 1;
DetectedLconeEdge = (BWoutline + IsoLconeEdge_img) > 1;
% figure, imshow(BWoutline);
% subaxis(2,2,1, 'Spacing', 0.03), imshow(DetectedUconeEdge); title('Iso U-cone');
% subaxis(2,2,2, 'Spacing', 0.03), imshow(DetectedSconeEdge); title('Iso S-cone'); 
% subaxis(2,2,3, 'Spacing', 0.03), imshow(DetectedMconeEge); title('Iso M-cone');
% subaxis(2,2,4, 'Spacing', 0.03), imshow(DetectedLconeEdge); title('Iso L-cone');
PctUconeEdge = sum(DetectedUconeEdge(:))/sum(BWoutline(:))
PctSconeEdge = sum(DetectedSconeEdge(:))/sum(BWoutline(:))
PctMconeEdge = sum(DetectedMconeEdge(:))/sum(BWoutline(:))
PctLconeEdge = sum(DetectedLconeEdge(:))/sum(BWoutline(:))

end