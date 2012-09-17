function rgb = colorimoverlay( im1, im2, mask )
% overlay im2 onto im1 according to mask, where im1 and im2 are both RGB
% images
dR = im2(:,:,1);
dR(mask) = 0;
dG = im2(:,:,2);
dG(mask) = 0;
dB = im2(:,:,3);
dB(mask) = 0;
bgR = im1(:,:,1);
bgR(~mask) = 0;
bgG = im1(:,:,2);
bgG(~mask) = 0;
bgB = im1(:,:,3);
bgB(~mask) = 0;
r = max(dR, bgR);
g = max(dG, bgG);
b = max(dB, bgB);
rgb = cat(3,r,g,b);
end

