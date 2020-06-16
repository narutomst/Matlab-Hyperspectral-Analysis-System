%%hyperDemo.m的改造版
% 直接跳过原版高光谱原始数据读取部分
% 使用Cuprite.mat数据替换原版的读入的数据

% function hyperDemo_1(hObject, handles)
function hyperDemo_1(M)  % x3
% HYPERDEMO Demonstrates the hyperspectral toolbox

clear; clc; dbstop if error; close all;
%{
%--------------------------------------------------------------------------
% Parameters

resultsDir = 'results\\';
dataDir = 'data\\AVIRIS\\';
fastIcaDir = 'FastICA_25\\';

%--------------------------------------------------------------------------

fprintf('Storing results in %s directory.\n', resultsDir);
% mkdir(resultsDir);     %在当前文件夹(地址栏中的文件夹)中创建子文件夹
if ~exist(resultsDir, 'dir') %若【当前文件夹下】不存在名为dataset的文件夹  
    mkdir(resultsDir);       %则在【当前文件夹下】创建名为dataset的文件夹
end
addpath(fastIcaDir); %将文件夹添加到搜索路径最前面
%}

filename1 = 'D:\MA毕业论文\ATrain_Record\20191002\f970620t01p02_r03_sc03.a.bip';
% Read in an HSI image and display one band
slice = hyperReadAvirisRfl(filename1, [1 100], [1 614], [132 132]);
figure; imagesc(slice); axis image; colormap(gray);
    title('Band 33');

% Read part of AVIRIS data file that we will further process
M = hyperReadAvirisRfl(filename1, [1 100], [1 614], [1 224]);
%{
% Read AVIRIS .spc file
% lambdasNm = hyperReadAvirisSpc(sprintf('%s\\f970620t01p02_r03.a.spc', dataDir));
% filename2 = 'D:\MA毕业论文\ATrain_Record\20191002\sample-data-master\92AV3C.spc';
% filename2 = 'D:\MA毕业论文\ATrain_Record\20191002\f970620t01p02_r03_sc03.a.hdr';
lambdasNm = hyperReadAvirisSpc(filename2);
figure; plot(lambdasNm, 1:length(lambdasNm)); title('Band Number Vs Wavelengths'); grid on;
    xlabel('Wavelength [nm]'); ylabel('Band Number');
 %}   
% lambdasNm 1×220 double; lambdasNm(1) =400.02, lambdasNm(end) = 2499;
% 借助'92AV3C.spc'，得知hyperReadAvirisSpc()函数的运行原理及返回值lambdasNm的具体情况
% lambdasNm是行向量，其元素为波长值。但是'92AV3C.spc'中的波长数只有220个，与'*.a.bip'的
% 通道数224并不匹配。所以为了匹配'*.a.bip'，决定读取'*.a.hdr'中的波长数据
% 来作为新的lambdasNm
%
filename2 = 'D:\MA毕业论文\ATrain_Record\20191002\f970620t01p02_r03_sc03.a.hdr';
info = read_envihdr(filename2);
lambdasNm = 1e3*info.wavelength';
figure; plot(lambdasNm, 1:length(lambdasNm)); title('Band Number Vs Wavelengths'); grid on;
    xlabel('Wavelength [nm]'); ylabel('Band Number');
    
    
% NDVI - I believe this should ideally be done with radiance data and no
% reflectance as we are doing here.
ir = M(:,:,59);
r = M(:,:,27);
ndvi = (ir - r) ./ (ir + r);
figure; imagesc(ndvi); title('NDVI of Image'); axis image; colorbar;

% Isomorph
[h, w, p] = size(M);
M = hyperConvert2d(M);


% Resample AVIRIS image.
desiredLambdasNm = 401:(2400-401)/(224-1):2400;
[s1,s2] = size(lambdasNm);
[s3,s4] = size(desiredLambdasNm);
length1 = max(s1,s2);
length2 = max(s3,s4);
d = lambdasNm(:,end)-lambdasNm(:,end-1);
if length1<length2 %若lambdasNm短于desiredLambdasNm，则尾部延展
    if s2 < s1
        lambdasNm = lambdasNm'; %转置为行向量
    end
        c =  lambdasNm(:,end)+d : d : lambdasNm(:,end)+d*(length2-length1);
        lambdasNm = [lambdasNm,c];
    if s2 < s1
        lambdasNm = lambdasNm'; %转置为原本形状
    end
