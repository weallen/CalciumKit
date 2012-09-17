function zproj = isZProj(handles)
    currState = get(get(handles.stackTypePanel, 'SelectedObject'), 'Tag');  

    % default is z projection
    zproj = true;
    if strcmp(currState, 'stackRadio')
        zproj = false;
    end
end