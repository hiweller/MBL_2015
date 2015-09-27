function [PercentEdge1pixel, CtrlEdge1pixel] = StriperEdge(Directory, Rad4Umat)
load Striper2Cones.dat
% 542 nm = S and M, 612 nm = L
BGMask = importdata(['Masks/BGMask_SegImg_', Rad4Umat], 1);
AniMask = importdata(['Masks/AnimalMask_SegImg_', Rad4Umat], 1);
% RefObjectImg = importdata([Directory, '/', GlobalRefImg], 1);
load([Directory, '/', Rad4Umat]);
RefObjectImg = BandImg;

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
    Simg(:,:,i) = RefObjectImg(:,:,i)*Striper2Cones(1,i); % use Up direction of light field
    Limg(:,:,i) = RefObjectImg(:,:,i)*Striper2Cones(2,i);
 % double cone
end

% summation across all wavelengths
Scone = sum(Simg,3);
Lcone = sum(Limg,3);

for i = 1:16
    Background(i) = mean2(RefObjectImg(:,:,i)); % average all reflectance spectra across the entire image
end

WhiteSurface = ones(1,16); % white surface for normalization purpose
BlackSurface = 0.01*ones(1,16); % black surface for normalization purpose

for i = 1:16
    S_bk(i) = Background(i)*Striper2Cones(1,i);
    L_bk(i) = Background(i)*Striper2Cones(2,i);
    S_White(i) = WhiteSurface(i)*Striper2Cones(1,i);
    L_White(i) = WhiteSurface(i)*Striper2Cones(2,i);
    S_Black(i) = BlackSurface(i)*Striper2Cones(1,i);
    L_Black(i) = BlackSurface(i)*Striper2Cones(2,i);
end

% make the quantal catch 0 equal the black surface quantal catch (to avoid log problem)
inxS = find(Scone == 0);
Scone(inxS) = sum(S_Black);
inxL = find(Lcone == 0);
Lcone(inxL) = sum(L_Black);

LconeAdp = log(Lcone/sum(L_bk)); % adapted to background and log-transformed (Ln)
SconeAdp = log(Scone/sum(S_bk)); 

% normalized to a range from 0 to 1 (for display purpose), using black and white surfaces
LconeAdpNorm = (LconeAdp - log(sum(L_Black)/sum(L_bk)))/(log(sum(L_White)/sum(L_bk)) - log(sum(L_Black)/sum(L_bk)));
SconeAdpNorm = (SconeAdp - log(sum(S_Black)/sum(S_bk)))/(log(sum(S_White)/sum(S_bk)) - log(sum(S_Black)/sum(S_bk)));

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

BWoutline = bwperim(AniMask,8);  % get animal outline
DetectedEdge = (BWoutline + Lcone_img) > 1;  % detected edge segments fall on the animal outline
figure, imshow(BWoutline);
figure, imshow(DetectedEdge);
PercentEdge1pixel = sum(DetectedEdge(:))/sum(BWoutline(:))

% get coordinates
[y,x] = find(BWoutline==1);
[BGy, BGx] = find(BGMask==1);
BGarray = horzcat(BGx, BGy);
xyarray = horzcat(x,y);
[xd, xy] = find(Lcone_img > 0);
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
      successcount = successcount+1;
      BGmember = ismember(xyrot, BGarray, 'rows');
      for i = 1:length(xyrot(:,1))
          if BGmember(i) == 0 | xyrot(i,1) < 1 | xyrot(i,2) < 1 | xyrot(i,1) > 512 | xyrot(i,2) > 512
              xyrot(i,:) = NaN;
          end
      end
      xrotplot = xyrot(:,1);
      xrotplot = xrotplot(isnan(xrotplot)==0);
      yrotplot = xyrot(:,2);
      yrotplot = yrotplot(isnan(yrotplot)==0);
      plot(xrotplot, yrotplot, '.')
      overlap = ismember(xyrot, Dcoords, 'rows');
      CtrlEdge1pixel(successcount) = length(find(overlap))/length(find(isnan(xyrot(:,1))==0));
  end

end
hold off;
figure
hist(CtrlEdge1pixel);

end