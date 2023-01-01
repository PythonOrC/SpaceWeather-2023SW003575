%* this is for maglat chain
%TODO add drv hob can cnb cul cta KTN LEM to afternoon
%TODO: add NRD DMR JAN CZT to prenon

%*this is for maglon chain
%TODO: find a chain that is evenly spread out
%TODO: one in the northen hemisphere one along the equator, and southern hemisphere
%TODO: same process as maglat chain

%* this is for 1724
%TODO: do the same maglat and maglon analysis


DATA = 'dbn_nez';
SEG = "0509";
PRENOON = true;
Xcorr = 3;
LINE = "MAGLAT"

if SEG == "0509"
    if LINE == "MAGLAT"
        if PRENOON == true
            if Xcorr == 0
                STATIONS =["MAW" "CZT" "HBK" "LMM" "MLT" "ELT" "QSB" "ISK" "SUA" "LVV" "BEL" "HLP" "TAR" "LOV" "UPS" "NUR" "HAN" "OUJ" "PEL" "SOD" "KIR" "MUO" "IVA" "ABK" "KIL" "MAS" "AND" "TRO" "SOR" "BJN" "HOR" "HRN" "ALE"];
            elseif Xcorr == 1
                STATIONS =["SOR" "BJN" "HOR" "HRN"];
            elseif Xcorr == 2
                STATIONS =["HAN" "OUJ" "PEL" "SOD" "KIR" "MUO" "IVA" "ABK" "KIL" "MAS" "AND"];
            elseif Xcorr == 3
                STATIONS =["HBK" "LMM" "MLT" "ELT" "QSB" "ISK" "SUA" "LVV" "BEL" "HLP" "TAR" "LOV" "UPS"];
            end
        elseif PRENOON == false
            if Xcorr == 0
                STATIONS = ["DRV" "LEM" "ASP" "CTA" "KDU" "WEP" "WEW" "GUA" "CBI" "KNY" "KAG" "HTY" "KAK" "ONW" "PPI" "RIK" "MMB" "MSR" "MGD" "CHD" "TIK" "KTN"]; 
            elseif Xcorr == 1
                STATIONS = ["CHD" "TIK" "KTN"];  
            elseif Xcorr == 2
                STATIONS = ["LEM" "ASP" "CTA" "KDU" "WEP" "WEW" "GUA" "CBI" "KNY" "KAG" "HTY" "KAK" "ONW" "PPI" "RIK" "MMB" "MSR" "MGD"]; 
            end
        end
    elseif LINE == "MAGLON"
        % when the line is maglon
        if PRENOON == true
            if Xcorr == 0
                STATIONS =[];
            elseif Xcorr == 1
                STATIONS =[];
            end
        else
            if Xcorr == 0
                STATIONS = []; 
            elseif Xcorr == 1
                STATIONS = [];  
            end
        end
    end
elseif SEG == "1724"
    if LINE == "MAGLAT"
        if PRENOON == true
            if Xcorr == 0
                STATIONS =[];
            elseif Xcorr == 1
                STATIONS =[];
            end
        elseif PRENOON == false
            if Xcorr == 0
                STATIONS = []; 
            elseif Xcorr == 1
                STATIONS = [];  
            end
        end
    elseif LINE == "MAGLON"
        if PRENOON == true
            if Xcorr == 0
                STATIONS =[];
            elseif Xcorr == 1
                STATIONS =[];
            end
        elseif PRENOON == false
            if Xcorr == 0
                STATIONS = []; 
            elseif Xcorr == 1
                STATIONS = [];  
            end
        end
    end
end




% import the raw unprocessed data
if SEG == "0509"
    raw = readtable("HalloweenStorm-SuperMAG-0509.csv", "Delimiter",",", "DatetimeType","datetime");
    raw_ACE = readtable("ACE_0509_interp.csv");
else
    raw = readtable("HalloweenStorm-SuperMAG-1724.csv", "Delimiter",",", "DatetimeType","datetime");
    raw_ACE = readtable("ACE_1724_interp.csv");
end

% get the stations from the raw data
[Stations,IA,IC] = unique(raw.IAGA, 'stable');
mlt_all = raw.MLT;
% get the latitude and longitude of each station
lat = raw.MAGLAT(1:length(Stations), 1);
long = raw.MAGLON(1:length(Stations), 1);
By = raw_ACE.By;
Bz = raw_ACE.Bz;

% extract the necessary data from the raw data
clear data;
data = {};
for i = 1:length(Stations)
    % raw datum refers to all the data from a single station
    raw_datum = raw(raw.IAGA == string(Stations(i)), :);
    % extract the needed datum from the raw datum
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
filtered = {};
for i = 1:length(STATIONS)
    for j = 1:length(Stations)
        if strcmp(string(Stations(j)), string(STATIONS(i)))
            filtered = [filtered; OBS.data{j}(:)];
            disp(STATIONS(i))
        end
    end
end
figure;
SPACING = 0;
hold on;
for i = 1:length(filtered)
    data_f = filtered(i);
    data_f = cell2mat(data_f);
    plot(1:length(data_f),data_f(:)+SPACING);
    if PRENOON == true

        % if i == 1
        %     SPACING = SPACING + 2000;
        % elseif i < 7
        %     SPACING = SPACING + 1000;
        % elseif i == 20 || i == 21
        %     SPACING = SPACING + 1000;
        % end
        % SPACING = SPACING + 500;
        SPACING = SPACING + 300;
    else
        % if i == 1
        %     SPACING = SPACING + 600;
        % elseif i == 3
        %     SPACING = SPACING + 750;
        % end
        SPACING = SPACING + 150;
    end
    
end

corr_lag = [];
    if PRENOON == true
        x_station = 2;
    elseif PRENOON ==false
        x_station = 1;
    end   
for i = 1:length(filtered)
    [r, lag] = xcorr(filtered{x_station}(50:150), filtered{i}(50:150)); 
    corr_lag = [corr_lag; lag(r == max(r)) max(r)];
end