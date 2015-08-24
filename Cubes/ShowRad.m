function ShowRad(Lizards,flatfield,deconvolution,radiancecalibration)
% shows ch 1 image without saving/sorting any files
% for use in checking image w/o saving processing
% ex: ShowRad('June07_lizards')

ArrayInx = [9,   6,   5,   13,  3,   10,  14,  15,  4,   8,   0,   11,  12,  1,   7,   2];
ArrayInx = ArrayInx+1; % make index starting from 1

% WaveNumber = {'360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', ...
%     '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'};

imagedir = dir([Lizards, '/*.3d']);

% fig = figure;

for iimage = 1:length(imagedir)
    cuberead = fread(fopen([Lizards '/' imagedir(iimage).name]), [2048 2048], 'uint16');
    
    %*% read the integration time for the image file name
    integration_time = str2double(regexp(imagedir(iimage).name,'(?<=_)(.*?)(?=ms.3d)','match'));
    
    %*% perform the dark field subtraction, add this in soon!
    
    %*% perform the flatfield correction
%     cuberead = cuberead.*flatfield;
    
    %*% separate into bands
    FilterImg = nan(512,512,16);
    BandImg = nan(512,512,16);
    RGBImg = nan(512,512,3);
    
    for i = 1:4
        FilterImg(:,:,i)=cuberead(i:4:2048,1:4:2048);
    end
    for i = 5:8
        FilterImg(:,:,i)=cuberead(i-4:4:2048,2:4:2048);
    end
    for i = 9:12
        FilterImg(:,:,i)=cuberead(i-8:4:2048,3:4:2048);
    end
    for i = 13:16
        FilterImg(:,:,i)=cuberead(i-12:4:2048,4:4:2048);
    end
    for j = 1:16
        FilterImg(:,:,j) = fliplr(FilterImg(:,:,j)); % flip image left-right
    end
        
    %*% perform the deconvolution to remove artifacts from spillover into
    %other wavelength bands
%     for iband = 1:16
%         temp = zeros(512,512);
%         for jband = 1:16
%             temp = temp + FilterImg(:,:,jband).*deconvolution(iband,jband);
%         end
%         FilterImg(:,:,iband) = temp;
%     end
    
    %*% perform radiance conversion
%     conv_t = radiancecalibration(1,1)./integration_time;
%     rad_conv = radiancecalibration(2:17,1)./radiancecalibration(2:17,2).*conv_t;
%     for iband = 1:16
%         FilterImg(:,:,iband) = FilterImg(:,:,iband).*rad_conv(iband);
%     end
    
    %*% compute the global mean - this is just for reporting, possibly skip
    
    for j = 1:16
        BandImg(:,:,j) = FilterImg(:,:,ArrayInx(j)); % reorder bands into ascending wavenumber order
    end
    BandImg(BandImg<0) = 0;
    BandImg = double(BandImg);
    BandImg = BandImg./max(BandImg(:));
    
    RGBImg(:,:,1) = BandImg(:,:,15); % 640 nm
    RGBImg(:,:,2) = BandImg(:,:,10); % 540 nm
    RGBImg(:,:,3) = BandImg(:,:,5); % 436 nm
    
    figure(1);
    imagesc(RGBImg);
    axis square;
    axis off;
    title(imagedir(iimage).name,'Interpreter','none');
    pause
end

end
