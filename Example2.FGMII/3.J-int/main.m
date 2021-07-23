% J-integral Computation
% Steps :
% 1- detection of the elements on which we integrate
% 2- loop over these elements
% 3- loop over Gauss points
% 4- computation of stress, strain... in local coordinates !!!   ATTENTION
% 5- computation of the auxilliary fields: AuxStress and AuxEps and AuxGradDisp
% 6- computation of I1 and I2
%==============================================================================

% close all
clear

%% Read data from .mat file
load('data.mat')
% 'contourElements' cell
% 'crackFront' int
% 'Elements' array
% 'Nodes' array
% 'U' array
nonode = size(Nodes,1);
noelem = size(Elements,1);

num_rings = 4;
xyTip = Nodes(crackFront,:); % 裂尖坐标
alpha = pi/6; % 裂尖段倾角
QT = [cos(alpha) sin(alpha);
     -sin(alpha) cos(alpha)]; % 裂尖局部坐标与整体坐标间的转换矩阵

stressState = 'PLANE_STRESS';
elemType = 'Q8';
quad_order = 3 ;

q_element_maps = zeros(noelem, 1);
q_node_map = zeros(nonode, 1);
q_values = zeros(nonode, 1);

Jcommon = zeros(num_rings, 2);

for ring = 1:num_rings
    % Plot mesh
%     figure
%     hold on
%     axis off
%     plot_mesh(Nodes,Elements,'Q8','b-'); % plot mesh

    %% Step 1: Setup integral domain
    
    % build list of all nodes for elements appearing in the previous domain.
    % if ring = 1 we use the list of crack front nodes to initialize the process.
    if ring == 1
        q_node_map(crackFront) = 1;
    else
        k = find(q_element_maps);
        q_node_map(unique(Elements(k,:))) = 1;
    end
    
    % build list of all elements incident on nodes in current list.
    k = find(q_node_map);
    for i = 1 : length(k)
        [row, ~] = find(Elements==k(i));
        q_element_maps(unique(row)) = 1;
    end
    Jdomain = find(q_element_maps);
    % Plot integral domain elements
%     plot_area(Nodes,Elements(Jdomain,:),'Q8','red');
    
    % for all nodes in the node map, set the q-value = 1
    k = find(q_node_map);
    q_values(k) = 1;
    % plot q-values
