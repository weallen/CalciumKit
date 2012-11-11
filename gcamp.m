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

%% Load includes
addpath(genpath('vlfeat'));
%addpath(genpath('maxflow'));
addpath(genpath('saveastiff'));
cd vlfeat/toolbox; vl_setup;
cd ../..;

%% 


%%%% NEWER IMAGES 6/25/12
%%
% SUCROSE IMAGES
srcdir = '~/Documents/Neuroscience/scott_lab/mushroom_body_stacks/or83btrp_6_25/';
img = strcat(srcdir, '8_2_8');
suc = imstack(img,10:199, 1:1);

suc = suc.dfofnorm(50:57);

%% 
% Quinine images
srcdir = '~/Documents/Neuroscience/scott_lab/mushroom_body_stacks/or83btrp_6_25/';
img = strcat(srcdir, '8_2_13');
%quin = imstack(img, 10:199, 1:1);
quin = imstack(img, 10:199);
quin = quin.dfofnorm(1:quin.Duration);

%%
% OR83b images
srcdir = '~/Documents/Neuroscience/scott_lab/mushroom_body_stacks/or83btrp_6_25/';
% t=8, z=7
img = strcat(srcdir, '8_2_4');
or83 = imstack(img);
or83 = or83.dfofnorm(8:8);

%%%% OLDER IMAGES

%%
%imgdir = '~/Documents/Neuroscience/scott_lab/mushroom_body_stacks/6-8 121/';
imgdir1 = '~/Documents/Neuroscience/scott_lab/mushroom_body_stacks/614_trp_suc_water/water';
imgdir2 = '~/Documents/Neuroscience/scott_lab/mushroom_body_stacks/614_trp_suc_water/sucrose';
imgdir3 = '~/Documents/Neuroscience/scott_lab/mushroom_body_stacks/614_trp_suc_water/or83b';

%%
suc = imstack(imgdir2, 3:19, 4:15);

suc = suc.dfofnorm(1:13);


suc = suc.pcareduce(10);
suc = suc.denoise(3);

%%
h2o = imstack(imgdir1, 3:19, 4:15);

h2o = h2o.dfofnorm(2:5);
%%
h2o = h2o.pcareduce(10);
h2o = h2o.denoise(8);

%%
or83 = imstack(imgdir3, 3:19, 4:15);

or83 = or83.dfofnorm(6:10);
%%
or83 = or83.pcareduce(10);
or83 = or83.denoise(8);

%%
suc = suc.denoise(3);
h2o = h2o.denoise(3);
or83 = or83.denoise(3);

suc.viewstack(5);
h2o.viewstack(5);


%% Compute SIFT descriptors
binSize = 10;
magnif = 3;
Is1 = single(obj.Images{10}(:,:,1));
Is2 = single(obj.Images{10}(:,:,10));
%Is1smooth = vl_imsmooth(Is1smooth, sqrt((binSize/magnif)^2 - .25));
%Is2smooth = vl_imsmooth(Is2smooth, sqrt((binSize/magnif)^2 - .25));
%[f1,d1] = vl_dsift(Is1,'size',10,'step',10,'fast');
%[f2,d2] = vl_dsift(Is2,'size',10,'step',10,'fast');
[f1,d1] = vl_sift(Is1);
[f2,d2] = vl_sift(Is2);

[m, s] = vl_ubcmatch(d1,d2);
%% plot features
figure;
vl_tightsubplot(1,2,1);
imshow(uint16(Is1));
colormap(jet);

hold on; vl_plotframe(f1(:,m(1,:)));
for i=1:size(m,2)    
    line([f1(1,m(1,i)) f2(1,m(2,i))],...
         [f1(2,m(1,i)) f2(2,m(2,i))],'Color','red');
end

vl_tightsubplot(1,2,2);
imshow(uint16(Is2));
colormap(jet);
hold on; vl_plotframe(f2(:,m(2,:)));

%%
matched1 = f1(1:2, m(1,:));
matched2 = f2(1:2, m(2,:));

[F, inliers] = fitrobustaffine(matched1, matched2, 0.99);


figure;
%imshow(uint16(Is1));
colormap(jet);
%hold on; vl_plotframe(f1(:, inliers));

for i=1:length(inliers)
    
    %line([matched1(1, inliers(i)) matched2(1,inliers(i))],...
        %[matched1(2, inliers(i)) matched2(2,inliers(i))],'Color','red');
    
end
vl_tightsubplot(1,2,1);
imshow(uint16(Is1) + imresize(uint16(Is2), size(Is1)));


vl_tightsubplot(1,2,2);

T = cp2tform(matched1(:, inliers)', matched2(:, inliers)', 'affine');
img = imtransform(uint16(Is2), T, 'bicubic', 'Size', size(Is1));

imshow(img + uint16(Is1));
colormap(jet);

