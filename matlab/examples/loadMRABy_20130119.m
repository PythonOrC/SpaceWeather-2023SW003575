clear;
%Load MRAy ATU
%initial variable 
%load data
filename=strcat('C:\dataMRA\20130119ATUyMRA.txt');
fid = fopen(filename);
%scan data head by how many strings in it, changing with stations
C_texttmp = textscan(fid, '%s', 14); %for second-data
%DETAIL name %s mradata %f *19 D1-D18+S18
oridata_ATU = textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
fclose(fid);
[m n]=size(oridata_ATU);
for i=1:n-1
    ByMRAtmp_ATU(:,i)=oridata_ATU{i+1};
end
ByMRA_ATU=ByMRAtmp_ATU';

%Load MRAx UMQ
filename=strcat('C:\dataMRA\20130119UMQyMRA.txt');
fid = fopen(filename);
%scan data head by how many strings in it, changing with stations
C_texttmp = textscan(fid, '%s', 14); %for second-data
%DETAIL name %s mradata %f *19 D1-D18+S18
oridata_UMQ = textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
fclose(fid);
[m n]=size(oridata_UMQ);
for i=1:n-1
    ByMRAtmp_UMQ(:,i)=oridata_UMQ{i+1};
end
ByMRA_UMQ=ByMRAtmp_UMQ';

%Load MRAx PG3a
filename=strcat('C:\dataMRA\20130119PG3ayMRA.txt');
fid = fopen(filename);
%scan data head by how many strings in it, changing with stations
C_texttmp = textscan(fid, '%s', 14); %for second-data
%DETAIL name %s mradata %f *19 D1-D18+S18
oridata_PG3a = textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
fclose(fid);
[m n]=size(oridata_PG3a);
for i=1:n-1
    ByMRAtmp_PG3a(:,i)=oridata_PG3a{i+1};
end
ByMRA_PG3a=ByMRAtmp_PG3a';

%Load MRAx PG1a
filename=strcat('C:\dataMRA\20130119PG1ayMRA.txt');
fid = fopen(filename);
%scan data head by how many strings in it, changing with stations
C_texttmp = textscan(fid, '%s', 14); %for second-data
%DETAIL name %s mradata %f *19 D1-D18+S18
oridata_PG1a = textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
fclose(fid);
[m n]=size(oridata_PG1a);
for i=1:n-1
    ByMRAtmp_PG1a(:,i)=oridata_PG1a{i+1};
end
ByMRA_PG1a=ByMRAtmp_PG1a';

%Load MRAx GDH
filename=strcat('C:\dataMRA\20130119GDHyMRA.txt');
fid = fopen(filename);
%scan data head by how many strings in it, changing with stations
C_texttmp = textscan(fid, '%s', 14); %for second-data
%DETAIL name %s mradata %f *19 D1-D18+S18
oridata_GDH = textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
fclose(fid);
[m n]=size(oridata_GDH);
for i=1:n-1
    ByMRAtmp_GDH(:,i)=oridata_GDH{i+1};
end
ByMRA_GDH=ByMRAtmp_GDH';

