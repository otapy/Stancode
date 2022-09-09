//functions{
//  vector reactfunc(vector x, real tau) {
//     return 1 - exp( - x / tau);
//  }
//}

data {
  int<lower=0> N;          //データ数
  int<lower=0> T;          //日数
  int<lower=0> M;          //メディア数
  int<lower=0> K;          //ベースライン数
  matrix[N, T] EXPO[M];    //N行T列の説明変数行列
  matrix[N, K] BASE;       //N行K列の説明変数行列（ベースライン）
  vector[N] Y;             //目的変数
  vector[N] I;             //切片ベクトル
}
 
parameters {
  vector<lower=0>[M] b;                 //回帰係数ベクトル
  vector[K] c;                          //ベースライン係数ベクトル
  real d;                               //切片係数
  vector<lower=0,upper=1>[M] eta;       //残存率
  vector<lower=0>[M] tau;               //時定数
  real<lower=0> sigma;   
}

transformed parameters {
  vector[N] mu;
  matrix[N, T] adstockAlt;
  matrix[N, M] adstock;
  matrix[N, M] reactEX;
  
  for(i in 1:M){
     for(j in 1:N){
        adstockAlt[j,1] = EXPO[j,1][i];
        for(t in 2:T){
           adstockAlt[j,t] = EXPO[j,t][i] + eta[i] * adstockAlt[j,t-1];
           }
        adstock[j, i] = adstockAlt[j,T];
        reactEX[j, i] = 1 - exp( - adstock[j, i] / tau[i] );
        } 
     }
     
  mu = reactEX*b + BASE*c + d*I;
}
 
model {
  eta ~ cauchy(0.5, 5);
  tau ~ cauchy(2, 5);

  Y ~ normal(mu, sigma);
}

//generated quantities {
//  real yhat[N];
//  for (i in 1:N) 
//          yhat[i] = normal_rng(mu, sigma);
//}