function [tMin tMax] = getTLim(handles)
    tMin = str2double(get(handles.minTEdit, 'String'));
    tMax = str2double(get(handles.maxTEdit, 'String'));
end