%plot MRAx with different wave bands from 13:30 to 15:30
%the data starts at 0 sec everyday, interval is 10 sec.
rate=10;
TStart=13.5*3600/rate;
TEnd=15.5*3600/rate;
XaByMRA=[1:30*60/rate:(TEnd-TStart)+1];
XbByMRA=['13:30'; '14:00'; '14:30'; '15:00'; '15:30'];
DStart=1;DEnd=13;
for i=DStart:DEnd
    figure;
    subplot(4,1,1)
    plot(ByMRA_UMQ(i,1+TStart:1+TEnd));
    xlim([1 (TEnd-TStart)+1]);
    set(gca,'XTick',XaByMRA,'XTickLabel',XbByMRA);
    ylabel('UMQ');
    str_title_ByMRA=['20130119ByMRA D' int2str(i)];
    title(str_title_ByMRA);
    subplot(4,1,2)
    plot(ByMRA_ATU(i,1+TStart:1+TEnd));
    xlim([1 (TEnd-TStart)+1]);
    set(gca,'XTick',XaByMRA,'XTickLabel',XbByMRA);
    ylabel('ATU')
    subplot(4,1,3)
    plot(ByMRA_PG3a(i,1+TStart:1+TEnd));
    xlim([1 (TEnd-TStart)+1]);
    set(gca,'XTick',XaByMRA,'XTickLabel',XbByMRA);
    ylabel('PG3a')
    subplot(4,1,4)
    plot(ByMRA_PG1a(i,1+TStart:1+TEnd));
    xlim([1 (TEnd-TStart)+1]);
    set(gca,'XTick',XaByMRA,'XTickLabel',XbByMRA);
    xlabel('UT');
    ylabel('PG1a');
    saveas(gcf,['K:\draftFigure\Conjugate\',str_title_ByMRA,'.png'], 'png')
end

%Cross Co-relation UMQ VS PG1, ATU VS PG3
corr_ByMRA_UMQ_PG1a=0;
for Di=DStart:DEnd
corr_ByMRA_UMQ_PG1a_tmp=corrcoef(ByMRA_PG1a(Di,1+TStart:1+TEnd),ByMRA_UMQ(Di,1+TStart:1+TEnd));
corr_ByMRA_UMQ_PG1a(Di)=corr_ByMRA_UMQ_PG1a_tmp(1,2);
x_corr=ByMRA_PG1a(Di,1+TStart:1+TEnd);y_corr=ByMRA_UMQ(Di,1+TStart:1+TEnd);
N=length(ByMRA_UMQ(Di,1+TStart:1+TEnd));
X_corr=sum(x_corr)/N;
Y_corr=sum(y_corr)/N;
S_temp=0;
for i=1:N
    Sxx_temp(i)=(x_corr(i)-X_corr)^2;
    Sxy_temp(i)=(x_corr(i)-X_corr)*(y_corr(i)-Y_corr);
    Syy_temp(i)=(y_corr(i)-Y_corr)^2;
end
Sxx=sum(Sxx_temp);Sxy=sum(Sxy_temp);Syy=sum(Syy_temp);
a_corr=Sxy/Sxx;
b_corr=Y_corr-a_corr*X_corr;
Vxy=Sxy/sqrt(Sxx*Syy);

for i=1:N
    y1_corr(i)=x_corr(i)*a_corr+b_corr;
end

figure;plot(x_corr,y_corr,'.');
hold on;plot(x_corr,y1_corr,'k','LineWidth',3);
str_title_ByMRA_corr=['20130119ByMRA Correlation PG1-UMQ D' int2str(Di)];
title(str_title_ByMRA_corr);
xlabel('PG1a');
ylabel('UMQ');
text(0.05, 0.05,strcat('correlation coeff = ',num2str(corr_ByMRA_UMQ_PG1a_tmp(1,2))),...
                'Units', 'normalized');
saveas(gcf,['K:\draftFigure\Conjugate\',str_title_ByMRA_corr,'.png'], 'png')
end

%Cross Co-relation ATU VS PG3
corr_ByMRA_ATU_PG3a=0;
for Di=DStart:DEnd
corr_ByMRA_ATU_PG3a_tmp=corrcoef(ByMRA_PG3a(Di,1+TStart:1+TEnd),ByMRA_ATU(Di,1+TStart:1+TEnd));
corr_ByMRA_ATU_PG3a(Di)=corr_ByMRA_ATU_PG3a_tmp(1,2);
x_corr=ByMRA_PG3a(Di,1+TStart:1+TEnd);y_corr=ByMRA_ATU(Di,1+TStart:1+TEnd);
N=length(ByMRA_ATU(Di,1+TStart:1+TEnd));
X_corr=sum(x_corr)/N;
Y_corr=sum(y_corr)/N;
S_temp=0;
for i=1:N
    Sxx_temp(i)=(x_corr(i)-X_corr)^2;
    Sxy_temp(i)=(x_corr(i)-X_corr)*(y_corr(i)-Y_corr);
    Syy_temp(i)=(y_corr(i)-Y_corr)^2;
end
Sxx=sum(Sxx_temp);Sxy=sum(Sxy_temp);Syy=sum(Syy_temp);
a_corr=Sxy/Sxx;
b_corr=Y_corr-a_corr*X_corr;
Vxy=Sxy/sqrt(Sxx*Syy);

for i=1:N
    y1_corr(i)=x_corr(i)*a_corr+b_corr;
end

figure;plot(x_corr,y_corr,'.');
hold on;plot(x_corr,y1_corr,'k','LineWidth',3);
str_title_ByMRA_corr=['20130119ByMRA Correlation PG3-ATU D' int2str(Di)];
title(str_title_ByMRA_corr);
xlabel('PG3a');
ylabel('ATU');
text(0.05, 0.05,strcat('correlation coeff = ',num2str(corr_ByMRA_ATU_PG3a_tmp(1,2))),...
                'Units', 'normalized');
saveas(gcf,['K:\draftFigure\Conjugate\',str_title_ByMRA_corr,'.png'], 'png')
end

%Cross Co-relation ATU VS UMQ
corr_ByMRA_ATU_UMQ=0;
for Di=DStart:DEnd
corr_ByMRA_ATU_UMQ_tmp=corrcoef(ByMRA_UMQ(Di,1+TStart:1+TEnd),ByMRA_ATU(Di,1+TStart:1+TEnd));
corr_ByMRA_ATU_UMQ(Di)=corr_ByMRA_ATU_UMQ_tmp(1,2);
x_corr=ByMRA_UMQ(Di,1+TStart:1+TEnd);y_corr=ByMRA_ATU(Di,1+TStart:1+TEnd);
N=length(ByMRA_ATU(Di,1+TStart:1+TEnd));
X_corr=sum(x_corr)/N;
Y_corr=sum(y_corr)/N;
S_temp=0;
for i=1:N
    Sxx_temp(i)=(x_corr(i)-X_corr)^2;
    Sxy_temp(i)=(x_corr(i)-X_corr)*(y_corr(i)-Y_corr);
    Syy_temp(i)=(y_corr(i)-Y_corr)^2;
end
Sxx=sum(Sxx_temp);Sxy=sum(Sxy_temp);Syy=sum(Syy_temp);
a_corr=Sxy/Sxx;
b_corr=Y_corr-a_corr*X_corr;
Vxy=Sxy/sqrt(Sxx*Syy);

for i=1:N
    y1_corr(i)=x_corr(i)*a_corr+b_corr;
end

figure;plot(x_corr,y_corr,'.');
hold on;plot(x_corr,y1_corr,'k','LineWidth',3);
str_title_ByMRA_corr=['20130119ByMRA Correlation UMQ-ATU D' int2str(Di)];
title(str_title_ByMRA_corr);
xlabel('UMQ');
ylabel('ATU');
text(0.05, 0.05,strcat('correlation coeff = ',num2str(corr_ByMRA_ATU_UMQ_tmp(1,2))),...
                'Units', 'normalized');
saveas(gcf,['K:\draftFigure\Conjugate\',str_title_ByMRA_corr,'.png'], 'png')
end

%Cross Co-relation ATU VS PG1a
corr_ByMRA_ATU_PG1a=0;
for Di=DStart:DEnd
corr_ByMRA_ATU_PG1a_tmp=corrcoef(ByMRA_PG1a(Di,1+TStart:1+TEnd),ByMRA_ATU(Di,1+TStart:1+TEnd));
corr_ByMRA_ATU_PG1a(Di)=corr_ByMRA_ATU_PG1a_tmp(1,2);
x_corr=ByMRA_PG1a(Di,1+TStart:1+TEnd);y_corr=ByMRA_ATU(Di,1+TStart:1+TEnd);
N=length(ByMRA_ATU(Di,1+TStart:1+TEnd));
X_corr=sum(x_corr)/N;
Y_corr=sum(y_corr)/N;
S_temp=0;
for i=1:N
    Sxx_temp(i)=(x_corr(i)-X_corr)^2;
    Sxy_temp(i)=(x_corr(i)-X_corr)*(y_corr(i)-Y_corr);
    Syy_temp(i)=(y_corr(i)-Y_corr)^2;
end
Sxx=sum(Sxx_temp);Sxy=sum(Sxy_temp);Syy=sum(Syy_temp);
a_corr=Sxy/Sxx;
b_corr=Y_corr-a_corr*X_corr;
Vxy=Sxy/sqrt(Sxx*Syy);

for i=1:N
    y1_corr(i)=x_corr(i)*a_corr+b_corr;
end

figure;plot(x_corr,y_corr,'.');
hold on;plot(x_corr,y1_corr,'k','LineWidth',3);
str_title_ByMRA_corr=['20130119ByMRA Correlation PG1a-ATU D' int2str(Di)];
title(str_title_ByMRA_corr);
xlabel('PG1a');
ylabel('ATU');
text(0.05, 0.05,strcat('correlation coeff = ',num2str(corr_ByMRA_ATU_PG1a_tmp(1,2))),...
                'Units', 'normalized');
saveas(gcf,['K:\draftFigure\Conjugate\',str_title_ByMRA_corr,'.png'], 'png')
end

%Cross Co-relation UMQ VS PG3a
corr_ByMRA_UMQ_PG3a=0;
for Di=DStart:DEnd
corr_ByMRA_UMQ_PG3a_tmp=corrcoef(ByMRA_PG3a(Di,1+TStart:1+TEnd),ByMRA_UMQ(Di,1+TStart:1+TEnd));
corr_ByMRA_UMQ_PG3a(Di)=corr_ByMRA_UMQ_PG3a_tmp(1,2);
x_corr=ByMRA_PG3a(Di,1+TStart:1+TEnd);y_corr=ByMRA_UMQ(Di,1+TStart:1+TEnd);
N=length(ByMRA_UMQ(Di,1+TStart:1+TEnd));
X_corr=sum(x_corr)/N;
Y_corr=sum(y_corr)/N;
S_temp=0;
for i=1:N
    Sxx_temp(i)=(x_corr(i)-X_corr)^2;
    Sxy_temp(i)=(x_corr(i)-X_corr)*(y_corr(i)-Y_corr);
    Syy_temp(i)=(y_corr(i)-Y_corr)^2;
end
Sxx=sum(Sxx_temp);Sxy=sum(Sxy_temp);Syy=sum(Syy_temp); 
a_corr=Sxy/Sxx;
b_corr=Y_corr-a_corr*X_corr;
Vxy=Sxy/sqrt(Sxx*Syy);

for i=1:N
    y1_corr(i)=x_corr(i)*a_corr+b_corr;
end

figure;plot(x_corr,y_corr,'.');
hold on;plot(x_corr,y1_corr,'k','LineWidth',3);
str_title_ByMRA_corr=['20130119ByMRA Correlation PG3a-UMQ D' int2str(Di)];
title(str_title_ByMRA_corr);
xlabel('PG3a');
ylabel('UMQ');
text(0.05, 0.05,strcat('correlation coeff = ',num2str(corr_ByMRA_UMQ_PG3a_tmp(1,2))),...
                'Units', 'normalized');
saveas(gcf,['K:\draftFigure\Conjugate\',str_title_ByMRA_corr,'.png'], 'png')
end

%Cross Co-relation PG1a VS PG3a
corr_ByMRA_PG1a_PG3a=0;
for Di=DStart:DEnd
corr_ByMRA_PG1a_PG3a_tmp=corrcoef(ByMRA_PG3a(Di,1+TStart:1+TEnd),ByMRA_PG1a(Di,1+TStart:1+TEnd));
corr_ByMRA_PG1a_PG3a(Di)=corr_ByMRA_PG1a_PG3a_tmp(1,2);
x_corr=ByMRA_PG3a(Di,1+TStart:1+TEnd);y_corr=ByMRA_PG1a(Di,1+TStart:1+TEnd);
N=length(ByMRA_PG1a(Di,1+TStart:1+TEnd));
X_corr=sum(x_corr)/N;
Y_corr=sum(y_corr)/N;
S_temp=0;
for i=1:N
    Sxx_temp(i)=(x_corr(i)-X_corr)^2;
    Sxy_temp(i)=(x_corr(i)-X_corr)*(y_corr(i)-Y_corr);
    Syy_temp(i)=(y_corr(i)-Y_corr)^2;
end
Sxx=sum(Sxx_temp);Sxy=sum(Sxy_temp);Syy=sum(Syy_temp); 
a_corr=Sxy/Sxx;
b_corr=Y_corr-a_corr*X_corr;
Vxy=Sxy/sqrt(Sxx*Syy);

for i=1:N
    y1_corr(i)=x_corr(i)*a_corr+b_corr;
end

figure;plot(x_corr,y_corr,'.');
hold on;plot(x_corr,y1_corr,'k','LineWidth',3);
str_title_ByMRA_corr=['20130119ByMRA Correlation PG3a-PG1a D' int2str(Di)];
title(str_title_ByMRA_corr);
xlabel('PG3a');
ylabel('PG1a');
text(0.05, 0.05,strcat('correlation coeff = ',num2str(corr_ByMRA_PG1a_PG3a_tmp(1,2))),...
                'Units', 'normalized');
saveas(gcf,['K:\draftFigure\Conjugate\',str_title_ByMRA_corr,'.png'], 'png')
end