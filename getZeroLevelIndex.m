function [idx] = getZeroLevelIndex(psi)
    [row,col] = size(psi);
    idx = logical(0*psi);
    for r=2:row-1
        for c=2:col-1
            if psi(r,c)>=0
                if psi(r-1,c)<0 || psi(r+1,c)<0 || psi(r,c-1)<0 || psi(r,c+1)<0
                    idx(r,c) = true;
                end
            end
        end
    end