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

