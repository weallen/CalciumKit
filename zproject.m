%%
%% CALCIUM IMAGING ANALYSIS SOFTWARE 
%% KRISTIN SCOTT LAB -- UC BERKELEY
%% (C) 2012 THE REGENTS OF THE UNIVERSITY OF CALIFORNIA
%% 
%% 
%% SOFTWARE WRITTEN BY WILL ALLEN (we.allen@gmail.com)
%%  

function project = zproject( zstack, useZ)
%ZPROJECT Turn stack into maximum intensity z-projection
% zstack is W x H x Z

%[w h z] = size(zstack);
if nargin < 2
    useZ = 1:size(zstack,3);
end
project = squeeze(max(zstack(:,:,useZ), [], 3));

end

