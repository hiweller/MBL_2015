% read in deconvolution matrix

DeconMat = cell2mat(textscan(fopen('deconvolution.txt'), '%f'));

for i = 1:16
    index = DeconMat(((i-1)*16+1):(i*16));
    TransforMatrix(:, :, i) = vec2mat(index, 4);
end

% 1:4, 1:4
% 5:8, 1:4
% 9:12, 1:4
(i-1)*4+1
for i = 1:512
    i_index = (i-1)*4+1;
    i_stop = i*4;
    for j = 1:512
        j_index = (j-1)*4+1;
        j_stop = i*4;
        superpixel = cuberead(j_index:j_stop, i_index:i_stop);
        for k = 1:16
            newpixel = superpixel*TransforMatrix(:, :, k);
            channel = sum(sum(newpixel));
            Wallace(j, i, k) = channel;
        end
%          blah blah blah transformation blah blah
    end
end
