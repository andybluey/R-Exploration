# OnTime.R - R OnTime script
setwd("C:/TO_YOUR_FOLDER")

# Load the data into a data frame with columns and rows
origData <- read.csv2('.\\Jan_2015_ontime.csv', sep=",", header=TRUE, stringsAsFactors = FALSE)
# We specify the file path, separator, whether the CSV file's 1st row is clumn names, and how to treat strings.
nrow(origData)
# we read in in 469,969 rows of data

# Narrow the list
airports <-c('ATL','LAX', 'ORD', 'DFW', 'JFK', 'SFO', 'CLT', 'LAS', 'PHX')
origData <- subset(origData, DEST %in% airports & ORIGIN %in% airports)
nrow(origData)
# 32,716 rows



#Inspecting and Cleaning Data

head(origData,2)

# Check the end of the data frame with the tail() function.
tail(origData,2)

# Column X has no value. Set it's value to NULL
origData$X <- NULL

head(origData,2)

# In general we want eliminate any columns that we do not need.  
# Eliminate duplicates or highly correlated columns

head(origData,10)
# There are possible correlations between ORIGIN_AIRPORT_SEQ_ID and ORIGIN_AIRPORT_ID
# and between DEST_AIRPORT_SEQ_ID and DEST_AIRPORT_ID.
#  Check correlation using cor()
cor(origData[c("ORIGIN_AIRPORT_SEQ_ID", "ORIGIN_AIRPORT_ID")])
cor(origData[c("DEST_AIRPORT_SEQ_ID", "DEST_AIRPORT_ID")])
# The results for both is 1.
# We can drop the columns ORIGIN_AIRPORT_SEQ_ID and DEST_AIRPORT_SEQ_ID since they are not providing
# any new data
origData$ORIGIN_AIRPORT_SEQ_ID <- NULL
origData$DEST_AIRPORT_SEQ_ID <- NULL

# UNIQUE_CARRIER and CARRIER also look related
mismatched <- origData[origData$CARRIER != origData$UNIQUE_CARRIER,]
nrow(mismatched)
# 0 mismatched, so UNIQUE_CARRIER and CARRIER are identical. Blow away UNIQUE_CARRIER column
origData$UNIQUE_CARRIER <- NULL
# Reveiw the original data
head(origData,2)

onTimeData <- origData[!is.na(origData$ARR_DEL15) & origData$ARR_DEL15!="" & !is.na(origData$DEP_DEL15) & origData$DEP_DEL15!="",]
# Compare the number of rows in the new and old dataframes
nrow(origData)
nrow(onTimeData)

# Change the formats of the columns
onTimeData$DISTANCE <- as.integer(onTimeData$DISTANCE)
onTimeData$CANCELLED <- as.integer(onTimeData$CANCELLED)
onTimeData$DIVERTED <- as.integer(onTimeData$DIVERTED)

#   Let's take the Arrival departure and delay fields.
onTimeData$ARR_DEL15 <- as.factor(onTimeData$ARR_DEL15)
onTimeData$DEP_DEL15 <-as.factor(onTimeData$DEP_DEL15)

# Let also change some other columns factors
onTimeData$DEST_AIRPORT_ID <- as.factor(onTimeData$DEST_AIRPORT_ID)
onTimeData$ORIGIN_AIRPORT_ID <- as.factor(onTimeData$ORIGIN_AIRPORT_ID)
onTimeData$DAY_OF_WEEK <- as.factor(onTimeData$DAY_OF_WEEK)
onTimeData$DEST <- as.factor(onTimeData$DEST)
onTimeData$ORIGIN <- as.factor(onTimeData$ORIGIN)
onTimeData$DEP_TIME_BLK <- as.factor(onTimeData$DEP_TIME_BLK)
onTimeData$CARRIER <- as.factor(onTimeData$CARRIER)

# Find out how many arrival delayed vs non delayed flights.
tapply(onTimeData$ARR_DEL15, onTimeData$ARR_DEL15, length)
# We should check how many departure delayed vs non delayed flights

(6460 / (25664 + 6460))
# The fact that we have a reasonable number of delays (6460 / (25664 + 6460)) = 0.201 ~ (20%) is important.  
