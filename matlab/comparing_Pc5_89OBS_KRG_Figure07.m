T1=41400; T2=45000; interval1=2;

%Interpolating Scattered Data Using griddata and griddatan

% build Observitories location
% Begin with a small set of point data, approximate latitudes and longitudes
latTUC =  32.17; lonTUC =   -110.73;   
% OBStion Id: TUC
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
OBS(1).Name = 'TUC';
OBS(2).Name = 'FRN';
OBS(3).Name = 'BOU';
OBS(4).Name = 'NEW';
OBS(5).Name = 'FRD';
OBS(6).Name = 'BSL';
k=1;
%%%%%%%%%%%%%%%%%%%%%% With BOU  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=T1:interval1:T2%3600*26-3600*36 which is the storm period
% interoplated pc5 index
lat=[latTUC latFRN latBOU latNEW latFRD latBSL latSJG latHON latSIT];
long=[lonTUC lonFRN lonBOU lonNEW lonFRD lonBSL lonSJG lonHON lonSIT];
pc5=[atucBH(8,i)+atucBH(9,i) afrnBH(8,i)+afrnBH(9,i) abouBH(8,i)+abouBH(9,i)...
    anewBH(8,i)+anewBH(9,i) afrdBH(8,i)+afrdBH(9,i) abslBH(8,i)+abslBH(9,i) asjgBH(8,i)+asjgBH(9,i)...
    ahonBH(8,i)+ahonBH(9,i) asitBH(8,i)+asitBH(9,i)]'; 
%Use meshgrid to create a set of 2-D grid points in the longitude-latitude plane and then use griddata to interpolate the corresponding depth at those points:
[longi,lati] = meshgrid(-127:0.5:-66, 25:0.5:50);
%%%%%%% KRG !!!!!
v = variogram([long' lat'],pc5);
[dum,dum,dum,vstruct] = variogramfit(v.distance,v.val,[],[],[],'model','stable');
close;
[pc5i,pc5Vari] = krigingtest(vstruct,long',lat',pc5,longi,lati);

