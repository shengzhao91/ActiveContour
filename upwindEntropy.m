function [psi_out]=upwindEntropy(psi)
% psi_out is norm of the gradient of psi
    [row,col]=size(psi);
    psi_out = 0.*psi;
    for r=2:row-1
        for c=2:col-1
            temp1 = max(psi(r,c+1)-psi(r,c),0).^2;
            temp2 = min(psi(r,c)-psi(r,c-1),0).^2;
            
            temp3 = max(psi(r+1,c)-psi(r,c),0).^2;
            temp4 = min(psi(r,c)-psi(r-1,c),0).^2;
            psi_out(r,c) = sqrt(temp1+temp2+temp3+temp4);
        end
    end
end