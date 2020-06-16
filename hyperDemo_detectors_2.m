function hyperDemo_detectors_2(M)
% HYPERDEMO_DETECTORS Demonstrates target detector algorithms

% clear; clc; dbstop if error; close all;
%{
%--------------------------------------------------------------------------
% Parameters
resultsDir = 'results\';
dataDir = 'data\\AVIRIS\\';
%--------------------------------------------------------------------------

mkdir(resultsDir);
%}
% Read part of AVIRIS data file that we will further process
if nargin == 0
    filename1 = 'D:\MA毕业论文\ATrain_Record\20191002\f970620t01p02_r03_sc03.a.bip';
    M = hyperReadAvirisRfl(filename1, [1 100], [1 614], [1 224]);
end
M = hyperNormalize(M);
size3 = size(M,3);
% Read AVIRIS .spc file
% lambdasNm = hyperReadAvirisSpc(sprintf('%s\\f970620t01p02_r03.a.spc', dataDir));
filename2 = 'D:\MA毕业论文\ATrain_Record\20191002\f970620t01p02_r03_sc03.a.hdr';
info = read_envihdr(filename2);
lambdasNm = 1e3*info.wavelength';

lambdasNm = lambdasNm(1:size3); %保持与输入数据的波段数相同
% Isomorph
[h, w, p] = size(M);
M = hyperConvert2d(M);
% Resample AVIRIS image.
desiredLambdasNm = 400:(2400-400)/(size3-1):2400;
M = hyperResample(M, lambdasNm, desiredLambdasNm);

% Remove low SNR bands.
try
    goodBands = [10:100 116:150 180:216];
catch
    goodBands = [10:20 50:60 80:100];
end
M = M(goodBands, :);
p = length(goodBands);

% Demonstrate difference spectral similarity measurements
M = hyperConvert3d(M, h, w, p);
target = squeeze(M(11, 77, :));
figure; plot(desiredLambdasNm(goodBands), target); grid on;
    title('Target Signature; Pixel (32, 257)');

M = hyperConvert2d(M);
  
% RX Anomly Detector
r = hyperRxDetector(M);
r = hyperConvert3d(r.', h, w, 1);
figure; imagesc(r); title('RX Detector Results'); axis image;
    colorbar;
hyperSaveFigure(gcf, ['results\rxDetector.png']);

% Constrained Energy Minimization (CEM)
r = hyperCem(M, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(abs(r)); title('CEM Detector Results'); axis image;
    colorbar;    
hyperSaveFigure(gcf, ['results\cemDetector.png']);

% Adaptive Cosine Estimator (ACE)
r = hyperAce(M, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(r); title('ACE Detector Results'); axis image;
    colorbar;
hyperSaveFigure(gcf, ['results\aceDetector.png']);    

% Signed Adaptive Cosine Estimator (S-ACE)
r = hyperSignedAce(M, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(r); title('Signed ACE Detector Results'); axis image;
    colorbar;
hyperSaveFigure(gcf, ['results\signedAceDetector.png']);  

% Matched Filter
r = hyperMatchedFilter(M, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(r); title('MF Detector Results'); axis image;
    colorbar;
hyperSaveFigure(gcf, ['results\mfDetector.png']); 

% Generalized Likehood Ratio Test (GLRT) detector
r = hyperGlrt(M, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(r); title('GLRT Detector Results'); axis image;
    colorbar;
hyperSaveFigure(gcf, ['results\glrtDetector.png']);


% Estimate background endmembers
U = hyperAtgp(M, 5);

% Hybrid Unstructured Detector (HUD)
r = hyperHud(M, U, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(abs(r)); title('HUD Detector Results'); axis image;
    colorbar;
hyperSaveFigure(gcf, ['results\hudDetector.png']);
   
% Adaptive Matched Subspace Detector (AMSD)
r = hyperAmsd(M, U, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(abs(r)); title('AMSD Detector Results'); axis image;
    colorbar;
hyperSaveFigure(gcf, ['results\amsdDetector.png']);    
figure; mesh(r); title('AMSD Detector Results');

% Orthogonal Subspace Projection (OSP)
r = hyperOsp(M, U, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(abs(r)); title('OSP Detector Results'); axis image;
    colorbar;   
hyperSaveFigure(gcf, ['results\ospDetector.png']);    

