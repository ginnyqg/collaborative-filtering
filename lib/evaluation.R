#############################################################
### Evaluation ###
#############################################################

### Author: Jiongjiong Li
### Project 3

##compute MAE value

mae<-function(test,prediction){
  #making sure the prediction and test set has the same dimensions
  prediction<-prediction[row.names(prediction)%in%row.names(test),colnames(prediction)%in%colnames(test)]
  result<-mean(abs(prediction-test),na.rm = T)
  return(result)
}

##compute ROC
# require the package "pROC"
roc<-function(test,prediction){
  prediction<-prediction[row.names(prediction)%in%row.names(test),colnames(prediction)%in%colnames(test)]
  library('pROC')
  result<-multiclass.roc(test, prediction)
  return(result)
}

##compute ranking scores
rank_score<-function(test,prediction,alpha=5,d=0){
  #making sure the prediction and test set has the same dimensions
  prediction<-prediction[row.names(prediction)%in%row.names(test),colnames(prediction)%in%colnames(test)]
  nrow<-nrow(test)
  ncol<-ncol(test)
  rank_mat<-matrix(NA,nrow = nrow(prediction),ncol=ncol(prediction))
  # sort pred values
  rank_pred<-t(apply(prediction,1,function(x){return(names(sort(x, decreasing = T)))}))
  # sort observed values based on pred values
  for(i in 1:nrow(prediction)){
    rank_mat[i,]<-unname(test[i,][rank_pred[i,]])
  }
  row.names(rank_mat)<-row.names(prediction)
  #rank_pred<-data.frame(rank_pred2,row.names = row.names(prediction))
  

  rank_test<-t(apply(test, 1, sort,decreasing=T))
  vec<-2^(0:(ncol(prediction)-1)/(alpha-1))
  div<-matrix(rep(vec, nrow), nrow, ncol, byrow=T)
  
  tmp<-ifelse(rank_mat-d>0,rank_mat-d,0)
  #R_a formula
  R_a<-rowSums(tmp/div)
  #R_a_max formula
  R<-rowSums(rank_test/div)
  # the final score
  return(100*sum(R_a)/sum(R))
}



