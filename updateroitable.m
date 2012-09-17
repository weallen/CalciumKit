function handles = updateroitable( handles )
    [T Z] = getTZ(handles);
    nMask = handles.numMasks(Z);
    roiData = cell(nMask, 2);
    
    for i=1:nMask
        roiData{i,1} = colText(num2str(i), makeRgbString(handles.colors{Z}(:,i)));
       %celldata{i,1} = colText(i, 'red');
        roiData{i,2} = logical(handles.showRoi{Z}(i));
    end
    set(handles.roiTable, 'Data', roiData);
    drawnow;
 end
    
function str = makeRgbString(rgb)
    str = ['rgb(' num2str(round(255*rgb(1))) ',' num2str(round(255*rgb(2))) ',' num2str(round(255*rgb(3))) ')'];
end

function outHtml = colText(inText, inColor)
    outHtml = ['<html><b><font color="', ...
        inColor, ...
        '">', ...
        inText, ...
        '</font></b></html>'];
end

