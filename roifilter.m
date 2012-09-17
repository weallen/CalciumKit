function filtered = roifilter( Images, winsize )
% INPUT: Images is WxHxDuration
% OUTPUT: Filtered is WxH
    [Width Height Duration] = size(Images);
    f_xy = mean(Images,3);
    f = mean(f_xy(:));
    temp = zeros(Width, Height, Duration);
    for j=1:Duration
        temp(:,:,j) = colfilt((double(Images(:,:,j)) - f_xy) ./ (f_xy + f), winsize, 'sliding', @filt_fun);                                  
    end
    filtered =  im2uint16(mean(temp,3));            
end

function y = filt_fun(x)
y = (mean(x).^3)';
end