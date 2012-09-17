function col = my_colors( x )
% map grayscale intensity values to colors from HSV color-space 

H = abs(3-mod(x-1, 6))/3 + sin((x-1)/2.23)^2/7;
S = ones(length(x), 1);
V = ones(length(x), 1);

H = min(1, max(0, H));  % force it to be on [0 1]

[R G B] = hsv2rgb([H(:) S(:) V(:)]);

col = [R B G];  % avoid blue at first



end

