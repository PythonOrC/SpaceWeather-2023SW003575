% ax = worldmap("North America");
% land = readgeotable("landareas.shp");
% geoshow(ax,land,"FaceColor",[0.5 0.7 0.5])


s = shaperead('landareas.shp');
figure('Color','w');
mapshow(s);