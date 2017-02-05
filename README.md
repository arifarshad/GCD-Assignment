# GCD-Assignment
GCD Final Assignment to tidy the UCI dataset
The repo contains the script "run_analysis.R".  The script performs the following actions:
    1.  Downloads the UCI HAR Dataset if not already downloaded.
    2.  Loads and extracts the activity and feature files.
    3.  Reads and filters out variables that are mean or standard deviation measurements.
    4.  Merges the text files into a single dataset.
    5.  Variable names are applied to the columns.
    6.  The id columns are converted to factors.
    7.  The dataset is melted and then cast.
    8.  The output is tidydataset.txt.  This gives the mean for each variable in the dataset for each subject and activity type.
