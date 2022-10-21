DATA = 'dbn_nez';
TIME = 309;
DURATION = 240;

% import the raw unprocessed data
raw = readtable("supermag-6-stations.csv", "Delimiter",",", "DatetimeType","datetime");
% get the stations from the raw data
[Stations,IA,IC] = unique(raw.IAGA);
% get the latitude and longitude of each station
lat = raw.GEOLAT(1:length(Stations), 1);
long = raw.GEOLON(1:length(Stations), 1);
%convert the lat and long from [0,360] to [-180,180]
for i = 1:length(lat)
    if lat(i) > 180
        lat(i) = lat(i) - 360;
    end
    if long(i) > 180
        long(i) = long(i) - 360;
    end
end
% extract the necessary data from the raw data
clear data;
data = {};
for i = 1:length(Stations)
    % raw datum refers to all the data from a single station
    raw_datum = raw(raw.IAGA == string(Stations(i)), :);
    % extract the needed datum from the raw datum
    % datum = raw_datum.dbn_nez;
    datum = table2array(raw_datum(:,{DATA}));
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
[longi,lati] = meshgrid(-127:0.5:-66, 25:0.5:50); % * 0.5 is the resolution, longitude then latitude
% graph the data
for t = TIME:TIME+DURATION
    dat_c = dat(t,:);
    v = variogram([OBS.long OBS.lat],dat_c');
    [~,~,~,vstruct] = variogramfit(v.distance,v.val,[],[],[],'model','stable');
    close;
    [OBSi,OBSVari] = krigingtest(vstruct,OBS.long',OBS.lat',dat_c,longi,lati);
    h=pcolor(longi,lati,OBSi); % * draw the points
    set(h,'EdgeColor','none'); 
    xlabel('Longitude'), ylabel('Latitude'), colorbar; 
    clim([min max]) % * colorbar range
    str_title2=[DATA,' 6 stations 20031029 minute-',num2str(t)];
    title(str_title2);
    annotation('textbox',...
        [0.84 0.76 0.077 0.052],... % * position of the text box
        'String',{'nT'},...
        'FontSize',12,...
        'FontName','Arial',...
        'FitBoxToText','off',...
        'LineStyle','none');
    xlim([-127 -66]); % * longitude range
    ylim([25 50]); % * latitude range
    text(OBS.long,OBS.lat, [string(OBS.Stations)],'FontWeight','bold');
    hold on
    saveas(gcf,['D:\Github Repository\SpaceWeather\matlab\examples\draftFigure\',num2str(t),'.png'], 'png')
end