%%% PROGRAM TO 3D CO-ORDINATES FROM IMAGE CO-ORDINATES
% 
% See Reconstruct3D for simple example.
% XYZ_WC2         = Reconstructorcpp(xypts,CamParaLeft,abcd);
% MANU CHANDRAN


% EXPECTS xypts in 2xN FORMAT WITH X IN ROW 1, Y IN ROW 2
% EXPECTS "CamPara" as a struct in the following format
%         fc: [1.285752139000000e+003 1.284070353000000e+003]
%         cc: [6.454571670000000e+002 4.520439930000000e+002]
%     alphac: -4.260000000000000e-004
%         kc: [-0.139531000000000 0.136314000000000 -0.001839000000000 8.760000000000000e-004 0.005749000000000]
%          T: [2.039317000000000e+002 3.409870000000000e+002 1.354701000000000e+002]
%          R: [3x3 double]
% 
% EXPECTS Laser_abcd AS A 1X4 MATRIX WITH LASER PARAMETERS [a b c d]

% OUTPUTS IS XYZW as 3xN MATRIX, XYZ IN WORLD COORDINATES
         
function XYZ_WC = Reconstructorcpp(xypts,CamPara,Laser_abcd)

xpts            = xypts(1,:);
ypts            = xypts(2,:);
k1              = CamPara.kc(1,1);
k2              = CamPara.kc(1,2);
k3              = CamPara.kc(1,5);
p1              = CamPara.kc(1,3);
p2              = CamPara.kc(1,4);

for ii = 1:size(ypts,2)
    % Normalizing the image points
    x_distort_0 = (xpts(1,ii) - CamPara.cc(1,1))./CamPara.fc(1,1);
    x_distort_1 = (ypts(1,ii) - CamPara.cc(1,2))./CamPara.fc(1,2);
    % Subtract principal point, and divide by the focal length
    x_distort_0 = x_distort_0 - CamPara.alphac*x_distort_1;
    % Compensate lens distortion, comp_distortion_oulu.m
    xn          = x_distort_0;
    yn          = x_distort_1;
    for kk = 1:20
        r_2         = xn*xn + yn*yn;
        k_radial    = 1 + k1*r_2 + k2*r_2*r_2 + k3*r_2*r_2*r_2;
        delta_x_0   = 2*p1*xn*yn + p2*(r_2 + 2*xn*xn);
        delta_x_1   = p1*(r_2 + 2*yn*yn) + 2*p2*xn*yn;
        xn          = (x_distort_0 - delta_x_0)/k_radial;
        yn          = (x_distort_1 - delta_x_1)/k_radial;
    end
    % RECONSTRUCTING 3D LASER POINTS FROM NORMALIZED ONES, IN CAMERA REFERENCE FRAME
    dTemp       = Laser_abcd(1,1)*xn + Laser_abcd(1,2)*yn + Laser_abcd(1,3);
    Z           = -Laser_abcd(1,4)/dTemp;
    X           = xn*Z;
    Y           = yn*Z;
    XYZ_CC(1,ii) = X;
    XYZ_CC(2,ii) = Y;
    XYZ_CC(3,ii) = Z;
    
end
R               = CamPara.R;
T               = CamPara.T;
XYZ_WC          = R*XYZ_CC + repmat(T',1,size(XYZ_CC,2));