elseif length1 > length2%若lambdasNm长于desiredLambdasNm，则尾部截断
    if s2 < s1
        lambdasNm = lambdasNm'; %转置为行向量
    end    
    lambdasNm = lambdasNm(:,1:length2);
    if s2 < s1
        lambdasNm = lambdasNm'; %转置为原本形态
    end
end

M = hyperResample(M, lambdasNm, desiredLambdasNm);

% Remove low SNR bands.
goodBands = [10:100 116:150 180:216];
M = M(goodBands, :);
p = length(goodBands);


% Demonstrate difference spectral similarity measurements
M = hyperConvert3d(M, h, w, p);
target = squeeze(M(32, 107, :));
figure; plot(desiredLambdasNm(goodBands), target); grid on;
    title('Target Signature; Pixel (32, 107)');
   
% Spectral Angle Mapper
M = hyperConvert3d(M, h, w, p);
target = squeeze(M(32, 107, :));

r = zeros(h, w);
for i=1:h
    for j=1:w
        r(i, j) = abs(hyperSam(squeeze(M(i,j,:)), target));
    end
end
figure; imagesc(r); title('Spectral Angle Mapper Result [radians]'); axis image;
    colorbar;

% Spectral Information Divergence
r = zeros(h, w);
for i=1:h
    for j=1:w
        r(i, j) = abs(hyperSid(squeeze(M(i,j,:)), target));
    end
end
figure; imagesc(r); title('Spectral Information Divergence Result'); axis image;
    colorbar;
    
% Normalized Cross Correlation
r = zeros(h, w);
for i=1:h
    for j=1:w
        r(i, j) = abs((hyperNormXCorr(squeeze(M(i,j,:)), target)));
    end
end
figure; imagesc(r); title('Normalized Cross Correlation [0, 1]'); axis image;
    colorbar;        
    
% PPI
U = hyperPpi(hyperConvert2d(M), 50, 1000);
figure; plot(U); title('PPI Recovered Endmembers'); grid on;
    

%--------------------------------------------------------------------------
% Perform a fully unsupervised exploitation chain using HFC, ATGP, and NNLS
fprintf('Performing fully unsupervised exploitation using HFC, ATGP, and NNLS...');
M = hyperConvert2d(M);

% Estimate number of endmembers in image.
q = hyperHfcVd(M, [10^-3]);
%q = 50;

% PCA the data to remove noise
%hyperWhiten(M)
M = hyperPct(M, q);
%p = q;

% Unmix AVIRIS image.
%U = hyperVca(M, q);
U = hyperAtgp(M, q);
figure; plot(U); title('ATGP Recovered Endmembers'); grid on;

% Create abundance maps from unmixed endmembers.

%abundanceMaps = hyperUcls(M, U);
abundanceMaps = hyperNnls(M, U);
%abundanceMaps = hyperFcls(M, U);
% abundanceMaps = hyperNormXCorr(M, U);
abundanceMaps = hyperConvert3d(abundanceMaps, h, w, q);
resultsDir = 'results\';
for i=1:q
    tmp = hyperOrthorectify(abundanceMaps(:,:,i), 21399.6, 0.53418);
    figure; imagesc(tmp); colorbar; axis image; 
        title(sprintf('Abundance Map %d', i));
        hyperSaveFigure(gcf, ['results\chain1_mam_', num2str(i), '.png']);
        close(gcf);
end
fprintf('Done.\n');
%--------------------------------------------------------------------------
% Perform another fully unsupervised exploitation chain using ICA
fprintf('Performing fully unsupervised exploitation using ICA...');
[U, abundanceMaps] = hyperIcaEea(M, q);
abundanceMaps = hyperConvert3d(abundanceMaps, h, w, q);
for i=1:q
    tmp = hyperOrthorectify(abundanceMaps(:,:,i), 21399.6, 0.53418);
    figure; imagesc(tmp); colorbar; axis image; 
        title(sprintf('Abundance Map %d', i));
        hyperSaveFigure(gcf, ['results\chain2_mam_', num2str(i), '.png']);
        close(gcf);
end
fprintf('Done.\n');