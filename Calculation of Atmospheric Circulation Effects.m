
clc;
clear;
seriesname={'SWEI' 'MEI'};
d1=load('D:\thesis\MATLAB_daima\交叉小波_2\交叉小波\wavelet-coherence-master\faq\1979_2022SWEI_monthly.txt');
d2=load('D:\thesis\MATLAB_daima\交叉小波_2\交叉小波\wavelet-coherence-master\faq\1979_2022MEI_monthly.txt');



% 更改 pdf
% 波罗的海冰范围的时间序列是高度双峰的，因此我们将时间序列转换为一系列百分位数。转换后的系列可能对气候的反应“更线性”
d2(:,2)=boxpdf(d2(:,2));

% 连续小波变换 （CWT）
% CWT将时间序列扩展到时频空间
figure('color',[1 1 1])
tlim=[min(d1(1,1),d2(1,1)) max(d1(end,1),d2(end,1))];
subplot(2,1,1);
wt(d1);
title([seriesname{1} ' CWT'], 'FontSize', 18, 'FontWeight', 'bold');  % 设置标题字体大小和加粗
set(gca,'xlim',tlim);
ylabel('Period', 'FontSize', 16, 'FontWeight', 'bold');  % 添加纵轴标签并设置字体大小和加粗
xlabel('Year', 'FontSize', 16, 'FontWeight', 'bold');  % 添加横轴标签并设置字体大小和加粗
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % 设置坐标轴字体大小和加粗

subplot(2,1,2)
wt(d2)
title([seriesname{2} ' CWT'], 'FontSize', 18, 'FontWeight', 'bold');  % 设置标题字体大小和加粗
set(gca,'xlim',tlim);
ylabel('Period', 'FontSize', 16, 'FontWeight', 'bold');  % 添加纵轴标签并设置字体大小和加粗
xlabel('Year', 'FontSize', 16, 'FontWeight', 'bold');  % 添加横轴标签并设置字体大小和加粗
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % 设置坐标轴字体大小和加粗

% 交叉小波变换 （XWT）
% XWT 在时频空间中查找时间序列显示高公共功率的区域
figure('color',[1 1 1])
xwt(d1,d2)
title(['(d1) XWT: ' seriesname{1} '-' seriesname{2}], 'FontSize', 18, 'FontWeight', 'bold');  % 设置标题字体大小和加粗
ylabel('Period/months', 'FontSize', 16, 'FontWeight', 'bold');  % 添加纵轴标签并设置字体大小和加粗
xlabel('Year', 'FontSize', 16, 'FontWeight', 'bold');  % 添加横轴标签并设置字体大小和加粗
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % 设置坐标轴字体大小和加粗

% 小波相干性 （WTC）
% WTC 在时频空间中查找两个时间序列共同变化的区域（但不一定具有高功率）
figure('color',[1 1 1])
wtc(d1,d2)
title(['(d2) WTC: ' seriesname{1} '-' seriesname{2}], 'FontSize', 18, 'FontWeight', 'bold');  % 设置标题字体大小和加粗
ylabel('Period/months', 'FontSize', 16, 'FontWeight', 'bold');  % 添加纵轴标签并设置字体大小和加粗
xlabel('Year', 'FontSize', 16, 'FontWeight', 'bold');  % 添加横轴标签并设置字体大小和加粗
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % 设置坐标轴字体大小和加粗




seriesname = {'SWEI', 'MEI'};
% 读取数据
d1 = load('D:\thesis\MATLAB_daima\小波\小波代码\1979_2022SWEI_monthly.txt');

d2 = load('D:\thesis\MATLAB_daima\小波\小波代码\1979_2022MEI_monthly.txt');


d2(:,2) = boxpdf(d2(:,2));
% 定义时间轴
startYear = 1979;
endYear = 2022;
monthsCount = (endYear - startYear + 1) * 12;
time = linspace(startYear, endYear, monthsCount);
tlim = [1 monthsCount];
% 设置每5年一个时间跨度的标签
years = startYear:5:endYear;
yearIndices = (years - startYear) * 12 + 1; % 计算对应的索引
fontSize = 17;
figure('color', [1 1 1]);
[Rsq,period,scale,coi,sig95]=wtc(d1(:,2), d2(:,2));

% 计算平均小波相干 (AWC)
significant_area = sig95 >= 1;
[significant_rows, significant_cols] = find(significant_area);
% 计算显著性区域的平均 Rsq
AWC = mean(Rsq(significant_area))
%计算PASC
significant_count = sum(sig95(:) >= 1);
total_count = numel(sig95);
% 计算显著性相关的比例
PASC = significant_count / total_count*100;
disp(['Average Wavelet Coherence (AWC): ', num2str(AWC)]);
disp(['Percentage of Significant Coherence Area (PASC): ', num2str(PASC), '%']);



seriesname = {'SWEI', 'MEI'};
% 读取数据
d1 = load('D:\thesis\MATLAB_daima\小波\小波代码\1979_2022SWEI_monthly.txt');

d2 = load('D:\thesis\MATLAB_daima\小波\小波代码\1979_2022MEI_monthly.txt');



d2(:,2) = boxpdf(d2(:,2));
% 定义时间轴
startYear = 1979;
endYear = 2022;
monthsCount = (endYear - startYear + 1) * 12;
time = linspace(startYear, endYear, monthsCount);
tlim = [1 monthsCount];
% 设置每5年一个时间跨度的标签
years = startYear:5:endYear;
yearIndices = (years - startYear) * 12 + 1; % 计算对应的索引
fontSize = 17;
figure('color', [1 1 1]);
[Rsq,period,scale,coi,sig95]=wtc(d1(:,2), d2(:,2));

% 计算平均小波相干 (AWC)
significant_area = sig95 >= 1;
[significant_rows, significant_cols] = find(significant_area);
% 计算显著性区域的平均 Rsq
AWC = mean(Rsq(significant_area))
%计算PASC
significant_count = sum(sig95(:) >= 1);
total_count = numel(sig95);
% 计算显著性相关的比例
PASC = significant_count / total_count*100;
disp(['Average Wavelet Coherence (AWC): ', num2str(AWC)]);
disp(['Percentage of Significant Coherence Area (PASC): ', num2str(PASC), '%']);
















