function [x2] = FusionPALM(y1, y2, c, tau1, tau2, tau3, tau4, d, display)
%************************************************
% PALM algorithm for MRI and US fusion
% Inputs :
%   y1     : Low-resolution MRI image
%   y2     : Noisy ultrasound (US) image
%   c      : Polynomial coefficients linking MRI and US
%   tau1   : Weight for US data fidelity
%   tau2   : Weight for US TV regularization
%   tau3   : Weight for US-MRI coupling
%   tau4   : Not used directly 
%   display: Display final resul
%   d      : Downsampling factor
% Output :
%   x2     : Fused and denoised US image guided by MRI
%************************************************
[n1, n2] = size(y2) ;
B = fspecial('gaussian', 5, 4) ; % Blur modelisation
%[FB,FBC,F2B,~] = HXconv(y2,B,'Hx');
yint = imresize(y1, 6, 'bicubic') ; % MRI super-resolution
% Compute MRI gradient
Jx = conv2(yint, [-1 1], 'same');
Jy = conv2(yint, [-1 1]', 'same');
gradY = sqrt(Jx.^2+Jy.^2) ;
%% Parameters
m_iteration = 10 ;
gamma = 1e-3 ;
% Define the difference operator kernel
dh = zeros(n1, n2) ;
dh(1, 1) = 1 ;
dh(1, 2) = -1 ;
dv = zeros(n1, n2) ;
dv(1, 1) = 1 ;
dv(2, 1) = -1 ;
% Compute FFTs for filtering
FDH = fft2(dh) ;
F2DH = abs(FDH).^2 ;
FDV = fft2(dv) ;
FDV = conj(FDV) ;
F2DV = abs(FDV).^2 ;
c1 = 1e-8 ;
F2D = F2DH + F2DV + c1 ;
%% Hyperparameters
taup = 1 ;
tau = taup ;             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% paramètre IRM (influence TV) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau10 = tau1 ;           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% paramètre IRM (influence US) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau1 = tau2 ;            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% paramètre US (influence observation) %%%%%%%%%%%%%%%%%%%%%%%
tau2 = tau3 ;            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% paramètre US (influence TV) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau3 = tau4 ;            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% paramètre US (influence IRM) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PALM
x2 = y2 + c1 ;
x1 = yint ;
for i = 1:m_iteration
    %%%%%%%%%%%%%%%%%%%%%%%%%% update Xirm %%%%%%%%%%%%%%%%%%%%%%%%%%%
    x1 = FSR_xirm_NL(x1, y1, x2, gradY, B, d, c, F2D, tau, tau10, false) ;
    %%%%%%%%%%%%%%%%%%%%%%%%%% update Xus %%%%%%%%%%%%%%%%%%%%%%%%%%%
    x2 = Descente_grad_xus_NL(y2, x1, x2, c, gamma, tau1, tau2, tau3, false, 0.2) ;
end
if display
    figure ; imshow(x2, []) ; title('Fused Image') ;
end
end