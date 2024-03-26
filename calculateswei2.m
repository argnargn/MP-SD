%% 读取NC文件
datadir = 'D:\boyi\snow depth water equivalent\1950-2021nc\'; %指定批量数据所在的文件夹
ncdisp('-65-65sc.nc');
lon=ncread('-65-65sc.nc','longitude');%读取经度变量
lat=ncread('-65-65sc.nc','latitude');%读取纬度变量
ncFilePath=['D:\boyi\snow depth water equivalent\1950-2021nc\','-65-65sc.nc'];
SD=SWEI;
    m=1950; %初始年份
    n=1;
    row=73; % row 为具体的年数量
    YM=zeros(row*12,2); 
for j=1:row*12
    if mod(j,12)~=0
        YM(j,2)=n;
        n=n+1;
         YM(j,1)=m;
    else
        YM(j,2)=12;
    end

     if n>=12
        n=1;
        m=m+1;     
     end
end
for i=1:size(YM,1)
    if YM(i,1)==0
    YM(i,1)=YM(i-1,1);
    end
end
StudyPeriod=YM(1:row*12,:);
for i=1:12:size(StudyPeriod,1)
    Year=StudyPeriod(i,1);
	mkdir('D:\boyi\snow depth water equivalent\1950-2022result')%按年份新建文件夹
	filefolder=	['D:\boyi\snow depth water equivalent\1950-2022result\','\']%输出到新建文件夹的路径;
    month_data=SD(:,:,i:i+11);
    for month=1:9
        monthair=month_data(:,:,month); 
		monthair =rot90(monthair,1);
    Reference = georasterref('RasterSize', size(monthair),'Latlim', [double(-65) double(65)], 'Lonlim', [double(180) double(180)]);
    Tiffoutname=strcat('global-swei-',num2str(Year),'0',num2str(month));
	filename1=[filefolder,Tiffoutname,'.tif'];
    geotiffwrite(filename1,monthair,Reference);
    end
	for month=10:12
        monthair=month_data(:,:,month); 
		monthair =rot90(monthair,1);
    Reference = georasterref('RasterSize', size(monthair),'Latlim', [double(-65) double(65)], 'Lonlim', [double(180) double(180)]);
    Tiffoutname=strcat('global-swei-',num2str(Year),num2str(month));
	filename1=[filefolder,Tiffoutname,'.tif'];
    geotiffwrite(filename1,monthair,Reference);
    end
end
