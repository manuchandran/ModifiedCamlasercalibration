%clear all
%close all
%clc
fprintf('Cam1');
MyMatlabLibraryDir = 'D:\Data\Dropbox\PhD\Q8CamLasercalibration\DataAndCode\MyMatlabLibrary\';
addpath([MyMatlabLibraryDir 'Laserextractor']);
addpath(MyMatlabLibraryDir );
addpath([MyMatlabLibraryDir 'export_fig\']);
CalibFolder     = 'D:\Data\Dropbox\PhD\Q8CamLasercalibration\DataAndResults\3BeamSingleSourceLaserDataAndCalib\DataForpaper\Calibration\Final\ReDoneCalibrationC1\';
Paramfile       = [CalibFolder 'C1.dat'];
CamPara         = ReadParam(Paramfile);
imfolder        = 'D:\Data\Dropbox\PhD\Q8CamLasercalibration\DataAndResults\3BeamSingleSourceLaserDataAndCalib\DataForpaper\WithObject\';

% LAS3
Laserfile       = [CalibFolder '\L3C1.DAT'];
LaserEqu        = load(Laserfile);
imfile          = 'LASM_000000122_1.bmp';
LaserIn.Im      = imread([imfolder '\' imfile]);
LaserIn.Disp    = 0;
LaserInfo       = LaserExtractorWrap(LaserIn);
if 0 
    figure, 
    imshow(LaserIn.Im); hold on;
    plot(LaserInfo.trace(:,1)+1,LaserInfo.trace(:,2)+1,'r.')    
end
xypts           = [LaserInfo.trace(:,1),LaserInfo.trace(:,2)]';
    XYZ_WCini   = Project2Dto3D(xypts,CamPara,Laser_abcd);

    
[FR ]           = CurvedReconstructor3D(xypts,CamPara,LaserEqu);
XYZ_WCLAS3      = FR.WCi';


% LAS2
Laserfile       = [CalibFolder '\L2C1.DAT'];
LaserEqu        = load(Laserfile);
[FR ]           = CurvedReconstructor3D(xypts,CamPara,LaserEqu);
XYZ_WCLAS2      = FR.WCi';


% LAS1
Laserfile       = [CalibFolder '\L1C1.DAT'];
LaserEqu        = load(Laserfile);
[FR ]           = CurvedReconstructor3D(xypts,CamPara,LaserEqu);
XYZ_WCLAS1      = FR.WCi';

%% 
ROI3D.Xmin = 0;
ROI3D.Xmax = 45;
ROI3D.Ymin = -150;
ROI3D.Ymax = -70;
ROI3D.Zmin = -50;
ROI3D.Zmax = 250;

[XYZ_WCLAS1v2] = GetValidPointsFromROI(XYZ_WCLAS1,ROI3D);
[XYZ_WCLAS2v2] = GetValidPointsFromROI(XYZ_WCLAS2,ROI3D);
[XYZ_WCLAS3v2] = GetValidPointsFromROI(XYZ_WCLAS3,ROI3D);


%% DISPLAY AND Analysis 
Yoffset = 100.5;
Xoffset = 0.17-2;
if 0 
    figure(104), 
    plot3(XYZ_WCLAS1v2(:,2) + Yoffset,XYZ_WCLAS1v2(:,1),XYZ_WCLAS1v2(:,3),'r.'); hold on;
    plot3(XYZ_WCLAS2v2(:,2) + Yoffset,XYZ_WCLAS2v2(:,1),XYZ_WCLAS2v2(:,3),'b.'); hold on;
    plot3(XYZ_WCLAS3v2(:,2) + Yoffset,XYZ_WCLAS3v2(:,1),XYZ_WCLAS3v2(:,3),'g.'); hold on;
    xlabel('yaxis (mm) ')
    ylabel('xaxis (mm) ')
    zlabel('zaxis (mm) ')
end


ROI3DTop.Xmin = 0;
ROI3DTop.Xmax = 45;
ROI3DTop.Ymin = -150;
ROI3DTop.Ymax = -70;
ROI3DTop.Zmin = -50;
ROI3DTop.Zmax = 250;
[XYZ_WCLAS1v3] = GetValidPointsFromROI(XYZ_WCLAS1,ROI3DTop);
[XYZ_WCLAS2v3] = GetValidPointsFromROI(XYZ_WCLAS2,ROI3DTop);
[XYZ_WCLAS3v3] = GetValidPointsFromROI(XYZ_WCLAS3,ROI3DTop);

Thetax      = -0.5;
Thetay      = 0;
Thetaz      = 0;

Rotx3d       = [1 0 0;0 cosd(Thetax) -sind(Thetax) ; 0 sind(Thetax) cosd(Thetax)];
Roty3d       = [cosd(Thetay) 0 sind(Thetay) ; 0 1 0; -sind(Thetay) 0 cosd(Thetay)];
Rotz3d       = [cosd(Thetaz) -sind(Thetaz) 0; sind(Thetaz) cosd(Thetaz) 0; 0 0 1];

XYZ_WCLAS1v4 = [Rotx3d*Roty3d*Rotz3d*XYZ_WCLAS1v3']';
XYZ_WCLAS2v4 = [Rotx3d*Roty3d*Rotz3d*XYZ_WCLAS2v3']';
XYZ_WCLAS3v4 = [Rotx3d*Roty3d*Rotz3d*XYZ_WCLAS3v3']';

figure(105), 
%plot3(XYZ_WCLAS1(:,1),XYZ_WCLAS1(:,2),XYZ_WCLAS1(:,3),'r.'); hold on;
plot3(-(XYZ_WCLAS1v4(:,2) + Yoffset),XYZ_WCLAS1v4(:,1) + Xoffset,XYZ_WCLAS1v4(:,3),'r.'); hold on;
plot3(-(XYZ_WCLAS2v4(:,2) + Yoffset),XYZ_WCLAS2v4(:,1) + Xoffset,XYZ_WCLAS2v4(:,3),'b.'); hold on;
plot3(-(XYZ_WCLAS3v4(:,2) + Yoffset),XYZ_WCLAS3v4(:,1) + Xoffset,XYZ_WCLAS3v4(:,3),'g.'); hold on;
xlabel('yaxis (mm) ')
ylabel('xaxis (mm) ')
zlabel('zaxis (mm) ')
view([0 90])

XYZ_WCLAS1v5      = XYZ_WCLAS1v4;
XYZ_WCLAS2v5      = XYZ_WCLAS2v4;
XYZ_WCLAS3v5      = XYZ_WCLAS3v4;
XYZ_WCLAS1v5(:,2) = -(XYZ_WCLAS1v4(:,2) + Yoffset);
XYZ_WCLAS2v5(:,2) = -(XYZ_WCLAS2v4(:,2) + Yoffset);
XYZ_WCLAS3v5(:,2) = -(XYZ_WCLAS3v4(:,2) + Yoffset);
XYZ_WCLAS1v5(:,1) = XYZ_WCLAS1v4(:,1)  + Xoffset;
XYZ_WCLAS2v5(:,1) = XYZ_WCLAS2v4(:,1)  + Xoffset;
XYZ_WCLAS3v5(:,1) = XYZ_WCLAS3v4(:,1)  + Xoffset;

ROI3DTop.Xmin = 35;
ROI3DTop.Xmax = 45;
ROI3DTop.Ymin = 2;
ROI3DTop.Ymax = 35;
ROI3DTop.Zmin = -50;
ROI3DTop.Zmax = 250;
[XYZ_WCLAS1v6] = GetValidPointsFromROI(XYZ_WCLAS1v5,ROI3DTop);
[XYZ_WCLAS2v6] = GetValidPointsFromROI(XYZ_WCLAS2v5,ROI3DTop);
[XYZ_WCLAS3v6] = GetValidPointsFromROI(XYZ_WCLAS3v5,ROI3DTop);

figure(106), 

plot3( XYZ_WCLAS1v6(:,2), XYZ_WCLAS1v6(:,1), XYZ_WCLAS1v6(:,3),'kd'); hold on;
plot3( XYZ_WCLAS2v6(:,2), XYZ_WCLAS2v6(:,1), XYZ_WCLAS2v6(:,3),'kp'); hold on;
plot3( XYZ_WCLAS3v6(:,2), XYZ_WCLAS3v6(:,1), XYZ_WCLAS3v6(:,3),'ks'); hold on;
plot3( XYZ_WCLAS1v6(:,2), XYZ_WCLAS1v6(:,1), XYZ_WCLAS1v6(:,3),'k:'); hold on;
plot3( XYZ_WCLAS2v6(:,2), XYZ_WCLAS2v6(:,1), XYZ_WCLAS2v6(:,3),'k:'); hold on;
plot3( XYZ_WCLAS3v6(:,2), XYZ_WCLAS3v6(:,1), XYZ_WCLAS3v6(:,3),'k:'); hold on;
legend('Laser 1','Laser 2','Laser 3');
xlabel('yaxis (mm) ')
ylabel('xaxis (mm) ')
zlabel('zaxis (mm) ')
view([0 90])

L1mean      = mean(XYZ_WCLAS1v6(:,1)); 
L2mean      = mean(XYZ_WCLAS2v6(:,1)); 
L3mean      = mean(XYZ_WCLAS3v6(:,1)); 
L1std       = std(XYZ_WCLAS1v6(:,1)); 
L2std       = std(XYZ_WCLAS2v6(:,1)); 
L3std       = std(XYZ_WCLAS3v6(:,1)); 
format shortG

ObjeRef = 38;
fprintf(fid,'Cam1,%f,%f,%f\n', L1mean,L1std,L1mean-ObjeRef);
fprintf(fid,'Cam2,%f,%f,%f\n', L2mean,L2std,L2mean-ObjeRef);
fprintf(fid,'Cam3,%f,%f,%f\n', L3mean,L3std,L3mean-ObjeRef);

