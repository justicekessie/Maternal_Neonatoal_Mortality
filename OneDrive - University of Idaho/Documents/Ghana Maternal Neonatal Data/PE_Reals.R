library(deSolve)
library(ggplot2)
library(dplyr)


delta = 1/364
gamma_x = 0.0000123
gamma_y = 0.0000123
# Model definition
model <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    dS <- b - beta_x * S * X - beta_y * S * Y - delta * S
    dX <- beta_x * S * X - delta * X - kappa_x * X * T
    dY <- beta_y * S * Y - delta * Y - kappa_y * Y * T
    dT <- gamma_x * X + gamma_y - mu * T
    return(list(c(dS, dX, dY, dT)))
  })
}

# Load your data
data <- read.csv(file.choose())
head(data)

data$X <- abs(data$M70 - data$M78NP)
head(data)

# Selecting specific Animal by Animail_Tag
sel_data <- data %>% filter(Animal_Tag == "H3") #F(1, 2, 3), G(1, 2, 3) and H(1, 2, 3)
sel_data$Days <- seq(2, 2 * nrow(sel_data), by = 2)
plot(sel_data$Days, sel_data$X, type = 'l')

# Estimating parameters using LS on log(trans), keeping delta fixed
rssfunc <- function(params) {
  names(params) <- c("b", "beta_x", "beta_y", "mu", "kappa_x", "kappa_y")
  # Add delta as a constant in the parameters list
  full_params <- c(params, delta = delta, gamma_x = gamma_x, gamma_y = gamma_y) # Check this
  out = as.data.frame(ode(y = state, times = times, func = model, parms = full_params))
  rss = sum((log(sel_data$X + 1e-18) - log(out$X  + 1e-18))^2)  #  
  return(rss)
}

# Optimize parameters, excluding delta
optimized_params <- optim(par = initial_params, fn = rssfunc, method = c("Nelder-Mead", "BFGS", "CG", "L-BFGS-B", "SANN",
                                                                         "Brent"), lower = 1e-16, upper = Inf)

print(optimized_params)


# Helper function to run the model and extract X values for given parameters
fit_func <- function(b, beta_x, beta_y, mu, kappa_x, kappa_y) {
  # Define parameters
  params <- c(b = b, beta_x = beta_x, beta_y = beta_y, mu = mu, 
              kappa_x = kappa_x, kappa_y = kappa_y, delta = delta, gamma_x = gamma_x, gamma_y = gamma_y)
  
  # Solve the ODE system
  out <- as.data.frame(ode(y = state, times = times, func = model, parms = params))
  
  # Return the values of X (infected population)
  return(out$X)
}

# Residual sum of squares function for NLS optimization
rssfunc_nls <- function(params) {
  # Extract parameters
  b <- params[1]
  beta_x <- params[2]
  beta_y <- params[3]
  mu <- params[4]
  kappa_x <- params[5]
  kappa_y <- params[6]
  
  # Get the predicted X values from the model
  predicted_X <- fit_func(b, beta_x, beta_y, mu, kappa_x, kappa_y)
  
  # Calculate residuals (observed - predicted) and return RSS
  residuals <- log(sel_data$X + 1e-18) - log(predicted_X + 1e-18)  # Log to match scales
  return(sum(residuals^2))
}

# Initial parameter guesses
initial_params <- c(b = 1, beta_x = 0.001, beta_y = 0.001385, mu = 0.001, kappa_x = 0.000002, kappa_y = 0.00027, delta = delta, gamma_x = gamma_x, gamma_y = gamma_y)

# Fit the model using NLS
nls_fit <- optim(par = initial_params, fn = rssfunc_nls, method = "L-BFGS-B", 
                 lower = rep(1e-16, 9), upper = rep(1e+16, 9))

# Extract the optimized parameters
nls_params <- optimized_params$par

# Run the model with the optimized parameters
nls_out <- as.data.frame(ode(y = state, times = times, func = model, parms = c(nls_params, delta = delta, gamma_x = gamma_x, gamma_y = gamma_y)))

# Plot the fitted vs. observed data
ggplot() +
  geom_line(data = nls_out, aes(x = time, y = X, color = "Fitted (NLS)"), size = 1) +
  geom_point(data = sel_data, aes(x = Days, y = X), color = "black", size = 2) +
  labs(title = "NLS: Fitted vs. Observed", x = "Time", y = "Population") +
  scale_color_manual(values = c("Fitted (NLS)" = "blue")) +
  theme_minimal()



# Install and load the package
install.packages("rstan", dependencies = TRUE)
library(rstan)

# Define the model in Stan
stan_model_code <- "
data {
  int<lower=1> N;            // Number of data points
  vector[N] time;            // Time points
  vector[N] X_obs;           // Observed X values
}
parameters {
  real<lower=0> b;
  real<lower=0> beta_x;
  real<lower=0> beta_y;
  real<lower=0> mu;
  real<lower=0> kappa_x;
  real<lower=0> kappa_y;
}
model {
  // Priors
  b ~ normal(1, 1e+18);
  beta_x ~ normal(1e-16, 1e+2);
  beta_y ~ normal(1e-16, 1e+2);
  mu ~ normal(1e-16, 1e+2);
  kappa_x ~ normal(1e-16, 1e+2);
  kappa_y ~ normal(1e-16, 1e+2);

  // Likelihood (you will need to simulate X here)
  for (n in 1:N) {
    // Model simulation code to generate expected X values
    // Increment likelihood using model results
  }
}
"

