function [T Z] = getTZ( handles )
%GETTZ Get current T and Z values from gui
T = str2double(get(handles.currTText, 'String'));
Z = str2double(get(handles.currZText, 'String'));


end

