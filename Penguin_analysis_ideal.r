# ----------------------------------------------------------------
#            NOT IN THE SCRIPT, DO THIS IN THE CONSOLE ONLY 
# ----------------------------------------------------------------

# We want to make sure anything we install is saved in a folder called renv.
# This is so we can keep track of the packages we use. For other people to use our code,
# they can just run renv::restore() and it will install all the packages we used.

#  - We *don't* want to have install.packages() in the script or it will 
#    download the packages every time we run the script which is annoying and can
#    break the code if the package versions are different.

#  - When you create a new RProject, you can select a tick box "renv". 
#    If you don't see this, you will need to install renv onto your computer just the once:

#   - install.packages("renv") 
#   or use the Packages pane in RStudio

# Look in your RProject files, if you don't see a folder called renv
# you need to initialise it. 

#   - You can do this by double clicking 
#     your .RProject file in RStudio and going to the colourful "Environment" tab.
#     You'll see a tick box "use renv with this project".

#   - Alternatively you can do this in the console:
#     renv::init()

# Now we can install the packages we need using renv:

# ----Install the packages: ----
# renv::install("tidyverse")
# renv::install("palmerpenguins")
# renv::install("here")
# renv::install("janitor")

# You can use install.packages() to install, but you will need to update renv:
# renv::snapshot()

# Later when we come back to this project, or someone else wants to use it,
# we can restore the packages:
# renv::restore()

# Make sure you have the following files and subfolders in your project:

# - renv/
# - data/
#   - penguins_raw.csv (you should have this from the class, otherwise use the commented out code below)
# - functions/
#   - cleaning.R (get this from canvas)
# - penguin_analysis.Rmd (or .R This file)
# - penguinproject.Rproj
# - renv.lock (this is automatically created when you use renv)



# ----------------------------------------------------------------
#            INSIDE THE SCRIPT 
# ----------------------------------------------------------------

# ---- The top of our RMarkdown file ----

library(tidyverse)
library(palmerpenguins)
library(here)
library(janitor)

# This means we can use our own functions from cleaning.R file.
source(here("functions", "cleaning.R"))
# -------------------------------------

# ---- Save the raw data ----
# This is commented out because we already have the raw data saved.
# write_csv(penguins_raw, here("data", "penguins_raw.csv"))
# -------------------------------------

# ---- Load the raw data ----
penguins_raw <- read_csv(here("Datta", "penguins_raw.csv"))
# -------------------------------------

# ---- Check column names ----  
colnames(penguins_raw)
# -------------------------------------

# ---- Cleaning the data ----
# We can use the functions from libraries like janitor and also 
# our own functions, like those in cleaning.R. 
# I've used a pipe %>% to chain the functions together. You can also make this
# into a function if you want to (functions within functions).
penguins_clean <- penguins_raw %>%
  clean_column_names() %>%
  remove_columns(c("comments", "delta")) %>%
  shorten_species() %>%
  remove_empty_columns_rows()
# -------------------------------------

# ---- Check the output ----
colnames(penguins_clean)
# -------------------------------------

# ---- Save the clean data ----
write_csv(penguins_clean, here("data", "penguins_clean.csv"))
# -------------------------------------

# -------------------------------------
# WEEK 4
# -------------------------------------

# ---- box plot ----
# used for looking at raw data to see if there is a certain ditribution (eg normal, binomial)
# should be figure in all paper that is exploratory, so shows all the data
# exploratory figures include box plots, scatter plots, violin plots, histograms
# scatterplot with line drawn through it is not exploratory, as it has a model running on it / testing a hypothesis
#    starting dataset
penguins_clean <- read.csv(here("Datta","penguins_clean.csv"))
#'here' is a relative path rather than an absolute path (so will work on anyone's computer), and is more private (does not show my personal pathway)
#    craeting boxplot
flipper_boxplot <- ggplot(
  data = penguins_clean, 
  aes(x = species, 
      y = flipper_length_mm)) +
  geom_boxplot()
flipper_boxplot
#warnng came up because some datarows do not have data (N/A)
#want to remove N/A from data that I am interested in only, to keep as much data as possible
penguins_flippers <- select(penguins_clean, c("species", "flipper_length_mm")) #subsetting code to just these columns
colnames(penguins_flippers) #checking that new dataset only has 2 columns
#removing N/A from just those 2 columns
#penguins_flippers <- drop_na(penguins_flippers)#bad practice as it overwrites the original dataset, bad if you are running code out of order / running code multiple times
penguins_flippers <- penguins_clean %>% shorten_species() %>% 
  select(species, flipper_length_mm) %>% 
  drop_na() #incorporating all subsetting / removing N/A into one pipe yippee