# Check the filtered data
filtered_data <- data %>% filter(Animal_Tag == "H3")
print(filtered_data)

# Check if there are any rows in the filtered data
if (nrow(filtered_data) == 0) {
  stop("No data available for Animal_Tag 'H3'.")
}


# Construct the stan_data list
stan_data <- list(
  N = length(filtered_data$X),  # Number of observations
  X_obs = filtered_data$X,      # Observed X values
  time = filtered_data$Days,    # Time points
  delta = 1/365,                # Additional parameter
  gamma_x = 0.000123,           # Additional parameter
  gamma_y = 0.000123            # Additional parameter
)



# Compile and run the Stan model
stan_fit <- stan(model_code = stan_model_code, data = stan_data, iter = 2000, chains = 4)
??rstan

# Extract parameter estimates
print(stan_fit)
summary(stan_fit)


# Extract all posterior samples
posterior_samples <- extract(stan_fit)

# Summary of the fitted parameters (e.g., mean values)
summary_fit <- summary(stan_fit)$summary


# Mean parameter estimates
mean_b <- mean(posterior_samples$b)
mean_beta_x <- mean(posterior_samples$beta_x)
mean_beta_y <- mean(posterior_samples$beta_y)
mean_mu <- mean(posterior_samples$mu)
mean_kappa_x <- mean(posterior_samples$kappa_x)
mean_kappa_y <- mean(posterior_samples$kappa_y)


# Define the parameters for the model using posterior means
fitted_params <- c(b = mean_b, 
                   beta_x = mean_beta_x, 
                   beta_y = mean_beta_y, 
                   mu = mean_mu, 
                   kappa_x = mean_kappa_x, 
                   kappa_y = mean_kappa_y, 
                   delta = delta, 
                   gamma_x = gamma_x, 
                   gamma_y = gamma_y)

# Simulate the model using the mean parameters
fitted_output <- as.data.frame(ode(y = state, times = times, func = model, parms = fitted_params))

# Extract fitted X values from the model output
fitted_X <- fitted_output$X

# Plot the fitted vs. observed values
ggplot() +
  geom_line(data = fitted_output, aes(x = time, y = X, color = "Fitted"), size = 1) +
  geom_point(data = sel_data, aes(x = Days, y = X), color = "black", size = 2) +
  labs(title = "Fitted vs. Observed Data", x = "Time", y = "Population") +
  scale_color_manual(values = c("Fitted" = "blue")) +
  theme_minimal()


# Get 95% credible intervals for parameters
lower_b <- quantile(posterior_samples$b, probs = 0.025)
upper_b <- quantile(posterior_samples$b, probs = 0.975)

# Do the same for all other parameters (beta_x, beta_y, mu, etc.)

# Simulate the model using the lower and upper bounds for the parameters
# (You can do this for multiple percentiles if needed)




# Simulated Annealing
library(GenSA)

# Optimizing using simulated annealing
sa_fit <- GenSA(par = initial_params, fn = rssfunc, lower = rep(1e-16, 6), upper = rep(Inf, 6))

# Extract optimized parameters
sa_parameters <- sa_fit$par

# Run the model again with the optimized parameters
optimized_out <- as.data.frame(ode(y = state, times = times, func = model, parms = c(sa_parameters, delta = delta, gamma_x = gamma_x, gamma_y = gamma_y)))

# Plot results
ggplot() +
  geom_line(data = optimized_out, aes(x = time, y = X, color = "Infected (Optimized)"), size = 1) +
  geom_point(data = sel_data, aes(x = Days, y = X), color = "black", size = 2) +
  labs(title = "SIR Model with Optimized Parameters via Simulated Annealing",
       x = "Time",
       y = "Population") +
  scale_color_manual(values = c("Infected (Optimized)" = "blue")) +
  theme_minimal()



# Differential Optimum Method
library(DEoptim)

# Define bounds for each parameter
lower_bounds <- c(b = 1e-16, beta_x = 1e-16, beta_y = 1e-16, mu = 1e-16, kappa_x = 1e-16, kappa_y = 1e-16)
upper_bounds <- c(b = Inf, beta_x = Inf, beta_y = Inf, mu = Inf, kappa_x = Inf, kappa_y = Inf)

# Optimizing using DEoptim
de_fit <- DEoptim(rssfunc, lower = lower_bounds, upper = upper_bounds)

# Extract optimized parameters
de_parameters <- de_fit$optim$bestmem

# Run the model again with the optimized parameters
optimized_out <- as.data.frame(ode(y = state, times = times, func = model, parms = c(de_parameters, delta = delta, gamma_x = gamma_x, gamma_y = gamma_y)))

# Plot results
ggplot() +
  geom_line(data = optimized_out, aes(x = time, y = X, color = "Infected (Optimized)"), size = 1) +
  geom_point(data = sel_data, aes(x = Days, y = X), color = "black", size = 2) +
  labs(title = "SIR Model with Optimized Parameters via DEoptim",
       x = "Time",
       y = "Population") +
  scale_color_manual(values = c("Infected (Optimized)" = "blue")) +
  theme_minimal()
