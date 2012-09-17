function filtered = stackdfof(imgdir, zproj, withFrames, f0Range, justDF)

[fnames, ZSlices, Width, Height, Duration] = stackinfo( imgdir, true);

if nargin < 2
    zproj = false;
end

if nargin < 4
    f0Range = withFrames;
end

if nargin < 5
    justDF = false;
end

if ~zproj
    if nargin < 3        
        withFrames = 1:Duration;
    else
        Duration = length(withFrames);
    end

    
    fprintf('Loading image data\n');
    % Load all image data into N x T matrix
    % where N = W x H x Z (W = width, H = height, Z = num z slices)
    % and T = num time steps
    %npix = Width * Height * ZSlices;
    imgdata = zeros(Width, Height, ZSlices, Duration);

    for kk=1:length(withFrames)
        i = withFrames(kk);
        fprintf('Loading slice T=%d\n',i);
        fullname = strcat(imgdir,'/', fnames(i).name);
        data = double(loadtiff(fullname));    
        for j=1:ZSlices
            data(:,:,j) = medfilt2(data(:,:,j), [2 2]);
        end
        imgdata(:,:,:,kk) = data;
    end
else
    if nargin < 3       
        withFrames = 1:Duration;
    else
        Duration = length(withFrames);
    end
    
    %if nargin < 5
    %    withZ = 1:ZSlices;
    %end
    
    %npix = Width * Height;
    imgdata = zeros(Width, Height, Duration);

    for kk=1:length(withFrames)
        i = withFrames(kk);
        fprintf('Loading slice T=%d\n',i);
        fullname = strcat(imgdir,'/', fnames(i).name);
        data = double(loadtiff(fullname));    
        for j=1:ZSlices
            data(:,:,j) = medfilt2(data(:,:,j), [2 2]);
        end
        %imgdata(:, kk) = reshape(zproject(data, ), [1 npix]);
        imgdata(:,:,kk) = zproject(data);
        %imgdata(imgdata(:,i) > 1*std(imgdata(:,i))) = 1*std(imgdata(:,i));
    end
end



%imgdata = zscore(imgdata,0,2);

fprintf('Computing DF/F\n');
filtered = dfof( imgdata, justDF, f0Range);

end

