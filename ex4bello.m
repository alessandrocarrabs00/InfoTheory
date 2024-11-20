% ESERCIZIO 4
% Imposta un grande valore N per approssimare la somma infinita
N = 100; % Puoi cambiare N per migliorare la precisione
n = 0:N;


% Problema 1: p(n) ∝ exp(-λn)
function H = theoretical_entropy(lambda)
    % Calcolo dell'entropia teorica per p(n) ∝ exp(-lambda * n)
    exp_neg_lambda = exp(-lambda);  % Calcolo di exp(-lambda)
    log2_factor = 1 / log(2);       % Conversione da logaritmo naturale a base 2

    % Primo termine: -log2(1 - exp(-lambda))
    term1 = -log2(1 - exp_neg_lambda);
    % Secondo termine: (lambda * exp(-lambda)) / ((1 - exp(-lambda)) * ln(2))
    term2 = (lambda * exp_neg_lambda) / ((1 - exp_neg_lambda) * log(2));

    % Somma dei termini
    H = term1 + term2;
end

%implementazione:
lambda_values = [1, 2, 3];
for lambda = lambda_values
    H = theoretical_entropy(lambda);
    fprintf('Lambda = %.1f, Entropy = %.4f\n', lambda, H);
end


% Problem 2: p(n) ∝ exp(-n^2)
% There isn't an analytical solution
% Calcolo della distribuzione p(n) ∝ exp(-n^2)
p2 = exp(-(n.^2));
% Normalizzazione della distribuzione
p2n = p2 / sum(p2);
% Calcolo dell'entropia
H2 = -sum(p2n .* log2(p2n + eps));  % eps aggiunge una piccola costante per evitare log2(0)

% Visualizzazione del risultato
fprintf('Entropy of Problem 2: %.4f\n', H2);


% Problem 3: p(n) ∝ n^(-4)
% Definizione della costante Zeta(4) (funzione zeta di Riemann per s = 4)
zeta_4 = pi^4 / 90;
% Calcolo della costante -log(90 / pi^4)
log_term = -log(90 / pi^4);

% Somma numerica per la seconda parte dell'entropia: somma(n^(-4) * log(n))
sum_log_n = 0;
for n = 1:N
    sum_log_n = sum_log_n + (n^(-4)) * log(n);
end

% Calcolo dell'entropia analitica
H_analytical = log_term + 4 * sum_log_n * (90 / pi^4);
% Stampa del risultato
fprintf('Entropy of Problem 3: %.4f\n', H_analytical);


% Problem 4: p(n) ∝ α^n
% per la normalizzazione, la serie converge solo se |α| < 1
% se |α| < 1, probabilità normalizzata = (1 - alfa)*alfa^n
function H4 = entropy4(alpha)
term1 = log(1 - alpha) / log(2);
term2 = (alpha * log(alpha)) / ((1 - alpha) * log(2));
H4 = -(term1 + term2);
end

H4a=entropy4(0.2);
H4b=entropy4(0.9);
fprintf('Entropy of Problem 4: α=0.2 H=%.4f; α=0.9 H=%.4f\n', H4a, H4b);


% Problem 5: p(n) ∝ (1 + n^2)^(-k), per k = 1 e k = 2
function H = entropy5(k, N)
    % Calcola la costante di normalizzazione C_k
    n = 0:N; % Valori di n
    p = (1 + n.^2).^(-k); % Funzione di probabilità non normalizzata
    
    C_k = sum(p); % Somma per ottenere la costante di normalizzazione
    p_normalized = p / C_k; % Normalizzazione della distribuzione
    
    % L'entropia finale
    H = -sum(p_normalized .* log2(p_normalized));  % Correzione, rimuovendo il termine log(C_k) fuori
end
N = 100; % Numero massimo di termini nella somma
H_k1 = entropy5(1, N); % Entropia per k = 1
H_k2 = entropy5(2, N); % Entropia per k = 2

fprintf('Entropy for k = 1: %.4f\n', H_k1);
fprintf('Entropy for k = 2: %.4f\n', H_k2);

