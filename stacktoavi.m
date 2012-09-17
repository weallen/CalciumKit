function stacktoavi( imgdir,  outname)
% creates AVI movie of max intensity projection of stack


colormap(gray(256));

[fnames, ZSlices, Width, Height, Duration] = stackinfo( imgdir, true);

images = uint16(zeros(Width, Height, ZSlices, Duration));



for i=1:Duration    
    fprintf('Loading slice T=%d\n',i);
    fullname = strcat(imgdir,'/', fnames(i).name);
    data = double(loadtiff(fullname));    
    images(:,:,:,i) = data;
end

saveavi(images, outname);

end


