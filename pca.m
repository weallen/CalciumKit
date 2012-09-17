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

