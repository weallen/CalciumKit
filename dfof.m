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

function filtered = dfof( imgdata, justDF, f0Range)
% imgdata is either Width x Height x ZSlices x Duration if not z-projected
% image, or Width x Height x Duration if zprojected
%
% justDF tells whether to compute DF/F or just DF
% 
% f0Range tells the range of slices with which to compute f0.
% f0Range can either be [start stop] where start, stop > 0 or reverse where
% reverse > 0. I.e. a vector uses a defined range in the image stack, 
% whereas a scalar starts at the _reverse_ offset, and averages over the
% previous _reverse_ frames for each frame in the stack.
%


if numel(size(imgdata)) == 4
    [Width, Height, Duration, ZSlices] = size(imgdata);
    zproj = false;
else
    [Width, Height, Duration] = size(imgdata);
    zproj = true;
    ZSlices = 1;
end

% check if f0Range is a scalar or vector
if size(f0Range, 2) == 1
    backward = true;
else
    backward = false;
end

npix = Width * Height;

%  compute the DF/F for all frames and then subset later
if ~zproj
    filtered = zeros(Width, Height, Duration, ZSlices);
else
    filtered = zeros(Width, Height, Duration);
end

for i=1:ZSlices        
    if zproj
        currslice = double(reshape(squeeze(imgdata), npix, Duration));     
    else
        currslice = double(reshape(squeeze(imgdata(:,:,:,i)), npix, Duration));   
    end
    
    currzero = (currslice == 0);
    currslice(currzero) = 1;
    
    if ~backward
        currmean = mean(currslice(:,f0Range),2);
        if justDF
            currslice = currslice - (currmean * ones(1, Duration));
        else
            currslice = currslice ./ (currmean * ones(1, Duration)) - 1;
        end
    else
        for j=(f0Range+1):Duration
            if f0Range > 1
                currmean = mean(currslice(:,(j-f0Range):(j-1)),2);              
            else
                currmean = currslice(:,j-1); 
            end
            currmean(currmean == 0) = 1;
            if justDF
                currslice(:,j) = currslice(:,j) - currmean;
            else
                currslice(:,j) = (currslice(:,j) ./ currmean) - 1;
            end
        end
    end
    currslice(currzero) = 0;
    if zproj
        filtered = reshape(currslice, [Width Height Duration]);
    else
        filtered(:,:,:,i) = reshape(currslice, [Width Height Duration]);
    end
end

clear imgdata;



end

