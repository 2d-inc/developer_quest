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
