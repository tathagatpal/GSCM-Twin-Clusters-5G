function cluster = associateCluster(center, ringRadius, scatterers)
% This function associates scatterers to UE or BS creating a cluster
% Find all scatterers inside circle
isInRing = (scatterers(:,1)-center(1)).^2 + (scatterers(:,2)-center(2)).^2<=ringRadius^2;

cluster = scatterers(isInRing,:);
end