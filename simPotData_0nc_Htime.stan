// simPotData test model fixed effects non centered with time

data{
int<lower=2> N;       // number of observations in data
int<lower=1> N_dat;
vector[N] Y; // effect, response, dependent variable
int<lower=1, upper=N_dat> id_dat[N]; // date index
int<lower=1> N_C;     // number of distinct pots in data
int<lower=1> N_G;     // number of groups
int<lower=1, upper=N_C> C[N];    // pot index in data
int<lower=1, upper=N_G> G[N];    // group index in data
int<lower=1, upper=N_G> GC[N_C]; // list od group index for each pot
int BC[N_C]; // list of block index for each pot
real<lower=0> S;      // ref sd for effect prior
real E;      // ref effect for prior
}

parameters{
  real          alpha_top[N_G]; // mean effect for each group
  real<lower=0> sigma_alpha_top;      // sd for pot mean effects
  real alpha_zoffset[N_C];      // decalage de la cuve par rapport a la moyenne du groupe en unite de sd sigma_top

  real mean_level_top;            // mean overall level for Y
  real sigma_mean_level_top;      // sd for time effect
  real mean_level_zoffset[N_dat];

  real<lower=0> sigma;          // sd for Y response
}

transformed parameters{
   real alpha[N_C];           // effect for each pot
   real mean_level[N_dat];    // niveau moyen de Y par date
   real alpha_diff[N_G - 1];   // relative effect for each group
   for (c in 1:N_C) {
     alpha[c] = alpha_top[GC[c]] + sigma_alpha_top * alpha_zoffset[c];
   }
   for (d in 1:N_dat){
     mean_level[d] = mean_level_top + sigma_mean_level_top * mean_level_zoffset[d];
   }

   for (g in 1:N_G-1){
   alpha_diff[g] = alpha_top[g + 1] - alpha_top[g];
   }
}

model {

 // pot  priors
 alpha_top ~ normal(E, S);
 sigma_alpha_top ~ exponential(1/S);
 alpha_zoffset ~ normal(0, 1);

 // time priors
  mean_level_top ~ normal(mean(Y), sd(Y));
  sigma_mean_level_top ~ exponential(1/S);
  mean_level_zoffset ~ normal(0, 1);

  sigma ~ exponential(1/S);

 for (i in 1:N) {
   Y[i] ~ normal(alpha[C[i]] + mean_level[id_dat[i]] , sigma);
 }

}
generated quantities {
  vector[N] Y_sim;
  vector[N_dat] Y_dat; // Valeurs moyennes de Y par dat : param mean_level
  for (i in 1:N) {
    Y_sim[i] = normal_rng(alpha[C[i]] + mean_level[id_dat[i]] , sigma);
  }
  for (d in 1:N_dat){
    Y_dat[d] = mean_level[d];
  }
}



