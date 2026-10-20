# MATH319-Data-Cleaning
Data Cleaning assignment for MATH 319 - Data Science II.  

## Description of the Data
The raw data was downloaded from <https://ebird.org/top100> for multiple consecutive years in Cumberland County, PA.  Each page contains a table encoded in html, which I parsed and placed into one large dataframe of all the years.  

eBird is a citizen science project by Cornell University that allows users to submit checklists of birds they see in a single birdwatching outing.  Each checklist contains a time, location, and list of bird species with their counts, among other things.  As a user submits checklists, eBird keeps track of the total number of species and checklists that person has recorded in a particular region and time period (e.g., Cumberland County, 2025, or Pennsylvania, this August, or World, lifetime).  

The table on the top100 page displays the top 100 eBirders, ranked by number of species, in a particular year and place.  The data includes the rank, the user's name, the number of "complete" checklists they submitted, the number of species they recorded that year, the percentage of all the species observed in that region that this user observed, and some details on the last species they added to their list:  the common name, scientific name, and date.  

It is worth noting that I was signed in with my personal account when I downloaded the pages; if you are not signed in, the scientific name won't show up (it is an account setting).  

The cleaned data is an aggregation of several years with 100 observations per year.  The column names are rank, name, checklists, Nspecies, percentTotal, commonName, species, genus, date, and year.  

## Files and Usage
This repository contains two R scripts and the uncleaned data.  

cleaning.r contains the functions needed to clean the data.  The clean() function takes no arguments, reads all the uncleaned data, and produces a single dataframe that can be used in a program.  

runner.r contains a script to demonstrate the clean data by calling clean(),  printing some of it, and manipulating it. 

raw\_html/ contains one html file for each year.  


## Data Cleaning Process
The data cleaning relied heavily on regex from stringr.  

On each dataset, I start by reading the file and eliminating the first portion (1000+ lines) of it.  This is all of the html code before the table starts.  I use a regular expression to seek a pattern that occurs just before the start of the data table I need, and I delete everything up to that point.  I then split the text by a keyword that separates each entry in the table, leaving me with a list of 100 chunks of html code.  Each is mostly filled with tags to filter out.  The last chunk has the whole tail end of the file, which I can ignore.  

After splitting the file into these 100 chunks, I take a look at each and use some regexes to capture the key data I need.  I could have done this with one regex, but I chose to use multiple for simplicity.  Each is long enough to be unique and a little more, with the important datum to be captured inside.  

The trickiest one to capture was probably the name field because the requirements for account name are pretty loose.  The website asks for a full name but doesn't filter out odd characters or force any formatting, so some names are odd.  Not all are capitalized; some have special symbols; some represent multiple people.  

Once each of the 100 lines have been parsed, they are packed together into one dataframe for that year, and then those dataframes are bound together in one large dataset.  
