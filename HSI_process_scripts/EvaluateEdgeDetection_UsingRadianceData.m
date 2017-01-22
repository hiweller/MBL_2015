function EdgeDetection_UsingRadianceData(Directory,Filename)
% Example: EvaluateEdgeDetection_UsingRadianceData('Flounders/Blue','20150814104945.840_31ms.3d_31.00ms')
% Example: EvaluateEdgeDetection_UsingRadianceData('Flounders/Gravel','20150724110559.555_33ms.3d_33.00ms')
% Example: EvaluateEdgeDetection_UsingRadianceData('Flounders/Sand','20150730101055.833_42ms.3d_42.00ms')
load Buzzard4Cones.dat % 4x16 (UV, S, M, L)
load ChickenDoubleCone.dat %1x16

ChickenDoubleCone = ChickenDoubleCone/100; % make sensitivity range from 0 to 1
WaveNumber = ['360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'];
% load([Directory, '/', Filename, '.Rad4U.mat']);
% RefObjectImg = BandImg;
RefObjectImg = importdata([Directory, '/', Filename, '_Global_Ref']);

WaveNumber = {'360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'};

% plot 16 channels individually
figure
for i = 1:16
    TempImg = RefObjectImg(:,:,i);
    inx1 = find(TempImg > 1); % find reflectance larger than one
    TempImg(inx1) = 1;% make reflectance larger than one equal 1 
    TempImg(isnan(TempImg)) = 0; % set NaNs equal to 0 (because of noise)
    RefObjectImg(:,:,i) = TempImg; % reflectance range 0-1
    subaxis(4,4,i, 'Spacing', 0.03), imshow(RefObjectImg(:,:,i)); title(WaveNumber(i));
end
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 1,'\bf Reflectance images of 16 bands','HorizontalAlignment','center','VerticalAlignment', 'top');

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

figure
imshow(DconeAdpNorm); title('Double cone');

% Edge detection (Laplacian of Gaussian (Stevens and Cuthill, PRSB 2006)
for i = 1:11
    img(:,:,i) = edge_Otsu(DconeAdpNorm, 'log', [], (i/2)); % adaptive thresholding (Otsu, 1979)
end
for i = 1:10
    imgp(:,:,i) = img(:,:,i) & img(:,:,(i+1));
end

Dcone_img = double(imgp(:,:,1)+imgp(:,:,2)+imgp(:,:,3)+imgp(:,:,4)+imgp(:,:,5)+imgp(:,:,6)+imgp(:,:,7)+imgp(:,:,8)+imgp(:,:,9)+imgp(:,:,10))./10;

figure
imshow(Dcone_img); title('Edge detection using Laplacian of Gaussian model');


CombinedImg(:,:,1) = DconeAdpNorm + Dcone_img;
CombinedImg(:,:,2) = DconeAdpNorm + Dcone_img;
CombinedImg(:,:,3) = DconeAdpNorm;

figure
imshow(CombinedImg);



end
