%%
%% CALCIUM IMAGING ANALYSIS SOFTWARE 
%% KRISTIN SCOTT LAB -- UC BERKELEY
%% (C) 2012 THE REGENTS OF THE UNIVERSITY OF CALIFORNIA
%% 
%% 
%% SOFTWARE WRITTEN BY WILL ALLEN (we.allen@gmail.com)
%%  

function mijdenoise( imgdir )
%MIJDENOISE Denoise image stack

[fnames, ZSlices, Width, Height, Duration] = stackinfo(imgdir,false);

%currimage = uint16(zeros(Width, Height, Duration));
opener = ij.io.Opener();
for i=1:ZSlices
    fullname = strcat(imgdir,'/',fnames(i).name);
    fprintf('Denoising %s...\n', fullname);
    currname = fnames(i).name;
    %{
    currimage = loadtiff(fullname);
    for j=1:Duration
        %currimage(:,:,j) = medfilt2(currimage(:,:,j), [5 5]);
        currimage(:,:,j) = cspin_purelet(currimage(:,:,j), 2, 3, 10);
    end
    
    MIJ.createImage(fnames(i).name, currimage, true);
    %saveastiff(currimage, fullname);
    %}
    mijread(fullname);
    
    MIJ.run('PureDenoise ...', 'parameters=[3 4] estimation=[Auto Individual]');
    %MIJ.run('PureDenoise ...', 'parameters=[1 1] estimation=[Manual 1.0 0.0 1.0]');
    
    ij.IJ.run('16-bit');
    ij.IJ.save(fullname);
    
    
    currimg = ij.IJ.getImage();
    currimg.close();    
    currimg = ij.IJ.getImage();
    currimg.close();    

end

end

