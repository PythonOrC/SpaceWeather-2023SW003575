T1=172800; T2=345600; interval1=120;

%Interpolating Scattered Data Using griddata and griddatan

% build Observitories location
% Begin with a small set of point data, approximate latitudes and longitudes
latTUC =  32.17; lonTUC =   -110.73;   
% OBStion Id: TUC
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
OBS(1).Name = 'TUC';
OBS(2).Name = 'FRN';
OBS(3).Name = 'BOU';
OBS(4).Name = 'NEW';
OBS(5).Name = 'FRD';
OBS(6).Name = 'BSL';
k=1;
%%%%%%%%%%%%%%%%%%%%%% With TUC  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=T1:interval1:T2
% interoplated WISA index
lat=[latTUC latFRN latBOU latNEW latFRD latBSL latSJG latHON latSIT];
long=[lonTUC lonFRN lonBOU lonNEW lonFRD lonBSL lonSJG lonHON lonSIT];
WISA=[WISA_tuc(i) WISA_frn(i) WISA_bou(i)...
    WISA_new(i) WISA_frd(i) WISA_bsl(i) WISA_sjg(i)...
    WISA_hon(i) WISA_sit(i)]'; 
%Use meshgrid to create a set of 2-D grid points in the longitude-latitude plane and then use griddata to interpolate the corresponding depth at those points:
[longi,lati] = meshgrid(-127:0.5:-66, 25:0.5:50);
%%%%%%% KRG !!!!!
v = variogram([long' lat'],WISA);
[dum,dum,dum,vstruct] = variogramfit(v.distance,v.val,[],[],[],'model','stable');
close;
[WISAi,WISAVari] = krigingtest(vstruct,long',lat',WISA,longi,lati);

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

%Put WISA on the map
pcolor(longi,lati,WISAi);
xlabel('Longitude'), ylabel('Latitude'),colorbar;
caxis([-120 50])
str_title2=['WISA TUC9 KRGMaps 1.0 20111024 second-',num2str(i)];
title(str_title2);
annotation('textbox',...
    [0.84 0.76 0.077 0.052],...
    'String',{'nT'},...
    'FontSize',12,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'LineStyle','none');
xlim([-127 -66]);ylim([25 50]);
str_title2s=['WISA_TUC9_KRGMaps_1_20111024_second_',num2str(i)];
saveas(gcf,['C:\Users\zxu\Documents\zxu_local\USU\xudoc\work1\USGS1sec\tmp2\',str_title2s,'.png'], 'png')
close
% WISA_tuc(i)=29.4482 WISAi(15,34)=29.3722 WISAi(14, 33)=29.4968 WISAi(13, 33)=29.4524 
% latTUC = 32.1700  lonTUC = -110.7300, for the matrix[-127:0.5:-66, 25:0.5:50], 32.00->15, -110.50->34.
% pick WISAi(14,33);
WISAi_9OBSKRG_tuc(k)=WISAi(14,33);
k=k+1;
end



%%%%%%%%%%%%%%%%%%%% Without TUC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=1;
%%%%%%%%%%%%%%%%%%%%%% loop for 100 second  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=T1:interval1:T2
%plot interoplated WISA index
lat=[latBOU latFRN latNEW latFRD latBSL latSJG latHON latSIT];
long=[lonBOU lonFRN lonNEW lonFRD lonBSL lonSJG lonHON lonSIT];
WISA=[WISA_bou(i) WISA_frn(i)...
    WISA_new(i) WISA_frd(i) WISA_bsl(i) WISA_sjg(i)...
    WISA_hon(i) WISA_sit(i)]'; 
%Use meshgrid to create a set of 2-D grid points in the longitude-latitude plane and then use griddata to interpolate the corresponding depth at those points:
[longi,lati] = meshgrid(-127:0.5:-66, 25:0.5:50);
%%%%%%% KRG !!!!!
v = variogram([long' lat'],WISA);
[dum,dum,dum,vstruct] = variogramfit(v.distance,v.val,[],[],[],'model','stable');
close;
[WISAi,WISAVari] = krigingtest(vstruct,long',lat',WISA,longi,lati);

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

pcolor(longi,lati,WISAi);
xlabel('Longitude'), ylabel('Latitude'),colorbar;
caxis([-120 50])
str_title2=['WISA TUC8 KRGMaps 1.0 20111024 second-',num2str(i)];
title(str_title2);
annotation('textbox',...
    [0.84 0.76 0.077 0.052],...
    'String',{'nT'},...
    'FontSize',12,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'LineStyle','none');
xlim([-127 -66]);ylim([25 50]);
str_title2s=['WISA_TUC8_KRGMaps_1_20111024_second_',num2str(i)];
saveas(gcf,['C:\Users\zxu\Documents\zxu_local\USU\xudoc\work1\USGS1sec\tmp2\',str_title2s,'.png'], 'png')
close
% WISA_tuc(i)=29.4482 WISAi(15,34)=29.3722 WISAi(14, 33)=29.4968 WISAi(14, 33)=29.1424 
% latTUC = 32.1700  lonTUC = -110.7300, for the matrix: 32.00->15, -110.50->34.
WISAi_8OBSKRG_tuc(k)=WISAi(14,33);
k=k+1;
end

%%%% ori WISAi_ori_tuc %%%%
k=1;
for i=T1:interval1:T2
WISAi_ori_tuc(k)=WISA_tuc(i);
k=k+1;
end

XaPc = [1:7200/interval1:((T2-T1)/interval1+1)];
XbPc = [T1:7200:T2+1];
figure;
subplot(3,1,1:2);
%plot(WISA_tuc(T1:T2),'k+');
hold on;plot(WISAi_9OBSKRG_tuc,'kx');
plot(WISAi_8OBSKRG_tuc,'k--');
legend('BOU-9OBS','BOU-8OBS','Location','Best');
xlim([1 (T2-T1)/interval1+1]);set(gca,'XTick',XaPc,'XTickLabel',XbPc);
str_title_compare8vs9=['Comparing WISA 8-9OBS KRG interpolation at TUC ',num2str(T1),'-',num2str(T2),'sec'];
title(str_title_compare8vs9);
subplot(3,1,3);
plot(WISAi_9OBSKRG_tuc-WISAi_8OBSKRG_tuc,'k');
xlim([1 (T2-T1)/interval1+1]);set(gca,'XTick',XaPc,'XTickLabel',XbPc);
str_title_diff=['Difference between interpolation with data from 8 and 9 OBS at BOU'];
title(str_title_diff);
saveas(gcf,['C:\Users\zxu\Documents\zxu_local\USU\xudoc\work1\USGS1sec\tmp2\',str_title_compare8vs9,'.png'], 'png')
%mean error
WISAi_bar=mean(abs(WISAi_ori_tuc));
k=1;kk=1;
for i=1:length(WISAi_ori_tuc)
    if  abs(WISAi_ori_tuc(k))>WISAi_bar
        WISAi_delta_tuc2(kk)=abs((WISAi_ori_tuc(k)-WISAi_8OBSKRG_tuc(k))/WISAi_ori_tuc(k));kk=kk+1;
        WISAi_delta_tuc(k)=abs((WISAi_ori_tuc(k)-WISAi_8OBSKRG_tuc(k))/WISAi_ori_tuc(k));
    end    
    k=k+1;
end
WISAi_mean_error_tuc2= mean(WISAi_delta_tuc2);
WISAi_mean_error_tuc= mean(WISAi_delta_tuc);
