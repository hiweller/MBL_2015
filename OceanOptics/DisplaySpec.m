
clear;
wl = 400:700;
load spec/Spec_ch0_Spec.dat;
load spec/Spec_ch1_Spec.dat;
load spec/Spec_ch3_Spec.dat;
load spec/Spec_ch4_Spec.dat;
load spec/Spec_ch6_Spec.dat;
Spec_ch0_Spec = Spec_ch0_Spec(:,101:401); % only use from 400 to 700 nm
Spec_ch1_Spec = Spec_ch1_Spec(:,101:401);
Spec_ch3_Spec = Spec_ch3_Spec(:,101:401);
Spec_ch4_Spec = Spec_ch4_Spec(:,101:401);
Spec_ch6_Spec = Spec_ch6_Spec(:,101:401);

figure
plot(wl,Spec_ch0_Spec(1,:),'b'); hold on;
plot(wl,Spec_ch1_Spec(1,:),'c');
plot(wl,Spec_ch3_Spec(1,:),'g');
plot(wl,Spec_ch4_Spec(1,:),'m');
plot(wl,Spec_ch6_Spec(1,:),'r'); hold off;

figure
plot(wl,Spec_ch0_Spec(2,:),'b'); hold on;
plot(wl,Spec_ch1_Spec(2,:),'c');
plot(wl,Spec_ch3_Spec(2,:),'g');
plot(wl,Spec_ch4_Spec(2,:),'m');
plot(wl,Spec_ch6_Spec(2,:),'r'); hold off;

