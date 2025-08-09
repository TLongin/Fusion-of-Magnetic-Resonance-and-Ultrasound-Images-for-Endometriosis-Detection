function gradf = gradf1_NL(x, y2, x1k, x2k, c, gamma, tau1, tau2, tau3)
X = x2k - 4*(x2k - Link(x1k, c)) ;
gradf = tau1*(gamma - exp(y2 - x)) + tau2*(dtd(x)) + tau3/2*(x - X) ;
end