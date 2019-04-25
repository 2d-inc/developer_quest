# Load data from disk.
durations <- read.csv("test_driver/durations.tsv", sep = "\t")

# Uncomment and modify the following line to focus on just a few selected runs.
# durations <- durations[durations$description == "baseline" | durations$description == "statvalue-always-notifies" ,]

# Get just the IDs as a vector.
ids <- aggregate(durations$id, by=list(durations$id), FUN=head)[1]$Group.1
# Get just the date and time from the id.
labels <- substr(ids, 18, 33)

# Setting plot margins.
old.par <- par(no.readonly = TRUE)

# Percentiles
build90 <- aggregate(build ~ description, durations, function(x) quantile(x, c(0.5,0.90)))
build95 <- aggregate(build ~ description, durations, function(x) quantile(x, c(0.5,0.95)))
build99 <- aggregate(build ~ description, durations, function(x) quantile(x, c(0.5,0.99)))
len <- length(build95$description)
labels <- gsub("-", "\n", build95$description)

# Jank chart
pdf("test_driver/builds_bad.pdf", width = 16, height = 9)
par(mar = c(15,6,4,2)+0.1, las = 2)
x <- barplot(t(build95$build), xlim = c(0, max(build99$build)), density = len:1 * 2, angle = len:1 * 90 + 45, names.arg = labels, horiz = TRUE, beside = TRUE)
#arrows(x, build90$build, x, build99$build, length=0.05, angle=90, code=3)
title("Build times worst case")
dev.off()

# CPU time chart
pdf("test_driver/cpu_time.pdf", width = 4, height = 8)
stats <- read.csv("test_driver/perf_stats.tsv", sep = "\t")
mean_with_moe <- function(x) { 
  m <- mean(x)
  std_dev <- sd(x)/sqrt(length(x))
  crit_val <- qt(0.975, df = length(x) - 1)
  moe <- std_dev * crit_val
  df <- data.frame(m, m - moe, m + moe)
  colnames(df) <- c("mean", "lower", "upper")
  return(df)
}
m <- aggregate(expiredTasksDuration ~ description, stats, function(x) mean_with_moe(x)$mean) / 1000
low <- aggregate(expiredTasksDuration ~ description, stats, function(x) mean_with_moe(x)$lower)  / 1000
high <- aggregate(expiredTasksDuration ~ description, stats, function(x) mean_with_moe(x)$upper)  / 1000
x <- barplot(m$expiredTasksDuration, ylim = c(0, max(high$expiredTasksDuration) * 1.1), density = 5, names.arg = m$description, ylab = "CPU time (ms)")
arrows(x, low$expiredTasksDuration, x, high$expiredTasksDuration, length=0.10, angle=90, code=3)
title("CPU time (lower is better)")
dev.off()

# Build durations
pdf("test_driver/builds.pdf", width = 10, height = 10)
par(mar = c(15,6,4,2)+0.1, las = 2)
boxplot(build ~ description, durations, notch = TRUE, boxwex = 0.8)
#axis(1, at = 1:length(ids), labels = labels, las = 2, cex.axis=0.5)
title("Build times")
dev.off()

pdf("test_driver/rasterizations.pdf", width = 10, height = 10)
par(mar = c(15,6,4,2)+0.1, las = 2)
boxplot(rasterizer ~ description, durations, notch = TRUE, boxwex = 0.8, las = 2)
#axis(1, at = 1:length(ids), labels = labels, las = 2, cex.axis=0.5)
title("Rasterizer times")
dev.off()

pdf("test_driver/frame_requests.pdf", width = 10, height = 10)
par(mar = c(15,6,4,2)+0.1, las = 2)
boxplot(frameRequest ~ description, durations, notch = TRUE, boxwex = 0.8, las = 2)
#axis(1, at = 1:length(ids), labels = labels, las = 2, cex.axis=0.5)
title("Frame request pending times")
dev.off()

par(old.par)
