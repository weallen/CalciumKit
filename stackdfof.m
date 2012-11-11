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

function filtered = stackdfof(imgdir, zproj, withFrames, f0Range, justDF)

[fnames, ZSlices, Width, Height, Duration] = stackinfo( imgdir, true);

if nargin < 2
    zproj = false;
end

if nargin < 4
    f0Range = withFrames;
end

if nargin < 5
    justDF = false;
end

if ~zproj
    if nargin < 3        
        withFrames = 1:Duration;
    else
        Duration = length(withFrames);
    end

    
    fprintf('Loading image data\n');
    % Load all image data into N x T matrix
    % where N = W x H x Z (W = width, H = height, Z = num z slices)
    % and T = num time steps
    %npix = Width * Height * ZSlices;
    imgdata = zeros(Width, Height, ZSlices, Duration);

    for kk=1:length(withFrames)
        i = withFrames(kk);
        fprintf('Loading slice T=%d\n',i);
        fullname = strcat(imgdir,'/', fnames(i).name);
        data = double(loadtiff(fullname));    
        for j=1:ZSlices
            data(:,:,j) = medfilt2(data(:,:,j), [2 2]);
        end
        imgdata(:,:,:,kk) = data;
    end
else
    if nargin < 3       
        withFrames = 1:Duration;
    else
        Duration = length(withFrames);
    end
    
    %if nargin < 5
    %    withZ = 1:ZSlices;
    %end
    
    %npix = Width * Height;
    imgdata = zeros(Width, Height, Duration);

    for kk=1:length(withFrames)
        i = withFrames(kk);
        fprintf('Loading slice T=%d\n',i);
        fullname = strcat(imgdir,'/', fnames(i).name);
        data = double(loadtiff(fullname));    
        for j=1:ZSlices
            data(:,:,j) = medfilt2(data(:,:,j), [2 2]);
        end
        %imgdata(:, kk) = reshape(zproject(data, ), [1 npix]);
        imgdata(:,:,kk) = zproject(data);
        %imgdata(imgdata(:,i) > 1*std(imgdata(:,i))) = 1*std(imgdata(:,i));
    end
end



%imgdata = zscore(imgdata,0,2);

fprintf('Computing DF/F\n');
filtered = dfof( imgdata, justDF, f0Range);

end

