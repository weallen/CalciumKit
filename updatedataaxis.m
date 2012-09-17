function handles = updatedataaxis( handles, h)
% update axis with fluorescence time course of each ROI in current
% Z-section
[T Z] = getTZ(handles);
if nargin < 2 || isempty(h)
    h = handles.dataAxes;
    axes(handles.dataAxes);
else
    axes(h);
end

cla;
hold on;

%[xx,yy] = meshgrid(1:512, 1:512,-1:1);
[minT maxT] = getTLim(handles);
[minZ maxZ] = getZLim(handles);
duration = length(minT:maxT);

% compute mean intensity in each ROI at each time point
plotAllZ = ~isZProj(handles) && (get(handles.plotAllZCheck, 'Value') == 1);
if plotAllZ
    if sum(handles.numMasks) == 0
        return;
    end
    totalShown = 0;
    for i=minZ:maxZ
        totalShown = totalShown + sum(handles.showRoi{i} == true);
    end
    if totalShown == 0
        return;
    end
else
    if handles.numMasks(Z) > 0
        numActiveRoi = sum(handles.showRoi{Z} == true);
        if numActiveRoi == 0
            return;
        end
    else
        return;
    end
end

%dfof = zeros(size(fluor,1)-3,size(fluor,2));
plotType = getCurrentPlotType(handles);
useDFOpts = (get(handles.useDFCheck, 'Value') == 1);
if ~isZProj(handles)
    if get(handles.plotAllZCheck, 'Value') == 1
        currZ = Z;
        zidx = minZ:maxZ;
        alldfof = cell(length(zidx),1);
        allcolors = cell(length(zidx),1);
        allusez = cell(length(zidx),1);
        for i=1:length(minZ:maxZ)
            set(handles.currZText, 'String', num2str(zidx(i)));
            [handles dfof] = computeroidfof( handles, plotType, useDFOpts);
            alldfof{i} = dfof';
            allcolors{i} = handles.colors{zidx(i)}';
            allusez{i} = handles.showRoi{zidx(i)}';
            %alldfof = [alldfof dfof];
            %clrs = handles.colors{zidx(i)}';
            %allcolors = [allcolors; clrs];
            %allusez = [allusez handles.showRoi{zidx(i)}];
        end
        allcolors = cell2mat(allcolors);
        allusez = cell2mat(allusez);
        set(h, 'ColorOrder', allcolors(logical(allusez),:));
        dfof = cell2mat(alldfof);
        set(handles.currZText, 'String', num2str(currZ));
    else
        [handles dfof] = computeroidfof( handles, plotType, useDFOpts);
        dfof = dfof';
        % use same colors as ROIs seen on screen
        clrs = handles.colors{Z}';
        set(h, 'ColorOrder', clrs(logical(handles.showRoi{Z}),:));
    end
else
    [handles dfof] = computeroidfof( handles, plotType, useDFOpts);
    dfof = dfof';
    % use same colors as ROIs seen on screen
    clrs = handles.colors{Z}';
    set(h, 'ColorOrder', clrs(logical(handles.showRoi{Z}),:));
end

% plot the values per ROI
%dfof = filter(3, [1 3-1], dfof);
plot(minT:maxT, dfof, 'Parent', h);

if plotType == 1
    ylabel('\Delta F/F');
elseif plotType == 3
    ylabel('\Delta F');
elseif plotType == 2
    ylabel('Intensity');
elseif plotType == 4
    ylabel('Z-Score');
end
xlabel('Frame');
%set(gca, 'XLimMode', 'manual');

set(gca, 'XTick', minT:maxT);
%set(gca, 'XTickLabel', minT:maxT);
set(gca, 'XLim', [minT maxT]);
end

