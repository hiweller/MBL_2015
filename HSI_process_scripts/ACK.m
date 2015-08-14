F1Gravel = '20150806145852.542_47ms.3d_47.00ms';
F1GravelWhite = '20150806150039.656_23ms.3d_23.00ms';
F1Sand = '20150730102012.079_41ms.3d_41.00ms';
F1SandWhite = '20150730102053.278_17ms.3d_17.00ms';

F2Gravel = '20150724104729.711_26ms.3d_26.00ms';
F2GravelWhite = '20150724104454.494_13ms.3d_13.00ms';
F2Sand = '20150730101055.833_42ms.3d_42.00ms';
F2SandWhite = '20150730101144.329_16ms.3d_16.00ms';
F2Rocks = '20150728102430.721_129ms.3d_129.00ms';
F2RocksWhite = '20150728102556.827_75ms.3d_75.00ms';

F3Gravel = '20150724110559.555_33ms.3d_33.00ms';
F3GravelWhite = '20150724110719.795_12ms.3d_12.00ms';
F3Sand = '20150730104549.650_36ms.3d_36.00ms';
F3SandWhite = '20150730104649.934_20ms.3d_20.00ms';

F4Gravel = '20150806145510.796_42ms.3d_42.00ms';
F4GravelWhite = '20150806145556.736_18ms.3d_18.00ms';
F4Sand = '20150730102559.874_43ms.3d_43.00ms';
F4SandWhite = '20150730102726.378_16ms.3d_16.00ms';


Buzzard4Cones = xlsread('forCC.xlsx', 'B4:E404');
Hawk4Cones = xlsread('forCC.xlsx', 'G4:J404');

RefNumber = [360, 380, 405, 420, 436, 460, 480, 500, 520, 540, 560, 580, 600, 620, 640, 660];
RefNumber = RefNumber - 299;

Buzzard4Cones = Buzzard4Cones(RefNumber,:);
Buzzard4Cones(isnan(Buzzard4Cones))=0;
Buzzard4Cones = Buzzard4Cones/norm(Buzzard4Cones, Inf);
dlmwrite('Buzzard4Cones.dat', transpose(Buzzard4Cones));

Hawk4Cones = Hawk4Cones(RefNumber,:);
Hawk4Cones(isnan(Hawk4Cones))=0;
dlmwrite('Hawk4Cones.dat', transpose(Hawk4Cones));

difishcones = [450, 545];

for i = 1:length(difishcones)
    Difish2Cones(i,:) = GenVPtemplate(difishcones(i));
end
Fish2Cones = Difish2Cones(RefNumber,:);
Fish2Cones(isnan(Fish2Cones))=0;
Fish2Cones = Fish2Cones/norm(Fish2Cones, Inf);
dlmwrite('Fish2Cones.dat', Fish2Cones);
