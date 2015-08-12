function spectrum = GenVPtemplate(LambdaMax)

% Using template from Stavenga et al (1993)
% Based on Alpha band only
A = 1;
a0 = 380;
a1 = 6.09;
a2 = 13.90804;

for i = 1:501
    spectrum(i) = A*exp((-1)*a0*((log10((i+299)/LambdaMax))^2)*(1+(a1*(log10((i+299)/LambdaMax)))+(a2*(log10((i+299)/LambdaMax))^2)));
end
% wavelength = 300:800;

% plot(wavelength,spectrum);

% bird is like ~400, ~460, ~540, ~600

