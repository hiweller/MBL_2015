function GetLightField(Date)
% Example: GetLightField('Aug7')

Channel0 = [Date,'/Spec_ch0_Spec.dat'];
Channel1 = [Date,'/Spec_ch1_Spec.dat'];
Channel3 = [Date,'/Spec_ch3_Spec.dat'];
Channel4 = [Date,'/Spec_ch4_Spec.dat'];
Channel6 = [Date,'/Spec_ch6_Spec.dat'];

Spec_ch0_Spec = load(Channel0); % 300-800 nm (Nx501, 2x501 is a set))
Spec_ch1_Spec = load(Channel1);
Spec_ch3_Spec = load(Channel3);
Spec_ch4_Spec = load(Channel4);
Spec_ch6_Spec = load(Channel6);

Spec_ch0_Spec = Spec_ch0_Spec(:,[61,81,106,121,137,161:20:361]); % only use from 360 to 660 nm at each filter Lambda-max
Spec_ch1_Spec = Spec_ch1_Spec(:,[61,81,106,121,137,161:20:361]); % Nx16 (2x16 is a set)
Spec_ch3_Spec = Spec_ch3_Spec(:,[61,81,106,121,137,161:20:361]);
Spec_ch4_Spec = Spec_ch4_Spec(:,[61,81,106,121,137,161:20:361]);
Spec_ch6_Spec = Spec_ch6_Spec(:,[61,81,106,121,137,161:20:361]);

for i = 1:ceil(size(Spec_ch0_Spec,1)/2) % determine the number of set
    LightField(1,:) = Spec_ch4_Spec((i-1)*2+1,:)/max(Spec_ch4_Spec((i-1)*2+1,:)); % UP direction (1x16, normalized to 1)
    LightField(2,:) = Spec_ch6_Spec((i-1)*2+1,:)/max(Spec_ch6_Spec((i-1)*2+1,:)); % North direction
    LightField(3,:) = Spec_ch1_Spec((i-1)*2+1,:)/max(Spec_ch1_Spec((i-1)*2+1,:)); % East direction
    LightField(4,:) = Spec_ch6_Spec(i*2,:)/max(Spec_ch6_Spec(i*2,:)); % South direction
    LightField(5,:) = Spec_ch1_Spec(i*2,:)/max(Spec_ch1_Spec(i*2,:)); % West direction
    LightField(6,:) = Spec_ch0_Spec((i-1)*2+1,:)/max(Spec_ch0_Spec((i-1)*2+1,:)); % North 45 degree direction
    LightField(7,:) = Spec_ch3_Spec((i-1)*2+1,:)/max(Spec_ch3_Spec((i-1)*2+1,:)); % East 45 degree direction
    LightField(8,:) = Spec_ch0_Spec(i*2,:)/max(Spec_ch0_Spec(i*2,:)); % South 45 degree direction
    LightField(9,:) = Spec_ch3_Spec(i*2,:)/max(Spec_ch3_Spec(i*2,:)); % West 45 degree direction
    Output_filename = [Date,'/LightField',num2str(i)];
    save(Output_filename,'LightField');
end
end


