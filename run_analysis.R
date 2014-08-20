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
?grep
mean_header <- grep("mean()",featureHeader,fixed=TRUE) 
std_header <- grep("std()",featureHeader)
required_vec <- c(mean_header,std_header)
req_frame <- featureCompleteDataFrame[required_vec]
activityName <- read.table("./data/UCI HAR Dataset/activity_labels.txt",stringsAsFactors=FALSE)
setnames(activityName, c("serialNo","activity"))
subjectTrainData <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
subjectTestData <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
setnames(subjectTrainData, c("subjectSerialNo"))
setnames(subjectTestData, c("subjectSerialNo"))
subjectCompleteData <- rbind(subjectTrainData,subjectTestData)
?row.names
dataActivityNames <- colnames(req_frame)
rm(dataActivityNames)
activityTrainData <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
activityTestData <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
activityCompleteData <- rbind(activityTrainData,activityTestData)
setnames(activityCompleteData,c("activityNameDataFrame"))
rm(activityTrainData,activityTestData,featureTestDataFrame,featureDataFrame,subjectTrainData,subjectTestData)
?lapply
func <- function(x){if (x==activityName$serialNo){x<- activityName$activity}}
activityVector <- activityCompleteData$activityNameDataFrame

for (i in 1:6){
  activityVector <-replace(activityVector,which(activityVector==i), activityName$activity[i])
}
activityNameDF <- data.frame(activityVector)

setnames(activityNameDF,c("activityType"))
allCompleteDataSet <- cbind(subjectCompleteData,activityNameDF,req_frame)
