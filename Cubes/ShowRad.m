function ShowRad(Lizards)
% shows ch 1 image without saving/sorting any files
% for use in checking image w/o saving processing
% ex: ShowRad('June07_lizards')
start_row = 32;     %|Super pixel start row of unblanked image area
start_col = 28;     %|super pixel start col of unblanked image area
stop_row  = 500;	%|Super pixel stop row of unblanked image area
stop_col  = 484;	%|Super pixel stop col of unblanked image area

%*% make sure this file is in your path
load 2015-08-21_Leif_conversion_files flatfield radiancecalibration deconvolution

flatfield(flatfield==Inf) = 0;

%*% arrangement of the filters on the camera:
ArrayInx = [9,   6,   5,   13,  3,   10,  14,  15,  4,   8,   0,   11,  12,  1,   7,   2];
ArrayInx = ArrayInx+1; % start from 1

ArrayInxInv = [11 14 16 5 9 3 2 15 10 1 6 12 13 4 7 8];

WaveNumber = {'360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', ...
     '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'};

imagedir = dir([Lizards, '/*.3d']);

fig = figure;

for iimage = 1%:length(imagedir)
    cuberead = fread(fopen([Lizards '/' imagedir(iimage).name]), [2048 2048], 'uint16');
    cuberead = double(cuberead);
    cuberead(cuberead>2^16) = 0;
    
    %*% read the integration time for the image file name
    integration_time = str2double(regexp(imagedir(iimage).name,'(?<=_)(.*?)(?=ms.3d)','match'));
    
    %*% perform the dark field subtraction: add this in soon!
    
    %*% sort flatfield image by bands
    FlatfieldByBand = nan(512,512,16);
    for i = 1:4
        FlatfieldByBand(:,:,i)=flatfield(i:4:2048,1:4:2048);
    end
    for i = 5:8
        FlatfieldByBand(:,:,i)=flatfield(i-4:4:2048,2:4:2048);
    end
    for i = 9:12
        FlatfieldByBand(:,:,i)=flatfield(i-8:4:2048,3:4:2048);
    end
    for i = 13:16
        FlatfieldByBand(:,:,i)=flatfield(i-12:4:2048,4:4:2048);
    end
    
    %*% flip left-right
    for j = 1:16
        FlatfieldByBand(:,:,j) = fliplr(FlatfieldByBand(:,:,j)); 
    end
    
    %*% reorder by wavenumber
    temp = FlatfieldByBand;
    for j = 1:16
        FlatfieldByBand(:,:,j) = (temp(:,:,ArrayInx(j))); % flip image left-right
    end
        
    %*% separate image into bands
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
    
    % flip image left-right
    for j = 1:16
        FilterImg(:,:,j) = fliplr(FilterImg(:,:,j)); 
    end
    
    % reorder by wavenumber
    temp = FilterImg;
    for j = 1:16
        FilterImg(:,:,j) = temp(:,:,ArrayInx(j)); 
    end
    
    %*% mask out the pixels Leif excludes from analysis (I think)
    for iband = 1:16
        temp = squeeze(FlatfieldByBand(:,:,iband));
        temp(1:start_row-1,:) = 1;
        temp(:,1:start_col-1) = 1;
        temp(stop_row+1:end,:) = 1;
        temp(:,stop_col+1:end) = 1;
        FlatfieldByBand(:,:,iband) = temp;
    end
    
    %*% perform the flat field correction
    for iband = 1:16
        FilterImg(:,:,iband) = FilterImg(:,:,iband).*FlatfieldByBand(:,:,iband);
    end
    
    %*% perform the deconvolution to remove artifacts from spillover into
    %other wavelength bands
    TempImg = FilterImg;
    deconv_unscramble = deconvolution(:,ArrayInx);
    for iband = 1:16
        temp = zeros(512,512);
        deconv_temp = deconv_unscramble(iband,:);
        for jband = 1:16
            temp = temp + TempImg(:,:,jband).*deconv_temp(jband);
        end
        FilterImg(:,:,iband) = temp;
    end
    FilterImg(FilterImg<0) = 0;
    
    %*% perform radiance conversion
%     conv_t = radiancecalibration(1,1)./integration_time;
%     rad_conv = radiancecalibration(2:17,1)./radiancecalibration(2:17,2).*conv_t;
%     for iband = 1:16
%         FilterImg(:,:,iband) = FilterImg(:,:,iband).*rad_conv(ArrayInx(iband));
%     end
    
    %*% compute the global mean - this is just for reporting, possibly skip
    global_mean = mean(FilterImg(:));
    global_max = max(FilterImg(:));
    
    for j = 1:16
        BandImg(:,:,j) = FilterImg(:,:,j); 
    end
    BandImg(BandImg<0) = 0;
    BandImg = double(BandImg);
%     BandImg = BandImg./global_max.*(2^16);
%     BandImg = BandImg./global_mean.*4096;
    BandImg = BandImg./max(BandImg(:));
    
    RGBImg(:,:,1) = BandImg(:,:,15); % 640 nm
    RGBImg(:,:,2) = BandImg(:,:,10); % 540 nm
    RGBImg(:,:,3) = BandImg(:,:,5); % 436 nm
    
%     RGBImg = RGBImg./max(RGBImg(:));

    figure(fig);
    imagesc(RGBImg);
    axis square;
    axis off;
    title(imagedir(iimage).name,'Interpreter','none');
    pause
end

end
