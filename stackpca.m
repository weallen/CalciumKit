%%
%% CALCIUM IMAGING ANALYSIS SOFTWARE 
%% KRISTIN SCOTT LAB -- UC BERKELEY
%% (C) 2012 THE REGENTS OF THE UNIVERSITY OF CALIFORNIA
%% 
%% 
%% SOFTWARE WRITTEN BY WILL ALLEN (we.allen@gmail.com)
%% BASED ON CELLSORT PACAKGE

function [mixedfilters, eigvals, mixedsig] = stackpca( imgdir , numpc, zproj, withFrames, withZ)
%STACKPCA Reduce dimensionality of image sequence
% and save resulting principal components.


[fnames, ZSlices, Width, Height, Duration] = stackinfo( imgdir, true);
if nargin < 3
    zproj = false;
end
    
if ~zproj
    if nargin < 4        
        withFrames = 1:Duration;
    else
        Duration = length(withFrames);
    end

    
    fprintf('Loading image data\n');
    % Load all image data into N x T matrix
    % where N = W x H x Z (W = width, H = height, Z = num z slices)
    % and T = num time steps
    npix = Width * Height * ZSlices;
    imgdata = zeros(npix, Duration);

    for i=1:Duration    
        fprintf('Loading slice T=%d\n',i);
        fullname = strcat(imgdir,'/', fnames(i).name);
        data = double(loadtiff(fullname));    
        for j=1:ZSlices
            data(:,:,j) = medfilt2(data(:,:,j), [1 1]);
        end
        imgdata(:, i) = reshape(data, [1 npix]);
    end
else
    if nargin < 4        
        withFrames = 1:Duration;
    else
        Duration = length(withFrames);
    end
    
    %if nargin < 5
    %    withZ = 1:ZSlices;
    %end
    
    npix = Width * Height;
    imgdata = zeros(npix, Duration);

    for i=1:Duration    
        fprintf('Loading slice T=%d\n',i);
        fullname = strcat(imgdir,'/', fnames(i).name);
        data = double(loadtiff(fullname));    
        %for j=1:ZSlices
        %    data(:,:,j) = medfilt2(data(:,:,j), [1 1]);
        %end
        imgdata(:, i) = reshape(zproject(data, withZ), [1 npix]);
        %imgdata(imgdata(:,i) > 1*std(imgdata(:,i))) = 1*std(imgdata(:,i));
    end
end



%imgdata = zscore(imgdata,0,2);

fprintf('Reducing image to principal components\n');
if ~zproj
    [mixedfilters, eigvals, mixedsig] = pca(imgdata, numpc, Duration, Width, Height, ZSlices);
else
   [mixedfilters, eigvals, mixedsig] = pca(imgdata, numpc, Duration, Width, Height, 1);
end

clear imgdata;

end



