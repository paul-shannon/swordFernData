adz <- c(0, 2, 0,8,0,0,7,5,2,7,4,5)
gzn <- c(10,16,5, 1,16,12, 8,6,16,16,10,14)
gzs <- c(16,21,12,5, 18,12, 8, 8,12,15, 5, 8)
lapply(list(adz, gzn, gzs), length)

t.test(adz, gzn)          #  3.458e-04
t.test(adz, gzs)          #  1.283e-04
t.test(adz, c(gzn, gzs))  #  1.49e-06
