function [W,Q] = quadrature(quadorder, type, dim)
% The function quadrature returns a n x 1 column vector W of quadrature
% weights and a n x dim matrix of quadrature points, where n is the
% number of quadrature points. The function is called as follows:
%
%   [W,Q]=quadrature(quadorder, type, dim)
%
% quadorder is the quadrature order, type is the type of quadrature
% (i.e. gaussian, triangular, etc.. ) and dim is the number of spacial
% dimentions of the problem.  The default for type is GAUSS and the
% default for dim is unity.
%
% wrQ=quadrature(quadorder,'TRIANGULAR',2);itten by Jack Chessa
%            j-chessa@northwestern.edu
% Department of Mechanical Engineering
% Northwestern University
if (nargin < 3) % set default arguments
    if (strcmp(type,'GAUSS') == 1)
        dim = 1;
    else
        dim = 2;
    end
end

if (nargin < 2)
    type = 'GAUSS';
end

if (strcmp(type,'GAUSS') == 1)
    if ( quadorder > 8 )  % check for valid quadrature order
        disp('Order of quadrature too high for Gaussian Quadrature');
        quadorder =8;
    end

    quadpoint=zeros(quadorder^dim,dim);  %初始化积分点坐标阵及权重向量
    quadweight=zeros(quadorder^dim,1);

    r1pt=zeros(quadorder,1); r1wt=zeros(quadorder,1);

    switch (quadorder)
        case 1
            r1pt(1) = 0.000000000000000;
            r1wt(1) = 2.000000000000000;

        case 2
            r1pt(1) =-0.577350269189626;
            r1pt(2) = 0.577350269189626;

            r1wt(1) = 1.000000000000000;
            r1wt(2) = 1.000000000000000;

        case 3
            r1pt(1) =-0.774596669241483;
            r1pt(2) = 0.000000000000000;
            r1pt(3) = 0.774596669241483;

            r1wt(1) = 0.555555555555556;
            r1wt(2) = 0.888888888888889;
            r1wt(3) = 0.555555555555556;

        case 4
            r1pt(1) = 0.861134311594053;
            r1pt(2) =-0.861134311594053;
            r1pt(3) = 0.339981043584856;
            r1pt(4) =-0.339981043584856;

            r1wt(1) = 0.347854845137454;
            r1wt(2) = 0.347854845137454;
            r1wt(3) = 0.652145154862546;
            r1wt(4) = 0.652145154862546;

        case 5
            r1pt(1) = 0.906179845938664;
            r1pt(2) =-0.906179845938664;
            r1pt(3) = 0.538469310105683;
            r1pt(4) =-0.538469310105683;
            r1pt(5) = 0.000000000000000;

            r1wt(1) = 0.236926885056189;
            r1wt(2) = 0.236926885056189;
            r1wt(3) = 0.478628670499366;
            r1wt(4) = 0.478628670499366;
            r1wt(5) = 0.568888888888889;

        case 6
            r1pt(1) = 0.932469514203152;
            r1pt(2) =-0.932469514203152;
            r1pt(3) = 0.661209386466265;
            r1pt(4) =-0.661209386466265;
            r1pt(5) = 0.238619186003152;
            r1pt(6) =-0.238619186003152;

            r1wt(1) = 0.171324492379170;
            r1wt(2) = 0.171324492379170;
            r1wt(3) = 0.360761573048139;
            r1wt(4) = 0.360761573048139;
            r1wt(5) = 0.467913934572691;
            r1wt(6) = 0.467913934572691;

        case 7
            r1pt(1) =  0.949107912342759;
            r1pt(2) = -0.949107912342759;
            r1pt(3) =  0.741531185599394;
            r1pt(4) = -0.741531185599394;
            r1pt(5) =  0.405845151377397;
            r1pt(6) = -0.405845151377397;
            r1pt(7) =  0.000000000000000;

            r1wt(1) = 0.129484966168870;
            r1wt(2) = 0.129484966168870;
            r1wt(3) = 0.279705391489277;
            r1wt(4) = 0.279705391489277;
            r1wt(5) = 0.381830050505119;
            r1wt(6) = 0.381830050505119;
            r1wt(7) = 0.417959183673469;

        case 8
            r1pt(1) =  0.960289856497536;
            r1pt(2) = -0.960289856497536;
            r1pt(3) =  0.796666477413627;
            r1pt(4) = -0.796666477413627;
            r1pt(5) =  0.525532409916329;
            r1pt(6) = -0.525532409916329;
            r1pt(7) =  0.183434642495650;
            r1pt(8) = -0.183434642495650;

            r1wt(1) = 0.101228536290376;
            r1wt(2) = 0.101228536290376;
            r1wt(3) = 0.222381034453374;
            r1wt(4) = 0.222381034453374;
            r1wt(5) = 0.313706645877887;
            r1wt(6) = 0.313706645877887;
            r1wt(7) = 0.362683783378362;
            r1wt(8) = 0.362683783378362;

        case 9
            r1pt(1) =  0.9681602395;
            r1pt(2) = -0.9681602395;
            r1pt(3) =  0.8360311073;
            r1pt(4) = -0.8360311073;
            r1pt(5) =  0.6133714327;
            r1pt(6) = -0.6133714327;
            r1pt(7) =  0.3242534234;
            r1pt(8) = -0.3242534234;
            r1pt(9) =  0.0000000000;

            r1wt(1) = 0.0812743884;
            r1wt(2) = 0.0812743884;
            r1wt(3) = 0.1806481607;
            r1wt(4) = 0.1806481607;
            r1wt(5) = 0.2606106964;
            r1wt(6) = 0.2606106964;
            r1wt(7) = 0.3123470770;
            r1wt(8) = 0.3123470770;
            r1wt(9) = 0.3302393550;

        case 10
            r1pt(1) =  0.9739065285;
            r1pt(2) = -0.9739065285;
            r1pt(3) =  0.8650633667;
            r1pt(4) = -0.8650633667;
            r1pt(5) =  0.6794095683;
            r1pt(6) = -0.6794095683;
            r1pt(7) =  0.4333953941;
            r1pt(8) = -0.4333953941;
            r1pt(9) =  0.1488743390;
            r1pt(10)= -0.1488743390;

            r1wt(1) = 0.0666713443;
            r1wt(2) = 0.0666713443;
            r1wt(3) = 0.1494513492;
            r1wt(4) = 0.1494513492;
            r1wt(5) = 0.2190863625;
            r1wt(6) = 0.2190863625;
            r1wt(7) = 0.2692667193;
            r1wt(8) = 0.2692667193;
            r1wt(9) = 0.2955242247;
            r1wt(10)= 0.2955242247;

        otherwise
            disp('Order of quadrature to high for Gaussian Quadrature');
    end  % end of quadorder switch

    n = 1;

    if (dim == 1)
        for i = 1:quadorder
            quadpoint(n,:) = r1pt(i);
            quadweight(n) = r1wt(i);
            n = n + 1;
        end

    elseif (dim == 2)
        for i = 1:quadorder
            for j = 1:quadorder
                quadpoint(n,:) = [r1pt(i), r1pt(j)];
                quadweight(n) = r1wt(i)*r1wt(j);
                n = n+1;
            end
        end

    else % dim == 3
        for i = 1:quadorder
            for j = 1:quadorder
                for k = 1:quadorder
                    quadpoint(n,:) = [ r1pt(i), r1pt(j), r1pt(k) ];   %第三列先变化
                    quadweight(n) = r1wt(i)*r1wt(j)*r1wt(k);
                    n = n+1;
                end
            end
        end
    end

    Q=quadpoint;
    W=quadweight;
    % END OF GAUSSIAN QUADRATURE DEFINITION

