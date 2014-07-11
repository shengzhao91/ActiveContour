clear,clc,close all
I = imread('Mug.jpg');  %-- load the image
[rowI,colI,layerI] = size(I);
if (layerI == 3)
    I = rgb2gray(I);
end
I = double(I);
init_mask = zeros(size(I,1),size(I,2));          %-- create initial mask
init_mask(38:72,8:72) = 1;
% init_mask(35:47,16:22) = 1;

psi = mask2psi(init_mask);
Energy = zeros(1,120);
contourLength = zeros(1,120);

for its = 1:120   % Note: no automatic convergence test

    idx = find(psi <= 1.2 & psi >= -1.2);  %get the curve's narrow band
    
    %-- find interior and exterior mean
    upts = find(psi<=0);                 % interior points
    vpts = find(psi>0);                  % exterior points
    u = sum(I(upts))/(length(upts)+eps); % interior mean
    v = sum(I(vpts))/(length(vpts)+eps); % exterior mean
    
    % Narrow band
    I_hat = I(idx);
    
    [psi_x,psi_y]=gradient(psi);
    s = sqrt(psi_x.^2+psi_y.^2+eps);
    
    dpsidt = (u-v).*(I_hat-(u+v)./2).*s(idx);% + 0.1.*s(idx);
    dpsidt = dpsidt./max(abs(dpsidt));
    dt = .45/(max(dpsidt)+eps);
    psi(idx) = psi(idx) - dt.*dpsidt;
    psi = sussman(psi, .5);
    
    Energy(its) = sum((u-I(upts)).^2) + sum((v-I(vpts)).^2);
    contourLength(its) = length(idx);
    
    figure(1)
    imshow(I,'initialmagnification',500,'displayrange',[0 255]); hold on;
    contour(psi, [0 0], 'g','LineWidth',4);
    contour(psi, [0 0], 'k','LineWidth',2);
    hold off; title([num2str(its) ' Iterations']); drawnow;
end

% figure(2)
% plot(Energy)
% contourLength