%% 龙格库塔迭代导弹参数
function [ updateXm, updateYm, updateZm, updateVm, updateCita_m, updateFai_m ] = Mlgkt( Xm, Ym, Zm, Vm, Cita_m, Fai_m, Ny, Nz, Tm, P, Q, G )
    g = 9.8;  
    
    GZ = [ 0  Ny  Nz ];  % 切向过载为0
    KT = [ Xm, Ym, Zm, Vm, Cita_m, Fai_m];

    k1 = fun_m( KT, GZ, g, Tm, P, Q, G );
    k2 = fun_m( KT + 1/2*k1, GZ, g, Tm, P, Q, G );
    k3 = fun_m( KT + 1/2*k2, GZ, g, Tm, P, Q, G );
    k4 = fun_m( KT + k3, GZ, g, Tm, P, Q, G );
    
    KT = KT + 1/6*(k1 + 2*k2 + 2*k3 + k4);   
  
    updateXm = KT(1);     % 迭代后导弹的坐标，速度，倾角，偏角
    updateYm = KT(2);
    updateZm = KT(3);       
    updateVm = KT(4);
    updateCita_m = KT(5);
    updateFai_m = KT(6);     
    
end

%% 导弹参数一步增量计算
function drk = fun_m( KT, GZ, g, Tm, P, Q, G )

    Vm = KT(4);   Cita_m = KT(5);    Fai_m = KT(6);
    Ny = GZ(2);   Nz = GZ(3);    

    dXm = Vm*cos(Cita_m)*cos(Fai_m);  % 各参数增量    
    dYm = Vm*sin(Cita_m);   
    dZm = Vm*cos(Cita_m)*sin(Fai_m); 
    dVm = ((P-Q)*g/G)-g*sin(Cita_m);
    dCita_m = (Ny - cos(Cita_m))*g/Vm;   
    dFai_m = g*Nz/(Vm*cos(Cita_m));
    
    drk = [ dXm, dYm, dZm, dVm, dCita_m, dFai_m ].*Tm;

end
