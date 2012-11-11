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

function handles = showdfofimage(handles, dfofimg, minDfof, maxDfof)
% Show dfof image in a figure window
% inputs are handles structure, dfofimg of dimensions W x H x Duration
[T Z] = getTZ(handles);

[minT maxT] = getTLim(handles);

if get(handles.dfofBackgroundCheck, 'Value') == 1
    showBackground = true;
    bgThreshold = get(handles.dfofBgThreshSlider, 'Value');
else
    showBackground = false;
    bgThreshold = 0;
end

dfofRange = maxDfof - minDfof;

fgThreshold = get(handles.dfofFgThreshSlider, 'Value');

blurVal = round(get(handles.dfofBlurSlider, 'Value'));

h = figure;
clf;
if showBackground
    if isZProj(handles)
        background = mean(handles.zproj(:,:,minT:maxT),3);
    else
        background = mean(handles.imgdata(:,:,minT:maxT,Z),3);
    end
    
    background = background ./ max(background(:));
    background = repmat(background, [1 1 3]);
    dfofimg = zproject(dfofimg(:,:,minT:maxT));
    
    % denoise dfofimg
    if blurVal > 0
        dfofimg = medfilt2(double(dfofimg), [blurVal blurVal]);
    end
    
    mask = dfofimg < minDfof + (bgThreshold * dfofRange);
    mask = imopen(mask, strel('disk',2));
    mask = imerode(mask, strel('disk',1));
    dfofimg = colorize(dfofimg);
    rgb = colorimoverlay(background, dfofimg, mask);
    imshow(rgb);
else
    dfofimg = zproject(dfofimg(:,:,minT:maxT));
    if blurVal > 0
        dfofimg = medfilt2(double(dfofimg), [blurVal blurVal]);
    end
    imshow(colorize(dfofimg));
end

if get(handles.showRoiCheck,'Value') == 1
    handles = drawroicallback(handles, gca);
end

set(gca, 'XLim', [1 handles.width]);
set(gca, 'YLim', [1 handles.height]);

if get(handles.showScalebarCheck, 'Value') == 1
        %set(gca, 'YLim', [cmin cmax]);
        ch = colorbar;
        %set(ch, 'YLim', []);
end

end

