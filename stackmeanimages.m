%%
%% CALCIUM IMAGING ANALYSIS SOFTWARE 
%% KRISTIN SCOTT LAB -- UC BERKELEY
%% (C) 2012 THE REGENTS OF THE UNIVERSITY OF CALIFORNIA
%% 
%% 
%% SOFTWARE WRITTEN BY WILL ALLEN (we.allen@gmail.com)
%%  

function meanimgs = stackmeanimages( imgdir )
%STACKMEANIMAGE Creates mean images 
% Input: imgdir of TIFF files of zsections, one file per time slice
% Output: stack of mean image z sections

[fnames, ZSlices, Width, Height, Duration] = stackinfo(imgdir,true);

images = uint16(zeros(Width, Height, ZSlices, Duration));

for i=1:Duration
    fullname = strcat(imgdir,'/',fnames(i).name);       
    images(:,:,:,i) = loadtiff(fullname);        
end

meanimgs = mean(images,4);

end

