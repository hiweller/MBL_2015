function TiffSort(Date)
% sorts the individual tiff files into folders according to name
% ex: TiffSort('Jun29')

directoryRead = dir(['../',Date]);
%fileNames = directoryRead.name;
<<<<<<< HEAD
directoryRead = directoryRead(arrayfun(@(x)x.name(1),
    directoryRead) ~='.'); %remove hidden files



=======
directoryRead = directoryRead(arrayfun(@(x)x.name(1), directoryRead) ~='.');
>>>>>>> 75a2bebfd860b6a0eec1de02d14b7e857c534a15

FileID = directoryRead(1).name(1:18)
mkdir(FileID)

for i = 1:length(directoryRead)
    if directoryRead(i).name(1:18) == FileID
        movefile(directoryRead(i).name, FileID)
        i = i+1
    else
        FileID = directoryRead(i).name(1:18)
        mkdir(FileID)
        i = i+1
    end
end

    
    
