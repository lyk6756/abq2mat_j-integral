function [C,St,E,nu,dCtdE,dStdE,dEdx] = mat_model(stressState,pt)
% This function calculates the constitutive matix for the element
% Inputs:
%     stressState - stress states: 'PLANE_STRESS' or 'PLANE_STRAIN'
%     pt - position of the material points: [xx yy]
% Outputs:
%     C - Stiffness matrix (with engineering strain)
%     St - Compliance matrix (with tensor strain)
%     E - Young's modulus
%     nu - Poisson's ratio
%     dCtdE - derivatives of stiffness matrix (with tensor strain) w.r.t. modulus
%     dStdE - derivatives of compliance matrix (with tensor strain) w.r.t. modulus
%     dEdx - derivatives of modulus w.r.t. coordinates

% LINEAR ELASTIC
E0  = 280;
nu0 = 0.45;

dEx = 10;
dEy = 1;
x   = pt(1);
y   = pt(2);

% constant E0
E    = E0 ;
dEdx = [0 0];
nu   = nu0;

%Compliance matrix C       %%%材料参数 对于非均匀材料这里比较关键
%%特别注意::这里采用的是 工程应变epsilon,计算K过程中使用C,平面问题3个量求和;
%%计算J积分时采用张量应变 Ct，St, 平面问题4个量求和.
if strcmpi(stressState,'PLANE_STRESS') % Plane Stress
    C = E / (1 - nu*nu)*[
        1,  nu, 0;
        nu, 1,  0;
        0,  0,  (1-nu)/2];

    Ct= E / (1 - nu*nu)*[
        1,   nu, 0;
        nu,  1,  0 ;
        0,   0,  (1-nu)];

    St= 1/E *[
        1,   -nu, 0;
        -nu, 1,   0;
        0,   0,   (1+nu)];
elseif strcmpi(stressState,'PLANE_STRAIN') % Plane Strain
    C = E / (1+nu) / (1-2*nu)*[
        1-nu, nu    0;
        nu,   1-nu, 0;
        0,    0     0.5-nu];

    Ct= E / (1+nu) / (1-2*nu)*[
        1-nu, nu,   0;
        nu,   1-nu, 0;
        0,    0,    1-2*nu];

    St= (1+nu) / E*[
        1-nu, -nu,  0;
        -nu,  1-nu, 0;
        0,    0,    1];
end
dCtdE = Ct/E;
dStdE = -St/E;