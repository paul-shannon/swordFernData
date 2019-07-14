tbl <- read.table("fern_distances.csv", sep=",", as.is=TRUE, header=TRUE)
rownames(tbl) <- tbl$X
tbl <- tbl[, -1]
t.test(subset(tbl, status!="alive")$min, subset(tbl, status=="alive")$min)$p.value  # [1] 0.006256451
tbl.close <- subset(tbl, min <= 15)
dim(tbl.close)
tbl.far <- subset(tbl, min > 15)
dim(tbl.far)
dim(tbl)
t.test(subset(tbl.close, status!="alive")$min, subset(tbl.close, status=="alive")$min)$p.value  # [1] 0.1612051

boxplot(list(alive=subset(tbl.close, status=="alive")$min, dead=subset(tbl.close, status!="alive")$min),
        main="All Ferns w/in 15 feet of tree or log")




