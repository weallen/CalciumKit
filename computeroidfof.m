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

function [handles dfof] = computeroidfof(handles, plotType, useDFOpts)
% Computes matrix of DF/F over time for every ROI in the current Z section
% Inputs: handles structure, plotType (1 for DF/F, 2 for intensity, 3 for
% DF), useDFOpts (true/false) tells whether to use options from "Image
% DF/F" panel, or just to use entire
% Outputs: handles structure, Duration x numActiveRoi matrix of DF/F values
%  where duration = length(minT:maxT)
[T Z] = getTZ(handles);


if nargin < 3 || isempty(useDFOpts)
    useDFOpts = false;
end


Duration = str2double(get(handles.maxTText, 'String'));
numActiveRoi = sum(handles.showRoi{Z} == true);

fluor = zeros(Duration, numActiveRoi);
[minT maxT] = getTLim(handles);

kk = 1;
for i=1:handles.numMasks(Z)
    if handles.showRoi{Z}(i)
        thismask = squeeze(handles.masks{Z}(i,:,:))==1;
        for t=1:Duration
            temp = handles.imgdata(:,:,t,Z);
            fluor(t,kk) = mean(temp(thismask));
        end
        kk = kk + 1;
    end
end

dfof = zeros(size(fluor));

% if making DF/F plot, compute DF/F; otherwise, just use intensity
if useDFOpts
    currFState = get(get(handles.fOptionsPanel, 'SelectedObject'), 'Tag');
    if strcmp(currFState, 'dfofRollingButton')
        winSize = str2double(get(handles.dfofWinSizeEdit, 'String'));
        if winSize < 1
            msgbox('Rolling window Size < 1.', '', 'error');
            return;
        end
        f0Range = winSize;
        idx = minT:maxT;
        dfof = zeros(length(idx), size(fluor,2));
        for kk=1:length(idx)
            j = idx(kk);
            if f0Range > 1
                mF = mean(fluor((j-f0Range):(j-1),:));              
            else
                mF = fluor(j-1,:); 
            end
            if plotType == 1
                dfof(kk, :) = (fluor(j,:) ./ mF) - 1;
            elseif plotType == 2
                dfof(kk,:) = fluor(j,:);
            elseif plotType == 3
                dfof(kk,:) = fluor(j,:) - mF;
            elseif plotType == 4
                dfof = bsxfun(@minus,fluor(minT:maxT,:),mean(fluor(minT:maxT,:),1));
                dfof = bsxfun(@rdivide,dfof,max(1e-20,std(dfof,0,1)));
            end
        end
        return;
    else
        dfminT = str2double(get(handles.dfofMinTEdit, 'String'));
        dfmaxT = str2double(get(handles.dfofMaxTEdit, 'String'));
        f0Range = dfminT:dfmaxT;
        mF = mean(fluor(f0Range, :));
    end
else
    mF = mean(fluor(minT:maxT,:));
end

% DF/F
if plotType == 1
    dfof = bsxfun(@rdivide, fluor(minT:maxT,:), mF) - 1;
    % intensity
elseif plotType == 2
    dfof = fluor(minT:maxT,:);
    % DF
elseif plotType == 3
    dfof = bsxfun(@minus, fluor(minT:maxT,:), mF);
elseif plotType == 4
    dfof = bsxfun(@minus,fluor(minT:maxT,:),mean(fluor(minT:maxT,:),1));
    dfof = bsxfun(@rdivide,dfof,max(1e-20,std(dfof,0,1)));
end


end

