### Authors: Group 7
### Project 3
### ADS Spring 2018


###################################################################
###     Memory-based Collaborative Filtering Algorithm Code     ###
###################################################################

########################################################
######## Building the UI matrix for the MS Data ########
########################################################

packages.used <- c('lsa', 'infotheo')

# check packages that need to be installed.
packages.needed <- setdiff(packages.used, intersect(installed.packages()[,1], packages.used))

# install additional packages
if(length(packages.needed) > 0) {
  install.packages(packages.needed, dependencies = TRUE, repos = 'http://cran.us.r-project.org')
}

library(lsa)
library(infotheo)

setwd("../lib")
#change source function as needed

# Which similarity weight to run
run.pearson <- TRUE
run.spearman <- FALSE
run.vs <- FALSE
run.entropy <- FALSE
run.msd <- FALSE
run.simrank <- FALSE

if (run.pearson){
source("functions_pearson.R")
}
if (run.spearman){
source("functions_spearman.R")
}
if (run.vs){
source("functions_vs.R")
}
if (run.entropy){
source("functions_entropy.R")
}
if (run.msd){
source("functions_msd.R")
}
if (run.simrank){
source("functions_simrank.R")
}


setwd("../data/MS_sample")
# Load Microsoft data
MS_train <- read.csv("data_train.csv", as.is = TRUE, header = TRUE)
MS_train <- MS_train[, 2:4] # get rid of first column: row number


# Transform from narrow to wide, i.e. user-item matrix (UI matrix)
# Using MS_data_transform function

# Below takes 2.17 minutes
MS_UI <- MS_data_transform(MS_train)
save(MS_UI, file = "../output/MS_UI.RData")


###############################################################
######## Building the UI matrix for the EachMovie Data ########
###############################################################

setwd("../data/eachmovie_sample")

# Load movie data
movie_train <- read.csv("data_train.csv", as.is = TRUE, header = TRUE)
movie_train <- movie_train[, 2:4] # get rid of first column: row number

# Compute the full matrix, below takes about 4 minutes
movie_UI <- movie_data_transform(movie_train)
save(movie_UI, file = "../output/movie_UI.RData")


#################################################################
######## Calculating the Similarity Weights of the Users ########
#################################################################


# Calculate the full similarity weights on the MS data
# Below took 30 minutes on my Macbook and 14 on my iMac

system.time(MS_sim <- calc_weight(MS_UI))
save(MS_sim, file = "../output/MS_sim.RData")


# Calculate the full similarity weights on the movie data
# Below took 87 minutes on my Macbook, 35 on my iMac

system.time(movie_sim <- calc_weight(movie_UI))
save(movie_sim, file = "../output/movie_sim.RData")


###########################################################
######## Calculating the Predictions for the Users ########
###########################################################


# Calculate predictions for MS
# This calculation took me 15 minutes

system.time(MS_pred <- pred_matrix(MS_UI, MS_sim))
save(MS_pred, file = "../output/MS_pred.RData")

# Calculate predictions for movies
# This calculation took me 2493 second

system.time(movie_pred <- pred_matrix(movie_UI, movie_sim))
save(movie_pred, file = "../output/movie_pred.RData")


#########################################################################
######## Calculating Normalized Rating Predictions for the Users ########
#########################################################################


# Calculate predictions for MS
# This calculation took me 15 minutes

system.time(MS_pred_norm <- pred_matrix_norm(MS_UI, MS_sim))
save(MS_pred_norm, file = "../output/MS_pred_norm.RData")

# Calculate predictions for movies
# This calculation took me 2493 second

system.time(movie_pred_norm <- pred_matrix_norm(movie_UI, movie_sim))
save(movie_pred_norm, file = "../output/movie_pred_norm.RData")


###########################################################
########                Evaluation                 ########
###########################################################

setwd("../lib")
# Evaluate using MAE, ROC, and ranking score
source("evaluation.R")

########                MS                 ########

w_test_UI <- get(load('../output/MS_UI_test.RData'))
w_pred_pearson <- get(load('../output/MS_pred_pearson.RData'))
rank_score(w_test_UI, w_pred_pearson)
w_pred_spearman <- get(load('../output/MS_pred_spearman.RData'))
rank_score(w_test_UI, w_pred_spearman)
w_pred_vs <- get(load('../output/MS_pred_vs.RData'))
rank_score(w_test_UI, w_pred_vs)
w_pred_entropy <- get(load('../output/MS_pred_entropy.RData'))
rank_score(w_test_UI, w_pred_entropy)
w_pred_msd <- get(load('../output/MS_pred_msd.RData'))
rank_score(w_test_UI, w_pred_msd)

########                Movie                 ########

m_test_UI <- get(load('../output/movie_UI_test.RData'))
m_pred_pearson <- get(load('../output/movie_pred_pearson.RData'))
mae(m_test_UI, m_pred_pearson)
roc(m_test_UI, m_pred_pearson)
m_pred_spearman <- get(load('../output/movie_pred_spearman.RData'))
mae(m_test_UI, m_pred_spearman)
roc(m_test_UI, m_pred_spearman)
m_pred_vs <- get(load('../output/movie_pred_vs.RData'))
mae(m_test_UI, m_pred_vs)
roc(m_test_UI, m_pred_vs)
m_pred_entropy <- get(load('../output/movie_pred_entropy.RData'))
mae(m_test_UI, m_pred_entropy)
roc(m_test_UI, m_pred_entropy)
m_pred_msd <- get(load('../output/movie_pred_msd.RData'))
mae(m_test_UI, m_pred_msd)
roc(m_test_UI, m_pred_msd)


