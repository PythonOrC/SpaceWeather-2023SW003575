ACE = readtable("20031029_ace_mag_1m.csv");
figure;
hold on;
ylim([-50 250]);
xlim([0 1440]);
ACE.Bx(ACE.Bx == -999.9) = NaN;
ACE.By(ACE.By == -999.9) = NaN;
ACE.Bz(ACE.Bz == -999.9) = NaN;
ylabel("Intensity (nT)");
xlabel("Time (hour)")

title("IMF Data on October 29, 2003");
plot(1:length(ACE.Bx),ACE.Bx+200);
plot(1:length(ACE.By),ACE.By+100);
plot(1:length(ACE.Bz),ACE.Bz);
legend(["Bx" "By" "Bz"]);
xticks([0 120 240 360 480 600 720 840 960 1080 1200 1320 1440]);
xticklabels([0,2,4,6,8,10,12,14,16,18,20,22,24]);

x0=10;
y0=10;
width=600;
height=400;
set(gcf,'position',[x0,y0,width,height]);