#    creating new boxplot with better dataset
flipper_boxplot <- ggplot(
  data = penguins_flippers, 
  aes(x = species, 
      y = flipper_length_mm)) +
  geom_boxplot()
flipper_boxplot
#no warming coming up so celaning worked
#adding colours and raw data
flipper_boxplot <- ggplot(
  data = penguins_flippers, 
  aes(x = species, 
      y = flipper_length_mm)) +
  geom_boxplot(aes(color = species), #adding colour
               show.legend = FALSE, #adding legend
               width = 0.4) + #reducing width
  geom_jitter(aes(color = species), 
              show.legend = FALSE, 
              position = position_jitter(width = 0.2, #adds raw datapoints on top of box plot, x of data is randomly spaced within the 3 species (so points will move around if data is rerun, not reproducible)
                                         seed = 0)) + #jitter is not truly random as computers can't do that, therefore give jitter random seed (so random number will be same every time, making randomness reproducible)
                labs(x = "Species", #adding labels
                     y = "Flipper length (mm)")
flipper_boxplot
# -------------------------------------
# ---- colour mapping ---- ***not working yet***
species_colours <- c("Adelie" = "darkorange", "Chinstrap" = "purple", "Gentoo" = "cyan4") #need to have shortened names for this (use cleaning package for that)
flipper_boxplot <- ggplot(
  data = penguins_flippers, 
  aes(x = species, 
      y = flipper_length_mm)) +
  geom_boxplot(show.legend = FALSE, #adding legend
               width = 0.4) + #reducing width
  geom_jitter(show.legend = FALSE, 
              position = position_jitter(width = 0.2, #adds raw datapoints on top of box plot, x of data is randomly spaced within the 3 species (so points will move around if data is rerun, not reproducible)
                                         seed = 0)) + #jitter is not truly random as computers can't do that, therefore give jitter random seed (so random number will be same every time, making randomness reproducible)
                scale_color_manual(values = species_colours) +
                labs(x = "Species", #adding labels
                     y = "Flipper length (mm)") +theme_bw()
flipper_boxplot
#colours not working but just leave it for now

# -------------------------------------

# ---- creating plot function ---- 
# create template plot so same plot can be made for different data easily, good for comparison and reproducibility
# want specific file for all our plots to go into, function should not secify dataset so graph can be made for ANY data (yippeee)
# overwriting within a function file is fine
# plot function also means that code only requires 1 line of code to run an entire plot with all the colours / fun stuff already in it

# -------------------------------------

# ---- saving figures ---- 
# want to save plot that can be stretched / shrunk to look as good on A4 or on a large poster
install.packages("ragg")
install.packages("svglite")
library(ragg)
library(svglite)
renv::()
  renv::()
#use svglite function in plot function to:
#    change scale form 1 to 2 to make everything bigger, no need to change individual font sizes
#    resolution = how many pixels there are per cm
#    width and height is in cm
#    when incraesing size, also need to increase scale to same degree (so double  height and width = double scale)
#
#vectors are better than PNG, as PNG is information on pixels (so they break when you zoom in), vector does not do this
#save figures as .svg or .pdf, as the save images as lines (so do not get blurry when you zoom in)

# -------------------------------------
  
# ---- github ---- 
# used to keep track of files, and keep them safe in one place
# can see files through time, so if code breaks can go back like 8 months to when it worked an work on that file instead
# good for collaboration, especially across the globe, will not get overwrite errors when multiple people work on same code
# Commit = save file snapshot
# push = send file somewhere else, eg to github / online
# pull = grab someone else's code
# namw of new repo has to be same name as folder you are working code in
git remote add origin https://github.com/AliceThynne/PenguinProject.git #paste into console
#lol its not working, was supposed to put a git tab in the environment module
#then supposed to sleect all penguin project files and press commit, write notes on changes
#then press push to send all files to github

# -------------------------------------
# ---- assignments ---- 
# one is quarto, one is git, another is git, another is phylogeny / data
# assignments will not be released at same time :(
# assessed on code (clearness, layout, whether it is clear from someone looking at it from the outside)
#github troubleshooting
#put this in the terminal
git config --global user.email "alice.thynne"
git config --global user.name "AliceThynne"
git remote add origin https://github.com/AliceThynne/PenguinProject.git 
/usr/bin/git push origin HEAD:refs/heads/main
git push --set-upstream origin main