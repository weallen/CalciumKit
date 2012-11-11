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

function overlayicsproject(meanImg, filters, cutoffThresh, showMeanImg)
%OVERLAYICS Overlay colored mask based on IC over mean fluorescence image
% So far just overlays first 2 ICs...

clf;

filters = (filters - mean(filters(:)))/abs(std(filters(:)));

%% try overlaying IC
%temp3 = thresh(filters, cutoffThresh, 3);
nIC = size(filters, 1);
%imfilter(squeeze(x(i,:,:)),fspecial('gaussian',5,rad));

if showMeanImg
    colormap(gray(255));
   imagesc(meanImg);
end

%ti = get(gca,'TightInset');
%set(gca,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);

green = cat(3, zeros(512,512), ones(512,512), zeros(512,512));
red = cat(3, ones(512,512), zeros(512,512), zeros(512,512));
blue = cat(3, zeros(512,512), zeros(512,512), ones(512,512));
purple = cat(3, .8*ones(512,512), .2*ones(512,512), 1*ones(512,512));

temp1 = thresh(filters, cutoffThresh, 1);

hold on;
h = imshow(purple);
hold off;
set(h, 'AlphaData', temp1);
%alim([0 0.25])

if nIC > 1
    temp2 = thresh(filters, cutoffThresh, 2);

    hold on;
    h = imshow(green);
    hold off;
    set(h, 'AlphaData', temp2);
end
%alim([0 0.25]);
%hold on;
%h = imshow(green);
%hold off;
%set(h, 'AlphaData', temp3);
set(gca, 'XLim', [1 512]);
set(gca, 'YLim', [1 512]);
set(gca,'Units', 'normalized','Position',[0 0 1 1]);

set(gca,'LooseInset',get(gca,'TightInset'))

end

function out = thresh(filt, thresh, idx)
out = double(squeeze(filt(idx,:,:) ./ max(max(filt(idx,:,:)))));
%out(out > 1.0*std(out(:))) = 1;
out(out < thresh) = 0;
%out = imfilter(out, fspecial('gaussian', 5, 0.5));

end
