// simPotData test model fixed effects non centered

data{
int<lower=2> N;       // number of time observations in data
vector[N] Y; // effect, response, dependent variable
int<lower=2> N_C;     // number of distinct pots in data
int<lower=2> N_G;     // number of groups
int<upper=N_C> C[N];    // pot index in data
int<upper=N_G> G[N];    // group index in data
int<lower=1, upper=N_G> GC[N_C]; // list od group index for each pot
int BC[N_C]; // list of block index for each pot
real<lower=0> S;      // ref sd for effect prior
real E;      // ref effect for prior
}

parameters{
  real          alpha_top[N_G]; // mean effect for each group
  real<lower=0> sigma_top;      // sd for mean effects
  real<lower=0> sigma;          // sd for pot effect
  real alpha_zoffset[N_C];      // decalage de la cuve par rapport a la moyenne du groupe en unite de sd sigma_top
}

transformed parameters{
   real alpha[N_C];          // effect for each pot
   real alpha_diff[N_G - 1];   // relative effect for each group
   for (c in 1:N_C) {
     alpha[c] = alpha_top[GC[c]] + sigma_top * alpha_zoffset[c];
   }
   for (g in 1:N_G-1){
   alpha_diff[g] = alpha_top[g+1] - alpha_top[g];
   }
}

model {
  // priors for pot fixed effect
  sigma ~ exponential(1/S);
 // Hyper priors
 alpha_top ~ normal(E, S);
 sigma_top ~ exponential(1/S);
 alpha_zoffset ~ normal(0, 1);

 for (i in 1:N) {
   Y[i] ~ normal(alpha[C[i]] , sigma);
 }

}
generated quantities {
  vector[N] Y_sim;
  for (i in 1:N) {
    Y_sim[i] = normal_rng(alpha[C[i]] , sigma);
  }
}



