function x1 = FSR_xirm_NL(x1k,y1,xus,gradY,B,d,c,F2D,tau,tau10,display)
%************************************************
% This function solves the following problem :
% xus = argmin_x ||yirm - SHx||^2 + TV(x) + tau4||xirm - Link(xus)||^2
% Inputs :
%   y2      : US image (observed) of size [n1 x n2]
%   x1k     : current estimate of the MRI image (vectorized)
%   x2k     : current estimate of the US image (vectorized)
%   c       : vector of polynomial coefficients (from estimate_c)
%   gamma   : scalar weight for coupling between modalities
%   tau1    : regularization parameter (Tikhonov or similar)
%   tau2    : regularization parameter (L2 norm)
%   tau3    : regularization parameter for coupling
%   display : boolean flag for displaying the result (true/false)
%   alpha   : gradient descent step size
% Outputs :
%   x2      : updated US image after gradient descent, shape [n1 x n2]
%   fopt    : final value of the objective function
%   niter   : number of iterations performed
%************************************************
[n1y, n2y] = size(y1) ;
n = size(xus) ;
X = x1k - 4*(c(2) + 2*c(3)*x1k + 3*c(4)*x1k.^2 + 4*c(5)*x1k.^3 + c(7)*gradY + 2*c(8)*gradY.*x1k + 3*c(9)*gradY.*x1k.^2 +...    
     c(11)*gradY.^2 + 2*c(12)*gradY.^2.*x1k + c(14)*gradY.^3).*(xus - Link(x1k, c)) ;
% yirm = SHxirm + n2
STy = zeros(n) ;
STy(1:d:end, 1:d:end) = y1 ;
[FB, FBC, F2B, ~] = HXconv(STy, B, 'Hx') ;
% Analytical solution
FR = FBC.*fft2(STy) + fft2(2*tau10*X) ;
l1 = FB.*FR./(F2D + 100*tau10/tau) ;
FBR = BlockMM(n1y, n2y, d*d, n1y*n2y, l1) ;
invW = BlockMM(n1y, n2y, d*d, n1y*n2y, F2B./(F2D + 100*tau10/tau)) ;
invWBR = FBR./(invW + tau*4) ;
fun = @(block_struct) block_struct.data.*invWBR ;
FCBinvWBR = blockproc(FBC, [n1y, n2y], fun) ;
FX = (FR - FCBinvWBR)./(F2D + 100*tau10/tau)/tau ;
x1 = real(ifft2(FX)) ;
% Display
if display == true
figure ; imshow(x1, []) ; title('Super-resolved MRI image') ;
end
end

function x = BlockMM(nr, nc, Nb, m, x1)
myfun = @(block_struct) reshape(block_struct.data, m, 1) ;
x1 = blockproc(x1, [nr nc], myfun) ;
x1 = reshape(x1, m, Nb) ;
x1 = sum(x1, 2) ;
x = reshape(x1, nr, nc) ;
end