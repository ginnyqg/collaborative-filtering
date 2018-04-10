#############################################################
### Evaluation ###
#############################################################

### Author: Jiongjiong Li with edits by Ginny Gao
### Project 3

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



