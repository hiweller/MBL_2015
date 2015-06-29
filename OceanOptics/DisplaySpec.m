<<<<<<< HEAD
function DisplaySpec(Date)
=======
<<<<<<< HEAD
function DisplaySpec(Date)

wl = 400:700; % wavelengths in the visible

a = load([Date,'/','Spec_ch0_Spec.dat']);
size_a = size(a,1);
Spec_ch_all = zeros(size_a,501,5);

ch = [0, 1, 3, 4, 6];
for i = (1:5);
    proc_files = dir([Date,'/','*.dat']);
    filename = proc_files(i).name;
    fullfilename = [Date,'/',filename];
    Spec_ch_all(:,:,i) = load([Date,'/',proc_files(i).name]);
end

for i = 1:size_a
    figure
    for j = 1:5 
        hold all;
        plot(wl,Spec_ch_all(i,101:401,j));
        hold on;
    end
    hold off;
%     title(['Measurement number: ' num2str(i)]);
%     legend({'ch 0 front-45','ch 1 right','ch 3 right-45','ch 4 up','ch 6 front'})
end

end
=======
>>>>>>> ff1e1197f2fac8afd7b549c275eb6883d7b6e8a5

wl = 400:700; % wavelengths in the visible

a = load([Date,'/','Spec_ch0_Spec.dat']);
size_a = size(a,1);
Spec_ch_all = zeros(size_a,501,5);

ch = [0, 1, 3, 4, 6];
for i = (1:5);
    proc_files = dir([Date,'/','*.dat']);
    filename = proc_files(i).name;
    fullfilename = [Date,'/',filename];
    Spec_ch_all(:,:,i) = load([Date,'/',proc_files(i).name]);
end

<<<<<<< HEAD
for i = 1:size_a
    figure
    title(['Measurement number: ' num2str(i)]);
    for j = 1:5 
        hold all;
        plot(wl,Spec_ch_all(i,101:401,j));
        hold on;
    end
    legend({'ch 0 front-45','ch 1 right','ch 3 right-45','ch 4 up','ch 6 front'});
    hold off;
end

end 
=======
>>>>>>> ef5bb8c5a9546ae424dc4ee6666ba4b4dc1d5aba
>>>>>>> ff1e1197f2fac8afd7b549c275eb6883d7b6e8a5
