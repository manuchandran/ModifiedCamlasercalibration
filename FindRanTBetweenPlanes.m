A           = [0.63715542  -0.67037254  0.38030726  -106.33075804]
a           = A(1,1);
b           = A(1,2);
c           = A(1,3);
d           = A(1,4);
om          = [ -0.00903   -2.50520  1.49854 ];
R_l2r       = rodrigues_cal(om);
T_l2r       = [ 82.25204   277.25005  496.86562 ];
R           = R_l2r';
T           = -R_l2r'*T_l2r';
abc2        = R*[ a b c]';
newd        = d - T'*abc2;
B           = [abc2' newd]
abc_o     = A(1:3);
abc_n     = B(1:3);

keyboard


% Rotate A to XY plane
cosine_thetax = sqrt(sum(A(1,[1,2]).^2));
thetax        = 90 - acosd(cosine_thetax);
cosine_thetay = sqrt(sum(A(1,[2,3]).^2));
thetay        = 90 - acosd(cosine_thetay);
cosine_thetaz = sqrt(sum(A(1,[1,3]).^2));
thetaz        = 90 - acosd(cosine_thetaz);
rot_thetax   = [ 1 0 0; ... 
                            0 cosd(thetax), -sind(thetax);...
                            0 sind(thetax),cosd(thetax)];
rot_thetay    = [ cosd(thetay), 0, sind(thetay); ... 
                                0         , 1, 0 ;... 
                            -sind(thetay) , 0 , cosd(thetay)]; 
rot_thetaz    = [ cosd(thetaz), -sind(thetaz), 0; ... 
                            sind(thetaz), cosd(thetaz), 0; ... 
                            0, 0, 1];
rot_mat       = rot_thetay'*rot_thetaz'*rot_thetax';
arrA           = [-50:0.5:50]'*A(1,1:3);
rot_arrA      = arrA*rot_mat;                        

% ROTATE B TO XYPLANE
A             = B;
cosine_thetax = sqrt(sum(A(1,[1,2]).^2));
thetax        = 90 - acosd(cosine_thetax);
cosine_thetay = sqrt(sum(A(1,[2,3]).^2));
thetay        = 90 - acosd(cosine_thetay);
cosine_thetaz = sqrt(sum(A(1,[1,3]).^2));
thetaz        = 90 - acosd(cosine_thetaz);
rot_thetax   = [ 1 0 0; ... 
                            0 cosd(thetax), -sind(thetax);...
                            0 sind(thetax),cosd(thetax)];
rot_thetay    = [ cosd(thetay), 0, sind(thetay); ... 
                                0         , 1, 0 ;... 
                            -sind(thetay) , 0 , cosd(thetay)]; 
rot_thetaz    = [ cosd(thetaz), -sind(thetaz), 0; ... 
                            sind(thetaz), cosd(thetaz), 0; ... 
                            0, 0, 1];
rot_mat       = rot_thetay'*rot_thetaz'*rot_thetax';
arrB          = [-50:0.5:50]'*A(1,1:3);
rot_arrB      = arrB*rot_mat;  

figure;
plot3(rot_arrA(:,1),rot_arrA(:,2),rot_arrA(:,3),'go'); hold on
plot3(rot_arrB(:,1),rot_arrB(:,2),rot_arrB(:,3),'r.');

figure
plot3(arrA(:,1),arrA(:,2),arrA(:,3),'go'); hold on
plot3(arrB(:,1),arrB(:,2),arrB(:,3),'r.');

