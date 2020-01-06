// simPotData test model fixed effects

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
  real alpha_top[N_G]; // mean effect for each group
  real sigma_top;      // sd for mean effects
  real alpha[N_C];     // effect for each pot
  real sigma;          // sd for pot effect
  real beta_block;     // effect for block B
}

model {
  // priors
  for (c in 1:N_C){
    alpha[c] ~ normal(alpha_top[GC[c]], sigma_top);
  }

}
