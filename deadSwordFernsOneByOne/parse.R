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
#f <- "Solocator.2019-12-29.15.03.57.csv"
#f.in <- "Solocator.2020-01-06.06.22.23.csv"
#f.out <- "locations-05jan2020.js"
# f.in <- "Solocator.2020-01-12.19.20.26.csv"
# f.out <- "locations-12jan2020.js"
#f <- "Solocator.2020-01-12.19.20.26.csv"
#f <- "19jan2020.csv"

f.in <- "download-02feb2020.csv"
f.out <- "locations-02feb020.csv"

run <- function()
{
   tbl <- read.table(f.in, sep=",", as.is=TRUE, header=TRUE,nrow=-1, quote=NULL, fill=TRUE)
   dim(tbl)
   lat <- tbl$Latitude
   lat <- as.numeric(sub("°", "", lat))
   long <- tbl$Longitude
   long <- as.numeric(sub("°", "", long))

   lats <- jitter(lat, amount=0.0005)
   longs <- jitter(long, amount=0.0005)

# lats <- unlist(lapply(lat, toDecimalLoc))
   # longs <- -1 * unlist(lapply(long, toDecimalLoc))

   js.file <- file(f.out)

   line.count <- length(lats) + 3;
   lines <- vector("character", line.count)
   lines[1] <- "var locations = [";

   out.count <- length(lats)

   for(i in seq_len(out.count)){
      text <- sprintf("   {lat: %f, lng: %f},", lats[i], longs[i])
      lines[i+1] <- text
      }
   lines[i+1] <- "];"

   writeLines(lines, js.file)
   close(js.file)
   }
