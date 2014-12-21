#########################################################################
# This is the script for the course project of Getting and cleaning data.
#
#########################################################################


### Step 1 : Merge the training and the test sets to create one data set.

# First we load the training set
dat <- read.table('UCI HAR Dataset/train/X_train.txt')

# Then we bind the test set 'under' the training set
dat <- rbind(dat, read.table('UCI HAR Dataset/test/X_test.txt'))

# In the same way, we load and binds together the subject file
sub_dat <- read.table('UCI HAR Dataset/train/subject_train.txt')
sub_dat <- rbind(sub_dat, read.table('UCI HAR Dataset/test/subject_test.txt'))
colnames(sub_dat) <- c('subjectId')

# In the same way, we load and binds together the activity file
act_dat <- read.table('UCI HAR Dataset/train/y_train.txt')
act_dat <- rbind(act_dat, read.table('UCI HAR Dataset/test/y_test.txt'))
colnames(act_dat) <- c('activityId')

# Finally we add the two columns to the main data set
dat <- cbind(act_dat, sub_dat, dat)


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

# We load the activities labels table
act_lab <- read.table('UCI HAR Dataset/activity_labels.txt', 
                      col.names = c('activityId', 'activityName'))

# We then merge it with the activity data (we do not want to re-sort the data,
# we want to keep all the rows of 'dat' but do not care if all the values in 
# 'act_lab' appear)
dat <- merge(x = dat, y = act_lab, by = c('activityId'), 
             all.x = TRUE, all.y = FALSE, sort = FALSE)


### Step 4 : Appropriately labels the data set with descriptive variable names. 

# We proceed as follows : 
# (1) the first column is 'activityId' (cf. Step 1 and 3)
# (2) the second column is 'subjectId' (cf. Step 1)
# (3) the last column is 'activityName' (cf. Step 3)
# (3) we label the other columns using the features names and the logical
#     vector that helped us select the columns in Step 2
colnames(dat) <- c('activityId', 'subjectId', feat$V2[colToKeep], 
                   'activityName')


### Step 5 : From the data set in step 4, creates a second, independent tidy 
###          data set with the average of each variable for each activity and 
###          each subject.


# We load the library we need
library(reshape2)

# We melt the data into a long table
md <- melt(dat, id.vars = c('subjectId', 'activityName'), measure.vars = 3:68)

# We then cast it into a table in which each line correspond to one subject for
# one activity (stated in columns 1 and 2). Columns 3 to 68 show the mean of
# the different variables for the subject and the activity of the line.
dc <- dcast(md, subjectId + activityName ~ variable, mean)

# Finally, we write the resulting table into a text file
write.table(dc, file = 'tidy_data.txt', row.names = FALSE)
