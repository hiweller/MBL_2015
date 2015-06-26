function ShowHSIimage

clear;

% Img360 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_360nm_raw.tiff','tiff');
% Img380 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_380nm_raw.tiff','tiff');
% Img405 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_405nm_raw.tiff','tiff');
% Img420 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_420nm_raw.tiff','tiff');
% Img436 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_436nm_raw.tiff','tiff');
% Img460 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_460nm_raw.tiff','tiff');
% Img480 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_480nm_raw.tiff','tiff');
% Img500 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_500nm_raw.tiff','tiff');
% Img520 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_520nm_raw.tiff','tiff');
% Img540 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_540nm_raw.tiff','tiff');
% Img560 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_560nm_raw.tiff','tiff');
% Img580 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_580nm_raw.tiff','tiff');
% Img600 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_600nm_raw.tiff','tiff');
% Img620 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_620nm_raw.tiff','tiff');
% Img640 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_640nm_raw.tiff','tiff');
% Img660 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_660nm_raw.tiff','tiff');

Img360 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_360nm_global.tiff','tiff');
Img380 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_380nm_global.tiff','tiff');
Img405 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_405nm_global.tiff','tiff');
Img420 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_420nm_global.tiff','tiff');
Img436 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_436nm_global.tiff','tiff');
Img460 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_460nm_global.tiff','tiff');
Img480 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_480nm_global.tiff','tiff');
Img500 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_500nm_global.tiff','tiff');
Img520 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_520nm_global.tiff','tiff');
Img540 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_540nm_global.tiff','tiff');
Img560 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_560nm_global.tiff','tiff');
Img580 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_580nm_global.tiff','tiff');
Img600 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_600nm_global.tiff','tiff');
Img620 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_620nm_global.tiff','tiff');
Img640 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_640nm_global.tiff','tiff');
Img660 = imread('Aug7/2014-08-07-14hr17min41sec/2014-08-07-14hr17min41sec_660nm_global.tiff','tiff');

ImgRGB(:,:,1) = Img640;
ImgRGB(:,:,2) = Img540;
ImgRGB(:,:,3) = Img436;

UpBound = max(ImgRGB(:));
sc = 2^16/UpBound;
ScaledImgRGB = ImgRGB*sc;

figure;
imshow(ScaledImgRGB);
end