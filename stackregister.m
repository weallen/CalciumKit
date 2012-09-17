function stackregister( foldername )
    temp = regexp(foldername, '/', 'split');
    dirname = temp(end);

    tmpname = cell2mat(strcat(dirname,'.tmp'));
    foldername 
    tmpname
    movefile(foldername, tmpname);
    
    try
        zstacktotimeseries(tmpname, dirname{1});
        movefile(dirname{1}, foldername);
        rmdir(tmpname,'s');        
    catch ME2        
        movefile(tmpname, foldername);
        rethrow(ME2);
    end
    
    % register
    mijregister(foldername);
    
    % transform back
    try
        tmpname = cell2mat(strcat(dirname,'.tmp'));
        movefile(foldername, tmpname);
        timeseriestozstack(tmpname, dirname{1});
        movefile(dirname{1}, foldername);
        rmdir(tmpname,'s');
    catch ME2
        movefile(tmpname, foldername);
        rethrow(ME2);
    end
end

