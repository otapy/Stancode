data {
  int<lower=0> N;             //データ数
  int<lower=0> holiday[N];    //休祝日数
  real Y[N];                  //売上個数
  real X[N];                  //広告量
}
 
parameters {
  real trend[N];
  real<lower=0> sigtrend;
  real ar[N];
  real c_ar[2];
  real<lower=0> sigar;
  real a;
  real b;
  real<lower=0> c;
  real d;
  real e;
  real<lower=0> sigY;
  real<lower=0,upper=1> eta;
  real tau;
}

transformed parameters {
  real adstock[N];
  real actfunc[N];
  adstock[1] = X[1];
  for(i in 2:N)
        adstock[i] = X[i] + eta * adstock[i-1];
  for(i in 1:N)
        actfunc[i] = 1 - exp( -adstock[i] / tau); 
}
 
model {
  for(i in 3:N)
         trend[i] ~ normal(2*trend[i-1]-trend[i-2], sigtrend);
  for(i in 3:N)
         ar[i] ~ normal(c_ar[1]*ar[i-1]+c_ar[2]*ar[i-2], sigar);
  for(i in 1:N)
         Y[i] ~ normal(a*trend[i]+b*ar[i]+c*X[i]+d, sigY);
}