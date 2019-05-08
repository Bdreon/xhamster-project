# Input Directory

This directory should contain unedited data files directly from the source. I typically put different data sources into different sub-directories and include any relevant data documentation in the same directory. 

Following the guidelines of [Code and Data](https://web.stanford.edu/~gentzkow/research/CodeAndData.xhtml#magicparlabel-270), this directory is dedicated to raw data from other sources ONLY. Datasets in this input directory should NEVER be edited. If newer data extracts are used, older raw data should just be replaced and changes commmitted. Constructed datasets should NEVER be placed in this directory. 


#Data for current project

The datasets for this project were collected from http://sexualitics.github.io/ The "xhamster.csv.tar.gz" file contains an exhaustive list of every video uploaded to the website Xhamster "from its creation in 2007 until February 2013," comprising almost 800,000 cases. There is no codebook for this dataset, however the website lists its variables as follows:
upload_date: day the video was uploaded
title: title of the video
channels: a list of tags associated with the video
description: description of the video, appears to be the uploader's description
nb_views: number of times the video has been displayed
nb_votes: number of users who voted for or against the video
nb_comments: number of comments posted to the video
runtime: length of video, in seconds
uploader: anonymized identifier of uploader's username

The second dataset was also collected from the same website (http://sexualitics.github.io/), and is listed as "Category Rankings," with the description "various ranking methods for all categories in xHamster and XNXX." THe dataset does not have a codebook, and contains 5 variables: tag, occurence, novelty, popularity, user_reaction. No further information is provided on this dataset.