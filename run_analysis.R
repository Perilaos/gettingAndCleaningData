run_analysis <- function(returnCondensedDataFrame = TRUE){
  
  # Assignment step 1: merge training and test data set to one single data set
  testData  <- readGroupData("test") 
  trainData <- readGroupData("train")
  newFrame <- rbind(trainData,testData)
  
  # Assignment step 2: extract only measurements on mean and std for each measurement
  newFrame <- newFrame[,grep("subject|activities|mean|std",names(newFrame))]
  
  # Assignment step 3: rename activities via subfunction getActivities below
  newFrame <- getActivities(newFrame)
  
  # Assignment step 5 (if input argument is set to TRUE)
  if (returnCondensedDataFrame == TRUE){
    newFrame <- extractActivityMeans(newFrame)
  }
  newFrame
}

# readGroupData (subfunction for step 1)
readGroupData <- function(groupName){
  giveImportString <- function(str,upperDirectory = TRUE){
    if (upperDirectory) {
      ## filename string for data in upper directory
      paste("UCI HAR Dataset/",groupName,"/",str,"_",groupName,".txt",sep ="")
    }
    else{
      ## filename String for data in Inertial Signals
      paste("UCI HAR Dataset/",groupName,"/Inertial Signals/",str,".txt",sep ="")
    }   
  }
  
  activities <- read.table(giveImportString("y"))        ## labels: 7352 x 1 (training) or 2947 x 1 (test)
  subject    <- read.table(giveImportString("subject"))  ## subject: same size as labels
  features   <- read.table(giveImportString("X"))        ## traning or test set: 7352 x 561 or 2947 x 561
 
  featureNames <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
  D <- data.frame(subject,activities,features)           ## dataFrame containing all data
  names(D) <- c("subject","activities",featureNames)
  D
} 

# getActivities (subfunction for step 3)
getActivities <- function(dataFrame){
  # import activity labels from file
  activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)[,2]
  numberOfRows <- nrow(dataFrame)
  newColumn <- character(numberOfRows)
  # rename activities
  for (k in 1:numberOfRows) {
    newColumn[k] <- activityLabels[dataFrame[k,"activities"]]
  }
  dataFrame[,"activities"] <- newColumn
  dataFrame
}

# extractActivityMeans (subfunction for step 5)
extractActivityMeans <- function(dataFrame){
  require(dplyr)
  # import activity labels
  activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)[,2]
  # create empty data frame with same variable names as original data frame
  newFrame <- data.frame(matrix(vector(), 0, ncol(dataFrame), 
                                dimnames=list(c(), names(dataFrame))), stringsAsFactors=FALSE)
  
  for (j in 1:30){ # iterate over subjects
    for (k in 1:6){ # iterate over activities
      dataFrameRow <- data.frame(j,activityLabels[k])
      names(dataFrameRow) <- c("subject","activities")
      
      dataFrameFilt <- filter(dataFrame, subject == j & activities == activityLabels[k])
      activityMeans <- colMeans(dataFrameFilt[,3:81])
      dataFrameRow  <- cbind(dataFrameRow,t(activityMeans))
      # add single row to data row
      newFrame <- rbind(newFrame,dataFrameRow)
    }
  }
  newFrame
}
