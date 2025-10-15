%%%%%%计算每个像元一年中SWE峰值月份的SWEI,年值%%%%%%%%%%%%
%%%输出年值%%%%%
clc;
clear;

% 路径设置
datadir = 'D:\PhD1\mp_swe\1950-2025swe_nc\';
datadirout = 'D:\PhD1\mp_swe\1950_2025mp_swei_tif1\';
ncFilePath = [datadir, 'data_stream-moda.nc'];

% 读取数据
latnew = ncread(ncFilePath, 'latitude');     % 251x1
lonnew = ncread(ncFilePath, 'longitude');    % 501x1
valid_time = ncread(ncFilePath, 'valid_time'); % 905x1
SD = ncread(ncFilePath, 'sd');               % 501x251x905
SD(SD == 3.402823466385289e+38) = NaN;

[nlon, nlat, ntime] = size(SD);
SWEI = NaN(nlon, nlat, ntime);
sc = 3;

% SWEI 计算
for s = 1:nlon
    for t = 1:nlat
        td = squeeze(SD(s,t,:));
        td(td < 0) = 0;
        n = length(td);
        SI = NaN(n,1);

        if sum(~isnan(td)) == n
            SI(1:sc-1) = NaN;
            A1 = [];
            for i = 1:sc
                A1 = [A1, td(i:n-sc+i)];
            end
            Y = sum(A1, 2);
            nn = length(Y);
            SI1 = NaN(nn,1);
            for k = 1:12
                d = Y(k:12:nn);
                d(d == 0) = rand() * 1.5e-4;
                nnn = length(d);
                bp = arrayfun(@(x) sum(d <= x), d);
                y = (bp - 0.44) ./ (nnn + 0.12);
                SI1(k:12:nn) = norminv(y);
            end
            SI(sc:end) = SI1;
        end
        SWEI(s,t,:) = SI;
    end
    fprintf('已完成经度像元 %d/%d\n', s, nlon);
end

% 时间转换
time_dt = datetime(1970,1,1) + seconds(valid_time);
time_years = year(time_dt);
years = unique(time_years);
nyear = length(years);

% 提取每年最大SWE对应的SWEI值
outSwei = NaN(nlon, nlat, nyear);
for y = 1:nyear
    idx = find(time_years == years(y));
    swe_temp = SD(:,:,idx);
    swei_temp = SWEI(:,:,idx);
    [~, max_idx] = max(swe_temp, [], 3);
    for i = 1:nlon
        for j = 1:nlat
            if ~isnan(max_idx(i,j))
                outSwei(i,j,y) = swei_temp(i,j,max_idx(i,j));
            end
        end
    end
end

% 写出每年SWEI为 GeoTIFF
for ii = 1:nyear
    data = squeeze(outSwei(:,:,ii));  % 501x251
    data = rot90(data,1);  % 注意方向是否需要调整
    Reference = georasterref('RasterSize', size(data), ...
        'Latlim', double([min(latnew), max(latnew)]), ...
        'Lonlim', double([min(lonnew), max(lonnew)]));
    Tiffoutname = sprintf('MP-swei-%d.tif', years(ii));
    geotiffwrite(fullfile(datadirout, Tiffoutname), data, Reference);
end

disp('所有年份处理完成。');



clc;
clear;
[a,R]=geotiffread('D:\PhD1\MP\MP1951_2021_SWEI_year\MP-swei-1951.tif'); %先导入投影信息
info=geotiffinfo('D:\PhD1\MP\MP1951_2021_SWEI_year\MP-swei-1951.tif');%先导入投影信息
[m,n]=size(a);
cd=1959-1951+1;      %21年，时间跨度  
datasum=zeros(m*n,cd)+0;   %生成一个像素个数*年数的矩阵
p=1;
for year=1951:1959   %起止年份
    filename=['D:\PhD1\MP\MP1951_2021_SWEI_year\MP-swei-',int2str(year),'.tif']; %读入文件名 如D:\qixiang\年全国8kmPET\china2000.pet.tif(china2000pet.tif)
    data=importdata(filename);  %导入数据
    data=reshape(data,m*n,1);   %reshape 改变矩阵形式为m*n行、1列
    datasum(:,p)=data;          %把每年的数据依次放到datasum的每一列
    p=p+1;
end
sresult=zeros(m,n);
result=zeros(m,n);
for i=1:size(datasum,1)
    data=datasum(i,:);
    if min(data)>-2.42479       % 有效格点判定，我这里有效值在0以上
        sgnsum=[];  
        for k=2:cd       %作用类似于sgn函数    xj-xi>0,sgn=1; xj-xi=0,sgn=0; xj-xi<0,sgn=-1;   (后减前)
            for j=1:(k-1)
                sgn=data(k)-data(j);
                if sgn>0
                    sgn=1;
                else
                    if sgn<0
                        sgn=-1;
                    else
                        sgn=0;
                    end
                end
                sgnsum=[sgnsum;sgn];  %在sgnsum后面再加上sgn
            end
        end  
        add=sum(sgnsum);
        sresult(i)=add;  %检验统计量S
    end
end
for i=1:size(datasum,1)         
    data=datasum(i,:);          %第i列赋值给data
    if min(data)>0              %判断是否是有效值,我这里的有效值必须大于0  
        valuesum=[];
        for k1=2:cd
            for k2=1:(k1-1)
                cz=data(k1)-data(k2);    %(后减前)
                jl=k1-k2;
                value=cz./jl;
                valuesum=[valuesum;value];  %在valuesum后面再加上value
            end
        end
        value=median(valuesum);   
        result(i)=value;   %Sen趋势度B  B>0上升   B<0下降
     end
end
 
vars=cd*(cd-1)*(2*cd+5)/18;
zc=zeros(m,n);
sy=find(sresult==0);    %|Z|>1.96变化显著，|Z|<=1.96时变化不显著
zc(sy)=0;                             %S=0时
sy=find(sresult>0);
zc(sy)=(sresult(sy)-1)./sqrt(vars);   %S>0时       
sy=find(sresult<0);
zc(sy)=(sresult(sy)+1)./sqrt(vars);   %S<0时
 
result1=reshape(result,m*n,1);
zc1=reshape(zc,m*n,1);
tread=zeros(m,n);
for i=1:size(datasum,1)
    %result1(i)
    if result1(i)>0   % Sen趋势B>0  上升     
        if abs(zc1(i))>=2.58    %极显著上升
            tread(i)=4;
        elseif (1.96<=abs(zc1(i)))&&(abs(zc1(i))<2.58)      %显著上升  
            tread(i)=3;
        elseif (1.645<=abs(zc1(i)))&&(abs(zc1(i))<1.96)     %微显著上升
            tread(i)=2;
        else		%不显著上升
            tread(i)=1;
        end
        elseif result1(i)<0  % Sen趋势B<0  下降 
        if abs(zc1(i))>=2.58   %极显著下降
            tread(i)=-4;
        elseif (1.96<=abs(zc1(i)))&&(abs(zc1(i))<2.58)  %显著下降
            tread(i)=-3;
        elseif (1.645<=abs(zc1(i)))&&(abs(zc1(i))<1.96)   %微显著下降
            tread(i)=-2;
        else			%不显著下降
            tread(i)=-1;
        end
        else
            tread(i)=0;      % 无变化
    end
end
geotiffwrite('D:\PhD1\MP\MP1951_2021_SWEI_year\sweitread_mp_1950s.tif',tread,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)%注意修改路径
