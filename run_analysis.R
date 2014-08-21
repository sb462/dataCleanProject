# Data is downloaded and saved in ./data folder, below command extracts the files 
unzip("./data/getdata-projectfiles-UCI HAR Dataset.zip", exdir ="./data")
# To get the filenames
list.files("./data/UCI HAR Dataset/test")
# Reading the Readme file and features_info and features file and by inspecting the data in notepad++, X_train contains
# 561 dimension feature vector data for each subject. Read and extracted it into data.frames. fread() does not work for
# the leading whitespace hence using slower read.table command
featureDataURL <- "./data/UCI HAR Dataset/train/X_train.txt"
featureDataFrame <- read.table(featureDataURL,header=FALSE)
# Data files have data only, need to combine the headers from features file. Make a vector out of the the features and 
# combine the vectir as header of the data
featureCol <- read.table("./data/UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)
library(data.table)
setnames(featureCol, c("serialNo","featureName"))
featureHeader <- featureCol$featureName
setnames(featureDataFrame,featureHeader)
# Repeating the above excercise with test data
featureTestDataURL <- "./data/UCI HAR Dataset/test/X_test.txt"
featureTestDataFrame <- read.table(featureTestDataURL,header=FALSE)
setnames(featureTestDataFrame,featureHeader)
# joining test and training data set
featureCompleteDataFrame<- rbind(featureDataFrame,featureTestDataFrame, deparse.level=0)
# extracting only mean() and std() of feature header constructed
mean_header <- grep("mean()",featureHeader,fixed=TRUE) 
std_header <- grep("std()",featureHeader)
required_vec <- c(mean_header,std_header)
# subsetting the data to extract mean and std measurements only
req_frame <- featureCompleteDataFrame[required_vec]
# reading activity labels 
activityName <- read.table("./data/UCI HAR Dataset/activity_labels.txt",stringsAsFactors=FALSE)
setnames(activityName, c("serialNo","activity"))
# reading subject data
subjectTrainData <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
subjectTestData <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
setnames(subjectTrainData, c("subjectSerialNo"))
setnames(subjectTestData, c("subjectSerialNo"))
subjectCompleteData <- rbind(subjectTrainData,subjectTestData)
# reading activity data for test and train
activityTrainData <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
activityTestData <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
activityCompleteData <- rbind(activityTrainData,activityTestData)
setnames(activityCompleteData,c("activityNameDataFrame"))
rm(activityTrainData,activityTestData,featureTestDataFrame,featureDataFrame,subjectTrainData,subjectTestData)


# replacing activity indicators with descriptive activity names
activityVector <- activityCompleteData$activityNameDataFrame

for (i in 1:6){
  activityVector <-replace(activityVector,which(activityVector==i), activityName$activity[i])
}
activityNameDF <- data.frame(activityVector)

setnames(activityNameDF,c("activityType"))
# Constructing the complete data set
allCompleteDataSet <- cbind(subjectCompleteData,activityNameDF,req_frame)

#creating tidy data taking mean for every subject and every activity
tData <- aggregate(allCompleteDataSet[-c(1:2)],by = list(allCompleteDataSet$subjectSerialNo,allCompleteDataSet$activityType), mean)
library(data.table)
setnames(tData,1:2, c("subjectID", "subjectActivity"))
#writing output data to a txt file
write.table(tData, file = "./data/activityDataTidy.txt", sep ="\t",row.names = FALSE)
