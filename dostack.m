%%
%% CALCIUM IMAGING ANALYSIS SOFTWARE 
%% KRISTIN SCOTT LAB -- UC BERKELEY
%% (C) 2012 THE REGENTS OF THE UNIVERSITY OF CALIFORNIA
%% 
%% 
%% SOFTWARE WRITTEN BY WILL ALLEN (we.allen@gmail.com)
%%  
%% Step 0: Setup path
currpath = pwd;

addpath(genpath('saveastiff'));
addpath(genpath('vlfeat'));
addpath(genpath('export_fig'));
%addpath(genpath('spams'));
%addpath(genpath('PURE-LET'));
%addpath('/Applications/Fiji.app/scripts');
%javaaddpath('/Applications/Fiji.app/jars/ij.jar');
%added /Applications/Fiji.app/jars/ij.jar and
% /Applications/Fiji.app/jars/mij.jar to classpath.txt

%setenv('MKL_NUM_THREADS','1');
%Miji;

cd(currpath);

isZStack = true;

%% Step 1: Select folder 
fprintf('>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<\n');
fprintf('>>>>>> Welcome to GCaMP Image Analyzer 1.0 <<<<<\n'); 
fprintf('>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<\n');
fprintf('Step 1: Select a directory of TIFFs for processing\n');
foldername = uigetdir();
temp = regexp(foldername, '/', 'split');
dirname = temp(end);

%% Step 2: Transform from Slidebook
fprintf('>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<\n');
fprintf('Step 2: Import z-stack TIFFs from slidebook to t-stack\n');
fprintf('(Warning: Irreversible--overwrites files)\n');
x = input('Transform? [y/n]: ','s');
if x == 'y'
    % TODO auto rename files so in correct order    
    % convert to time-series    
    tmpname = cell2mat(strcat(dirname,'.tmp'));
    movefile(foldername, tmpname);
    try
        zstacktotimeseries(tmpname, dirname{1});
        movefile(dirname{1}, foldername);
        rmdir(tmpname,'s');
        isZStack = false;
    catch ME2        
        movefile(tmpname, foldername);
        rethrow(ME2);
    end
end

%% Step 3: Register images in stack
fprintf('>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<\n');
fprintf('Step 3: Register images in stack and denoise\n');
fprintf('(Warning: Irreversible--overwrites files)\n');
x = input('Register? [y/n]: ','s');
if x == 'y'
    mijregister(foldername);
end
%%
fprintf('>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<\n');
fprintf('Step 4: Register images in stack and denoise\n');
fprintf('(Warning: Irreversible--overwrites files)\n');
x = input('Denoise? [y/n]: ','s');
if x == 'y'
    mijdenoise(foldername);
end

%%
% transform back to series of ZStacks
if ~isZStack
    tmpname = cell2mat(strcat(dirname,'.tmp'));
    movefile(foldername, tmpname);
    timeseriestozstack(tmpname, dirname{1});
    movefile(dirname{1}, foldername);
    rmdir(tmpname,'s');
    isZStack = true;
end

%% STEP 5: Analyze image stacks with either ICA or filtering
fprintf('>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<\n');
fprintf('Step 5: Do ICA and ROI filtering\n');

%% Step 5A: Do ROI filtering
[~, ZSlices, Width, Height, Duration] = stackinfo(foldername, false);
roiWinSize = [5 5];
filtered = stackroifilter(foldername, roiWinSize, false, 2:Duration);

%%
x = input('View ROI filtered image ZStack projection [y/n]: ', 's');
if x == 'y'
    figure;
    imagesc(zproject(filtered));
end
%%
x = input('View ROI filtered images in montage? [y/n]: ','s');
if x == 'y'
    mijview(filtered);
end

%clear filtered;

%%
bw = uint16(zeros(size(filtered)));
for i=1:ZSlices
    level = graythresh(filtered(:, :, i));
    bw(:,:,i) = filtered(:,:,i) > 5;  
end

%%
%mijview(bw);

%% Step 5B: Do PCA
fprintf('>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<\n');
fprintf('Step 5A: Computing PCA of stack\n');
numpc = 15;
[~, ZSlices, Width, Height, Duration] = stackinfo( foldername, true);
[mixedfilters, eigvals, mixedsig] = stackpca( foldername , numpc);

%[mixedfilters, mixedsigs] = stacknmf( foldername, numpc, 1:Duration);

% View principal componenets
x = input('View principal components? [y/n]: ','s');

if x == 'y'
    for i=1:numpc
        viewstack(mixedfilters(:,i), Width, Height, ZSlices, true); 
    end
end

%% Step 5C: Do ICA
fprintf('>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<\n');
fprintf('Step 5B: Computing ICA of stack\n');
PCuse = 1:5;
mu = 0.5;
nIC = 4;
[ica_sig, ica_filters, ica_A, numiter] = stackica(mixedfilters, mixedsig, eigvals, PCuse, mu, nIC);

%% View independent components
x = input('View ICA components in montage? [y/n]: ','s');
if x == 'y'
    for i=1:nIC
        viewstack(ica_filters(i,:), Width, Height, ZSlices, true); 
    end
end

%% Step 6: Visualize results as z-projection
fprintf('>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<\n');
fprintf('Step 6: Show ICA projection\n');

% reshape filters into image stack
reshapedFilters = zeros(nIC, Width, Height);
for i=1:nIC
    reshapedFilters(i, :, :) = zproject(reshape(abs(ica_filters(i,:)), [Width Height ZSlices]));
    %reshapedFilters(i, :, :, :) = reshape(ica_filters(i,:), [Width Height ZSlices]);
end

%% Load max intensity mean image
meanImg = zproject(stackmeanimages(foldername));
meanImg = meanImg ./ max(meanImg(:));

%%
% Show project


threshold = 2.0*std(filtered(:));
figure;
%overlayicsproject(meanImg, reshapedFilters, threshold);
overlayroiproject(meanImg, zproject(filtered), threshold);

