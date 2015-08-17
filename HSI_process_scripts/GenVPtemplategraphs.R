

GenVPtemplate <- function(LambdaMax) {
# Using template from Stavenga et al (1993)
# Based on Alpha band only
   spectrum <- rep(NA, 501)
  A <- 1
  a0 <- 380
  a1 <- 6.09
  a2 <- 13.90804
  
  for (i in 1:501) {
    logthing <- log10((i+299)/LambdaMax)
    
    spectrum[i] <- A*exp((-1)*a0*((logthing)^2)*(1+(a1*logthing)+(a2*logthing)^2))
  }
  return(spectrum)
}

wavelength <- c(300:800)

par(mar=c(3.4,3.4,2,1), mgp=c(2,0.6,0.4))

# bird
bird <- c(362, 449, 504, 563)
birdmat <- matrix(NA, nrow=length(bird), ncol=501)
for (i in 1:length(bird)) {
  birdmat[i,] <- GenVPtemplate(bird[i])
}
plot(wavelength, birdmat[1,], type='l',col='purple',
     xlab='Wavelength (nm)', ylab='Relative sensitivity',
     main='Bird vision (tetrachromatic)',
     cex.main=1.8, cex.lab=0.8, cex.axis=0.8, lwd=3)
points(wavelength, birdmat[2,], type='l', col='blue', lwd=3)
points(wavelength, birdmat[3,], type='l', col='green', lwd=3)
points(wavelength, birdmat[4,], type='l', col='red', lwd=3)


# human
human <- c(465, 550, 580)
humanmat <- matrix(NA, nrow=length(human), ncol=501)
for (i in 1:length(human)) {
  humanmat[i,] <- GenVPtemplate(human[i])
}
plot(wavelength, humanmat[1,], type='l',col='blue',
     xlab='Wavelength (nm)', ylab='Relative sensitivity',
     main='Human vision (trichromatic)', 
     cex.main=1.8, cex.lab=0.8, cex.axis=0.8, lwd=3)
points(wavelength, humanmat[2,], type='l', col='green', lwd=3)
points(wavelength, humanmat[3,], type='l', col='red', lwd=3)

# multichromatic fish
multifish <- c(400, 450, 530, 560)
multifishmat <- matrix(NA, nrow=length(multifish), ncol=501)
for (i in 1:length(multifish)) {
  multifishmat[i,] <- GenVPtemplate(multifish[i])
}
plot(wavelength, multifishmat[1,], type='l', col='purple',
     xlab='Wavelength (nm)', ylab='Relative sensitivity',
     main='Fish vision (di-, tri-, or tetrachromatic)',
     cex.main=1.8, cex.lab=0.8, cex.axis=0.8, lty=2, lwd=3)
points(wavelength, multifishmat[2,], type='l', col='blue', lwd=3)
points(wavelength, multifishmat[3,], type='l', col='green', lwd=3)
points(wavelength, multifishmat[4,], type='l', col='red', lty=2, lwd=3)

# trichromatic fish
# trifish <- c(450, 530, 560)
# trifishmat <- matrix(NA, nrow=length(trifish), ncol=501)
# for (i in 1:length(trifish)) {
#   trifishmat[i,] <- GenVPtemplate(trifish[i])
# }
# plot(wavelength, trifishmat[1,], type='l', col='blue',
#      xlab='Wavelength (nm', ylab='Relative sensitivity',
#      main='Fish vision (trichromatic)', lwd=3)
# points(wavelength, trifishmat[2,], type='l', col='green', lwd=3)
# points(wavelength, trifishmat[3,], type='l', col='red', lwd=3)
