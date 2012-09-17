%%
%% CALCIUM IMAGING ANALYSIS SOFTWARE 
%% KRISTIN SCOTT LAB -- UC BERKELEY
%% (C) 2012 THE REGENTS OF THE UNIVERSITY OF CALIFORNIA
%% 
%% 
%% SOFTWARE WRITTEN BY WILL ALLEN (we.allen@gmail.com)
%%  

function mijregister( imgdir )
%MIJIREGISTER 
%  Register 4D image 
% Assumes each image in imgdir is t-stack

[fnames, ZSlices, Width, Height, Duration] = stackinfo(imgdir,false);

%currimage = uint16(zeros(Width, Height, Duration));
opener = ij.io.Opener();
for i=1:ZSlices
    fullname = strcat(imgdir,'/',fnames(i).name);
    fprintf('Registering %s...\n', fullname);
    
    %currimage = loadtiff(fullname);
    
    %MIJ.createImage(fnames(i).name, currimage, true);
    mijread(fullname);
    %MIJ.run('StackReg', 'transformation=[Rigid Body]');    
    ij.IJ.run('StackReg', 'transformation=[Rigid Body]');
    ij.IJ.save(fullname);    
    currimg = ij.IJ.getImage();
    currimg.close();    
end

end

