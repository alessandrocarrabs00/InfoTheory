% Differential entropy for 3 distirbutions

% parameters
a = 4;
b_values = [10,18,36];
lambda_values = [0.6,1.5,6];
n_values =[1,4,9]; 

fprintf('Differential entropy:\n');

% 1. uniform distribution
uniform_pdf = @(x) (x >= a & x <= b) * (1 / (b - a));
uniform_entropy = @(a, b) log2(b - a);
fprintf('1. Uniform distribution:\n');
for b = b_values
    H_uniform = uniform_entropy(a, b);
    fprintf('a = %.1f, b = %.1f, Entropy = %.4f\n', a,b, H_uniform);
end

% 2. exponential distribution
exponential_pdf = @(x) (x >= 0) .* lambda .* exp(-lambda * x);
exponential_entropy = @(lambda) 1 - log2(lambda);
fprintf('2. Exponential distribution:\n');
for lambda = lambda_values
    H_exponential = exponential_entropy(lambda);
    fprintf('lambda = %.1f, Entropy = %.4f\n', lambda, H_exponential);
end

% 3. Distribuzione Gamma
gamma_pdf = @(x) (x >= 0) .* (1 / gamma(n)) .* (x.^(n - 1)) .* exp(-x);
gamma_entropy = @(n) (n + log(gamma(n)) + (1 - n) * psi(n))/log(2); % psi = funzione digamma
fprintf('3. Gamma distribution:\n');
for n = n_values
    H_gamma = gamma_entropy(n);
    fprintf('n = %.1f, Entropy = %.4f\n', n, H_gamma);
end

