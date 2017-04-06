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
         
function [FR ] = CurvedReconstructor3D(xypts,CamPara,Laser_p)


FR.p000 = Laser_p(1,1);
FR.p100 = Laser_p(1,2);
FR.p010 = Laser_p(1,3);
FR.p001 = Laser_p(1,4);
FR.p200 = Laser_p(1,5);
FR.p020 = Laser_p(1,6);
FR.p002 = Laser_p(1,7);
% fprintf(fid,'%5.15f %5.15f %5.15f %5.15f %5.15f %5.15f %5.15f', ...
%             eq3d.p000,eq3d.p100,eq3d.p010,eq3d.p001, ...
%             eq3d.p200,eq3d.p020,eq3d.p002 ...    
%         );
%     

    CrossVars    = 0;
    xyn          = normalize_pixel(xypts,CamPara.fc,CamPara.cc,CamPara.kc,CamPara.alphac);
    xn           = xyn(1,:);
    yn           = xyn(2,:);
% RECONSTRUCTING 3D LASER POINTS FROM NORMALIZED ONES, IN CAMERA REFERENCE FRAME


    A            = FR.p200*xn.^2 + FR.p020*yn.^2 + FR.p002;
    B            = FR.p100*xn + FR.p010*yn + FR.p001;
    C            = FR.p000;
      
    Z           = (-B - sqrt(B.^2 - 4*A*C))./(2*A);
    X           = xyn(1,:).*Z;
    Y           = xyn(2,:).*Z;
    XYZ_CC      = [X; Y; Z];    

 
    R               = CamPara.R;
    T               = CamPara.T;
    XYZ_WC          = R*XYZ_CC + repmat(T',1,size(XYZ_CC,2));

    FR.WCi          = XYZ_WC;
    FR.CCi          = XYZ_CC;
    
%%      
    %     dTemp       = Laser_abcd(1,1)*xyn(1,:) + Laser_abcd(1,2)*xyn(2,:) + Laser_abcd(1,3);
    %     Z           = -Laser_abcd(1,4)./dTemp;

    
    %[FR, gof]      = createSurfaceFitplane(Laserpts(:,1), Laserpts(:,2), Laserpts(:,3));
    %Z           = FR.p00./(-FR.p10*xn - FR.p01*yn + 1);
    %[FR, gof]      = createSurfaceFitpoly(Laserpts(:,1), Laserpts(:,2), Laserpts(:,3));
   

