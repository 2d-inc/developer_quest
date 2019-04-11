# Load data from disk.
durations <- read.csv("test_driver/durations.tsv", sep = "\t")

# Get just the IDs as a vector.
ids <- aggregate(durations$id, by=list(durations$id), FUN=head)[1]$Group.1
# Get just the date and time from the id.
labels <- substr(ids, 18, 33)

# Setting plot margins.
old.par <- par(no.readonly = TRUE)

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
