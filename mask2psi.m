function psi = mask2psi(mask)
  psi=bwdist(mask)-bwdist(1-mask)+im2double(mask)-.5;
end