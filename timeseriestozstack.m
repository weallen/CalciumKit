%%
%% CALCIUM IMAGING ANALYSIS SOFTWARE 
%% KRISTIN SCOTT LAB -- UC BERKELEY
%% (C) 2012 THE REGENTS OF THE UNIVERSITY OF CALIFORNIA
%% 
%% 
%% SOFTWARE WRITTEN BY WILL ALLEN (we.allen@gmail.com)
%%  

function timeseriestozstack( imgdir, outdirname )
%ZSTACKTOTIMESERIES Convert a directory of TStack multipage TIFF images to 
% a directory of timeseries multipage TIFF images (one per t section)

fnames = dir(strcat(imgdir,'/*.tiff'));
imname = strcat(imgdir,'/',fnames(1).name);
[success,message] = mkdir(outdirname);

if ~success
    warning(message);
end

info = imfinfo(imname);

Width = info(1).Width;
Height = info(1).Height;
Duration = numel(info);
ZSlices = numel(fnames);

Images = cell(Duration,1);

for j=1:Duration    
    fprintf('Loading slice T=%d\n', j);
    Images{j} = uint16(zeros(Width, Height, ZSlices));
    for i=1:ZSlices        
        fullname = strcat(imgdir,'/',fnames(i).name);
        %fprintf('%s\n', fnames(i).name);        
        Images{j}(:,:,i) = imread(fullname, j);
    end
end

for j=1:Duration
    fprintf('Writing slice %d\n', j);
    fullname = strcat(outdirname,'/',outdirname,'_T', sprintf('%03d',j),'.tiff');
    saveastiff(Images{j}, fullname);    
end
end

