data {
  int<lower=0> N;   //データ数
  int<lower=0> K;   //説明変数の数
  matrix[N, K] X;   //N行K列の説明変数行列
  vector[N] Y;      //目的変数
  vector[N] I;      //切片ベクトル
}
 
parameters {
  vector<lower=0>[K] b;  //回帰係数ベクトル
  real c;                //切片係数
  real<lower=0> sigma;  
}
 
transformed parameters{
  vector[N] mu;
  vector[N] e;
  mu = X*b + c*I;
  e = Y - mu;
}
 
model {
  e ~ normal(0, sigma);  //残差eは正規分布に従う
}

generated quantities{
  vector[N] mu_pred;
  real Y_pred[N];
  mu_pred = X*b;
  Y_pred = normal_rng(mu_pred, sigma);  
}