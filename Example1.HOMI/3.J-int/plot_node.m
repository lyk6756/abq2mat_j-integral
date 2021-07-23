function plot_node(node,s,PropertyName,PropertyValure)
if (nargin == 1)
    holdState = ishold;
    hold on
    
    for e = 1:size(node,1)
        xpt = node(e,1);
        ypt = node(e,2);
        plot(xpt,ypt)
    end
    
    if (~holdState)
        hold off
    end
elseif (nargin == 2)
    PropertyName = 'MarkerSize';
    PropertyValure = 8.0;
    holdState = ishold;
    hold on
    
    for e = 1:size(node,1)
        xpt = node(e,1);
        ypt = node(e,2);
        plot(xpt,ypt,s,PropertyName,PropertyValure)
    end
    
    if (~holdState)
        hold off
    end
elseif (nargin == 4)
    holdState = ishold;
    hold on
    
    for e = 1:size(node,1)
        xpt = node(e,1);
        ypt = node(e,2);
        plot(xpt,ypt,s,PropertyName,PropertyValure)
    end
    
    if (~holdState)
        hold off
    end
end