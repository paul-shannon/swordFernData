tbl.logs <- read.table("logs.tsv", sep=",", as.is=TRUE, header=TRUE, stringsAsFactor=FALSE)
tbl.trees <- read.table("trees.tsv", sep=",", as.is=TRUE, header=TRUE,nrow=-1, stringsAsFactor=FALSE)
tbl.healthyFerns <- read.table("healthyFerns.tsv", sep=",", as.is=TRUE, header=TRUE,nrow=-1, stringsAsFactor=FALSE)
tbl.deadFerns <- read.table("deadFerns.tsv", sep=",", as.is=TRUE, header=TRUE,nrow=-1, stringsAsFactor=FALSE)

with(tbl.deadFerns, plot(x,y, xlim=c(-30, 65), ylim=c(-35, 50), main="Seward Park Ground Zero 5-year Fern Survival"))
with(tbl.healthyFerns, points(x,y, col="green", pch=16))
# pull out then rescale dbh into good sizes for the map, preserving relative diameters (more or less)
dbh <- tbl.trees$dbh
factor <- 20   # experimentally derived
dbh.transformed <- 1 + as.integer(dbh/factor)
unique(tbl.trees$species)
# "ACMA" "TSME" "COCO" "PSME.stump" "THPL"
tree.color.map <- c(ACMA="blue", TSME="magenta", COCO="orange", PSME.stump="darkGreen", THPL="darkRed")
tree.colors <- as.character(tree.color.map[tbl.trees$species])
#with(tbl.trees, points(x, y, col="lightblue", pch=16, cex=dbh.transformed))
with(tbl.trees, points(x, y, col=tree.colors, pch=16, cex=dbh.transformed))
with(tbl.logs, lines(x=c(x[1], x[2]), y=c(y[1], y[2]), lwd=10))
with(tbl.logs, lines(x=c(x[3], x[4]), y=c(y[3], y[4]), lwd=20))
with(tbl.logs, lines(x=c(x[5], x[6]), y=c(y[5], y[6]), lwd=8))

legend(52.5, 52, names(tree.color.map), as.character(tree.color.map))
