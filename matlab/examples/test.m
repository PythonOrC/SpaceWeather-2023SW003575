filename = "6_station_dbn_abridged.csv";
delimiter = ",";
dat = readtable("6_station_dbn_abridged.csv", "Delimiter",delimiter, "DatetimeType","datetime");

[Stations,IA,IC] = unique(dat.Station);

data = {};
for i = 1:length(Stations)
    display(string(S{i}));
    index = dat.Station == string(Stations{i});
    datS = dat(index,:);
    d = 
    data = [data, datS{:,7}];
end
