function [x, y, tx, ty, st] = CurvilinearDetector(I, mask, g, gp, gpp, thr)
% [x, y, tx, ty, st] = CurvilinearDetector(I, mask, g, gp, gpp, thr)
% finds the laser points (brighter than background) in image I.
% Inputs:
% I : input image
% mask : a logical image, determining the region of search for the points
% g, gp, gpp : the Gaussian filters to compute smoothed 1st and 2nd order
% derivations of the image, created by the function 'CreateFilters'. 
% thr: minimum strenght of the points.
% Outputs:
% (x,y)  : the subpixel positions of the curve points (starting from 0)
% (tx,ty): the tangent vector to the curve
% st : strength of the curve

%% compute the subpixel curve points and the normal vector
% 1- compute 1st and 2nd order (smoothed) derivative of the image
rx = imfilter(I, g' * gp);   % averaging in y direction, derivative in x
ry = imfilter(I, gp' * g);   % averaging in x direction, derivative in y
rxx= imfilter(I, g' * gpp);  % averaging in y direction, 2nd derivative in x
ryy= imfilter(I, gpp' * g);  % averaging in x direction, 2nd derivative in y
rxy= imfilter(I, gp' * gp);  % derivatives in x & y

% 2- compute the maximum absolute eigenvalue of the Hessian matrix. the
% actual eigenvalue is -lambda. note that (rxx+ryy) will be negative for
% our points of interest.
lambda = (-(rxx + ryy) + sqrt((rxx-ryy).^2 + 4 * rxy.^2)) / 2;
mask = ((rxx+ryy) < -0.1) & (lambda > thr) & mask;

% 3- find the vector normal to the curve (it is not necessary to normalize
% the vector (nx, ny), as it will be done automatically when computing
% subpixel shift values.
nx = rxy;
ny = -lambda - rxx;

t = -(rx.*nx + ry.*ny) ./ (rxx .* nx.^2 + 2*rxy.*nx.*ny + ryy .* ny.^2);
px = t .* nx;
py = t .* ny;

%% extract curve points
% 1- the subpixel values must be theoretically less than 0.5. also, apply
% the input mask to the points
[row, col] = find((abs(px) < 0.51) & (abs(py) < 0.51) & mask);
%[row, col] = find((abs(px) < 0.51) & (abs(py) < 0.51));
idx = sub2ind(size(I), row, col);

[rowx, colx] = find((abs(px) < 0.51) & mask);
[rowy, coly] = find((abs(py) < 0.51) & mask);

R = sqrt(nx(idx).^2 + ny(idx).^2) + 1e-40;       % to avoid division by 0

% 2- extract the characteristics of the curve point
st = lambda(idx);
 x = col - px(idx) - 1;
 y = row - py(idx) - 1;
% x = col - px(idx);
% y = row - py(idx);

tx = -ny(idx) ./ R;
ty = nx(idx) ./ R;

% % % % The followings are not necessary for the future steps. 
% % % % 3- sort the extracted points
% % % [x, idx] = sort(x);
% % % y = y(idx);
% % % st = st(idx);
% % % tx = tx(idx);
% % % ty = ty(idx);
% % % 
% % % % 4- by construction, always tx >= 0. for tx = 0, make ty = 1
% % % idx = find(tx < 1e-20);
% % % tx(idx) = 0;
% % % ty(idx) = 1;