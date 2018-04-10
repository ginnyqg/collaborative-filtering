
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
#object.size(MS_UI <- MS_data_transform(MS_train))
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


###############################################################
######## Building the UI matrix for the EachMovie Data ########
###############################################################

setwd("/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/data/eachmovie_sample")

# Load the data
movie_train <- read.csv("data_train.csv", as.is = TRUE, header = TRUE)
movie_train <- movie_train[, 2:4] # get rid of first column: row number


# Compute the full matrix
# Below takes about 4 minutes

movie_UI <- movie_data_transform(movie_train)
#object.size(movie_UI <- movie_data_transform(movie_train))
save(movie_UI, file = "/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_UI.RData")

# Some calculations
total_ratings <- rowSums(movie_UI, na.rm = TRUE)

table(total_ratings)
mean(total_ratings)
median(total_ratings)


#################################################################
######## Calculating the Similarity Weights of the Users ########
#################################################################


# Calculate the full similarity weights on the movie data
# The below took 87 minutes on my Macbook, 35 on my iMac

system.time(movie_sim <- calc_weight(movie_UI))
#object.size(movie_sim <- calc_weight(movie_UI))
save(movie_sim, file = "/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_sim.RData")


# Calculate the full similarity weights on the MS data
# The below took 30 minutes on my Macbook and 14 on my iMac


system.time(MS_sim <- calc_weight(MS_UI))
#object.size(MS_sim <- calc_weight(MS_UI))
save(MS_sim, file = "/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_sim.RData")


###########################################################
######## Calculating the Predictions for the Users ########
###########################################################


# Calculate predictions for MS
# This calculation took me 15 minutes

system.time(MS_pred <- pred_matrix(MS_UI, MS_sim))
#object.size(MS_pred <- pred_matrix(MS_UI, MS_sim))
save(MS_pred, file = "/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_pred.RData")

# Calculate predictions for movies
# This calculation took me 2493 second

system.time(movie_pred <- pred_matrix(movie_UI, movie_sim))
#object.size(movie_pred <- pred_matrix(movie_UI, movie_sim))
save(movie_pred, file = "/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_pred.RData")



#########################################################################
######## Calculating Normalized Rating Predictions for the Users ########
#########################################################################


# Calculate predictions for MS
# This calculation took me 15 minutes

system.time(MS_pred_norm <- pred_matrix_norm(MS_UI, MS_sim))
save(MS_pred_norm, file = "/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_pred_norm.RData")

# Calculate predictions for movies
# This calculation took me 2493 second

system.time(movie_pred_norm <- pred_matrix_norm(movie_UI, movie_sim))
save(movie_pred_norm, file = "/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_pred_norm.RData")



###########################################################
########                Evaluation                 ########
###########################################################

setwd("/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/lib")
# Evaluate performance with MAE, ROC, Rank Score
source("evaluation.R")

########                MS Regular                 ########

# Evaluation on MS website ratings (test vs pred)
w_test_UI <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_UI_test.RData'))

# Website: Pearson
w_pred_pearson <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_pred_pearson.RData'))
rank_score(w_test_UI, w_pred_pearson)

# Website: Spearman
w_pred_spearman <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_pred_spearman.RData'))
rank_score(w_test_UI, w_pred_spearman)

# Website: Cosine (VS)
w_pred_vs <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_pred_vs.RData'))
rank_score(w_test_UI, w_pred_vs)

# Website: Entropy
w_pred_entropy <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_pred_entropy.RData'))
rank_score(w_test_UI, w_pred_entropy)

# Website: MSD
w_pred_msd <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_pred_msd.RData'))
rank_score(w_test_UI, w_pred_msd)

########                Movie Regular                 ########

# Evaluation on MOVIE ratings (test vs pred)
m_test_UI <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_UI_test.RData'))

# Movie: Pearson
m_pred_pearson <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_pred_pearson.RData'))
mae(m_test_UI, m_pred_pearson)
roc(m_test_UI, m_pred_pearson)

# Movie: Spearman
m_pred_spearman <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_pred_spearman.RData'))
mae(m_test_UI, m_pred_spearman)
roc(m_test_UI, m_pred_spearman)

# Movie: Cosine (VS)
m_pred_vs <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_pred_vs.RData'))
mae(m_test_UI, m_pred_vs)
roc(m_test_UI, m_pred_vs)

# Movie: Entropy
m_pred_entropy <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_pred_entropy.RData'))
mae(m_test_UI, m_pred_entropy)
roc(m_test_UI, m_pred_entropy)

# Movie: MSD
m_pred_msd <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_pred_msd.RData'))
mae(m_test_UI, m_pred_msd)
roc(m_test_UI, m_pred_msd)


########                MS Norm                 ########

# Website: Pearson (normalized rating)
w_pred_norm_pearson <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_pred_norm_pearson.RData'))
rank_score(w_test_UI, w_pred_norm_pearson)

# Website: Spearman (normalized rating)
w_pred_norm_spearman <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_pred_norm_spearman.RData'))
rank_score(w_test_UI, w_pred_norm_spearman)

# Website: Cosine (VS) (normalized rating)
w_pred_norm_vs <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_pred_norm_vs.RData'))
rank_score(w_test_UI, w_pred_norm_vs)

# Website: Entropy (normalized rating)
w_pred_norm_entropy <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_pred_norm_entropy.RData'))
rank_score(w_test_UI, w_pred_norm_entropy)

# Website: MSD (normalized rating)
w_pred_norm_msd <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/MS_pred_norm_msd.RData'))
rank_score(w_test_UI, w_pred_norm_msd)


########                Movie Norm                 ########

# Movie: Pearson (normalized rating)
m_pred_norm_pearson <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_pred_norm_pearson.RData'))
mae(m_test_UI, m_pred_norm_pearson)
roc(m_test_UI, m_pred_norm_pearson)

# Movie: Spearman (normalized rating)
m_pred_norm_spearman <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_pred_norm_spearman.RData'))
mae(m_test_UI, m_pred_norm_spearman)
roc(m_test_UI, m_pred_norm_spearman)

# Movie: Cosine (VS) (normalized rating)
m_pred_norm_vs <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_pred_norm_vs.RData'))
mae(m_test_UI, m_pred_norm_vs)
roc(m_test_UI, m_pred_norm_vs)

# Movie: Entropy (normalized rating)
m_pred_norm_entropy <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_pred_norm_entropy.RData'))
mae(m_test_UI, m_pred_norm_entropy)
roc(m_test_UI, m_pred_norm_entropy)

# Movie: MSD (normalized rating)
m_pred_norm_msd <- get(load('/Users/qinqingao/Documents/GitHub/project-3-algorithms-project-3-algorithms-group-7/output/movie_pred_norm_msd.RData'))
mae(m_test_UI, m_pred_norm_msd)
roc(m_test_UI, m_pred_norm_msd)



