function handles = slidercallbackdrawimageslice( handles )
    [T Z] = getTZ(handles);
    axes(handles.imAxes);

    cla; 
    hold on;
    
    currState = get(get(handles.stackTypePanel, 'SelectedObject'), 'Tag');    
    if strcmp(currState,  'stackRadio')
        out = double(squeeze(handles.imgdata(:,:,T,Z)));
    else
        out = double(squeeze(handles.zproj(:,:,T)));        
    end
    %out = out ./ max(out(:));  
    colormap(gray(256));
    imagesc(out, 'Parent', handles.imAxes);
    %set(handles.imAxes, 'CData', out);
end

