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
    lambda = lambdas(i);
    
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
