function ProcessDarkness(SpecDir)
% subtract dark spectrum
% convert to irradiance spectrum (photon/cm^2/nm/sec)
% only look at dark spectra
% 

wl = 300:800;
load IrradCalCh0.dat; % from 300-800 nm
load IrradCalCh1.dat;
load IrradCalCh3.dat;
load IrradCalCh4.dat;
load IrradCalCh6.dat;
IrradCal = [IrradCalCh0; IrradCalCh1; IrradCalCh3; IrradCalCh4; IrradCalCh6]; % 5x501
ch = [0, 1, 3, 4, 6];

for i = [1:5]
   JazFiles = dir([SpecDir,'/Spec_ch',num2str(ch(i)),'_dark.*']);
  
   for j = 1:numel(JazFiles)
       curFileName = JazFiles(j).name;
       
       shortName = curFileName(1:end-4);
       fullFileName = [SpecDir,'/',curFileName];
       
       [InteTime_s] = textread(fullFileName,'%f',1); % get the integration time
       InteTime(j) = InteTime_s; % in sec
       [wavelength, spectrum(:,j)] = textread(fullFileName,'%f%f',2048,'headerlines',1); % skip the first 1 line (header)
       
       SubSpectrum(:,j) = spectrum(:,j) % subtract dark
       Spec(j,:) = abs(interp1(wavelength', SubSpectrum(:,j)', wl)); % make 1 nm interval
%        figure(i); plot(wl, Spec(j,:)); hold on;
       IrradSpec(j,:) = (Spec(j,:).*IrradCal(i,:))/InteTime(j); % photon/cm^2/nm/sec
%        figure(i+5); plot(wl, IrradSpec(j,:)); hold on;
   end
   save([SpecDir,'/',shortName,'_Spec.dat'], 'IrradSpec', '-ascii');
end