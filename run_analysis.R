unzip("./data/getdata-projectfiles-UCI HAR Dataset.zip", exdir ="./data")
list.files("./data/UCI HAR Dataset/test")
featureDataURL <- "./data/UCI HAR Dataset/train/X_train.txt"
featureDataFrame <- read.table(featureDataURL,header=FALSE)
featureCol <- read.table("./data/UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)
library(data.table)
setnames(featureCol, c("serialNo","featureName"))
featureHeader <- featureCol$featureName
setnames(featureDataFrame,featureHeader)
featureTestDataURL <- "./data/UCI HAR Dataset/test/X_test.txt"
featureTestDataFrame <- read.table(featureTestDataURL,header=FALSE)
setnames(featureTestDataFrame,featureHeader)
featureCompleteDataFrame<- rbind(featureDataFrame,featureTestDataFrame, deparse.level=0)
