%% 龙哥库塔迭代目标参数
function [ updateXt, updateYt, updateZt, updateVt, updateCita_t, updateFai_t ] = Tlgkt( Xt, Yt, Zt, Vt, Cita_t, Fai_t, Nxt, Nyt, Nzt, Tm)
    g = 9.8;

    GZ = [Nxt  Nyt  Nzt]; 
    KT = [Xt, Yt, Zt, Vt, Cita_t, Fai_t ] ;

    k1 = fun_t( KT, GZ, g, Tm ) ;   
    k2 = fun_t( KT + 1/2*k1, GZ, g, Tm ) ;
    k3 = fun_t( KT + 1/2*k2, GZ, g, Tm ) ;
    k4 = fun_t( KT + k3, GZ, g, Tm ) ;
    
    KT = KT + 1/6*(k1 + 2*k2 + 2*k3 + k4); 
    
    updateXt = KT(1);     % 迭代后目标的坐标，速度，倾角，偏角
    updateYt = KT(2);
    updateZt = KT(3);
    updateVt = KT(4);
    if updateVt>400
        updateVt=400;
    end
    updateCita_t = KT(5);
    updateFai_t = KT(6);    
        
end

%% 目标参数一步增量计算
function drk = fun_t( KT, GZ, g, Tm )   

    Vt = KT(4);    Cita_t = KT(5);   Fai_t = KT(6);  
    Nx = GZ(1);     Ny = GZ(2);   Nz = GZ(3);

    dXt = Vt*cos(Cita_t)*cos(Fai_t);  % 各参数增量    
    dYt = Vt*sin(Cita_t); 
    dZt = Vt*cos(Cita_t)*sin(Fai_t); 
    dVt = (Nx-sin(Cita_t))*g;
    dCita_t = g*(Ny - cos(Cita_t))/Vt; 
    dFai_t = g*Nz/(Vt*cos(Cita_t)); 
        
    drk = [ dXt, dYt, dZt, dVt, dCita_t, dFai_t ].*Tm; 
    
end

