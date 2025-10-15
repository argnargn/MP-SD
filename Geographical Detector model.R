setwd("D:/PHD3/drivers_clipped_by_decade/humid_drive/h2010s/h2010s_ExtractedResults/")
##install.packages("GD")##下载一下GD包
library('GD')
test <- read.csv("h_2010s_Processed.csv")#这里注意保存为csv格式的文件，后续不会报错

# 查看数据的前几行
head(test)

# 定义离散化方法和区间数
discmethod <- c("equal", "natural", "quantile", "geometric")
discitv <- c(4:15)

# 假设你的数据框名称是 test
# 确保 Y 列和所有自变量列都在 test 数据框中

test.fd <- gdm(                                             
  SWEI ~ TEM + PRE + RH + VPD + SM + SSR + WS + DEM + ASPECT + SLOPE + TWI + TPI + WEI
  + CDD + CSDI + ID0 + TN10p + TX10p,
  continuous_variable = c("TEM", "PRE", "RH", "VPD", "SM", "SSR", "WS", "DEM", "ASPECT", "SLOPE",
                          "TWI", "TPI", "WEI", "CDD", "CSDI", "ID0", "TN10p", "TX10p" ),
  data = test,
  discmethod = discmethod,  # 保留原参数
  discitv = discitv  # 保留原参数
)

# 打印分析结果
test.fd

# 设置 PDF 图形设备和字体
pdf("h_2010s.pdf", family = "Times", width = 9, height = 8) # 设置图形设备为PDF，字体为Times New Roman

# 绘制结果的图表
plot(test.fd)

# 关闭图形设备
dev.off()

# 提取交互检测结果和因子检测的q值
交互 <- test.fd[["Interaction.detector"]][["Interaction"]]
q值 <- test.fd[["Factor.detector"]][["Factor"]]

# 提取风险检测和生态检测的结果
风险探测 <- test.fd[["Risk.mean"]]
生态探测 <- test.fd[["Ecological.detector"]][["Ecological"]]

# 提取分类结果
分类 <- test.fd[["Discretization"]]

# 提取X1到XN的分类结果
result_list <- lapply(分类, function(x) {
  data.frame(method = x$method, n.itv = x$n.itv)
})

# 将结果组合为一个数据框
result_df <- do.call(rbind, result_list)

# 提取X1到XN的风险检测结果
result_list2 <- lapply(风险探测, function(x) {
  data.frame(Mean = x$meanrisk, itv = x$itv)
})

# 将结果组合为一个数据框
result_df2 <- do.call(rbind, result_list2)

# 导出因子探测结果
write.csv(q值, file = "h_2010s单因子显著情况及q值表.csv", row.names = FALSE, fileEncoding = "UTF-8")

# 导出生态探测结果
write.csv(生态探测, file = "h_2010s生态探测结果表.csv", row.names = FALSE, fileEncoding = "UTF-8")

# 导出交互探测结果
write.table(交互, file = "h_2010s因子交互探测结果表.csv", sep = ",", row.names = TRUE, fileEncoding = "UTF-8")

# 导出分类结果
write.table(result_df, file = "h_2010s最优离散化类别及分类数.csv", sep = ",", row.names = TRUE, fileEncoding = "UTF-8")

# 导出风险探测结果
write.table(result_df2, file = "h_2010s风险探测结果表.csv", sep = ",", row.names = TRUE, fileEncoding = "UTF-8")
