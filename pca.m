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

function [mixedfilters, eigvals, mixedsig] = pca(data,numpc,nt,w,h,z)
covmat = [];
mixedsig = [];
mixedfilters = [];
eigvals = [];
npix = w*h*z;
if nt < npix
    % do svd on temporal components    
    covmat = tcov(data);
    [mixedsig, eigvals] = svd(covmat, numpc, nt, npix);
    mixedfilters = reconstruct_data(npix, data, mixedsig, eigvals);    
else    
    % do svd on spatial components    
    covmat = xcov(data);
    [mixedfilters, eigvals] = svd(covmat, numpc, nt, npix);
    mixedsig = reconstruct_data(nt, data', mixedfilters, eigvals); 
end
%mixedfilters = reshape(mixedfilters, w, h, numpc);
end

function covmat = xcov(obs)
npix = size(obs,1);
xmean = mean(obs,2);
cl = (obs' * obs) / npix;
covmat = cl - xmean' * xmean;
clear cl;
end

function covmat = tcov(obs)
npix = size(obs,1);
cl = (obs' * obs)/npix;
tmean = mean(obs,1);
covmat = cl - tmean'*tmean;
clear cl;
end

function [mixedsig, eigvals] = svd(covmat, nPC, nt, npix)
covtrace = trace(covmat) / npix;
opts.disp = 0;
opts.issym = 'true';
if nPC < size(covmat,1)
    [mixedsig, eigvals] = eigs(covmat, nPC, 'LM', opts);
else
    [mixedsig, eigvals] = eig(covmat);
    eigvals = diag(sort(diag(eigvals), 'descend'));
    nPC = size(eigvals,1);
end
eigvals = diag(eigvals);
if nnz(eigvals <= 0)
    nPC = nPC - nnz(eigvals<0);
    mixedsig = mixedsig(:,eigvals>0);
    eigvals = eigvals(eigvals>0);
end
mixedsig = mixedsig' * nt;
eigvals = eigvals / npix;

%percentvar = 100*sum(eigvals(1:nPC)/(trace(covmat)/npix);
%num2str(percentvar,3)

end

function mixedfilters = reconstruct_data(npix, obs, mixedsig, eigvals)
npc = size(mixedsig, 1);
%Sinv = inv(diag(eigvals.^(1/2)));
xmean = mean(obs,1); % average over space
movuse = obs - ones(npix,1) * xmean;
temp = (movuse * mixedsig')/diag(eigvals.^(1/2));
%mixedfilters = reshape(movuse * mixedsig' * Sinv, npix, npc);
mixedfilters = reshape(temp, npix, npc);
end

