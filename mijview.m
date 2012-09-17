%%
%% CALCIUM IMAGING ANALYSIS SOFTWARE 
%% KRISTIN SCOTT LAB -- UC BERKELEY
%% (C) 2012 THE REGENTS OF THE UNIVERSITY OF CALIFORNIA
%% 
%% 
%% SOFTWARE WRITTEN BY WILL ALLEN (we.allen@gmail.com)
%%  

function mijview(images)
%MIJVIEW3D Use fiji to view 2D, 3D, or 4D image stacks
if ndims(images) < 4 
    MIJ.createImage('Viewer', images, true);    
else
    %MIJ.run(
end
end

