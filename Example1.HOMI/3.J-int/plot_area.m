function plot_area(node,connect,elem_type,se)

if (nargin < 4)
    se='black';
end

holdState = ishold;
hold on

% fill node if needed
if (size(node,2) < 3)
    for c = size(node,2)+1:3
        node(:,c) = zeros(size(node,1),1);
    end
end

for e = 1:size(connect,1)
    if (strcmp(elem_type,'Q9'))      % 9-node quad element
        ord = [1,5,2,6,3,7,4,8,1];
    elseif (strcmp(elem_type,'Q8'))  % 8-node quad element
        ord = [1,5,2,6,3,7,4,8,1];
    elseif (strcmp(elem_type,'T3'))  % 3-node triangle element
        ord = [1,2,3,1];
    elseif (strcmp(elem_type,'T6'))  % 6-node triangle element
        ord = [1,4,2,5,3,6,1];
    elseif (strcmp(elem_type,'Q4'))  % 4-node quadrilateral element
        ord = [1,2,3,4,1];
    elseif (strcmp(elem_type,'L2'))  % 2-node line element
        ord = [1,2];
    elseif (strcmp(elem_type,'L3'))  % 3-node line element
        ord = [1,3,2];
    elseif (strcmp(elem_type,'H4'))  % 4-node tet element
        ord = [1,2,4,1,3,4,2,3];
    elseif (strcmp(elem_type,'B8'))  % 8-node brick element
        ord = [1,5,6,2,3,7,8,4,1,2,3,4,8,5,6,7];
    end
    
    for n = 1:size(ord,2)
        xpt(n) = node(connect(e,ord(n)),1);
        ypt(n) = node(connect(e,ord(n)),2);
        zpt(n) = node(connect(e,ord(n)),3);
    end
    fill(xpt,ypt,se)
end

rotate3d on
axis equal

if (~holdState)
    hold off
end