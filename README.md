GetDataProject
==============

*Getting and cleaning data* course's project

## General presentation

The repository contains the following files :

* **README.md** - this file 
* **CodeBook.md** - the code book explaining the content of the data file
* **tidy_data.txt** - the required data file
* **run_analysis.R** - R script creating the data file and performing the five 
required steps of the assignement. The code should be appropriately commented. 

## Notes and choices

* As stated in the assignement, the R code is working *as long as the Samsung data is in your working directory*. It means the data folder *UCI HAR Dataset* should be in your working directory.
* On step 2 : *Extracts only the measurements on the mean and standard deviation for each measurement.*, we only kept the variable with *mean()* and *std()* functions at the end. We **did not keep** variables ending with *meanFreq()* (for instance *fBodyAcc-meanFreq()*) since 
their mean was already accounted for through other variable (e.g. *fBodyAcc-mean()*).
