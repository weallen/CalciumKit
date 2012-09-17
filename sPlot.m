function sPlot(data,colors,showRoi,useTotalNum,showNums, xaxis)
%spaced out plot of 2-d data
% Originally by Gautam Agarwal (gagarwal@berkeley.edu)
% Modified by Will Allen (we.allen@gmail.com)
if nargin < 4 || isempty(useTotalNum)
    useTotalNum = false;
end
if nargin < 5 || isempty(showNums)
    showNums = true;
end

h = figure;
set(h, 'Color','white');
set(h, 'Units', 'normalized');
activeColors = squeeze(colors(logical(showRoi),:));

if ~exist('xaxis','var') || isempty(xaxis)
    xaxis = 1:size(data,2);
end
spacing = 3*std(data(:));%5*

numTotalPlots = size(data, 2);
numUsePlots = sum(showRoi);
numT = size(data,1);
maxData = max(data(:));
minData = min(data(:));
k = 1;
if ~useTotalNum
    nums = find(showRoi == 1);
else
    nums = 1:numTotalPlots;
end

for i=1:numTotalPlots
    plot(data(:,i)-spacing*i, 'Color', activeColors(i,:), 'LineWidth', 1);
    hold on;
    if showNums
        text(0, -i*spacing+(0.5*spacing), num2str(nums(i)), 'FontSize', 7);
    end
end
%plot(data'-repmat(spacing*(1:size(data,1))',[1 size(data,2)])','linewidth',1);
%set(gca, 'ColorOrder', squeeze(colors(logical(showRoi),:)));
axis off;

%xlim(xaxis);
%{
h = figure;
set(h, 'Color','white');
activeColors = squeeze(colors(logical(showRoi),:));

numTotalPlots = size(data, 2);
numUsePlots = sum(showRoi);
numT = size(data,1);
maxData = max(data(:));
minData = min(data(:));
k = 1;
for i=1:numTotalPlots
    vl_tightsubplot(numUsePlots, 1, k, 'Box','outer');
    %set(gca,'Units','Pixels');
    %set(gca, 'Position', [0 100*k 500 10]);
    plot(data(:,i), 'Color', activeColors(i,:), 'LineWidth', 2);
    ylim([minData maxData]);
    if k < numUsePlots
        set(gca,'XTickLabel','');
        set(gca,'XTick',[]);
    else
        
        %set(gca,'XTick',[]);
    end
    text(0, 0.5, num2str(k));
    k = k + 1;
    axis off;
    
end
%}
