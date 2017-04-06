clear all
close all
clc

load('XYZ_7beamlaserdata.mat');


figure,
plot3(XYZ_bout(:,1),XYZ_bout(:,2),XYZ_bout(:,3),'r.');hold on;

range1     = 100000:130000;
range2     = 300000:330000;
range3     = 400000:430000;

X   = XYZ_bout([range1 range2 range3],:);
[class,type]    =   dbscan3d(X,100,5);

figure, 
plot3(XYZ_bout(range1,1),XYZ_bout(range1,2),XYZ_bout(range1,3),'r.'); hold on;
plot3(XYZ_bout(range2,1),XYZ_bout(range2,2),XYZ_bout(range2,3),'r.'); hold on;
plot3(XYZ_bout(range3,1),XYZ_bout(range3,2),XYZ_bout(range3,3),'r.'); hold on;

c = class;
plot3(X(c==1,1),X(c==1,2),X(c==1,3),'bo')
plot3(X(c==2,1),X(c==2,2),X(c==2,3),'mo')
plot3(X(c==3,1),X(c==3,2),X(c==3,3),'go')
plot3(X(c==4,1),X(c==4,2),X(c==4,3),'co')
plot3(X(c==5,1),X(c==5,2),X(c==5,3),'b+')
plot3(X(c==6,1),X(c==6,2),X(c==6,3),'m+')
plot3(X(c==7,1),X(c==7,2),X(c==7,3),'g+')

DistThreshold   = 10;
for ii = 1:7
    PData   = X(c==ii,:);
    [s,p]   = best_fit_plane(PData(:,1),PData(:,2),PData(:,3));
    a1 = p(1);
    b1 = p(2);
    c1 = p(3);
    d1 = p(4);
    syms x y z
    z1plane = -(b1*y)/c1 - (a1*x)/c1 - d1/c1;
    ezmesh(z1plane, [-200, 200, -150, 150]);
    dist                = p(1)*PData(:,1) + p(2)*PData(:,2) + p(3)*PData(:,3) + p(4);
    ValidPlaneIdx       = (abs(dist) < DistThreshold);
    [s,p]   = best_fit_plane(PData(ValidPlaneIdx,1),PData(ValidPlaneIdx,2),PData(ValidPlaneIdx,3));
    a1 = p(1);
    b1 = p(2);
    c1 = p(3);
    d1 = p(4);
    syms x y z
    z1plane = -(b1*y)/c1 - (a1*x)/c1 - d1/c1;
    ezmesh(z1plane, [-200, 200, -150, 150]);
    
end


 
% 
% %[labs labscore] = dbscan(XYZ_bin,1,10000);
%  
% %% k-means 
% % [ IDX ctrs]   = kmeans(XYZ_bin,7,'replicates',5,'emptyaction','drop','Distance','cityblock','MaxIter',200,'Display','iter');
% %  plot3(XYZ_bin(:,1),XYZ_bin(:,2),XYZ_bin(:,3),'r.');hold on;
% %  Las1pts = XYZ_bin(IDX == 1,:);
% %  plot3(Las1pts(:,1),Las1pts(:,2),Las1pts(:,3),'bo');
% 
% 
% 
% 
% 
% 
% %% Cluster
% 
%  %T   = clusterdata(XYZ_bout,'maxclust',7);
%  % X = rand(20000,3);
%      range1     = 120000:130000;
%      range2     = 320000:330000;
%      range3     = 400000:430000;
%      figure, 
%      plot3(XYZ_bout(range1,1),XYZ_bout(range1,2),XYZ_bout(range1,3),'r.'); hold on;
%      plot3(XYZ_bout(range2,1),XYZ_bout(range2,2),XYZ_bout(range2,3),'g.'); hold on;
%      plot3(XYZ_bout(range3,1),XYZ_bout(range3,2),XYZ_bout(range3,3),'b.'); hold on;
%    
%  
%      X   = XYZ_bout([range1 range2 range3],:);
%      c   = clusterdata(X,'linkage','single','savememory','on','maxclust',7);
%  
%      plot3(X(c==1,1),X(c==1,2),X(c==1,3),'bo')
%      plot3(X(c==2,1),X(c==2,2),X(c==2,3),'mo')
%      plot3(X(c==3,1),X(c==3,2),X(c==3,3),'go')
%      plot3(X(c==4,1),X(c==4,2),X(c==4,3),'co')
%      plot3(X(c==5,1),X(c==5,2),X(c==5,3),'b+')
%      plot3(X(c==6,1),X(c==6,2),X(c==6,3),'m+')
%      plot3(X(c==7,1),X(c==7,2),X(c==7,3),'g+')
%  
%      figure, 
%      plot3(XYZ_bout(c==2,1),XYZ_bout(c==2,2),XYZ_bout(c==2,3),'b.'); hold on;
%      [s,p]       = best_fit_plane(XYZ_bout(c==2,1),XYZ_bout(c==2,2),XYZ_bout(c==2,3));
%      a1 = p(1);
%      b1 = p(2);
%      c1 = p(3);
%      d1 = p(4);
%      syms x y z
%      z1plane = -(b1*y)/c1 - (a1*x)/c1 - d1/c1;
%      ezmesh(z1plane, [-200, 200, -150, 150]);
%  
%  %% PCA 
% % plot3(0,0,0,'g*','linewidth',5) 
% %  
% 
% X   = XYZ_bout([range1 range2 range3],:);
% [COEFF, SCORE, LATENT1] = pca(X); 
% LATENT          = LATENT1/10;
% figure,
% plot3(SCORE(:,1),SCORE(:,2),SCORE(:,3),'m.');hold on;
% plot3([0   COEFF(1,1)*LATENT(1)],[0 COEFF(2,1)*LATENT(1)],[0 COEFF(3,1)*LATENT(1)],'r','linewidth',3)
% plot3([0   COEFF(2,1)*LATENT(2)],[0 COEFF(2,2)*LATENT(2)],[0 COEFF(2,3)*LATENT(2)],'b','linewidth',3)
% plot3([0   COEFF(3,1)*LATENT(3)],[0 COEFF(3,2)*LATENT(3)],[0 COEFF(3,3)*LATENT(3)],'g','linewidth',3)

 
