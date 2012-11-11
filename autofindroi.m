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

function handles = autofindroi( handles, filters, Z, roiThresh, numIC)
% handles is guidata handles structure, filters is nIC * Width * Height matrix of
% independent components
[minZ maxZ] = getZLim(handles);

smwidth = 1.5;
thresh = roiThresh;
plotting = false;
arealims = 100;
%filters = reshape(filters, [numIC 512 512]);
[ica_segments, segmentlabel, segcentroid] = stackicafindcells(filters, smwidth, thresh, arealims, plotting);
for kk=1:size(ica_segments, 1)
    %f = fspecial('gaussian');
    %temp =  imfilter(squeeze(ica_segments(kk,:,:)),f);
    temp = squeeze(ica_segments(kk,:,:));
    % find the first nonzero element to start trace from
    [row, col] = find(temp, 1);
    
    %temp = bwperim(temp);
    %[Y, X] = find(temp > 0);
    %coord = [X Y];
    %cntr = bwtraceboundary(temp, [row col], 'SW');
    cntr = bwboundaries(temp, 4, 'noholes');
    cntr = cntr{1};
    numPoints = size(cntr,1);
    % make mask to subsample 20% the points, ensuring that forms
    % closed loop
    %subsampMask = logical(repmat([0 0 0 0 1], 1, floor(numPoints/5)));
    subsampMask = logical([1 binornd(1,.2,1,numPoints-2) 1]);
    X = cntr(subsampMask,2);
    Y = cntr(subsampMask,1);
    handles.numMasks(Z) = handles.numMasks(Z) + 1;
    i = handles.numMasks(Z);
    handles.masks{Z}(i,:,:) = bwperim(temp); %squeeze(ica_segments(kk,:,:)) > 0);
    handles.xPoints{Z,i} = X;
    handles.yPoints{Z,i} = Y;
    colortype = getcolortype(handles);
    if strcmp(colortype, 'random')
        handles.colors{Z} = add_random_colors(handles.colors{Z},.4);  
    elseif strcmp(colortype, 'depth')
        handles.colors{Z} = add_z_colors(handles.colors{Z}, Z, maxZ);
    elseif strcmp(colortype, 'fixed')
        handles.colors{Z} = add_fixed_colors(handles.colors{Z}, handles.rgbcolor);
    end
    handles.showRoi{Z}(i) = true;
end

end

