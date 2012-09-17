function [zMin zMax] = getZLim(handles)
    zMin = str2double(get(handles.minZEdit, 'String'));
    zMax = str2double(get(handles.maxZEdit, 'String'));

end