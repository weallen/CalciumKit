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

function [mixedfilters, mixedsig] = stackpca(imgdir, numpc, frames)
%STACKPCA Reduce dimensionality of image sequence
% and save resulting principal components.

fprintf('Loading image data\n');
% Load all image data into N x T matrix
% where N = W x H x Z (W = width, H = height, Z = num z slices)
% and T = num time steps
[fnames, ZSlices, Width, Height, Duration] = stackinfo( imgdir, true);
npix = Width * Height * ZSlices;
imgdata = zeros(npix, length(frames));
for i=frames    
    fprintf('Loading slice T=%d\n',i);
    fullname = strcat(imgdir,'/', fnames(i).name);
    imgdata(:, i) = reshape(double(loadtiff(fullname)), [1 npix]);
end

fprintf('Reducing image to principal components\n');
param.K = numpc;
param.iter = 300;

%[mixedfilters, mixedsig] = nmfdiv(imgdata, numpc, 1E-4, 300);
[mixedfilters, mixedsig] = nmf(imgdata, param);

clear imgdata;

end




function [W, H] = nmfdiv( V, rdim, termtol, maxrounds)
%

% Check that we have non-negative data
if min(V(:))<0, error('Negative values in data!'); end

% Globally rescale data to avoid potential overflow/underflow
V = V/max(V(:)) + 1e-9;

% Dimensions
vdim = size(V,1);
samples = size(V,2);

% Create initial matrices
W = abs(randn(vdim,rdim));
H = abs(randn(rdim,samples));



% Calculate initial objective
objhistory = sum(sum((V.*log(V./(W*H))) - V + W*H));

timestarted = clock;
delta = Inf;

% Start iteration
iter = 1;

while (iter < maxrounds) %&& (delta>termtol)

    % Show progress
    fprintf('[%d]: %.5f \n',iter,objhistory(end));    

    % Update iteration count
    iter = iter+1;    
    
    % Save old values
    %Wold = W;
    %Hold = H;
    
    % Compute new W and H (Lee and Seung; NIPS*2000)
    W = W.*((V./(W*H + 1e-9))*H')./(ones(vdim,1)*sum(H,2)');
    H = H.*(W'*(V./(W*H + 1e-9)))./(sum(W)'*ones(1,samples));

    % Renormalize so rows of H have constant energy
    norms = sqrt(sum(H'.^2));
    H = H./(norms'*ones(1,samples));
    W = W.*(ones(vdim,1)*norms);
    
    % Calculate objective
    newobj = sum(sum((V.*log(V./(W*H))) - V + W*H));
    objhistory = [objhistory newobj]; 	
    %delta = objhistory(iter) - objhistory(iter-1);
end
end
