function DisplaySpec(Date)

% Date = 'Documents/MBL2015/jaz/Jun26';
% File = 'Spec_ch0_Spec.dat';
% fname = fullfile(Date,File);
% a = load(fname);

a = load([Date,'/','Spec_ch0_Spec.dat']);
size_a = size(a,1);
Spec_ch_all = zeros(size_a,501,5);

ch = [0, 1, 3, 4, 6];
for i = (1:5);
    proc_files = dir([Date,'/','*.dat']);
    filename = proc_files(i).name;
    fullfilename = [Date,'/',filename];
    Spec_ch_all(i) = load([Date,'/',proc_files(i).name]);
end


% load [Date,'Spec_ch0_Spec.dat'];
% load Jun26/Spec_ch1_Spec.dat;
% load Jun26/Spec_ch3_Spec.dat;
% load Jun26/Spec_ch4_Spec.dat;
% load Jun26/Spec_ch6_Spec.dat;

<<<<<<< HEAD
% Spec_ch1_Spec = [Date,'Spec_ch1_Spec.dat'];
% Spec_ch3_Spec = [Date,'Spec_ch3_Spec.dat'];
% Spec_ch4_Spec = [Date,'Spec_ch4_Spec.dat'];
% Spec_ch6_Spec = [Date,'Spec_ch6_Spec.dat'];
=======
% 
% load Date/'Spec_ch0_Spec.dat';
% 
% % channel0;
% load channel1;
% load channel3;
% load channel4;
% load channel6;

% Spec_ch0_Spec = [Date,'/Spec_ch0_Spec.dat'];
% Spec_ch1_Spec = [Date,'/Spec_ch1_Spec.dat'];
% Spec_ch3_Spec = [Date,'/Spec_ch3_Spec.dat'];
% Spec_ch4_Spec = [Date,'/Spec_ch4_Spec.dat'];
% Spec_ch6_Spec = [Date,'/Spec_ch6_Spec.dat'];
>>>>>>> 1a48521c1e0fb9330373d05ffd225ba8af6ca791


Spec_ch0_Spec = Spec_ch0_Spec(:,101:401); % only use from 400 to 700 nm
Spec_ch1_Spec = Spec_ch1_Spec(:,101:401);
Spec_ch3_Spec = Spec_ch3_Spec(:,101:401);
Spec_ch4_Spec = Spec_ch4_Spec(:,101:401);
Spec_ch6_Spec = Spec_ch6_Spec(:,101:401);

for i = 1:size(Spec_ch0_Spec,1)
figure
plot(wl,Spec_ch0_Spec(i,:),'b'); hold on;
plot(wl,Spec_ch1_Spec(i,:),'c');
plot(wl,Spec_ch3_Spec(i,:),'g');
plot(wl,Spec_ch4_Spec(i,:),'m');
plot(wl,Spec_ch6_Spec(i,:),'r'); hold off;
title(['Measurement number: ' num2str(i_measurement)]);
legend({'ch 0 front-45','ch 1 right','ch 3 right-45','ch 4 up','ch 6 front'})
end

end