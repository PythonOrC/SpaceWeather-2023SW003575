T1=93600; T2=121800; interval1=60;
%Interpolating Scattered Data Using griddata and griddatan

% take BOU out of the interpolation

% build Observitories location
% Begin with a small set of point data, approximate latitudes and longitudes
latTUC =  32.17; lonTUC =   -110.73;   
% Station Id: TUC
% Location: Tucson, AZ
% Latitude: 32.17癗
% Longitude: 110.73癢
latFRN = 37.09; lonFRN = -119.72;
% Station Id: FRN
% Location: O'Neals, CA
% Latitude: 37.09癗
% Longitude: 119.72癢
latBOU = 40.14; lonBOU = -105.24;
% Station Id: BOU
% Location: Boulder, CO
% Latitude: 40.14癗
% Longitude: 105.24癢
latNEW = 48.27; lonNEW = -117.12;
% Station Id: NEWmaps
% Location: Colville National Forest, WA
% Latitude: 48.27癗
% Longitude: 117.12癢
latFRD = 38.20; lonFRD = -77.37;
% Station Id: FRD
% Location: Corbin, VA
% Latitude: 38.20癗
% Longitude: 77.37癢
latBSL = 30.35; lonBSL = -89.63;
% Station Id: BSL
% Location: NASA Stennis Space Center, MS
% Latitude: 30.35癗
% Longitude: 89.63癢
latSJG = 18.11; lonSJG = -66.15;
% Station Id: SJG
% Location: Cayey, PR
% Latitude: 18.11癗
% Longitude: 66.15癢
latHON = 21.32; lonHON = -158.00;
% Station Id: HON
% Location: Ewa Beach, HI
% Latitude: 21.32癗
% Longitude: 158.00癢
latSIT = 57.06; lonSIT = -135.33;
% Station Id: SIT
% Location: Sitka, AK
% Latitude: 57.06癗
% Longitude: 135.33癢
latSHU = 55.35; lonSHU = -160.46;
% Station Id: SHU
% Location: Sand Point, Popof, AK
% Latitude: 55.35癗
% Longitude: 160.46癢
latGUA = 13.59; lonGUA = 35.13;
%latGUA = 13.59; lonGUA = -215.13;
% Station Id: GUA
% Location: Dededo, Guam
% Latitude: 13.59癗
% Longitude: 215.13癢=35.13癊
latBRW = 71.32; lonBRW = -156.62;
% Station Id: BRW
% Location: Point Barrow, AK
% Latitude: 71.32癗
% Longitude: 156.62癢
latCMO = 64.87; lonCMO = -147.86;
% Station Id: CMO
% Location: Fairbanks, AK
% Latitude: 64.8741癗
% Longitude: 147.8597癢

% latDED = 70.36; lonDED = -148.79;
% Station Id: DED
% Location: Deadhorse, AK
% Latitude: 70.36癗
% Longitude: 148.79癢

%Geometry (in this case 'Point') 
%Lat (for points, this is a scalar double)
%Lon (for points, this is a scalar double)
clear OBS;
[OBS(1:11).Geometry] = deal('Point');
OBS(1).Lat = latTUC; OBS(1).Lon = lonTUC;
OBS(2).Lat = latFRN; OBS(2).Lon = lonFRN;
%OBS(3).Lat = latBOU; OBS(3).Lon = lonBOU;
OBS(3).Lat = latNEW; OBS(3).Lon = lonNEW;
OBS(4).Lat = latFRD; OBS(4).Lon = lonFRD;
OBS(5).Lat = latBSL; OBS(5).Lon = lonBSL;
OBS(6).Lat = latSJG; OBS(6).Lon = lonSJG;
OBS(7).Lat = latHON; OBS(7).Lon = lonHON;
OBS(8).Lat = latSIT; OBS(8).Lon = lonSIT;
OBS(9).Lat = latSHU; OBS(9).Lon = lonSHU;
OBS(10).Lat = latCMO; OBS(10).Lon = lonCMO;
OBS(11).Lat = latBRW; OBS(11).Lon = lonBRW;
%OBS(13).Lat = latGUA; OBS(13).Lon = lonGUA;
OBS(1).Name = 'TUC';
OBS(2).Name = 'FRN';
%OBS(3).Name = 'BOU';
OBS(3).Name = 'NEW';
OBS(4).Name = 'FRD';
OBS(5).Name = 'BSL';
OBS(6).Name = 'SJG';
OBS(7).Name = 'HON';
OBS(8).Name = 'SIT';
OBS(9).Name = 'SHU';
OBS(10).Name = 'CMO';
OBS(11).Name = 'BRW';
%OBS(13).Name = 'GUA';
k=1;
%%%%%%%%%%%%%%%%%%%%%% loop for 100 second  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=T1:interval1:T2%3600*26-3600*36 which is the storm period

