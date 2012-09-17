%%
%% CALCIUM IMAGING ANALYSIS SOFTWARE 
%% KRISTIN SCOTT LAB -- UC BERKELEY
%% (C) 2012 THE REGENTS OF THE UNIVERSITY OF CALIFORNIA
%% 
%% 
%% SOFTWARE WRITTEN BY WILL ALLEN (we.allen@gmail.com)
%%  

function  viewstack(stack,w,h,z,montage)
%VIEWSTACK Shows montage of images in stack.
% Stack is W * H * Z x 1 matrix

if nargin < 5
    montage = false;
end
    
if montage == false
    images = reshape(stack, [w h z]);
    mijview(images);
else
    figure;
    images = reshape(stack, [w h 1 z]);
    %montage(images, 'DisplayRange', [1 max(stack)]);
    %montage(images, [-2E-8, 2E-8]);
    rectsize = ceil(sqrt(z));

    aspectRatio = 1;
    montageCols = sqrt(aspectRatio * w * z / h);

                % Make sure montage rows and columns are integers. The order in
                % the adjustment matters because the montage image is created
                % horizontally across columns.
    montageCols = ceil(montageCols);
    montageRows = ceil(z / montageCols);
    montageSize = [montageRows montageCols];

    k = 1;

    for i=1:rectsize
        for j=1:rectsize
            vl_tightsubplot(montageSize(1), montageSize(2), k);
            if k < z
                %imagesc(images(:,:,1,k), [-2E-8 2E-8]);
                imagesc(images(:,:,1,k));
                axis image tight off;            
                set(gca,'XTick',[]);
                set(gca,'YTick',[]);
            end
            k = k + 1;
        end
    end
end
end

