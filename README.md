# gettingAndCleaningData
This is a repo for the Course Project of "Getting and Cleaning Data". A full description of the data can be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

## Files
The repo contains the following files:
* Codebook.pdf
* courseProjectGettingAndCleaningData.txt
* Readme.md
* run_analysis.R

*Codebook.pdf* contains the description of the variables in the columns of the output data file *courseProjectGettingAndCleaningData.txt* created via *run_analysis.R*. In order to produce the output, the R file needs to be applied on the data files in the [UCI HAR Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) folder. 

## run_analysis.R
The R file consists of the R functions *readGroupData*, *getActivities* and *extractActivityMeans* which are called by the main function *run_analysis* in the given order. The computational steps are the following:  
1. *readGroupData* reads in the necessary data from both the *train* and *test* folder from *subject_test.txt*, *X_test.txt* and *y_test.txt* (or, respectively, *train*). The *subject* and *y* files contain label and subject information on the recorded data in the *X* file.  
2. In order to replace the standard variable names, *getActivities* writes new variable names describing the content to the data frame.  
3. *extractActivityMeans* creates a new data frame displaying the means of the means and standard deviations of the variables concerning variables that only deal with mean and standard deviation in the dataset.  
4. Finally, *run_analysis* returns the data frame created in 3., if no input (or TRUE) is entered. In the case of input FALSE, the functions returns the larger dataset.
