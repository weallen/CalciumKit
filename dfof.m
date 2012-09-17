function filtered = dfof( imgdata, justDF, f0Range)
% imgdata is either Width x Height x ZSlices x Duration if not z-projected
% image, or Width x Height x Duration if zprojected
%
% justDF tells whether to compute DF/F or just DF
% 
% f0Range tells the range of slices with which to compute f0.
% f0Range can either be [start stop] where start, stop > 0 or reverse where
% reverse > 0. I.e. a vector uses a defined range in the image stack, 
% whereas a scalar starts at the _reverse_ offset, and averages over the
% previous _reverse_ frames for each frame in the stack.
%


if numel(size(imgdata)) == 4
    [Width, Height, Duration, ZSlices] = size(imgdata);
    zproj = false;
else
    [Width, Height, Duration] = size(imgdata);
    zproj = true;
    ZSlices = 1;
end

% check if f0Range is a scalar or vector
if size(f0Range, 2) == 1
    backward = true;
else
    backward = false;
end

npix = Width * Height;

%  compute the DF/F for all frames and then subset later
if ~zproj
    filtered = zeros(Width, Height, Duration, ZSlices);
else
    filtered = zeros(Width, Height, Duration);
end

for i=1:ZSlices        
    if zproj
        currslice = double(reshape(squeeze(imgdata), npix, Duration));     
    else
        currslice = double(reshape(squeeze(imgdata(:,:,:,i)), npix, Duration));   
    end
    
    currzero = (currslice == 0);
    currslice(currzero) = 1;
    
    if ~backward
        currmean = mean(currslice(:,f0Range),2);
        if justDF
            currslice = currslice - (currmean * ones(1, Duration));
        else
            currslice = currslice ./ (currmean * ones(1, Duration)) - 1;
        end
    else
        for j=(f0Range+1):Duration
            if f0Range > 1
                currmean = mean(currslice(:,(j-f0Range):(j-1)),2);              
            else
                currmean = currslice(:,j-1); 
            end
            currmean(currmean == 0) = 1;
            if justDF
                currslice(:,j) = currslice(:,j) - currmean;
            else
                currslice(:,j) = (currslice(:,j) ./ currmean) - 1;
            end
        end
    end
    currslice(currzero) = 0;
    if zproj
        filtered = reshape(currslice, [Width Height Duration]);
    else
        filtered(:,:,:,i) = reshape(currslice, [Width Height Duration]);
    end
end

clear imgdata;



end

