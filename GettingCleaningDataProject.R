#########################################################################
# This is the script for the course project of Getting and cleaning data.
#
#########################################################################

### Libraries 



### Step 1 : Merge the training and the test sets to create one data set.

# First we load the training set
dat <- read.table('UCI HAR Dataset/test/X_test.txt')

# Then we bind the test set 'under' the training set
dat <- rbind(dat, read.table('UCI HAR Dataset/train/X_train.txt'))


### Step 2 : Extracts only the measurements on the mean and standard deviation 
###          for each measurement. 

# We load the features descriptions
feat <- read.table('UCI HAR Dataset/features.txt', 
                   colClasses = c('integer', 'character'))

# We create logical vector which indicates for each column if the name contains
# 'mean()' or 'std()'
colToKeep <- grepl('mean()', feat$V2, fixed = TRUE) | 
             grepl('std()', feat$V2, fixed = TRUE)

# We keep only the columns previously selected
dat <- dat[, colToKeep]


### Step 3 : Uses descriptive activity names to name the activities in the data 
###          set

# We load the activity file for training set
act_dat <- read.table('UCI HAR Dataset/train/y_train.txt')

# Then we load the activity file for test set 'under' the training set
act_dat <- rbind(act_dat, read.table('UCI HAR Dataset/test/y_test.txt'))

# We load the activities labels table
act_lab <- read.table('UCI HAR Dataset/activity_labels.txt')

# We then merge it with the activity data
act_dat <- merge(act_dat, act_lab, by = 'V1')

# Finally, we add a column in the main data set with a descriptive activity name
dat <- cbind(act_dat$V2, dat)


### Step 4 : Appropriately labels the data set with descriptive variable names. 

# We will do that by : 
# (1) labelling the first column 'activityName' because we built it that 
#     way in Step 3
# (2) labelling the other columns using the features names and the logical
#     vector that helped us select the columns in Step 2
colnames(dat) <- c('activityName', feat$V2[colToKeep])


