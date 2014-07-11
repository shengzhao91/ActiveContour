function [psi_x,psi_y]=upwindDifference(psi,phi_x,phi_y)
    [row,col]=size(psi);
    psi_x = 0.*psi;
    psi_y = 0.*psi;
    for r=2:row-1
        for c=2:col-1
            if phi_x(r,c)>=0
                psi_x(r,c)=psi(r,c+1)-psi(r,c); %forward
            elseif phi_x(r,c)<0
                psi_x(r,c)=psi(r,c)-psi(r,c-1); %backward
            end
            if phi_y(r,c)>0
                psi_y(r,c)=psi(r+1,c)-psi(r,c); %forward
            elseif phi_y(r,c)<0
                psi_y(r,c)=psi(r,c)-psi(r-1,c); %backward
            end
        end
    end
end