%     plot_node(Nodes(find(q_values),:),'g.');
    
    %% Step 2: Loop over integral elements
    for iel = 1:length(Jdomain) % loop on elements
        e = Jdomain(iel); % current element
        sctr = Elements(e,:); % element connectivity
        nn = length(sctr);
        % Choose Gauss quadrature rule
        order = quad_order ;
        if (strcmp(elemType,'Q4'))
           [W,Q] = quadrature(quad_order, 'GAUSS', 2);
        elseif (strcmp(elemType,'Q8'))
           [W,Q] = quadrature(quad_order, 'GAUSS', 2);
        end
        
        %% Step 3: Loop over Gauss points
        for q = 1:size(W,1) % loop on Gauss points
            pt = Q(q,:);
            wt = W(q);
            [N,dNdxi] = lagrange_basis(elemType,pt);
            J0 = Nodes(sctr,:)' * dNdxi; % element Jaccobian matrix
            dNdx = dNdxi / J0;
            Gpt = N' * Nodes(sctr,:); % GP in global coord
            
            [C,St,E,nu,dCtdE,dStdE,dEdx] = mat_model(stressState,Gpt);
            
            % 常规有限单元法 应变-位移矩阵
            B = zeros(3, 2 * nn);
            B(1, 1:2:2*nn) = dNdx(:,1)';
            B(2, 2:2:2*nn) = dNdx(:,2)';
            B(3, 1:2:2*nn) = dNdx(:,2)';
            B(3, 2:2:2*nn) = dNdx(:,1)';
            leB = size(B,2); % 列数
            
            % nodal displacement of current element
            % taken from the total nodal parameters u
            idx = 0;
            elmU = zeros(2*nn,1);
            for in = 1:nn
                idx = idx + 1;
                nodeI = sctr(in);
                elmU(2*idx-1) = U(nodeI,1);
                elmU(2*idx)   = U(nodeI,2);
            end
            
            % compute derivatives of u w.r.t xy
            H(1,1) = B(1,1:2:leB) * elmU(1:2:leB); % u,x
            H(1,2) = B(2,2:2:leB) * elmU(1:2:leB); % u,y
            H(2,1) = B(1,1:2:leB) * elmU(2:2:leB); % v,x
            H(2,2) = B(2,2:2:leB) * elmU(2:2:leB); % v,y
            
            % Gradient of q
            q1 = q_values(sctr,:)';
            gradq = q1 * dNdx; % 单元结点权函数的导数
            qloc  = q1 * N; % 当前积分点处的q值
            
            epsilon = B * elmU; % 高斯点应变 (engineering strain)
            sigma = C * epsilon; % 高斯点应力
            
            % Transformation to local coordinate
            voit2ind = [1 3;3 2];
            gradqloc = QT * gradq'; % 局部坐标下权函数导数
            graddisploc = QT * H * QT'; % 局部坐标下位移导数
            stressloc = QT * sigma(voit2ind) * QT'; % 局部坐标下高斯点应力
            
            %%!!特别注意前面计算为工程应变,  而后面的附加场给出的是张量应变
            %%为了适合计算,这同样计算出实际场的 物理应变 eps = eplis
            epsten = epsilon; epsten(3) = epsten(3)/2;
            strainloc = QT * epsten(voit2ind) * QT';
            epsloc = [strainloc(1,1);strainloc(2,2);strainloc(1,2)];
            
            %----各向同性材料--泊松比为常数--求导未考虑nu-----
            dEdxloc  = QT * dEdx';
            dCtdxloc{1} = dCtdE * dEdxloc(1);
            dCtdxloc{2} = dCtdE * dEdxloc(2);
            dStdxloc{1} = dStdE * dEdxloc(1);
            dStdxloc{2} = dStdE * dEdxloc(2);
            dCtdxloc_epsloc{1} = dCtdxloc{1} * epsloc;
            dCtdxloc_epsloc{2} = dCtdxloc{2} * epsloc;
            dCtdxloc_strain{1} = dCtdxloc_epsloc{1}(voit2ind); % voit2ind=[1 3;3 2]
            dCtdxloc_strain{2} = dCtdxloc_epsloc{2}(voit2ind); % voit2ind=[1 3;3 2]
        
            %% Step 4: Compute J-integral
            for mode = 1:2
                JSdU = (stressloc(1,1) * graddisploc(1,mode) + stressloc(2,1) * graddisploc(2,mode) ) * gradqloc(1) + ...
                    (stressloc(1,2) * graddisploc(1,mode) + stressloc(2,2) * graddisploc(2,mode) ) * gradqloc(2);
                JW = 0; JIN = 0;
                for i=1:2
                    for j=1:2
                        JW = JW + 0.5 * stressloc(i,j) * strainloc(i,j);
                        JIN = JIN + 0.5 * dCtdxloc_strain{mode}(i,j) * strainloc(i,j);
                    end
                end
                Jcommon(ring,mode) = Jcommon(ring,mode) + (JSdU - JW * gradqloc(mode) - JIN * qloc) * det(J0) * wt;
            end
        end % end of Gauss points loop
    end % end of element loop
end % end of rings loop

%% Step 5: Compute SIFs via J-integral

% compute crack tip moduli for FGM fields
[C,St,E,nu,dCtdE,dStdE,dEdx] = mat_model(stressState,xyTip);

Ks = zeros(size(Jcommon));

if (strcmp(stressState,'PLANE_STRESS'))
    kappa = (3 - nu)/(1 + nu); % 平面应力 Kolosov coeff
elseif (strcmp(stressState,'PLANE_STRAIN'))
    kappa = 3 - 4 * nu; % 平面应变 Kolosov coeff
end
kappap = (1 + nu) * (1 + kappa) / E;

for ii = 1:size(Jcommon,1)
    SS = 2 * ( (Jcommon(ii,1)-Jcommon(ii,2)) / kappap )^0.5;
    Ks(ii,1) = 0.5 * ( SS + ( SS^2 + 8 * Jcommon(ii,2) / kappap )^0.5 );
    Ks(ii,2) = 0.5 * ( SS - ( SS^2 + 8 * Jcommon(ii,2) / kappap )^0.5 );
end

%% Step 6: Outputs
fprintf('J-integral: (J1, J2)\n');
for ii = 1:size(Jcommon,1)
    fprintf('%10.6g    %10.6g\n', Jcommon(ii,1), Jcommon(ii,2));
end
fprintf('\n');
fprintf('SIFs: (KI, KII)\n');
for ii = 1:size(Jcommon,1)
    fprintf('%10.6g    %10.6g\n', Ks(ii,1), Ks(ii,2));
end

filename = 'ResultsFromMat.csv';
A={'Rings','J1 (MPa.mm)','J2 (MPa.mm)','KI (MPa.mm^0.5)','KII (MPa.mm^0.5)'};
writecell(A,filename, 'WriteMode','overwrite')
writematrix([(1:num_rings)', Jcommon, Ks], filename, 'WriteMode','append')
