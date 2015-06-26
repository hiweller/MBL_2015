Convert2Tiff Installation Instructions

You must put the following three <3> data files into the c: folder before running the software

file: flatfield.bin     
desc: <the flatfield correction file - in binary> <2048 by 2048 floats>

file: deconvolution.txt 
desc: <this is the band leakage inversion matrix, 256 elements> <16 by 16 doubles>

file: radiance_calibration.txt
desc: <this is the mapping from counts to radiance for each band>

<Program Executable>

Convert2Tiff.exe <convert to Tiff executable>

Should run from anywhere on the computer. Only the data files need to be located in the C: folder.
