function FRout = ReturnCurvedLas(Laserpts)

    CrossVars     = 0;
    [FRini1, gof] = createSurfaceFitsquadonly(Laserpts(:,1), Laserpts(:,2), Laserpts(:,3));
    FRini         = FRini1{1,1};
    p001        = -1;
    p002        = 0;
    W0          = [FRini.p000 FRini.p100 FRini.p010 p001 ...
                    FRini.p200 FRini.p020 p002 ...
                    ]; 
%                  
%     [FRini, gof] = createSurfaceFitpoly(Laserpts(:,1), Laserpts(:,2), Laserpts(:,3));
%     FRini        = FRini{1,1};
%     
%     p001        = -1;
%     p002        = 0;
%     p110        = FRini.p11;
%     p011        = FRini.p11;
%     p101        = FRini.p11;
%     W0          = [FRini.p00 FRini.p10 FRini.p01 p001 ...
%                      FRini.p20 FRini.p02 p002 ...
%                      p110 p011 p101 ]; 

    initerror   = callLaserPointfit(W0,Laserpts,CrossVars);

    abcvar      = 0.2;
    dvar        = 5;
    HalfVar     = [dvar abcvar abcvar abcvar abcvar abcvar abcvar ];

    lb          = W0 - HalfVar;
    ub          = W0 + HalfVar;
    opts        = optimset('fminunc');
    opts        = optimset(opts, 'MaxFunEvals', 10000,'Algorithm','interior-point','TolCon',0.1);
    fun         = @(x)callLaserPointfit(x,Laserpts,CrossVars);

    %[Wout,fval] = fmincon(fun,W0,[],[],[],[],lb,ub,[],opts); 
    [Wout,fval] = fminunc(fun,W0,opts); 
    FRout.p000  = Wout(1,1);
    FRout.p100  = Wout(1,2);
    FRout.p010  = Wout(1,3);
    FRout.p001  = Wout(1,4);
    FRout.p200  = Wout(1,5);
    FRout.p020  = Wout(1,6);
    FRout.p002  = Wout(1,7);

    finalerror = callLaserPointfit(Wout,Laserpts,CrossVars);

%keyboard    
%keyboard