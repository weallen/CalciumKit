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

function handles = drawroicallback( handles, h, useTotalNum)
% handles is the handles datastructure, h is the handle for an image to
% draw to, useTotalNum tells whether to use number as total in all z slices

if nargin < 2 || isempty(h)
    h = handles.imAxes;
end
if nargin < 3 || isempty(useTotalNum)
    useTotalNum = false;
end

[T Z] = getTZ(handles);

if useTotalNum
    % sum the active indices of all slices below
    [minZ maxZ] = getZLim(handles);
    offset = 0;
    for i=minZ:(Z-1)
        offset = offset + sum(handles.showRoi{i});
    end
end

nMask = handles.numMasks(Z);
showNums = get(handles.roiShowNumberCheck, 'Value');
k = 1;
for i=1:nMask
    if handles.showRoi{Z}(i)
       
        xi = handles.xPoints{Z,i};
        yi = handles.yPoints{Z,i};
        for j=1:length(xi)-1
            L1 = line([xi(j) xi(j+1)], [yi(j) yi(j+1)], 'Parent', h);
            set(L1, 'Color', handles.colors{Z}(:,i));
            set(L1, 'LineWidth',2);
        end
        if showNums == 1
            [xx,yy] = meshgrid(1:handles.width, 1:handles.height,-1:1);
            thismask = find(squeeze(handles.masks{Z}(i,:,:))==1);
            if useTotalNum
              H = text(median(xx(thismask)), median(yy(thismask)), sprintf('%d',k + offset), 'Parent', h, 'Color', 'white');
            else
                H = text(median(xx(thismask)), median(yy(thismask)), sprintf('%d',i), 'Parent', h, 'Color', 'white');
            end
            set(H, 'HorizontalAlignment', 'center');
            k = k + 1;
        end
    end
end
end

