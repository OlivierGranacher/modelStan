// case study for comparison of 2 Bernouilli tests

data {
  int<lower=1> N; // number of periods
  int trials[N];  // number  of trials for each period
  int  successes[N]; // number of successes for each period
  int  period[N];
}


parameters {
  vector[max(period)] prob;
}

model {
  prob ~ uniform(0, 1);
  for (i in 1:N) {
    successes[i] ~ binomial(trials[i], prob[period[i]]);
  }
}

