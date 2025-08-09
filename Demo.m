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

%% Load or read images
% if needed resize MRI and US images (Nus = d*Nmri), in this example d = 6
% (d is an integer)
load('images/Data1/irm.mat') ; %MRI image
load('images/Data1/us.mat') ; % US image

%% Display observations
figure ; imshow(irm, []) ; title('MRI') ;
figure ; imshow(us, []) ; title('US') ;

% Compute the polynomial coefficients
estimate_c ;
output_args = cest ;
c = abs(output_args) ;

%% Image normalization
ym = double(irm)./double(max(irm(:))) ;
yu = double(us)./double(max(us(:))) ;

%% Initialization of PALM
d = 6 ; %MRI and US must have the same size
xm0 = imresize(ym, d, 'bicubic') ; %MRI bicubic interpolation
figure ; imshow(xm0, []) ; title('MRI super-resolution') ; 

%US denoising
net = denoisingNetwork('DnCNN') ;
xu0 = denoiseImage(yu, net) ;
figure ; imshow(xu0, []) ; title('US denoising') ; 

%% Regularization parameters
% Tune these parameters for PALM convergence
tau1 = 1e-12 ;
tau2 = 1e-15 ;
tau3 = 1e-4 ;
tau4 = 2e-4 ;

%% Fusion of MRI and US images
[x2] = FusionPALM(ym, xu0, c, tau1, tau2, tau3, tau4, d, true) ;