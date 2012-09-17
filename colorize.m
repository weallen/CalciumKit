function img = colorize( img )
%COLORIZE Color image scaled according to colormap cmap, as
% would be shown by imagesc, in range cax
% Some ideas from freezeColors.m 


img = mat2gray(img);
img = gray2ind(img, 256);
%dfofimg = colorize(dfofimg, jet(256));\
img = ind2rgb(img, jet(256));
end
