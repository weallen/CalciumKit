function saveavi(images, outname)

% TODO make fps a parameter.
aviobj = avifile(outname,'compression','None', 'fps',6);

fig = figure;

%axis fill;
set(gca, 'XLim', [1 512]);
set(gca, 'YLim', [1 512]);
set(gca,'Units', 'normalized','Position',[0 0 1 1]);
set(gcf, 'Color', [1 1 1]);



for i=1:Duration
    %vid(:,:,i) = zproject(squeeze(images(:,:,:,i)));
    proj = zproject(squeeze(images(:,:,:,i)));
    imshow(proj);
    F = getframe(fig);
    aviobj = addframe(aviobj,F);
end

%implay(vid);
close(fig);
aviobj = close(aviobj);

end
