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

function filtered = stackroifilter( imgdir, winsize, zproj, withFrames)
%ROIFILTER Nonlinear ROI filtering 
% from Ahrens et al, "Brain-wide neuronal dynamics during 
% motor adaptation in zebrafish" Nature, 2012
% INPUT: Directory of images in time series (one image file per time point)
% OUTPUT: Filtered stack of images
% where filter is m_xy = <<(f_xy(t) - f_xy)/(f_xy + f)>_ROI^3>_t
% and f_xy = <f_xy>_t f = <f_xy>

fprintf('Loading image data\n');
% Load all image data into N x T matrix
% where N = W x H x Z (W = width, H = height, Z = num z slices)
% and T = num time steps

if nargin < 3
    zproj = false;
end


if ~zproj
    [fnames, ZSlices, Width, Height, Duration] = stackinfo(imgdir, true);
    
    if nargin < 4        
        withFrames = 1:Duration;
    else
        Duration = length(withFrames);
    end

    Images = cell(ZSlices,1);

    filtered = zeros(Width, Height, ZSlices);

    for i=1:ZSlices    
        fprintf('Loading slice Z=%d\n', i);
        Images{i} = uint16(zeros(Width, Height, Duration));
        for j=withFrames    
            fullname = strcat(imgdir,'/',fnames(j).name);
            %fprintf('%s\n', fnames(i).name);        
            Images{i}(:,:,j) = medfilt2(imread(fullname, i), [2 2]);
        end
    end
    

    % averages and cubes m x n window

    for i=1:ZSlices    
        fprintf('Processing Z=%d\n',i);    
        f_xy = mean(Images{i},3);
        f = mean(f_xy(:));
        temp = zeros(Width, Height, Duration);
        for j=withFrames
            temp(:,:,j) = colfilt((double(Images{i}(:,:,j)) - f_xy) ./ (f_xy + f), winsize, 'sliding', @filt_fun);                                  
        end
        filtered(:,:,i) =  im2uint16(mean(temp,3));        
    end
else
    [fnames, ZSlices, Width, Height, Duration] = stackinfo(imgdir, false);

    if nargin < 4
        withFrames = 1:Duration;
    else
        Duration = length(withFrames);
    end

    
    Images = uint16(zeros(Width, Height, Duration));
    for j=1:Duration    
        fullname = strcat(imgdir,'/',fnames(1).name);
        %fprintf('%s\n', fnames(i).name);        
        %Images(:,:,j) = medfilt2(imread(fullname,j), [2 2]); 
        Images(:,:,j) = imread(fullname,j);
    end

    % averages and cubes m x n window

    
    f_xy = mean(Images,3);
    f = mean(f_xy(:));
    temp = zeros(Width, Height, Duration);
    for j=1:Duration
        temp(:,:,j) = colfilt((double(Images(:,:,j)) - f_xy) ./ (f_xy + f), winsize, 'sliding', @filt_fun);                                  
    end
    filtered =  im2uint16(mean(temp,3));            

end


end

% function applied to rearranged matrix created by colfilt
function y = filt_fun(x)
y = (mean(x).^3)';
end

