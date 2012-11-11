%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2012, William E. Allen (we.allen@gmail.com)
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification,
% are permitted provided that the following conditions are met:
%
% - Redistributions of source code must retain the above copyright notice,
%   this list of conditions and the following disclaimer.
% 
% - Redistributions in binary form must reproduce the above copyright notice,
%   this list of conditions and the following disclaimer in the documentation
%   and/or other materials provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
% EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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