% % plot USA map with province
% s = shaperead('physio_Dissolve_province.shp');
% figure('Color','w');
% mapshow(s);
% 
% % PUT OBS ON THE MAP
% mapshow(OBS(1:6),'Marker','o',...
%     'MarkerFaceColor','c','MarkerEdgeColor','k');
% % Display the OBS names using data in the geostruct field Name.
% % Note that you must treat the Name field as a cell array.
% text([OBS(1:6).Lon]-1,[OBS(1:6).Lat]+0.7,...
%     {OBS(1:6).Name},'FontWeight','bold');
% hold on
% 
% %Put pc5 on the map
% h=pcolor(longi,lati,pc5i);
% set(h,'EdgeColor','none');
% xlabel('Longitude'), ylabel('Latitude'),colorbar;
% caxis([-2.5 2.5])
% str_title2=['pc5 9OBS KRGMaps 1.0 2008-68 second-',num2str(i)];
% title(str_title2);
% annotation('textbox',...
%     [0.84 0.76 0.077 0.052],...
%     'String',{'nT'},...
%     'FontSize',12,...
%     'FontName','Arial',...
%     'FitBoxToText','off',...
%     'LineStyle','none');
% xlim([-127 -66]);ylim([25 50]);
% saveas(gcf,['K:\draftFigure\tmp\',str_title2,'.png'], 'png')
% close
% clear h;
% find the value of BOU latBOU = 40.14; lonBOU = -105.24, 
% round to lat=40, which 31 row fo lati, and long=-105, which is 45 colomn for longi
pc5i_9OBSKRG_bou(k)=pc5i(31,44);
k=k+1;
end



%%%%%%%%%%%%%%%%%%%% Without BOU %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=1;
for i=T1:interval1:T2%3600*26-3600*36 which is the storm period

%plot interoplated pc5 index
lat=[latTUC latFRN latNEW latFRD latBSL latSJG latHON latSIT];
long=[lonTUC lonFRN lonNEW lonFRD lonBSL lonSJG lonHON lonSIT];
pc5=[atucBH(8,i)+atucBH(9,i) afrnBH(8,i)+afrnBH(9,i)...
    anewBH(8,i)+anewBH(9,i) afrdBH(8,i)+afrdBH(9,i) abslBH(8,i)+abslBH(9,i) asjgBH(8,i)+asjgBH(9,i)...
    ahonBH(8,i)+ahonBH(9,i) asitBH(8,i)+asitBH(9,i)]'; %aguaBH(8,i)+aguaBH(9,i)
%Use meshgrid to create a set of 2-D grid points in the longitude-latitude plane and then use griddata to interpolate the corresponding depth at those points:
[longi,lati] = meshgrid(-127:0.5:-66, 25:0.5:50);
%%%%%%% KRG !!!!!
v = variogram([long' lat'],pc5);
[dum,dum,dum,vstruct] = variogramfit(v.distance,v.val,[],[],[],'model','stable');
close;
[pc5i,pc5Vari] = krigingtest(vstruct,long',lat',pc5,longi,lati);

% % plot USA map with province
% s = shaperead('physio_Dissolve_province.shp');
% figure('Color','w');
% mapshow(s);
% 
% % PUT OBS ON THE MAP
% mapshow(OBS(1:6),'Marker','o',...
%     'MarkerFaceColor','c','MarkerEdgeColor','k');
% % Display the OBS names using data in the geostruct field Name.
% % Note that you must treat the Name field as a cell array.
% text([OBS(1:6).Lon]-1,[OBS(1:6).Lat]+0.7,...
%     {OBS(1:6).Name},'FontWeight','bold');
% hold on
% 
% h=pcolor(longi,lati,pc5i);
% set(h,'EdgeColor','none');
% xlabel('Longitude'), ylabel('Latitude'),colorbar;
% caxis([-2.5 2.5])
% str_title2=['pc5 8OBS KRGMaps 1.0 2008-68 second-',num2str(i)];
% title(str_title2);
% annotation('textbox',...
%     [0.84 0.76 0.077 0.052],...
%     'String',{'nT'},...
%     'FontSize',12,...
%     'FontName','Arial',...
%     'FitBoxToText','off',...
%     'LineStyle','none');
% xlim([-127 -66]);ylim([25 50]);
% saveas(gcf,['K:\draftFigure\tmp\',str_title2,'.png'], 'png')
% close
% find the value of BOU latBOU = 40.14; lonBOU = -105.24, 
% round to lat=40, which 31 row fo lati, and long=-105, which is 45 colomn for longi
pc5i_8OBSKRG_bou(k)=pc5i(31,44);
k=k+1;
end

%%%% ori pc5i_ori_bou %%%%
k=1;
for i=T1:interval1:T2
pc5i_ori_bou(k)=abouBH(8,i)+abouBH(9,i);
k=k+1;
end

XaPc = [1:1800/interval1:((T2-T1)/interval1+1)];
XbPc = [T1:1800:T2+1];
figure;
subplot(3,1,1:2);
plot(pc5i_9OBSKRG_bou,'kx');
hold on;
plot(pc5i_8OBSKRG_bou,'k--');
legend('With BOU','No BOU','Location','Best');
xlim([1 (T2-T1)/interval1+1]);set(gca,'XTick',XaPc,'XTickLabel',XbPc);
str_title_compare8vs9=['Comparing pc5 8-9OBS KRG interpolation at BOU ',num2str(T1),'-',num2str(T2),'sec'];
title(str_title_compare8vs9);
subplot(3,1,3);
plot(pc5i_9OBSKRG_bou-pc5i_8OBSKRG_bou,'k');
xlim([1 (T2-T1)/interval1+1]);set(gca,'XTick',XaPc,'XTickLabel',XbPc);
str_title_diff=['Difference between interpolation with data from 8 and 9 OBS at BOU'];
title(str_title_diff);
saveas(gcf,['K:\draftFigure\',str_title_compare8vs9,'.png'], 'png')

%%%%%% Correlation %%%%%%
corr_pc5 = corrcoef(pc5i_9OBSKRG_bou,pc5i_8OBSKRG_bou)
x=pc5i_9OBSKRG_bou;y=pc5i_8OBSKRG_bou;
N=length(pc5i_8OBSKRG_bou);
X_M=sum(x)/N;
Y_M=sum(y)/N;
S_temp=0;
for i=1:N
    Sxx_temp(i)=(x(i)-X_M)^2;
    Sxy_temp(i)=(x(i)-X_M)*(y(i)-Y_M);
    Syy_temp(i)=(y(i)-Y_M)^2;
end
Sxx=sum(Sxx_temp);Sxy=sum(Sxy_temp);Syy=sum(Syy_temp);
a=Sxy/Sxx;
b=Y_M-a*X_M;
Vxy=Sxy/sqrt(Sxx*Syy);

for i=1:N
    y1(i)=x(i)*a+b;
end

figure;plot(x,y,'.');
hold on;plot(x,y1,'k','LineWidth',3);
xlabel('With BOU / nT');
ylabel('No BOU / nT');
text(0.4, 0.05,strcat('Correlation Coeff = ',num2str(corr_pc5(1,2))),...
                'Units', 'normalized');
str_title_corr=['pc5 KRG correlation 2008068 ',num2str(T1),'-',num2str(T2),'sec'];
title(str_title_corr);
saveas(gcf,['K:\draftFigure\',str_title_corr,'.png'], 'png')
