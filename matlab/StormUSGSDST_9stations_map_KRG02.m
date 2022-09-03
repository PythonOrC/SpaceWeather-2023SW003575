% Interpolating Scattered Data Using griddata and griddatan
% The stations we selected are 9 stations, NEW FRD SIT HON TUC BSL SJG FRN BOU from USGS
% 5 stations, VIC OTT FCC MEA STJ from CGS?

% New stations
latFCC = 90-31.241; lonFCC = 265.912-360;
% Station (ID):FCC
% Co-latitude: 31.241°
% Longitude:265.912°
latMEA = 90-35.384; lonMEA = 246.653-360;
% Co-latitude:35.384°
% Longitude:246.653°
latOTT = 90-44.597; lonOTT = 284.448-360;
% Co-latitude:44.597°
% Longitude:284.448°
latSTJ = 90-42.405; lonSTJ = 307.323-360;
% Co-latitude:42.405°
% Longitude:307.323°
latVIC = 90-41.480; lonVIC = 236.580-360;
% Co-latitude:41.480°
% Longitude:236.580°
% build Observitories location
% Begin with a small set of point data, approximate latitudes and longitudes
latTUC =  32.17; lonTUC =   -110.73;   
% Station Id: TUC
% Location: Tucson, AZ
% Latitude: 32.17°N
% Longitude: 110.73°W
latFRN = 37.09; lonFRN = -119.72;
% Station Id: FRN
% Location: O'Neals, CA
% Latitude: 37.09°N
% Longitude: 119.72°W
latBOU = 40.14; lonBOU = -105.24;
% Station Id: BOU
% Location: Boulder, CO
% Latitude: 40.14°N
% Longitude: 105.24°W
latNEW = 48.27; lonNEW = -117.12;
% Station Id: NEWmaps
% Location: Colville National Forest, WA
% Latitude: 48.27°N
% Longitude: 117.12°W
latFRD = 38.20; lonFRD = -77.37;
% Station Id: FRD
% Location: Corbin, VA
% Latitude: 38.20°N
% Longitude: 77.37°W
latBSL = 30.35; lonBSL = -89.63;
% Station Id: BSL
% Location: NASA Stennis Space Center, MS
% Latitude: 30.35°N
% Longitude: 89.63°W
latSJG = 18.11; lonSJG = -66.15;
% Station Id: SJG
% Location: Cayey, PR
% Latitude: 18.11°N
% Longitude: 66.15°W
latHON = 21.32; lonHON = -158.00;
% Station Id: HON
% Location: Ewa Beach, HI
% Latitude: 21.32°N
% Longitude: 158.00°W
latSIT = 57.06; lonSIT = -135.33;
% Station Id: SIT
% Location: Sitka, AK
% Latitude: 57.06°N
% Longitude: 135.33°W
latSHU = 55.35; lonSHU = -160.46;
% Station Id: SHU
% Location: Sand Point, Popof, AK
% Latitude: 55.35°N
% Longitude: 160.46°W
latGUA = 13.59; lonGUA = 35.13;
%latGUA = 13.59; lonGUA = -215.13;
% Station Id: GUA
% Location: Dededo, Guam
% Latitude: 13.59°N
% Longitude: 215.13°W=35.13°E
latBRW = 71.32; lonBRW = -156.62;
% Station Id: BRW
% Location: Point Barrow, AK
% Latitude: 71.32°N
% Longitude: 156.62°W
latCMO = 64.87; lonCMO = -147.86;
% Station Id: CMO
% Location: Fairbanks, AK
% Latitude: 64.8741°N
% Longitude: 147.8597°W

% latDED = 70.36; lonDED = -148.79;
% Station Id: DED
% Location: Deadhorse, AK
% Latitude: 70.36°N
% Longitude: 148.79°W

