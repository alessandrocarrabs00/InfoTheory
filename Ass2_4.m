%numerica non analitica

% Numero di parametri lambda casuali
num_lambdas = 4;

% Generazione di 4 valori casuali di lambda tra 0.1 e 2 (puoi adattare i limiti se necessario)
lambdas = 0.1 + (2 - 0.1) * rand(1, num_lambdas);

% Numero massimo di n per la somma
N = 100;

% Inizializza un vettore per memorizzare i risultati dell'entropia per ciascun lambda
entropies = zeros(1, num_lambdas);

% Calcolo dell'entropia per ciascun valore di lambda
for i = 1:num_lambdas
    lambda = 2;
    
    % Calcolo dell'entropia analitica
    % H = -log(1 - exp(-lambda)) + (lambda * exp(-lambda)) / ((1 - exp(-lambda))^2)
    term1 = -log(1 - exp(-lambda));
    term2 = (lambda * exp(-lambda)) / ((1 - exp(-lambda))^2);
    entropy = term1 + term2;
    
    % Salva il risultato
    entropies(i) = entropy;
end

% Visualizzazione dei risultati
disp('Valori di lambda:');
disp(lambdas);
disp('Entropie corrispondenti:');
disp(entropies);


% Impostazione dei parametri
exponent = -4;
N = 1000; % Limite superiore per l'approssimazione

% Calcolo delle probabilità proporzionali a n^exponent
n_values = 1:N;
p_values = n_values .^ exponent;

% Normalizzazione delle probabilità
p_values = p_values / sum(p_values);

% Calcolo dell'entropia
entropy1 = -sum(p_values .* log(p_values));

% Visualizzazione del risultato
disp(entropy1)


% Parametri
k = 1;
n_max = 1000; % Limite per n per approssimare l'infinito

% Calcolo della costante di normalizzazione Z
Z = 0;
for n = 0:n_max
    Z = Z + 1 / (1 + n^2)^k;
end

% Calcolo dell'entropia H
H = 0;
for n = 0:n_max
    p_n = 1 / (1 + n^2)^k / Z;
    H = H - p_n * log(p_n);
end

% Risultato dell'entropia
disp(H)
