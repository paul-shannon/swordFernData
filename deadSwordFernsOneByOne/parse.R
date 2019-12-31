library(RUnit)
#------------------------------------------------------------------------------------------------------------------------
toDecimalLoc <- function(s)
{
  tokens <- strsplit(s, "\"")[[1]][1]
  tokens.2 <- strsplit(tokens, "°")[[1]]
  degrees <- as.numeric(tokens.2[1])
  minutes.seconds <- tokens.2[2]
  tokens.3 <- strsplit(minutes.seconds, "'")[[1]]
  minutes <- as.numeric(tokens.3[1])
  seconds <- as.numeric(tokens.3[2])
  result <- degrees + minutes/60 + seconds/60^2
  jitter(result, amount=0.0005)

} # toDecimalLoc
#------------------------------------------------------------------------------------------------------------------------
test_toDecimalLoc <- function()
{
   lat <- "47°33'41\"N"
   x <- toDecimalLoc(lat)
   checkEqualsNumeric(x, 47.56139, tol=1e-5)

} # test_toDecimalLoc
#------------------------------------------------------------------------------------------------------------------------
f <- "Solocator.2019-12-29.15.03.57.csv"
tbl <- read.table(f, sep=",", as.is=TRUE, header=TRUE,nrow=-1, quote=NULL, fill=TRUE)
dim(tbl)
lat <- tbl$Latitude
long <- tbl$Longitude
lats <- unlist(lapply(lat, toDecimalLoc))
longs <- -1 * unlist(lapply(long, toDecimalLoc))

f <- file("locations.js")
line.count <- length(lats) + 3;
lines <- vector("character", line.count)
lines[1] <- "var locations = [";

out.count <- length(lats)

for(i in seq_len(out.count)){
   text <- sprintf("   {lat: %f, lng: %f},", lats[i], longs[i])
   lines[i+1] <- text
   }
lines[i+1] <- "];"

writeLines(lines, f)
close(f)
