#installing required packages
install.packages("palmerpenguins") 
#should not install packages multiple times, so do this then delete it, better to type it into the console
install.packages("here")
install.packages("janitor")
#loading packages into R (can be done in script)
library(palmerpenguins)
library(tidyverse)
library(here)
library(janitor)



here::here() #type in console to return current path to project
#set working directory to PenguinProject using session at top of screen
data(package = "palmerpenguins")
view(penguins_raw)
head(penguins_raw)
colnames(penguins_raw) #column names are bad due to spaces, random capitalization, brackets, slashes
#tempting to open in excel and change column names, must NEVER do this!!! as it overwrites original file making the science unreproducible



#preserving raw data by saving original un-meddled copy
write.csv(penguins_raw, here("Datta", "penguins_raw.csv"))
#"here" means you don't need to write folder names in code, and can change where in computer files that "datta" folder is



#remove comments column from raw_pengions dataset
penguins_raw <- select(penguins_raw, -Comments)
colnames(penguins_raw) #no loger a "comments" column
#this is bad practice as it is overwriting file
#now loading original file again (has all the columns in it)
penguins_raw <- read_csv(here("Datta", "penguins_raw.csv"))
colnames(penguins_raw) #checking all columns are back
#***best practice = make new varaible for dataset, then change this new one as much as we want
penguins_clean <- select(penguins_raw, -Comments)
colnames(penguins_raw) #original dataset is safe
colnames(penguins_clean) #new dataset has been changed as we wanted
penguins_clean <- select(penguins_clean, -starts_with("Delta")) #removes any columns that start with "delta"
colnames(penguins_clean)
#still overwriting dataset (not good)

#Cleaned up dtaa variables so that the bad code would not mess with the stuff I'm trying to do

#*best practice
#alternate way to remove columns = piping (reads as "and then" do next line of code)
#use piping (aka %>%) to remove columns, write using shift+control+M
penguins_clean <- penguins_raw %>% 
  select(-Comments) %>% 
  select(-starts_with("Delta")) %>% 
  clean_names() #janitor library, removes capitalization / spaces / brackets / slashes for ALL columns
#if we were to switch order to remove colums after, would have to take into account the fact that column names have chenged
    #so would do -comments, rather -Comments
colnames(penguins_clean) #checking that piping has worked



#variable names should not be "penguin2", should have meaning (eg penguinClean)
#saving modified dataset (pengions_clean rather than penguins_raw)
write.csv(penguins_clean, here("Datta", "penguins_clean.csv"))



#coding process = cleaning code (see lines above, making dataset useable), analysing code (statistics), visualising code (graphs)

#creating a function in R (this will be cleaning penguin columns:
cleaning_pengion_columns <- function(raw_data){ #raw data = generic dataset, denotes the thing that needs to go inside the brackets of this function
  raw_data %>% 
    select(-Comments) %>% 
    select(-starts_with("Delta"))%>% 
    clean_names()
}
#therefore function will take raw dataset, then remove Comments and Delta, then clean up names
penguins_clean <- cleaning_pengion_columns(penguins_raw) #checking function works
colnames(penguins_clean) #function works!!!



#loading data from another script (script then acts as a library)
source(here("functions", "cleaning.R"))
#can now use the functions named in that file
#for example
penguns_testfunction <- clean_column_names(penguins_raw)
colnames(penguins_raw) #for comparison to see original
colnames(penguns_testfunction) #the function works!!!! yay


#intsall.packages is bad
#use rnv instead (environment for code), by ticking box when craeting new markdown file
install.packages("renv")
renv::init() #renv folder will show up in penguinproject
renv::snapshot() #puts installed packages into renv folder
renv::restore() #synchronises packages you have with packages in lockfile
renv::diagnostics() #looks at what is inside renv file (shows me there are 107 packages)





  