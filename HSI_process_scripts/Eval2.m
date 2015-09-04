function [PercentEdge1pixel, CtrlEdge1pixel] = Eval2(Directory, GlobalRefImg)
load Buzzard4Cones.dat
load ChickenDoubleCone.dat
AniMask = importdata(['Masks/AnimalMask_SegImg_', GlobalRefImg, '.png.mat'], 1);
RefObjectImg = importdata([Directory, '/', GlobalRefImg], 1);

for i = 1:16
    TempImg = RefObjectImg(:,:,i);
    inx1 = find(TempImg > 1); % find reflectance larger than one
    TempImg(inx1) = 1; % make reflectance larger than one equal 1 
    inx_nan = isnan(TempImg); % find NaN in the image file
    inx2 = find(inx_nan == 1);
    TempImg(inx2) = 0; % make reflectance NaN (because of noise) equal 0
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

% Edge detection (Laplacian of Gaussian (Stevens and Cuthill, PRSB 2006)
for i = 1:11
    img(:,:,i) = edge_Otsu(LconeAdpNorm, 'log', [], (i/2)); % adaptive thresholding (Otsu, 1979)
end
for i = 1:10
    imgp(:,:,i) = img(:,:,i) & img(:,:,(i+1));
end
Dcone_img = double(imgp(:,:,1)+imgp(:,:,2)+imgp(:,:,3)+imgp(:,:,4)+imgp(:,:,5)+imgp(:,:,6)+imgp(:,:,7)+imgp(:,:,8)+imgp(:,:,9)+imgp(:,:,10))./10;
figure
imshow(Dcone_img); title('Edge detection using Laplacian of Gaussian model');

BWoutline = bwperim(AniMask,8);  % get animal outline
DetectedEdge = (BWoutline + Dcone_img) > 1;  % detected edge segments fall on the animal outline
figure, imshow(BWoutline);
figure, imshow(DetectedEdge);
PercentEdge1pixel = sum(DetectedEdge(:))/sum(BWoutline(:))

% get coordinates
[y,x] = find(BWoutline==1);
xyarray = horzcat(x,y);
[xd, xy] = find(Dcone_img > 0);
Dcoords = horzcat(xd, xy);

% get CoM
% stats = regionprops(AniMask, DconeAdpNorm, {'WeightedCentroid'});
stats = regionprops(AniMask, 'Centroid'); % do we want WeightedCentroid instead?
CoM = stats.Centroid;

imshow(AniMask); hold on;
successcount = 0;
CtrlEdge1pixel = zeros(1,500);

while successcount < 500
%     generate new random location for CoM
  CoMprime = randi([1 512], 1, 2);
  
  
%   there is probably some super elegant way to translate...this...but...
%   #CODELIKEABIOLOGIST (c/o westneat lab ideology)
%   translate coordinates to have new CoM as centroid
  diff = CoMprime - CoM;
  xprime = round(x+diff(1));
  yprime = round(y+diff(2));
  
  xyprime = horzcat(xprime, yprime);
  
%   ROTATE MY FRIEND
  theta = 2*pi*rand; % generate random angle for rotation
  RotMatrix = [cos(theta) -sin(theta); sin(theta) cos(theta)]; % rotation matrix
  center = repmat(CoMprime,length(xprime),1); 
  xytemp = xyprime - center; % move center of outline to origin for rotation
  temprot = xytemp*RotMatrix; % rotate outline
  xytemp = temprot+center; % move back to original center
  xyrot = round(xytemp);
  
  findfailures = ismember(xyarray, xyrot, 'rows');
  findnegs = xyprime(xyprime < 0);
  if isempty(find(findfailures)) == 1
      plot(xyrot(:,1), xyrot(:,2), '.')
      successcount = successcount+1;
      for i = 1:length(xyrot(:,1))
          if xyrot(i,1) < 1 | xyrot(i,2) < 1 | xyrot(i,1) > 512 | xyrot(i,2) > 512
              xyrot(i,:) = NaN;
          end
      end
      overlap = ismember(xyrot, Dcoords, 'rows');
      CtrlEdge1pixel(successcount) = length(find(overlap))/length(xyarray(:,1));
  end

end
hold off;

end