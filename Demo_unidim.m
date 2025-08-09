%**************************************************************************
%% Fusion of magnetic resonance and ultrasound images for endometriosis detection
% Author: Oumaima El Mansouri (2019 Oct.)
% University of Toulouse, IRIT/INP-ENSEEIHT
% Email: oumaima.el-mansouri@irit.fr
%
% Copyright (2020): Oumaima El Mansouri, Fabien Vidal, Adrian~Basarab, Denis Kouamé, Jean-Yves Tourneret.
% 
% Permission to use, copy, modify, and distribute this software for
% any purpose without fee is hereby granted, provided that this entire
% notice is included in all copies of any software which is or includes
% a copy or modification of this software and in all copies of the
% supporting documentation for such software.
% This software is being provided "as is", without any express or
% implied warranty.  In particular, the authors do not make any
% representation or warranty of any kind concerning the merchantability
% of this software or its fitness for any particular purpose."
% 
% This set of MATLAB files contain an implementation of the algorithms
% described in the following paper (Without backtracking step):
% 
% [1] EL MANSOURI, Oumaima, VIDAL, Fabien, BASARAB, Adrian, et al. Fusion of magnetic resonance and ultrasound images 
% for endometriosis detection. IEEE Transactions on Image Processing, 2020, vol. 29, p. 5324-5335.
%**************************************************************************
close all
clear
clc

% Path
addpath ./images ;
addpath ./utils ;


%% DATA 2
% Ground truth
%load('images/Data2/IRM_GT.mat') ;           % MRI image
%load('images/Data2/US_GT.mat') ;            % US image
%irm = irm1_gt ;
%us = us1_gt ;

% Observed
%load('images/Data2/IRM_observed.mat') ;    % MRI image
%load('images/Data2/US_observed.mat') ;     % US image
%irm = irm1 ;
%us = us1 ;

%% DATA 3
% Ground truth
load('images/Data3/IRM_GT.mat') ;          % MRI image
load('images/Data3/US_GT.mat') ;           % US image
irm = irm_gt ;
us = us_gt ;

% Observed
%load('Data3/IRM_observed.mat') ;           % MRI image
%load('Data3/US_observed.mat') ;            % US image
%irm = irm ;
%us = us ;

%% Affichage des observations
figure ; imshow(irm, []) ; title('IRM') ;
figure ; imshow(us, []) ; title('US') ;

%% Image normalization
ym = double(irm)./double(max(irm(:))) ;
yu = double(us)./double(max(us(:))) ;

%% Estimation des coefficients du polynôme
[n1, n2] = size(ym) ;
Jx = conv2(ym, [-1 1], 'same') ;
Jy = conv2(ym, [-1; 1], 'same') ;
gradY = sqrt(Jx.^2 + Jy.^2);

yi = reshape(ym, n1*n2, 1) ;
yu_vec = reshape(yu, n1*n2, 1) ;
dyi = reshape(gradY, n1*n2, 1) ;

A = [ones(n1 * n2, 1), yi, yi.^2, yi.^3, yi.^4, ...
     dyi, dyi .* yi, dyi .* yi.^2, dyi .* yi.^3, ...
     dyi.^2, dyi.^2 .* yi, dyi.^2 .* yi.^2, ...
     dyi.^3, dyi.^3 .* yi, dyi.^4] ;

cest = pinv(A) * yu_vec ;
c = abs(cest) ;

%% Initialization of PALM
d = 1 ; %MRI and US have the same size (Data 2 and 2 only)
xm0 = imresize(ym, d, 'bicubic') ; %MRI bicubic interpolation
figure ; imshow(xm0, []) ; title('MRI super-resolution') ; 

%US denoising
net = denoisingNetwork('DnCNN') ;
xu0 = denoiseImage(yu, net) ;
figure ; imshow(xu0, []) ; title('US denoising') ; 
%save('debruitage_matlab.mat', 'xu0') ;

%% Regularization parameters
% Tune these parameters for PALM convergence
tau1 = 1e-12 ;
tau2 = 1e-15 ;
tau3 = 2e-4 ;
tau4 = 1e-4 ;

size(ym)
size(xu0)

%% Fusion of MRI and US images
[x2] = FusionPALM(ym, xu0, c, tau1, tau2, tau3, tau4, d, true) ;