data {
  int<lower=0> N;       //データ数
  int<lower=0> K;       //説明変数の数
  int<lower=0> A;       //1の数
  matrix[N, K] X;       //N行K列の説明変数行列
  int Y[N];             //目的変数
}
 
parameters {
  vector<lower=0>[K] b; //回帰係数ベクトル
}
 
transformed parameters{
  vector[N] p;
  p = inv_logit(X*b);
}
 
model {
  p ~ beta(A,N-A);      //pの事前分布はベータ分布に従う
  Y ~ bernoulli(p);     //Yはベルヌーイ分布に従う
}

generated quantities{
  vector[N] p_pred;
  int Y_pred[N];
  p_pred = inv_logit(X*b);
  Y_pred = bernoulli_rng(p_pred);  
}