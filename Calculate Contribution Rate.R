########方差分解+新罗马体
# 加载vegan包（如果尚未安装，请先安装）
if (!require(vegan)) install.packages("vegan")
library(vegan)

# 设置数据文件路径
data_path <- "D:/PHD3/drivers_clipped_by_decade/humid_drive/h2010s/h2010s_ExtractedResults/h_2010s_Processed.csv"

# 读取CSV数据
data <- read.csv(data_path, header = TRUE)

# 查看数据结构
str(data)

# 提取响应变量和解释变量组
response <- data[, 1]            # 响应变量
Climate  <- data[, 2:8]          # 气候因素
Topographic <- data[, 9:14]      # 地形因素
Extremeclimate <- data[, 15:19]  # 极端气候因素

# 进行方差分解分析
vpa_result <- varpart(response, Climate, Topographic, Extremeclimate)

# 输出分析结果
print(vpa_result)
print(vpa_result$part)

# 设置字体（Windows系统）
windowsFonts(TNR = windowsFont("Times New Roman"))

# 设置输出路径及300 DPI图像参数（单位为像素）
jpeg(filename = "D:/PHD3/drivers_clipped_by_decade/humid_drive/h2010s/h2010s_ExtractedResults/VPA_plot_Humid 2010s.jpeg",
     width = 3000, height = 2400, res = 300)

# 设置字体为 Times New Roman
par(family = "TNR")

# 绘制VPA图（移除“Value < 0 not shown”）
plot(vpa_result,
     bg = c("#EF476F", "#FFD166", "#26547C"),
     Xnames = c("Meteorology", "Topography", "Extreme climate"),
     id.size = 3.5,
     cex = 2.5,
     show.values = FALSE,  # ← 取消右下角提示
     cutoff = 0)           # ← 显示全部解释量（包括负值，注意解释意义）

# 添加标题
title("(e7) Humid 2010s", cex.main = 4, font.main = 2)

# 保存并关闭图形设备
dev.off()
