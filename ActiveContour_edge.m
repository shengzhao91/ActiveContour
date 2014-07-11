function [errorRate,lastEnergy,contourLength,out_its] = ActiveContour_edge(I,colorI,psi_0,alpha,lamda,its,energyThresh)
load('benchmarkImage.mat')
% benchmarkImage = I<100; %cup is black
psi = psi_0;
[Ix,Iy] = gradient(I);
phi = 1./(1+lamda.*sqrt(Ix.^2+Iy.^2));

figure(1);
imshow(phi);
out_its = 0;

figure(2);
imagesc(colorI,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(psi, [0,0], 'r');
title('Initial zero level contour');

%% level-set 
[phi_x,phi_y]=gradient(phi);

Energy = zeros(1,500);
cLength = zeros(1,500);
for k=1:its
    [psi_x,psi_y]=gradient(psi);
    smallNumber=1e-6;  
    s=sqrt(psi_x.^2 + psi_y.^2);
    Nx=psi_x./(s+smallNumber); % add a small positive number to avoid division by zero
    Ny=psi_y./(s+smallNumber);
    kappa=div(Nx,Ny);
    
    % perform upwind difference
    [psi_x_u,psi_y_u]=upwindDifference(psi,phi_x,phi_y);
    
    % perform upwind entropy
    [psi_ent]=upwindEntropy(psi);
    
    idx = find(psi <= 1.2 & psi >= -1.2);

    phi_hat = phi(idx);    
    phi_hat_x = phi_x(idx);
    phi_hat_y = phi_y(idx);

    psi_t = (phi_hat.*s(idx).*kappa(idx)) ...
        + (phi_hat_x.*psi_x_u(idx) + phi_hat_y.*psi_y_u(idx)) ...
        - alpha.*phi_hat.*psi_ent(idx);
    
%     psi_t = psi_t./max(max(abs(psi_t)));
    timestep = .5/(max(max(psi_t))+eps);

    psi(idx)=psi(idx) + timestep.*psi_t;    
    psi = sussman(psi, .5);
    
    curve_idx = getZeroLevelIndex(psi);
    Energy(k) = mean(phi(curve_idx)); 
    cLength(k) = sum(sum(curve_idx));
    
%     if (Energy(k)<energyThresh & out_its==0)
%         out_its = k
%         break;
%     end
    
    if any(any(isnan(psi)))
       'paused' 
       pause(); 
    end
    
    if mod(k,50)==0
        figure(2);
        imshow(colorI,[0, 255]); axis off; axis equal; colormap(gray); hold on;  
        contour(psi, [0 0], 'g','LineWidth',4);
        contour(psi, [0 0], 'k','LineWidth',2);
        title([num2str(k), ' iterations']);
        drawnow;
    end
end

errorRate = mean(mean(abs((psi>0) - benchmarkImage)))*100;

figure(3)
plot(Energy)
lastEnergy = Energy(end);
title('Energy')
figure(4)
plot(cLength)
contourLength = min(cLength);
title('Contour Length')


end
