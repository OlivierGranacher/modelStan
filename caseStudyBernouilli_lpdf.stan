// case study for comparison of 2 Bernouilli tests

data {
  int<lower=1> N; // number of periods (rows)
  int trials[N];  // number  of trials for each period
  int  successes[N]; // number of successes for each period
  int  period[N];
}


parameters {
  vector[max(period)] prob;
}

model {
  //prob ~ uniform(0, 1);
  target += uniform_lpdf(prob | 0, 1);
  for (i in 1:N) {
    //successes[i] ~ binomial(trials[i], prob[period[i]]);
    target += binomial_lpmf(successes[i] | trials[i], prob[period[i]] );
  }
}

generated quantities{
  vector[N] log_lik;
  for (i in 1:N)
    log_lik[i] = binomial_lpmf(successes[i] | trials[i], prob[period[i]] );
  }

