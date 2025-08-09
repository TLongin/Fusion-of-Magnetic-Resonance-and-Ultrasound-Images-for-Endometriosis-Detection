function [x2, fopt, niter] = Descente_grad_xus_NL(y2, x1k, x2k, c, gamma, tau1, tau2, tau3, display, alpha)
%************************************************
% This function solves the following problem :
% xirm = argmin_x ||SHx - yirm||^2 + ||Dx||^2 + ||xus - (c1 + c2*gradY + c3*xirm)||^2
% Inputs : 
%    y2 : US image (observed) n1y*n2y
%    xus : US image after denoising (at the step k) n1*n2
%    B : 2D filter for MRI image blurring (H = F^hBF) 7*7
%    d : MRI super-resolution ratio (integer)
%    c1, c2 : polymone coefficients that link xus and xirm
%    F2D: Fourier transform of the analytical derivative 
%    tau : hyperparameter, influence of total variation (TV)
%    tau10 : hyperparameter, influence of US
%    a : display output (if a = 'true')
% Output : 
%    x1 : super-resolved image n1*n2
%************************************************
[n1, n2] = size(y2) ;
c1 = 1e-8 ;
y2 = reshape(y2, n1*n2, 1) ;
x1k = reshape(x1k, n1*n2, 1) ;
x2k = reshape(x2k, n1*n2, 1) ;
x0 = y2 + c1;
f = @(x)f1_NL(x, y2, x1k, x2k, c, gamma, tau1, tau2, tau3) ;
gradf = @(x)gradf1_NL(x, y2, x1k, x2k, c, gamma, tau1, tau2, tau3) ;
% Termination tolerance
tol = 1e-6 ;
% Maximum number of allowed iterations
maxiter = 100 ;
% Minimum allowed perturbation
dxmin = 1e-2 ;
% Initialize gradient norm, optimization vector, iteration counter, perturbation
gnorm = inf ; 
x = x0 ; 
niter = 0 ; 
dx = inf ;
while and(gnorm >= tol, and(niter <= maxiter, dx >= dxmin))
    % Calculate gradient
    g = gradf(x) ;
    % Take step
    xnew = x - alpha*g ;
    % Check step
    if ~ isfinite(xnew)
        display(['Number of iterations : ' num2str(niter)])
        error('x is inf or NaN')
    end
    % Update termination metrics
    niter = niter + 1 ;
    dx = norm(xnew - x) ;
    x = xnew ;
end
fopt = f(x) ;
niter = niter - 1 ;
x = reshape(x, n1, n2) ;
x2 = x ;
% Display
if (display == true)
figure ; imshow(x2, []) ; title('Denoised US image') ;
end
end