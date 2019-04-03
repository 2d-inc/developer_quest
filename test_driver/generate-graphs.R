durations <- read.csv("test_driver/durations.tsv", sep = "\t")
pdf("test_driver/durations.pdf")
boxplot(build ~ description, durations, notch = TRUE, boxwex = 0.5, las=2)
dev.off()