function TiffWrite(finaldestination, HSIname, imagename, image, colortype)
% ex: TiffWrite('path/to/save/file/', F1Gravel, '_Bluefish_contrast',
% LconeAdpNorm, 16, 'bw')

calib_img = image./max(image(:)).*(2^16);
calib_img = uint16(calib_img);
filename = sprintf('%s%s%s', imagename, HSIname, '.tiff');
tiff_handle = Tiff(filename, 'w');

if strcmp(colortype, 'bw') == 1
    tiff_handle.setTag('Photometric',Tiff.Photometric.MinIsBlack);
    tiff_handle.setTag('BitsPerSample', 16);
    tiff_handle.setTag('SamplesPerPixel', 1);
elseif strcmp(colortype, 'rgb') == 1
    tiff_handle.setTag('Photometric', Tiff.Photometric.RGB);
    tiff_handle.setTag('BitsPerSample', 16);
    tiff_handle.setTag('SamplesPerPixel', 3);
else
    error('Colortype should be bw (black and white) or rgb (pseudocolor).')
end

tiff_handle.setTag('PlanarConfiguration',Tiff.PlanarConfiguration.Chunky);
tiff_handle.setTag('Compression', Tiff.Compression.None);
tiff_handle.setTag('ImageLength', 512);
tiff_handle.setTag('ImageWidth', 512);
tiff_handle.write(calib_img);
tiff_handle.close();

destination = sprintf('%s%s', finaldestination, filename);

movefile(filename, destination);
end