%Geometry (in this case 'Point') 
%Lat (for points, this is a scalar double)
%Lon (for points, this is a scalar double)
clear OBS;
[OBS(1:12).Geometry] = deal('Point');
OBS(1).Lat = latTUC; OBS(1).Lon = lonTUC;
OBS(2).Lat = latFRN; OBS(2).Lon = lonFRN;
OBS(3).Lat = latBOU; OBS(3).Lon = lonBOU;
OBS(4).Lat = latNEW; OBS(4).Lon = lonNEW;
OBS(5).Lat = latFRD; OBS(5).Lon = lonFRD;
OBS(6).Lat = latBSL; OBS(6).Lon = lonBSL;
%OBS(7).Lat = latSJG; OBS(7).Lon = lonSJG;
%OBS(8).Lat = latHON; OBS(8).Lon = lonHON;
%OBS(9).Lat = latSIT; OBS(9).Lon = lonSIT;
%OBS(10).Lat = latSHU; OBS(10).Lon = lonSHU;
%OBS(11).Lat = latCMO; OBS(11).Lon = lonCMO;
%OBS(12).Lat = latBRW; OBS(12).Lon = lonBRW;
%OBS(13).Lat = latGUA; OBS(13).Lon = lonGUA;
OBS(1).Name = 'TUC';
OBS(2).Name = 'FRN';
OBS(3).Name = 'BOU';
OBS(4).Name = 'NEW';
OBS(5).Name = 'FRD';
OBS(6).Name = 'BSL';
%OBS(7).Name = 'SJG';
%OBS(8).Name = 'HON';
%OBS(9).Name = 'SIT';
%OBS(10).Name = 'SHU';
%OBS(11).Name = 'CMO';
%OBS(12).Name = 'BRW';
%OBS(13).Name = 'GUA';

%%%%%%%%%%%%%%%%%%%%%% loop for 100 second  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:10:1440%3600*26-3600*36 which is the storm period

%plot interoplated stormindex index
lat=[latTUC latBOU latNEW latFRD latBSL latSJG latHON latSIT];
long=[lonTUC lonBOU lonNEW lonFRD lonBSL lonSJG lonHON lonSIT];
stormindex=[dstusgsTUC(i) dstusgsBOU(i) dstusgsNEW(i) dstusgsFRD(i) dstusgsBSL(i) dstusgsSJG(i) dstusgsHON(i) dstusgsSIT(i)]';
[longi,lati] = meshgrid(-127:0.5:-66, 25:0.5:50);
% kriging!!!!!!!!!
v = variogram([long' lat'],stormindex);
[dum,dum,dum,vstruct] = variogramfit(v.distance,v.val,[],[],[],'model','stable');
close;
[stormindexi,stormindexVari] = krigingtest(vstruct,long',lat',stormindex,longi',lati');

% plot USA map with province
s = shaperead('physio_Dissolve_province.shp');
figure('Color','w');
mapshow(s);

% PUT OBS ON THE MAP
mapshow(OBS(1:6),'Marker','o',...
    'MarkerFaceColor','c','MarkerEdgeColor','k');
% Display the OBS names using data in the geostruct field Name.
% Note that you must treat the Name field as a cell array.
text([OBS(1:6).Lon]-1,[OBS(1:6).Lat]+0.7,...
    {OBS(1:6).Name},'FontWeight','bold');
hold on

pcolor(longi,lati,stormindexi');
%surface(longi,lati,stormindexi);
xlabel('Longitude'), ylabel('Latitude'),colorbar;
caxis([-50 30])
str_title2=['USGSDST 9STA KRGMaps 1.0 01252012 second-',num2str(i)];
title(str_title2);
annotation('textbox',...
    [0.84 0.74 0.077 0.052],...
    'String',{'nT'},...
    'FontSize',12,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'LineStyle','none');
xlim([-127 -66]);ylim([25 50]);
saveas(gcf,['C:\Users\zxu\Documents\zxu_local\USU\xudoc\work1\USGS1sec\tmp\',str_title2,'.png'], 'png')
close
end
