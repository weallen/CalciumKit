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

