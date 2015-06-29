function TiffSort(Date)
% ex: TiffSort('Jun29')

directoryRead = dir(Date);
%fileNames = directoryRead.name;
directoryRead = directoryRead(arrayfun(@(x)x.name(1),
    directoryRead) ~='.');





end

fileName = dir('../../HSIData/Jun29')