%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2012, William E. Allen (we.allen@gmail.com)
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification,
% are permitted provided that the following conditions are met:
%
% - Redistributions of source code must retain the above copyright notice,
%   this list of conditions and the following disclaimer.
% 
% - Redistributions in binary form must reproduce the above copyright notice,
%   this list of conditions and the following disclaimer in the documentation
%   and/or other materials provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
% EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

