%%
%% CALCIUM IMAGING ANALYSIS SOFTWARE 
%% KRISTIN SCOTT LAB -- UC BERKELEY
%% (C) 2012 THE REGENTS OF THE UNIVERSITY OF CALIFORNIA
%% 
%% 
%% SOFTWARE WRITTEN BY WILL ALLEN (we.allen@gmail.com)
%%  

function zstacktotimeseries( imgdir, outdirname )
%ZSTACKTOTIMESERIES Convert a directory of ZStack multipage TIFF images to 
% a directory of timeseries multipage TIFF images (one per z section)

fnames = dir(strcat(imgdir,'/*.tiff'));
imname = strcat(imgdir,'/',fnames(1).name);
[success,message] = mkdir('.', outdirname);

if ~success
    warning(message);
end
info = imfinfo(imname);

Width = info(1).Width;
Height = info(1).Height;
ZSlices = numel(info);
Duration = numel(fnames);

Images = cell(ZSlices,1);

for j=1:ZSlices    
    fprintf('Loading slice Z=%d\n', j);
    Images{j} = uint16(zeros(Width, Height, Duration));
    for i=1:Duration        
        fullname = strcat(imgdir,'/',fnames(i).name);
        %fprintf('%s\n', fnames(i).name);                
        Images{j}(:,:,i) = imread(fullname, j);        
        %Images{j} = loadtiff(fullname);
    end
end

for j=1:ZSlices    
    fprintf('Writing slice %d\n', j);
    fullname = strcat(outdirname,'/',outdirname,'_Z', sprintf('%03d',j),'.tiff');
    saveastiff(Images{j}, fullname);    
end
end

