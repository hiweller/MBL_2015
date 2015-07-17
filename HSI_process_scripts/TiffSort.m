% function TiffSort(Date)
% 
% directoryRead = dir(['../',Date, '/*.tif*']);
% 
% FileID = directoryRead(1).name(1:(end-13));
% mkdir(FileID)
% 
% for i = 1:length(directoryRead)
%     if length(directoryRead(i).name(1:(end-13))) == length(FileID)
%         if directoryRead(i).name(1:(end-13)) == FileID
%             movefile(directoryRead(i).name, FileID);
%         else
%             FileID = directoryRead(i).name(1:(end-13))
%             mkdir(FileID);
% %         blah blah balh
%         end
%     else
%         FileID = directoryRead(i).name(1:(end-13));
%         mkdir(FileID);
%     end
% end
% 
% end


function TiffSort(Date)
% sorts the individual tiff files into folders according to name
% ex: TiffSort('Jun29')
% you should be in the directory when you execute this function
% ex: be in the Jun29 folder when you execute TiffSort('Jun29')


directoryRead = dir(['../',Date, '/*.tiff']);
%fileNames = directoryRead.name;

directoryRead = directoryRead(arrayfun(@(x)x.name(1), directoryRead) ~='.'); %remove hidden files

FileID = directoryRead(1).name(1:18);
FolderID = directoryRead(1).name(1:(end-15));
mkdir(FolderID);

for i = 1:length(directoryRead)
    if directoryRead(i).name(1:18) == FileID
        movefile(directoryRead(i).name, FolderID);
    else
        FileID = directoryRead(i).name(1:18);
        FolderID = directoryRead(i).name(1:(end-15));
        mkdir(directoryRead(i).name(1:(end-15)));
        movefile(directoryRead(i).name, FolderID);
    end
end


end

    
    