%plot interoplated pc5 index
lat=[latTUC latFRN latNEW latFRD latBSL latSJG latHON latSIT latSHU latCMO latBRW];
long=[lonTUC lonFRN lonNEW lonFRD lonBSL lonSJG lonHON lonSIT lonSHU lonCMO lonBRW];
pc5=[atucBH(8,i)+atucBH(9,i) afrnBH(8,i)+afrnBH(9,i)...
    anewBH(8,i)+anewBH(9,i) afrdBH(8,i)+afrdBH(9,i) abslBH(8,i)+abslBH(9,i) asjgBH(8,i)+asjgBH(9,i)...
    ahonBH(8,i)+ahonBH(9,i) asitBH(8,i)+asitBH(9,i) ashuBH(8,i)+ashuBH(9,i)...
    acmoBH(8,i)+acmoBH(9,i) abrwBH(8,i)+abrwBH(9,i)]'; %aguaBH(8,i)+aguaBH(9,i)

%Use meshgrid to create a set of 2-D grid points in the longitude-latitude plane and then use griddata to interpolate the corresponding depth at those points:
[longi,lati] = meshgrid(-127:0.5:-66, 25:0.5:50);
% kriging!!!!!!!!!
v = variogram([long' lat'],pc5);
[dum,dum,dum,vstruct] = variogramfit(v.distance,v.val,[],[],[],'model','stable');
close;
[pc5i,pc5Vari] = krigingtest(vstruct,long',lat',pc5,longi,lati);

% plot USA map with province
s = shaperead('physio_Dissolve_province.shp');
figure('Color','w');
mapshow(s);

% PUT OBS ON THE MAP
mapshow(OBS(1:5),'Marker','o',...
    'MarkerFaceColor','c','MarkerEdgeColor','k');
% Display the OBS names using data in the geostruct field Name.
% Note that you must treat the Name field as a cell array.
text([OBS(1:5).Lon]-1,[OBS(1:5).Lat]+0.7,...
    {OBS(1:5).Name},'FontWeight','bold');
hold on

pcolor(longi,lati,pc5i);

xlabel('Longitude'), ylabel('Latitude'),colorbar;
caxis([-3.5 3.5])
str_title2=['pc5 11STA KrigingMaps 1.0 2008-68 second-',num2str(i)];
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
% find the value of BOU latBOU = 40.14; lonBOU = -105.24, 
% round to lat=40, which 31 row fo lati, and long=-105, which is 45 colomn for longi
pc5i_11staKIG_bou(k)=pc5i(31,44);
k=k+1;
end

%Interpolating Scattered Data Using griddata and griddatan

% build Observitories location
% Begin with a small set of point data, approximate latitudes and longitudes
latTUC =  32.17; lonTUC =   -110.73;   
% Station Id: TUC
% Location: Tucson, AZ
% Latitude: 32.17癗
% Longitude: 110.73癢
latFRN = 37.09; lonFRN = -119.72;
% Station Id: FRN
% Location: O'Neals, CA
% Latitude: 37.09癗
% Longitude: 119.72癢
latBOU = 40.14; lonBOU = -105.24;
% Station Id: BOU
% Location: Boulder, CO
% Latitude: 40.14癗
% Longitude: 105.24癢
latNEW = 48.27; lonNEW = -117.12;
% Station Id: NEWmaps
% Location: Colville National Forest, WA
% Latitude: 48.27癗
% Longitude: 117.12癢
latFRD = 38.20; lonFRD = -77.37;
% Station Id: FRD
% Location: Corbin, VA
% Latitude: 38.20癗
% Longitude: 77.37癢
latBSL = 30.35; lonBSL = -89.63;
% Station Id: BSL
% Location: NASA Stennis Space Center, MS
% Latitude: 30.35癗
% Longitude: 89.63癢
latSJG = 18.11; lonSJG = -66.15;
% Station Id: SJG
% Location: Cayey, PR
% Latitude: 18.11癗
% Longitude: 66.15癢
latHON = 21.32; lonHON = -158.00;
% Station Id: HON
% Location: Ewa Beach, HI
% Latitude: 21.32癗
% Longitude: 158.00癢
latSIT = 57.06; lonSIT = -135.33;
% Station Id: SIT
% Location: Sitka, AK
% Latitude: 57.06癗
% Longitude: 135.33癢
latSHU = 55.35; lonSHU = -160.46;
% Station Id: SHU
% Location: Sand Point, Popof, AK
% Latitude: 55.35癗
% Longitude: 160.46癢
latGUA = 13.59; lonGUA = 35.13;
%latGUA = 13.59; lonGUA = -215.13;
% Station Id: GUA
% Location: Dededo, Guam
% Latitude: 13.59癗
% Longitude: 215.13癢=35.13癊
latBRW = 71.32; lonBRW = -156.62;
% Station Id: BRW
% Location: Point Barrow, AK
% Latitude: 71.32癗
% Longitude: 156.62癢
latCMO = 64.87; lonCMO = -147.86;
% Station Id: CMO
% Location: Fairbanks, AK
% Latitude: 64.8741癗
% Longitude: 147.8597癢

