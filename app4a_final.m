% PART A EXERCISE 4
N = 100; 
n = 0:N;
npos = 1:N;

% Problem 1: p(n) ∝ exp(-λn)
function H = entropy1(lambda)
    % Analytical solution for p(n) ∝ exp(-λn)
    exp_neg_lambda = exp(-lambda);
    % For simplicity we split the equation in two terms
    % First term: 
    term1 = -log2(1 - exp_neg_lambda);
    % Second term: 
    term2 = lambda * log2(exp(1)) * exp_neg_lambda  / (1-exp_neg_lambda);

    H = term1 + term2;
end

fprintf("Entropy of problem 1:\n")
lambda_values = [1, 2, 3];
for lambda = lambda_values
    H1 = entropy1(lambda);
    fprintf('Lambda = %.1f, Entropy = %.4f\n', lambda, H1);
end


% Problem 2: p(n) ∝ exp(-n^2)
% There isn't an analytical slution
% Compute the distribution p(n) ∝ exp(-n^2)
p2 = exp(-(n.^2));
% Normalize the distribution
p2n = p2 / sum(p2);
% Calculate entropy
H2 = -sum(p2n .* log2(p2n + eps));  % eps to avoid log2(0)

fprintf('Entropy of Problem 2: %.4f\n', H2);


% Problem 3: p(n) ∝ n^(-4)

% Compute the distribution p(n) ∝ n^(-4)
p3 = npos.^(-4);
% Normalize the distribution
p3n = p3 / sum(p3);
% Calculate entropy
H3 = -sum(p3n .* log2(p3n + eps));  % eps to avoid log2(0)
fprintf('Entropy of Problem 3: %.4f\n', H3);


% Problem 4: p(n) ∝ α^n
% there is convergence only for |α| < 1
function H = entropy4(alpha)
term1 = log2((1 - alpha) / alpha);
term2 = log2(alpha) / (1 - alpha);
H = -(term1 + term2);
end
% since the series is truncated implicitly, we use the 
% formula also for values of |α| >= 1
H4a=entropy4(0.2);
H4b=entropy4(0.5);
H4c=entropy4(0.9);
fprintf('Entropy of Problem 4: α=0.2 H=%.4f; α=0.5 H=%.4f; α=0.9 H=%.4f\n', H4a, H4b, H4c);


% Problem 5: p(n) ∝ (1 + n^2)^(-k), for k = 1 and k = 2
function H = entropy5(k,n)
    p = (1 + n.^2).^(-k);
    p_normalized = p / sum(p);
    H = -sum(p_normalized .* log2(p_normalized));
end

H_k1 = entropy5(1,n); % Entropia per k = 1
H_k2 = entropy5(2,n); % Entropia per k = 2

fprintf('Entropy of Problem 5:  k = 1  H=%.4f; k=2 H=%.4f\n', H_k1, H_k2);