elseif ( strcmp(type,'TRIANGULAR') == 1 )
    if ( dim == 3 )  %%% TETRAHEDRA 四面体

        if (quadorder ~= 1 && quadorder ~= 2 && quadorder ~= 3 )
            % check for valid quadrature order
            disp('Incorect quadrature order for triangular quadrature');
            quadorder = 1;
        end
        if  (quadorder == 1)
            quadpoint = [ 0.25 0.25 0.25 ];
            quadweight = 1;
        elseif ( quadorder == 2 )
            quadpoint = [ 0.58541020  0.13819660  0.13819660;
                0.13819660  0.58541020  0.13819660;
                0.13819660  0.13819660  0.58541020;
                0.13819660  0.13819660  0.13819660];
            quadweight = [1; 1; 1; 1]/4;
        elseif ( quadorder == 3 )
            quadpoint = [ 0.25  0.25  0.25;
                1/2   1/6   1/6;
                1/6   1/2   1/6;
                1/6   1/6   1/2;
                1/6   1/6   1/6];
            quadweight = [-4/5 9/20 9/20 9/20 9/20]';
        end

        Q=quadpoint;
        W=quadweight/6;

    else  %%% TRIANGLES
        if ( quadorder > 7 ) % check for valid quadrature order
            disp('Quadrature order too high for triangular quadrature');
            quadorder = 1;
        end
        if ( quadorder == 1 )   % set quad points and quadweights
            quadpoint = [ 0.3333333333333, 0.3333333333333 ];
            quadweight = 1;
        elseif ( quadorder == 2 )
            quadpoint = zeros( 3, 2 );
            quadweight = zeros( 3, 1 );

            quadpoint(1,:) = [ 0.1666666666667, 0.1666666666667 ];
            quadpoint(2,:) = [ 0.6666666666667, 0.1666666666667 ];
            quadpoint(3,:) = [ 0.1666666666667, 0.6666666666667 ];

            quadweight(1) = 0.3333333333333;
            quadweight(2) = 0.3333333333333;
            quadweight(3) = 0.3333333333333;
        elseif (quadorder == 3)
            quadpoint = zeros( 4, 2 );
            quadweight = zeros( 4, 1 );

            quadpoint(1,:) = [ 0.3333333333333, 0.3333333333333 ];
            quadpoint(2,:) = [ 0.2, 0.2 ];
            quadpoint(3,:) = [ 0.6, 0.2 ];
            quadpoint(4,:) = [ 0.2, 0.6 ];

            quadweight(1) = -0.5625;
            quadweight(2) = 0.52083333333333;
            quadweight(3) = 0.52083333333333;
            quadweight(4) = 0.52083333333333;
        elseif (quadorder <= 5)
            quadpoint = zeros( 7, 2 );
            quadweight = zeros( 7, 1 );

            quadpoint(1,:) = [ 0.1012865073235, 0.1012865073235 ];
            quadpoint(2,:) = [ 0.7974269853531, 0.1012865073235 ];
            quadpoint(3,:) = [ 0.1012865073235, 0.7974269853531 ];
            quadpoint(4,:) = [ 0.4701420641051, 0.0597158717898 ];
            quadpoint(5,:) = [ 0.4701420641051, 0.4701420641051 ];
            quadpoint(6,:) = [ 0.0597158717898, 0.4701420641051 ];
            quadpoint(7,:) = [ 0.3333333333333, 0.3333333333333 ];

            quadweight(1) = 0.1259391805448;
            quadweight(2) = 0.1259391805448;
            quadweight(3) = 0.1259391805448;
            quadweight(4) = 0.1323941527885;
            quadweight(5) = 0.1323941527885;
            quadweight(6) = 0.1323941527885;
            quadweight(7) = 0.2250000000000;
        else
            quadpoint = zeros( 13, 2 );
            quadweight = zeros( 13, 1 );

            quadpoint(1 ,:) = [ 0.0651301029022, 0.0651301029022 ];
            quadpoint(2 ,:) = [ 0.8697397941956, 0.0651301029022 ];
            quadpoint(3 ,:) = [ 0.0651301029022, 0.8697397941956 ];
            quadpoint(4 ,:) = [ 0.3128654960049, 0.0486903154253 ];
            quadpoint(5 ,:) = [ 0.6384441885698, 0.3128654960049 ];
            quadpoint(6 ,:) = [ 0.0486903154253, 0.6384441885698 ];
            quadpoint(7 ,:) = [ 0.6384441885698, 0.0486903154253 ];
            quadpoint(8 ,:) = [ 0.3128654960049, 0.6384441885698 ];
            quadpoint(9 ,:) = [ 0.0486903154253, 0.3128654960049 ];
            quadpoint(10,:) = [ 0.2603459660790, 0.2603459660790 ];
            quadpoint(11,:) = [ 0.4793080678419, 0.2603459660790 ];
            quadpoint(12,:) = [ 0.2603459660790, 0.4793080678419 ];
            quadpoint(13,:) = [ 0.3333333333333, 0.3333333333333 ];

            quadweight(1 ) = 0.0533472356088;
            quadweight(2 ) = 0.0533472356088;
            quadweight(3 ) = 0.0533472356088;
            quadweight(4 ) = 0.0771137608903;
            quadweight(5 ) = 0.0771137608903;
            quadweight(6 ) = 0.0771137608903;
            quadweight(7 ) = 0.0771137608903;
            quadweight(8 ) = 0.0771137608903;
            quadweight(9 ) = 0.0771137608903;
            quadweight(10) = 0.1756152576332;
            quadweight(11) = 0.1756152576332;
            quadweight(12) = 0.1756152576332;
            quadweight(13) =-0.1495700444677;
        end
        Q=quadpoint;
        W=quadweight/2;   % ATTENTION ATTENTION WHY DIVIDE TO 2?????
    end

end  % end of TRIANGULAR initialization

% END OF FUNCTION