% latDED = 70.36; lonDED = -148.79;
% Station Id: DED
% Location: Deadhorse, AK
% Latitude: 70.36癗
% Longitude: 148.79癢

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
OBS(7).Lat = latSJG; OBS(7).Lon = lonSJG;
OBS(8).Lat = latHON; OBS(8).Lon = lonHON;
OBS(9).Lat = latSIT; OBS(9).Lon = lonSIT;
OBS(10).Lat = latSHU; OBS(10).Lon = lonSHU;
OBS(11).Lat = latCMO; OBS(11).Lon = lonCMO;
OBS(12).Lat = latBRW; OBS(12).Lon = lonBRW;
%OBS(13).Lat = latGUA; OBS(13).Lon = lonGUA;
OBS(1).Name = 'TUC';
OBS(2).Name = 'FRN';
OBS(3).Name = 'BOU';
OBS(4).Name = 'NEW';
OBS(5).Name = 'FRD';
OBS(6).Name = 'BSL';
OBS(7).Name = 'SJG';
OBS(8).Name = 'HON';
OBS(9).Name = 'SIT';
OBS(10).Name = 'SHU';
OBS(11).Name = 'CMO';
OBS(12).Name = 'BRW';
%OBS(13).Name = 'GUA';
k=1;
%%%%%%%%%%%%%%%%%%%%%% loop for 100 second  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=T1:interval1:T2%3600*26-3600*36 which is the storm period

%plot interoplated pc5 index
lat=[latTUC latFRN latBOU latNEW latFRD latBSL latSJG latHON latSIT latSHU latCMO latBRW];
long=[lonTUC lonFRN lonBOU lonNEW lonFRD lonBSL lonSJG lonHON lonSIT lonSHU lonCMO lonBRW];
pc5=[atucBH(8,i)+atucBH(9,i) afrnBH(8,i)+afrnBH(9,i) abouBH(8,i)+abouBH(9,i)...
    anewBH(8,i)+anewBH(9,i) afrdBH(8,i)+afrdBH(9,i) abslBH(8,i)+abslBH(9,i) asjgBH(8,i)+asjgBH(9,i)...
    ahonBH(8,i)+ahonBH(9,i) asitBH(8,i)+asitBH(9,i) ashuBH(8,i)+ashuBH(9,i)...
    acmoBH(8,i)+acmoBH(9,i) abrwBH(8,i)+abrwBH(9,i)]'; %aguaBH(8,i)+aguaBH(9,i)

[longi,lati] = meshgrid(-127:0.5:-66, 25:0.5:50);
% kriging!!!!!!!!!
v = variogram([long' lat'],pc5);
[dum,dum,dum,vstruct] = variogramfit(v.distance,v.val,[],[],[],'model','stable');
close;
[pc5i,pc5Vari] = krigingtest(vstruct,long',lat',pc5,longi,lati);

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

pcolor(longi,lati,pc5i);
%surface(longi,lati,pc5i);
xlabel('Longitude'), ylabel('Latitude'),colorbar;
caxis([-3.5 3.5])
str_title2=['pc5 12STA KrigingMaps 1.0 2008-68 second-',num2str(i)];
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
% find the value of BOU latBOU = 40.14; lonBOU = -105.24, 
% round to lat=40, which 31 row fo lati, and long=-105, which is 45 colomn for longi
pc5i_12staKIG_bou(k)=pc5i(31,44);
k=k+1;
end

figure;plot(pc5i_11staKIG_bou)
hold on;plot(pc5i_12staKIG_bou,'ko');
k=1;
for i=T1:interval1:T2
pc5i_ori_bou(k)=abouBH(8,i)+abouBH(9,i);
k=k+1;
end
plot(pc5i_ori_bou,'k+');




