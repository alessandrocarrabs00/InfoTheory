N = 100; 
n = 0:N;

% Problem 1: p(n) ∝ exp(-λn)

function H1 = entropy1(lambda)
term1 = ((exp(lambda) - 1) * exp(-lambda) / log(2)) * (log(exp(lambda) - 1) / (1 - exp(-lambda)));
term2 = ((exp(lambda) - 1) * exp(-lambda) * lambda / log(2)) / ((1 - exp(-lambda))^2);
H1 = term2 - term1;
end

H1a = entropy1(1);
H1b = entropy1(2);
H1c = entropy1(3);

% Display results
fprintf('Entropy of Problem 1: λ=1 H=%.4f; λ=2 H=%.4f; λ=2 H=%.4f\n', H1a, H1b, H1c);


% Problem 2: p(n) ∝ exp(-n^2)
% There isn't an analytical solution

p2 = exp(-(n.^2));
p2n = p2 / sum(p2); % normalization
H2 = -sum(p2n .* log2(p2n + eps));

fprintf('Entropy of Problem 2: %.4f\n', H2);


% Problem 3: p(n) ∝ n^(-4)
% normalized probability = (90 / pi^4) * p
%probably numerical

% Impostazione dei parametri
exponent = -4;
N = 1000; % Limite superiore per l'approssimazione

% Calcolo delle probabilità proporzionali a n^exponent
n_values = 1:N;
p_values = n_values .^ exponent;

% Normalizzazione delle probabilità
p_values = p_values / sum(p_values);

H3 = -sum(p_values .* log(p_values));

fprintf('Entropy of Problem 3: %.4f\n', H3);

% Problem 4: p(n) ∝ α^n
% per la normalizzazione, la serie converge solo se |α| < 1

% se |α| < 1, probabilità normalizzata = (1 - alfa)*alfa^n
alpha=0.2;

function H4 = entropy4(alpha)
term1 = log(1 - alpha) / log(2);
term2 = (alpha * log(alpha)) / ((1 - alpha) * log(2));
H4 = -(term1 + term2);
end

H4a=entropy4(0.2);
H4b=entropy4(0.9);
fprintf('Entropy of Problem 4: α=0.2 H=%.4f; α=0.7 H=%.4f %.4f\n', H4a, H4b);








