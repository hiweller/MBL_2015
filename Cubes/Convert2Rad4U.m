function BandImg = Convert2Rad4U(file_folder,varargin)
% ex: ShowRad('June07_lizards')

%*% make sure these files are in your path
load 2015-08-21_Leif_conversion_files flatfield radiancecalibration deconvolution
load 2015-08-27_dark_noise_average_by_band
load 2015-08-27_flatfieldSEP transformmat_test
load BadPixelMask

transformmat = transformmat_test;

save_file_path = [file_folder '/RadFiles/'];
if ~exist(save_file_path,'dir')
    mkdir(save_file_path)
end

if isempty(varargin)
    %*% defaults
    bad_pixel_mask_flag = 1;
    darknoisesubtraction_flag = 1;
    flatfieldcorrection_leif_flag = 1;
    flatfieldcorrection_sep_flag = 1;
    deconvolution_flag = 1;
    radiance_conversion_flag = 1;
    plot_flag = 1;
    save_flag = 0;
else
    bad_pixel_mask_flag = varargin{1};
    darknoisesubtraction_flag = varargin{2};
    flatfieldcorrection_leif_flag = varargin{3};
    flatfieldcorrection_sep_flag = varargin{4};
    deconvolution_flag = varargin{5};
    radiance_conversion_flag = varargin{6};
    plot_flag = varargin{7};
    save_flag = varargin{8};
end

flatfield(flatfield==Inf) = 0;

%*% arrangement of the filters on the camera, top left (moving right by rows), to bottom right:
ArrayInx = [10 7 6 14 4 11 15 16 5 9 1 12 13 2 8 3];
ArrayInxInv = [11 14 16 5 9 3 2 15 10 1 6 12 13 4 7 8]; %#ok<*NASGU>

WaveNumber = {'360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', ...
    '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'};

imagedir = dir([file_folder, '/*.3d']);

for iimage = [1 450:length(imagedir)]
    fid = fopen([file_folder '/' imagedir(iimage).name]);
    cuberead = fread(fid, [2048 2048], 'uint16');
    fclose(fid);
    %     cuberead = double(cuberead);
    %     cuberead(cuberead>2^16) = 0;
    
    %*% read the integration time for the image file name
    integration_time = str2double(regexp(imagedir(iimage).name,'(?<=_)(.*?)(?=ms.3d)','match'));
    
    %*% sort flatfield image by bands, Matlab is column major!
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
    
    %*% shift down 3 rows the flat field correction, add 3 black rows to top, per Leif's code
    for iband = 1:16
        temp = squeeze(FlatfieldByBand(:,:,iband));
        temp(4:end,:) = squeeze(FlatfieldByBand(1:509,:,iband));
        temp(1:3,:) = 0;
        FlatfieldByBand(:,:,iband) = temp;
    end
    
    %*% shift down 3 rows the image, add 3 black rows to top, per Leif's code
    for iband = 1:16
        temp = squeeze(FilterImg(:,:,iband));
        temp(4:end,:) = squeeze(FilterImg(1:509,:,iband));
        temp(1:3,:) = 0;
        FilterImg(:,:,iband) = temp;
    end
    FilterImg = double(FilterImg);
    
    %*% mask out bad pixels
    if bad_pixel_mask_flag == 1
        BadPixelMask = double(BadPixelMask);
        BadPixelMask(BadPixelMask==0) = nan;
        for iband = 1:16
            FilterImg(:,:,iband) = FilterImg(:,:,iband).*BadPixelMask;
        end
    end
    
    %*% perform the dark field subtraction
    if darknoisesubtraction_flag == 1
        for iband = 1:16
            FilterImg(:,:,iband) = FilterImg(:,:,iband) - dark_noise_by_band(iband);
        end
    end
    FilterImg(FilterImg<0) = 0;
    FilterImg = uint16(FilterImg);
    FilterImg = double(FilterImg);
    
    %*% perform the flat field correction
    if flatfieldcorrection_leif_flag == 1;
        for iband = 1:16
            FilterImg(:,:,iband) = FilterImg(:,:,iband).*FlatfieldByBand(:,:,iband);
        end
    end
    FilterImg = uint16(FilterImg);
    FilterImg = double(FilterImg);
    
    %*% SEP flat field correction (computed gradients in diffuse sky images)
    if flatfieldcorrection_sep_flag == 1;
        for iband = 1:16
            FilterImg(:,:,iband) = FilterImg(:,:,iband).*transformmat(:,:,iband);
        end
    end
    FilterImg = uint16(FilterImg);
    FilterImg = double(FilterImg);
    
    %*% perform the deconvolution to remove artifacts from spillover into
    %other wavelength bands
    if deconvolution_flag == 1
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
    end
%     FilterImg = uint16(FilterImg);  %*% question for Leif - they don't do
%     this in Convert2Tiff, but it seems like you may want to re-bin counts after
%     deconvolution.  It makes the images much "brighter".
    FilterImg = double(FilterImg);
    
    %*% perform radiance conversion
    if radiance_conversion_flag == 1
        conv_t = radiancecalibration(1,1)./integration_time;
        rad_conv = radiancecalibration(2:17,1)./radiancecalibration(2:17,2).*conv_t;
        for iband = 1:16
            FilterImg(:,:,iband) = FilterImg(:,:,iband).*rad_conv(ArrayInx(iband));
        end
    end
    
    %*% set mask to NaN's again, since uint8 or uint16 conversion changes NaN to 0
    if bad_pixel_mask_flag == 1
        for iband = 1:16
            FilterImg(:,:,iband) = FilterImg(:,:,iband).*BadPixelMask;
        end
    end
    
    %*% compute the global mean and max
    global_mean = double(nanmean(FilterImg(:)));
    global_max = double(nanmax(FilterImg(:)));
    
    for j = 1:16
        BandImg(:,:,j) = FilterImg(:,:,j);
    end
    BandImg(BandImg<0) = 0;
    
    RGBImg(:,:,1) = BandImg(:,:,15); % 640 nm
    RGBImg(:,:,2) = BandImg(:,:,10); % 540 nm
    RGBImg(:,:,3) = BandImg(:,:,5); % 436 nm
    
    gamma_monitor_adjust = 1/1.8;  %*% VIP if you want to actually see what's there on a mac monitor; use 2.2 if not mac
    RGBImg = uint8((RGBImg./global_max).^gamma_monitor_adjust.*255);
    
    %*% display a pseudocolor image to test
    if plot_flag == 1
        if iimage == 1
            fig = figure;
        end
        figure(fig);
        clf
        subplot(1,2,1)
        imagesc(RGBImg);
        axis square;
        axis off;
        title(imagedir(iimage).name,'Interpreter','none');
        subplot(1,2,2)
        imagesc(squeeze(BandImg(:,:,1)));colormap(gray)
        axis square;
        axis off;
        if length(imagedir)> 1; pause;end
    end
    
    %*% save a .mat file for each image
    if save_flag == 1
        save([save_file_path imagedir(iimage).name '.Rad4U.mat'],'BandImg','*flag');
        imwrite(RGBImg,[save_file_path imagedir(iimage).name '.Rad4U_RGB.png'],'png');
    end
end

end
