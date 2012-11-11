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

function [aff,inliers] = fitrobustaffine( p0, p1, est_outlier_rate_or_init_aff )

% [aff] = fit_robust_affine_transform( p0, p1 )
%
% Robustly compute the affine transformation that takes points
% p0 to points p1 using RANSAC and reweigted least squares.
%
% Input:
% p0 - initial points stores as an 2xn matrix.
% p1 - points after transformation.
% wght - weight of each constraint.
% est_outlier_rate_or_init_aff - the estimated outlier rate or
%   the initial affinie transform.  It an outlier rate is specified,
%   RANSAC is used to get an initial guess.  If an affine transform is
%   specified, it is used instead.
%
% Output:
% aff - affine tranformation embeded in a 3x3 matrix.
% inliers - indices of the inliers to the estimated
%   transformation.
%
% Thomas F. El-Maraghi
% May 2004

if ~exist('wght')
    wght = ones(1,size(p0,2));
end

if ~exist('est_outlier_rate_or_init_aff')
    est_outlier_rate = 0.5;
else
    if length(est_outlier_rate_or_init_aff(:)) == 1
        est_outlier_rate = est_outlier_rate_or_init_aff;
    else
        init_aff = est_outlier_rate_or_init_aff;
    end
end

% Check that there are enough constraints
n = size(p0,2);
if n < 3
    %error( 'Too few contraints to fit affine tranform.' );
    aff = [[eye(2,2); 0 0] [0 0 1]'];
    inliers = 1:n;
end

% Perform RANSAC to generate initial guess for the
% affine transformation
%num_guesses = ceil(1.0/(1.0-est_outlier_rate)^2);
num_guesses = 1000;
best_seed = zeros(3,1);
best_median = Inf;
best_aff = zeros(3,1);
for k = 1:num_guesses
    % Select 3 random constraints
    c = [ceil(rand * n)];
    for j = 2:3
        k = ceil(rand * n);
        while any(c == k)
            k = ceil(rand * n);
        end
        c = [c; k];
    end
    
    % Build the least squares matrices
    A = [];
    b = [];
    for j = 1:3
        x = p0(1,c(j));
        y = p0(2,c(j));
        A = [A; [x 0 y 0 1 0; 0 x 0 y 0 1]];
        b = [b; p1(:,c(j))];
    end
    
    % Solve for the affine tranform
    aff = pinv(A)*b;
    %aff = A \ b;
    aff = [aff(1:2) aff(3:4) aff(5:6); 0 0 1];
    
    % Compute the residuals
    pts = aff * [p0; ones(1,n)];
    resid = sqrt(sum((pts(1:2,:) - p1).^2,1));
    
    % Save the transformation that has the lowest median residual
    if median(resid) < best_median
        best_seed = c;
        best_median = median(resid);
        best_aff = aff;
    end
end
aff = best_aff;

%sigma = 1.4826*median(resid);
inliers = find(resid <= 20);

%{ 
%resestimate matrix with all inliers
b = [];
for j = 1:sum(resid <= 1);
    x = p0(1,inliers(j));
    y = p0(2,inliers(j));
    A = [A; [x 0 y 0 1 0; 0 x 0 y 0 1]];
    b = [b; p1(:,c(j))];
end

% Solve for the affine tranform
aff = pinv(A)*b;
aff = [aff(1:2) aff(3:4) aff(5:6); 0 0 1];

end
%}

