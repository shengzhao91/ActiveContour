clear,clc,close all
imgFilename = 'Mug.jpg';
origI = imread(imgFilename);
I = origI;
[rowI,colI,layerI] = size(I);
if (layerI == 3)
    I = rgb2gray(I);
end

I = double(I);
h = fspecial('gaussian');
temp = conv2(h,I);
I = temp(2:end-1,2:end-1);


% create initial mask
init_mask = zeros(size(I,1),size(I,2)); 
init_mask(8:72,8:72) = 1;
psi_0 = double(mask2psi(init_mask));

% alpha = [0:0.005:0.02];
% lamda = [1,0.7,0.5,0.3,0.2,0.1,0.05,0.01];
alpha = 0;
lamda = 0.2;
its = 500;

% load('lastEnergy_alpha0.mat');

for i = 1:length(alpha)
    for j = 1:length(lamda)
        [errorRate(i,j),lastEnergy(i,j),contourLength(i,j),out_its(i,j)] = ActiveContour_edge(I,origI,psi_0,alpha(i),lamda(j),its);
    end
end