The run_analysis.R script loads and transforms the UCI  Human Activity dataset into a tidy dataset.


Variables
1. Test data: 30% of data, 2947 observations of 561 variables
2. Train data: 70% of data, 7352 observations of 561 variables
3. Activity: 6 activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
4. Features: 561 variables for which data was collected for each of 30 volunteers; only mean and std are of interest


The Data
30 volunteers each performed the 6 activities wearing a smartphone. Using the accelerometer an gyroscope, a number of measurements were
captured and split two two groups, test and train.


Steps and Transformations
1. Load packages
2. Load test data set components
3. Load train data set components
4. Load activity labels
5. Load features labels
6. Get only mean and standard deviation of each label using the grepl function
7. Parse each character containing values of variables into separate vector
8. Convert character vectors into data frames
9. Replace integers with descriptive names for activity
10. Merge test and train
11. Change variable names to be descriptive by removing unnecessary characters and making readable
12. "Melt" data frame into a long and narrow dataset using reshape2 package
13. Obtain mean for each subject, activity, and variable using dcast function in reshape2 package



