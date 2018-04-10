
###################################################################
### Memory-based Collaborative Filtering Algorithm Starter Code ###
###################################################################

### Authors: Cindy Rush with edits by Ginny Gao
### Project 3
### ADS Spring 2018


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

setwd("/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/lib")

#change source function as needed
source("functions.R")


setwd("/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/data/MS_sample")

# Load the Microsoft MS data
MS_train <- read.csv("data_train.csv", as.is = TRUE, header = TRUE)
MS_train <- MS_train[, 2:4] # get rid of first column: row number


# Transform from narrow to wide, i.e. user-item matrix (UI matrix)
# Using MS_data_transform function

# Below takes 2.17 minutes
MS_UI <- MS_data_transform(MS_train)
save(MS_UI, file = "/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_UI.RData")


# Matrix Calculations
# Number of pages visited for each user
visit_nums <- rowSums(MS_UI != 0)

# Frequency count of how many users visited 6, 7, 8, etc pages, histogram
table(visit_nums)

# Mean of number of pages visted among users
mean(visit_nums)

# Median of number of pages visted among users
median(visit_nums)


# Another way: the long way
# Looping instead of rowSums()

# long.row.sums <- function(UI) {
#   vec <- rep(NA, nrow(UI))
#   for (i in 1:nrow(UI)) {
#     vec[i] <- sum(UI[i,], na.rm = TRUE)
#   }
#   return(vec)
# }


# system.time(long.row.sums(MS_UI))
# system.time(rowSums(MS_UI, na.rm = TRUE))

# vec <- long.row.sums(MS_UI)
# all(vec == rowSums(MS_UI, na.rm = TRUE))


###############################################################
######## Building the UI matrix for the EachMovie Data ########
###############################################################

setwd("/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/data/eachmovie_sample")

# Load the data
movie_train <- read.csv("data_train.csv", as.is = TRUE, header = TRUE)
movie_train <- movie_train[, 2:4] # get rid of first column: row number

# How we might fill in the user-item matrix using %in%

# Below is tutorial of how `movie_data_transform` function is derived in `functions.R`

# # Find sorted lists of unique users and movies
# users  <- sort(unique(movie_train$User))
# movies <- sort(unique(movie_train$Movie))

# # Initiate the UI (user-item) matrix
# UI            <- matrix(NA, nrow = length(users), ncol = length(movies))
# row.names(UI) <- users
# colnames(UI)  <- movies

# # We consider just user 1, finding user 1's movies and ratings
# movies  <- movie_train$Movie[movie_train$User == users[1]]
# ratings <- movie_train$Score[movie_train$User == users[1]]

# ord     <- order(movies)
# movies  <- movies[ord]
# ratings <- ratings[ord]

# system.time(UI[1, colnames(UI) %in% movies] <- ratings)

# # How we might fill in the user-item matrix using loops 

# long.in <- function(movies, ratings) {
  
#   # Cycle through the ratings, find the corresponding column
#   for (i in 1:length(ratings)) {
#     column <- which(colnames(UI) == movies[i])
#     UI[2, column] <- ratings[i]
#     print(column)
#   }
  
# }


# system.time(long.in(movies, ratings))
  
# all(UI[1, ] == UI[2,], na.rm = TRUE)

# Compute the full matrix
# Below takes about 4 minutes

movie_UI <- movie_data_transform(movie_train)
save(movie_UI, file = "/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_UI.RData")

# Some calculations
total_ratings <- rowSums(movie_UI, na.rm = TRUE)

table(total_ratings)
mean(total_ratings)
median(total_ratings)




#################################################################
######## Calculating the Similarity Weights of the Users ########
#################################################################

# Below is tutorial of how `calc_weight` function is derived from 'functions.R'

# # Initiate the similarity weight matrix

# movie_UI         <- as.matrix(movie_UI)
# movie_sim_weight <- matrix(NA, nrow = nrow(movie_UI), ncol = nrow(movie_UI))

