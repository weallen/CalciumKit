%% 

basePath = '/Users/wea/Documents/Neuroscience/scott_lab/image_data/lab_meeting_data/';
fnames = {...%'gr5a_wellfed_wholebrain', ...
          %'gr5a_wellfed_wholebrain2',...
          %'gr5a_wellfed_wholebrain3',...
          'rapid_gr5a_legs',...
          'rapid_gr5a_legs2',...
          'rapid_gr5a_prob',...
          'rapid_gr5a_prob2',...
          'Gr5a_Legs',...
          'Gr5a_Legs2',...
          'Gr5a_Prob',...
          '66ansybfly1_Prob',...
          '66ansybfly2_Legs',...
          '66ansybfly2_Prob'};
      
outdir =  '/Users/wea/Documents/Neuroscience/scott_lab/image_data/lab_meeting_data/processed/';
mkdir(outdir);

 %% Convert all files to movies
 for i=1:length(fnames)
     fprintf('Processing %s\n', fnames{i});
     fullpath = strcat(basePath, fnames{i});
     stacktoavi(fullpath, strcat(outdir, fnames{i},'.avi'));
 end
    
 
 %% Register each file  
 for i=2:length(fnames)
     fprintf('Processing %s\n', fnames{i});
     fullpath = strcat(basePath, fnames{i});
     stackregister(fullpath);
 end

 
 %% Do ROI analysis of each and save the output
 i = 1;
 winSize = 4;
for kk=9:9
   fprintf('*************Processing %s\n****************', fnames{kk});

    foldername = strcat(basePath, fnames{kk});
    [~, ZSlices, Width, Height, Duration] = stackinfo(foldername, true);
    roiWinSize = [winSize winSize];
    
    %filtered = stackroifilter(foldername, roiWinSize, true, 3:Duration);
    
    meanImg = zproject(stackmeanimages(foldername), 4:ZSlices);
    meanImg = meanImg ./ max(meanImg(:));
    
    h = figure('name', fnames{kk});
    

    %axis(fig);
    %axis tight;
    %set(gca, 'XLim', [1 512]);
    %set(gca, 'YLim', [1 512]);
    %set(gca,'Units', 'normalized','Position',[0 0 1 1]);
    %set(gcf, 'Color', [1 1 1]);
    %overlayicsproject(meanImg, reshapedFilters, threshold);

    zproj = true;
    numpc = 5;
    
    [mixedfilters, eigvals, mixedsig] = stackpca( foldername, numpc, true, 5:13, 5:20);
    
    PCuse = 1:5;
    mu = 0.5;
    nIC = 3;
    [ica_sig, ica_filters, ica_A, numiter] = stackica(mixedfilters, mixedsig, eigvals, PCuse, mu, nIC);
    
    reshapedFilters = zeros(nIC, Width, Height);
    
    for i=1:nIC
        reshapedFilters(i, :, :) = zproject(reshape(abs(ica_filters(i,:)), [Width Height]));    
    end

    

    threshold = 0.05;
    overlayicsproject(meanImg, reshapedFilters, threshold, true);
    %print(h,'-dtiffn', strcat(outdir, fnames{kk},'.tiff'));
    outname = strcat(outdir, fnames{kk},'.tiff');
    export_fig(h, outname, '-native');
    overlayicsproject(meanImg, reshapedFilters, threshold, false);
    %print(fig, '-dtiffn', strcat(outdir, fnames{kk}, '_icamask.tiff'));
    outname = strcat(outdir, fnames{kk},'_icamask.tiff');
    export_fig(h, outname, '-native', '-transparent');

end
 

%% Analyzing individual lines
basePath = '/Users/wea/Documents/Neuroscience/scott_lab/image_data/lines/';
fnames = {'428pics/428_Highstim', '428pics/428_lowstim', ...
          '852pics/852_Nostim', '852pics/852_Probstim'};
      
%%
for i=1:length(fnames)
     fprintf('Processing %s\n', fnames{i});
     fullpath = strcat(basePath, fnames{i});
     stackregister(fullpath);
end

%%
outdir =  '/Users/wea/Documents/Neuroscience/scott_lab/image_data/lines/processed/';


winSize = 4;
for kk=1:length(fnames)
   fprintf('*************Processing %s****************\n', fnames{kk});

    foldername = strcat(basePath, fnames{kk});
    [~, ZSlices, Width, Height, Duration] = stackinfo(foldername, true);
    roiWinSize = [winSize winSize];
    
    %filtered = stackroifilter(foldername, roiWinSize, false, 1:Duration);
    
    meanImg = zproject(stackmeanimages(foldername), 1:ZSlices);
    meanImg = meanImg ./ max(meanImg(:));
    
    h = figure('name', fnames{kk});     

    %axis(fig);
    %axis tight;
    %set(gca, 'XLim', [1 512]);
    %set(gca, 'YLim', [1 512]);
    %set(gca,'Units', 'normalized','Position',[0 0 1 1]);
    %set(gcf, 'Color', [1 1 1]);
    %overlayicsproject(meanImg, reshapedFilters, threshold);

    zproj = true;
    numpc = 5;
    
    [mixedfilters, eigvals, mixedsig] = stackpca( foldername, numpc, true, 1:Duration, 1:ZSlices);
    
    PCuse = 1:5;
    mu = 0.5;
    nIC = 3;
    [ica_sig, ica_filters, ica_A, numiter] = stackica(mixedfilters, mixedsig, eigvals, PCuse, mu, nIC);
    
    reshapedFilters = zeros(nIC, Width, Height);
    
%    for i=1:nIC
%        reshapedFilters(i, :, :) = zproject(reshape(abs(ica_filters(i,:)), [Width Height]));    
%    end

    smwidth = 0;
    thresh = 0.5;
    plotting = false;
    arealims = 200;
    ica_filters = reshape(ica_filters, [nIC 512 512]);
    [ica_segments, segmentlabel, segcentroid] = stackicafindcells(ica_filters, smwidth, thresh, arealims, plotting);
    
    
    %threshold = 0.05;
    %overlayicsproject(meanImg, reshapedFilters, threshold, true);
    %print(h,'-dtiffn', strcat(outdir, fnames{kk},'.tiff'));
    %outname = strcat(outdir, fnames{kk},'.tiff');
    %export_fig(h, outname, '-native');
    %overlayicsproject(meanImg, reshapedFilters, threshold, false);
    %print(fig, '-dtiffn', strcat(outdir, fnames{kk}, '_icamask.tiff'));
    %outname = strcat(outdir, fnames{kk},'_icamask.png');
    %export_fig(h, outname, '-native', '-transparent');

end


%% make DF/F images
for kk=1:length(fnames)
    fprintf('*************Processing %s****************\n', fnames{kk});
    foldername = strcat(basePath, fnames{kk});

    h = figure('name', fnames{kk});
    [~, ZSlices, Width, Height, Duration] = stackinfo(foldername, true);
    filtered = stackdfof(foldername, true, 1:Duration, 1:Duration, true);
    temp = zproject(filtered);
    insideRect = temp(50:450, 50:450);
    imagesc(temp);
    caxis([0 30000]);
    %caxis([min(insideRect(:)) max(insideRect(:))]);
end