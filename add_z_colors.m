function colors = add_z_colors(colors, currZ, maxZ)
% add new color for current z section, away from existing colors in HSV
% space
% There can be at most 61 ROIs in each Z section before it starts reusing
% colors. Successive colors are determined by moving along the V and S axes

% HSV color space is H in [0 360], V in [0 1] and S in [0 1]
    N = size(colors,2);
    
    maxCols = 30;
    idx = 1:maxCols;
    H = (currZ-1)/maxZ;
    S = 1;
    V = 1;
    [R G B] = hsv2rgb([H S V]);
   	colors(:,N+1) = [R B G];
end