# # Can calculate Pearson correlation between two rows of UI matrix as:

# rowA <- movie_UI[1, ]
# rowB <- movie_UI[2, ]

# cor(rowA, rowB, method = 'pearson', use = "pairwise.complete.obs")

# # Another way:

# joint_values <- !is.na(rowA) & !is.na(rowB)
# cor(rowA[joint_values], rowB[joint_values], method = 'pearson')

# # First fill in row 1 of the similarity matrix using apply

# system.time(vec1 <- apply(movie_UI, 1, cor, movie_UI[1, ], method = 'pearson', use = "pairwise.complete.obs"))

# # Now fill in row 1 of the similarity matrix looping over the columns and 
# # calculating pairwise correlations

# long.way <- function(row.num) {
  
#   for(i in 1:nrow(movie_UI)) {
#     movie_sim_weight[row.num, i] <- cor(movie_UI[i, ], movie_UI[row.num, ], method = 'pearson', use = "pairwise.complete.obs")
#   }
  
# }

# system.time(long.way(1))



# Calculate the full similarity weights on the movie data
# The below took 87 minutes on my Macbook, 35 on my iMac

# change method = "pearson" to "spearman" for Task B (1)

system.time(movie_sim <- calc_weight(movie_UI))
save(movie_sim, file = "/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_sim.RData")


# Calculate the full similarity weights on the MS data
# The below took 30 minutes on my Macbook and 14 on my iMac

# change method = "pearson" to "spearman" for Task B (1)

system.time(MS_sim <- calc_weight(MS_UI))
save(MS_sim, file = "/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_sim.RData")



###########################################################
######## Calculating the Predictions for the Users ########
###########################################################

# Below is tutorial of how `pred_matrix` function is derived from 'functions.R'

# # Calculate the predictions for user 1

# # Initiate the prediction matrix and find the columns we need to predict
# # for user 1.
# pred_mat        <- MS_UI
# cols_to_predict <- which(MS_UI[1, ] == 0)
# num_cols        <- length(cols_to_predict)

# # Transform the UI matrix into a deviation matrix since we want to calculate
# # weighted averages of the deviations
# neighb_weights <- MS_sim[1, ]
# row_avgs       <- apply(MS_UI, 1, mean, na.rm = TRUE)
# dev_mat        <- MS_UI - matrix(rep(row_avgs, ncol(MS_UI)), ncol = ncol(MS_UI))

# # We'll calculate the predictions in two ways:

# # First by looping over items where we want to make predictions


# for (i in 1:num_cols) {
  
#   # For each column to predict, first find all deviations for that item
#   neighb_devs <- dev_mat[ ,cols_to_predict[i]]
  
#   # For each column to predict, calculate the prediction as the weighted average
#   pred_mat[1, cols_to_predict[i]] <- row_avgs[1] +  sum(neighb_devs * neighb_weights, na.rm = TRUE)/sum(neighb_weights, na.rm = TRUE)
# }


# # Now using matrix equations

# pred_mat2 <- MS_UI

# weight_mat  <- matrix(rep(neighb_weights, ncol(MS_UI)), ncol = ncol(MS_UI))
# weight_sub  <- weight_mat[, cols_to_predict]
# neighb_devs <- dev_mat[ ,cols_to_predict]

# # Now fill in all of row 1 with matrix equations
# pred_mat2[1, cols_to_predict] <- row_avgs[1] +  apply(neighb_devs * weight_sub, 2, sum, na.rm = TRUE)/sum(neighb_weights, na.rm = TRUE)


# # They're the same
# all(pred_mat2[1,] == pred_mat[1, ])


# Calculate predictions for MS
# This calculation took me 15 minutes

system.time(MS_pred <- pred_matrix(MS_UI, MS_sim))
save(MS_pred, file = "/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_pred.RData")

# Calculate predictions for movies
# This calculation took me 2493 second

system.time(movie_pred <- pred_matrix(movie_UI, movie_sim))
save(movie_pred, file = "/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_pred.RData")
