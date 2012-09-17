function plotType = getCurrentPlotType( handles )
t = get(get(handles.plotOptionsGroup, 'SelectedObject'), 'Tag');
if strcmp(t, 'dfofOptionButton')
    plotType = 1;
elseif strcmp(t, 'intensityOptionButton')
    plotType = 2;
elseif strcmp(t, 'dfOptionButton')
    plotType = 3;
elseif strcmp(t, 'normOptionButton')
    plotType = 4;
end

end

