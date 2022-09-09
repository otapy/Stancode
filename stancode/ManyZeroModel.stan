data {
  int<lower=0> N;   //データ数
  int<lower=0> M;   //説明変数の数
  matrix[N, M] X;   //N行K列の説明変数行列
  vector[N] Y;      //目的変数
  vector[N] G;      //広告量
  vector[N] I;      //切片ベクトル
}
 
parameters {
  real<lower=0> g;               //広告係数
  vector[M] b;                   //回帰係数ベクトル
  real c;                        //切片係数
  real<lower=0,upper=1> theta;   //確率
  real tau;                      //時定数
}
 
transformed parameters {
  vector[N] reactG;
  vector[N] mu;
  vector[N] lambda;
  reactG = 1 - exp( -tau * G );
  mu = g*reactG + X*b + c*I;
  lambda = exp(mu);
}
 
model {
  for (i in 1:N){
    if (Y[i] == 0){
      target += log_sum_exp(log(1-theta), log(theta) + exponential_lpdf(Y[i] | lambda[i]));
    }else{
      target += log(theta) + exponential_lpdf(Y[i] | lambda[i]);
    }
  }
}