# Load data from disk.
durations <- read.csv("test_driver/durations.tsv", sep = "\t")

# Get just the IDs as a vector.
ids <- aggregate(durations$id, by=list(durations$id), FUN=head)[1]$Group.1
# Get just the date and time from the id.
labels <- substr(ids, 18, 33)

# Build durations
pdf("test_driver/builds.pdf")
boxplot(build ~ id, durations, notch = TRUE, boxwex = 0.8, xaxt = "n")
axis(1, at = 1:length(ids), labels = labels, las = 2, cex.axis=0.5)
title("Build times")
dev.off()
pdf("test_driver/rasterizations.pdf")
boxplot(rasterizer ~ id, durations, notch = TRUE, boxwex = 0.8, xaxt = "n")
axis(1, at = 1:length(ids), labels = labels, las = 2, cex.axis=0.5)
title("Rasterizer times")
dev.off()
pdf("test_driver/frame_requests.pdf")
boxplot(frameRequest ~ id, durations, notch = TRUE, boxwex = 0.8, xaxt = "n")
axis(1, at = 1:length(ids), labels = labels, las = 2, cex.axis=0.5)
title("Frame request pending times")
dev.off()
