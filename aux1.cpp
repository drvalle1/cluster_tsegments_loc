#include <Rcpp.h>
#include <iostream>
#include <ctime>
#include <fstream>
using namespace Rcpp;

/***************************************************************************************************************************/
/*********************************                      UTILS          *****************************************************/
/***************************************************************************************************************************/

// This function helps with multinomial draws
// [[Rcpp::export]]
int cat1(double value, NumericVector prob) {
  int res=-1;
  double probcum = 0;
  
  for (int i = 0; i < prob.length(); i++) {
    probcum = probcum + prob(i);
    if (value < probcum) {
      res = i;
      break;
    }
  }
  return res;
}

//' This function samples z's from a categorical distribution
// [[Rcpp::export]]
IntegerVector rmultinom1(NumericMatrix prob, NumericVector randu) {
  
  IntegerVector z(prob.nrow());

  for(int i=0; i<prob.nrow();i++){
    z[i]=cat1(randu[i],prob(i,_));
  }
  return z;
}

//' This function converts v into phi
// [[Rcpp::export]]
NumericVector GetPhi(NumericVector vec, int nclustmax) {
  NumericVector res(nclustmax);
  NumericVector prod1(nclustmax);
  double prod=1.0;
  
  for(int j=0; j<nclustmax;j++){
    res[j]=vec[j]*prod;
    prod=prod*(1-vec[j]);
  }
  
  return res;
}

//' This function helps sample z
// [[Rcpp::export]]
IntegerVector HelperSampleZ(IntegerVector tab, IntegerVector z,
                            NumericVector lphi, NumericMatrix LprobTmp, NumericVector CalcInterm,
                            int nclustmax, int  nloc, int nobs,
                            IntegerMatrix dat, IntegerVector n,
                            NumericVector RandUnif) {
  NumericVector lprob(nclustmax);
  for (int i=0; i<nobs; i++){
    tab[z[i]]=tab[z[i]]-1;
    
    //calculate lprob
    for (int k=0; k<nclustmax; k++){
      if (tab[k]==0){
        lprob[k]=lphi[z[i]]+CalcInterm[i];
      }
      if (tab[k]!=0){
        lprob[k]=LprobTmp(i,k);
      }
    }
      
    //get normalized probs
    lprob=lprob-max(lprob);
    lprob=exp(lprob);
    lprob=lprob/sum(lprob);
      
    //draw from multinomial distribution
    z[i]=cat1(RandUnif[i], lprob);
    tab[z[i]]=tab[z[i]]+1;
  }
  return z;
}

//' This function gets log-probab for existing groups (useful to sample z)
// [[Rcpp::export]]
NumericMatrix GetLoglikel(NumericMatrix ltheta, NumericVector lphi,
                          int nobs, int nloc, int nclustmax,
                          IntegerMatrix dat){
  NumericMatrix LogLikel(nobs,nclustmax);
  for (int i=0; i<nobs; i++){
    for (int k=0; k<nclustmax; k++){
      for (int l=0; l<nloc; l++){
        LogLikel(i,k)=LogLikel(i,k)+dat(i,l)*ltheta(k,l);        
      }
      LogLikel(i,k)=LogLikel(i,k)+lphi[k];
    }
  }
  return LogLikel;
}
