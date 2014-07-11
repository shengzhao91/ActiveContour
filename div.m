function f = div(nx,ny)
[nxx,nxy]=gradient(nx);  
[nyx,nyy]=gradient(ny);
f=nxx+nyy;

% num = nxx.*ny.^2 - 2.*nxy.*nx.*ny + nyy.*nx.^2;
% den = (nx.^2+ny.^2+smallNumber).^(3/2);
% f = num./den;
