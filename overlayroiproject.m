%%
%% CALCIUM IMAGING ANALYSIS SOFTWARE 
%% KRISTIN SCOTT LAB -- UC BERKELEY
%% (C) 2012 THE REGENTS OF THE UNIVERSITY OF CALIFORNIA
%% 
%% 
%% SOFTWARE WRITTEN BY WILL ALLEN (we.allen@gmail.com)
%%  

function overlayroiproject(meanImg, filter, cutoffThresh)
%OVERLAYICS Overlay colored mask based on IC over mean fluorescence image

% So far just overlays first 2 ICs...

%% try overlaying IC
%temp1 = squeeze(filter ./ max(max(filter)));
temp1 = filter;
temp1(temp1 < cutoffThresh) = 0;

%temp1 = imfilter(temp1, fspecial('gaussian', 5, 0.5));

%imfilter(squeeze(x(i,:,:)),fspecial('gaussian',5,rad));
imshow(meanImg);

green = cat(3, zeros(512,512), ones(512,512), zeros(512,512));
red = cat(3, ones(512,512), zeros(512,512), zeros(512,512));
blue = cat(3, zeros(512,512), zeros(512,512), ones(512,512));

hold on;
h = imshow(red);
hold off;
set(h, 'AlphaData', temp1);


end

