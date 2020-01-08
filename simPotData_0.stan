// simPotData test model fixed effects centered

data{
int N;       // number of observations in data
vector[N] Y; // effect, response, dependent variable
int C[N];    // pot index in data
int N_C;     // number of distinct pots in data
int N_G;     // number of groups
int G[N];    // group index in data
int GC[N_C]; // group index for each pot
int BC[N_C]; // block index for each pot
real S;      // ref sd for effect prior
}

parameters{
  real          alpha_top[N_G]; // mean effect for each group
  real<lower=0> sigma_top;      // sd for mean effects
  real          alpha[N_C];     // effect for each pot
  real<lower=0> sigma;          // sd for pot effect
  real          beta_block[N_G];     // effect for block B
}

model {
  // priors for pot fixed effect
  for (c in 1:N_C){
    alpha[c] ~ normal(alpha_top[GC[c]], sigma_top);
  }
  sigma ~ exponential(1/S);
  beta_block ~ normal(0, S);
 // Hyper priors
 alpha_top ~ normal(0, S);
 sigma_top ~ exponential(1/S);

 for (i in 1:N) {
   Y[i] ~ normal(alpha[C[i]] + beta_block[G[i]], sigma);
 }

}
generated quantities {
  vector[N] Y_sim;
  for (i in 1:N) {
    Y_sim[i] = normal_rng(alpha[C[i]] + beta_block[G[i]], sigma);
  }
}



