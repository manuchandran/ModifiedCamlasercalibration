function [g, gp, gpp] = CreateFilters(n, sigma)
% [g, gp, gpp] = CreateFilters(n, sigma)
% creates the filters for curvilinear structure detection. see 'An unbiased
% detector of curvilinear structures'
% n is usually -width:width.
% sigma is the variance of the Gaussian filter used for smoothing.


g = Phi(n+0.5, sigma) - Phi(n-0.5, sigma);
gp = Gaussian(n+0.5, sigma) - Gaussian(n-0.5, sigma);
gpp= GaussianP(n+0.5, sigma) - GaussianP(n-0.5, sigma);

% old implementation, used in C++. Not theoretically accurate
% g  = Phi((n+0.5), sigma) - Phi((n-0.5), sigma);
% gp = Phi((n+1), sigma) - 2*Phi(n, sigma) + Phi((n-1), sigma);
% gpp = Phi((n+1.5), sigma) - 3*Phi((n+0.5), sigma) + 3*Phi((n-0.5), sigma) - Phi((n-1.5), sigma);

end

function h = Phi(x, sigma)
h = erf(x/sigma/sqrt(2)) / 2;
end

function h = Gaussian(x, sigma)
h = exp(-x.^2 / (2*sigma^2)) / (sigma * sqrt(2*pi));
end

function h = GaussianP(x, sigma)
h = -x .* exp(-x.^2 / (2*sigma^2)) / (sigma^3 * sqrt(2*pi));
end