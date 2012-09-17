%%
%% CALCIUM IMAGING ANALYSIS SOFTWARE 
%% KRISTIN SCOTT LAB -- UC BERKELEY
%% (C) 2012 THE REGENTS OF THE UNIVERSITY OF CALIFORNIA
%% 
%% 
%% SOFTWARE WRITTEN BY WILL ALLEN (we.allen@gmail.com)
%%  

function [fnames, ZSlices, Width, Height, Duration] = stackinfo( imgdir,zstack)
%STACKINFO Get information about TIFF images in 4D 
% imgdir is directory with images, zstack is true or false indicating
% whether each image in the directory contains a zstack

fnames = dir(strcat(imgdir,'/*.tiff'));
imname = strcat(imgdir,'/',fnames(1).name);

info = imfinfo(imname);

Width = info(1).Width;
Height = info(1).Height;
if zstack
    ZSlices = numel(info);
    Duration = numel(fnames);
else
    ZSlices = numel(fnames);
    Duration = numel(info);
end
end

