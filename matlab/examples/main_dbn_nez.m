DATA = 'dbn_nez';
TIME = 444;
DURATION = 5;
INTERVAL = TIME:TIME+DURATION;
MARGIN = 3;
% import the raw unprocessed data
%raw = readtable("supermag-6-stations.csv", "Delimiter",",", "DatetimeType","datetime");
raw = readtable("all-na-stations-noRAN+SMI+UPN.csv", "Delimiter",",", "DatetimeType","datetime");
% get the stations from the raw data
[Stations,IA,IC] = unique(raw.IAGA);
% get the latitude and longitude of each station
lat = raw.GEOLAT(1:length(Stations), 1);
long = raw.GEOLON(1:length(Stations), 1);
clear LOC;
[LOC(1:length(Stations)).Geometry] = deal('Point');
for i = 1:length(Stations)
    LOC(i).Lat = lat(i);
    LOC(i).Lon = long(i);
end

%convert the lat and long from [0,360] to [-180,180]
for i = 1:length(lat)
    if lat(i) > 180
        lat(i) = lat(i) - 360;
    end
    if long(i) > 180
        long(i) = long(i) - 360;
    end
end

% max_lat = lat(1);
% min_lat = lat(1);
% max_long = lat(1);
% min_long = lat(1);
% min_long_index = 1;
% max_long_index = 1;
% min_lat_index = 1;
% max_lat_index = 1;
% for i = 1:length(lat)
%     if lat(i) > max_lat
%         max_lat = lat(i);
%         max_lat_index = i;
%     end
%     if lat(i) < min_lat
%         min_lat = lat(i);
%         min_lat_index = i;
%     end
%     if long(i) > max_long
%         max_long = long(i);
%         max_long_index = i;
%     end
%     if long(i) < min_long
%         min_long = long(i);
%         min_long_index = i;
%     end
% end
clear max;
clear min;
max_lat = max(lat) + MARGIN;
min_lat = min(lat) - MARGIN;
max_long = max(long) + MARGIN;
min_long = min(long) - MARGIN;
clear max;
clear min;
% extract the necessary data from the raw data
clear data;
data = {};
for i = 1:length(Stations)
    % raw datum refers to all the data from a single station
    raw_datum = raw(raw.IAGA == string(Stations(i)), :);
    % extract the needed datum from the raw datum
    datum = table2array(raw_datum(INTERVAL,{DATA}));
    %interpolate the Nan values
    datum = fillmissing(datum, 'linear');
    % add the datum to the data cell array
    data = [data; datum];
end

% combine the data and the Stations together
clear OBS;
OBS = table(Stations, data, lat, long);
%resulting sample structure of all:
    % Stations         data           lat      long  
    % ________    _______________    _____    _______
    % {'BOU'}     {1440×1 double}    40.14    -105.24
    % {'BSL'}     {1440×1 double}    30.35     -89.64
    % {'FRD'}     {1440×1 double}     38.2     -77.37
    % {'FRN'}     {1440×1 double}    37.09    -119.72
    % {'NEW'}     {1440×1 double}    48.27    -117.12

%combine all the values together
clear dat;
dat = [];
for i = 1:length(OBS.Stations)
    dat = [dat OBS(strcmp(OBS.Stations, OBS.Stations(i)), : ).data{1}];
end

%get the upper and lower bounds of the data
clear min;
clear max;

min = min(min(dat));
max = max(max(dat));
    %Use meshgrid to create a set of 2-D grid points in the longitude-latitude plane and then use griddata to interpolate the corresponding depth at those points:
[longi,lati] = meshgrid(min_long:1:max_long, min_lat:1:max_lat); % * 0.5 is the resolution, longitude then latitude
%[longi,lati] = meshgrid(-127:0.5:-66, 25:0.5:50);
% graph the data
% for t = TIME:TIME+DURATION
for t = 1:DURATION
    disp("Generating...");
    dat_c = dat(t,:);
    v = variogram([OBS.long OBS.lat],dat_c');
    [~,~,~,vstruct] = variogramfit(v.distance,v.val,[],[],[],'model','stable');
    close;
    [OBSi,OBSVari] = krigingtest(vstruct,OBS.long',OBS.lat',dat_c,longi,lati);
    
    
  figure('Color','w', 'Position',[0 0 1280 720]);

    


    h=pcolor(longi,lati,OBSi); % * draw the points
    hold on
    set(h,'EdgeColor','none'); 
        s = shaperead('landareas.shp');
    mapshow(LOC(1:length(LOC)),'Marker','o',...
    'MarkerFaceColor','c','MarkerEdgeColor','k');
    text(OBS.long,OBS.lat, [string(OBS.Stations)],'FontWeight','bold');
    mapshow(s,'FaceAlpha', 0);
    
    % colormap gray;
    xlabel('Longitude'), ylabel('Latitude'), colorbar; 
    clim([min max]) % * colorbar range
    str_title2=[DATA,' 20031029 minute-',num2str(t+TIME)];
    title(str_title2);
    annotation('textbox',...
        [0.84 0.76 0.077 0.052],... % * position of the text box
        'String',{'nT'},...
        'FontSize',12,...
        'FontName','Arial',...
        'FitBoxToText','off',...
        'LineStyle','none');
    xlim([min_long max_long-1]); % * longitude range
    ylim([min_lat max_lat-1]); % * latitude range
    
    saveas(gcf,['D:\Github Repository\SpaceWeather\matlab\examples\draftFigure\',num2str(t),'.png'], 'png')
end