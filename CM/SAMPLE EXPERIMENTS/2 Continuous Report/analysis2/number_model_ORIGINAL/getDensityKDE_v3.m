function [Pdensity] = getDensityKDE_v3 (density, xmesh, PXi, stepsize)

pl = stepsize*0.5;
for i = 1:length(PXi)
    points = find(abs(PXi(i)-xmesh) < stepsize); % original- 0.1
    while length(points) <1 
        points = find(abs(PXi(i)-xmesh) < stepsize+pl); % original- 0.1
        pl = stepsize+pl; 
        if length(points) >=1 
            break;
        end
    end 
    Pdensity(i) = mean(density(points));
    clear points
end