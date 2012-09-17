function colortype = getcolortype( handles )
% Returns the current color type for ROIs
colortype = get(get(handles.colorPanel, 'SelectedObject'), 'Tag');
end

