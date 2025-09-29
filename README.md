# Human Activity Recognition — Getting & Cleaning Data (Course Project)

This repository contains the course project solution for the "Getting and Cleaning Data" assignment (Coursera).  
It processes the UCI HAR Dataset (Human Activity Recognition using Smartphones) and produces a tidy dataset with the average of each selected variable for each activity and each subject.

## Files
- `run_analysis.R`  
  The single R script that:
  1. Downloads and unzips the UCI HAR Dataset (if needed).  
  2. Reads feature, activity, training and test data.  
  3. Merges training and test datasets into one.  
  4. Extracts only mean() and std() measurements.  
  5. Replaces activity IDs with descriptive activity names.  
  6. Cleans and makes variable names descriptive.  
  7. Produces a tidy dataset with the average of each variable for each activity and subject and writes it to `tidy_dataset.txt`.

- `tidy_dataset.txt` (generated after running `run_analysis.R`)  
  A space-separated text file with one row per subject+activity and columns for averaged variables. Use `read.table("tidy_dataset.txt", header = TRUE)` to load.

## Data source
The original raw dataset used by this script is available here:  
`https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`

## How to run
1. Clone this repository:
   ```bash
   git clone <your-repo-url>
   cd <your-repo-folder>
