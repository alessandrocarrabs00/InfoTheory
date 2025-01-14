clear all

% binary multiplication with row selection
function C = binaryMatrixMultiplication(A, B)
    [m, n] = size(A);
    [p, q] = size(B);
    A = double(A);
    B = double(B);

    C = zeros(m, q);
    
    for i = 1:m
        for j = 1:q
            % binary sum of the rows
            rowSum = 0; 
            for k = 1:n
                if A(i, k) == 1
                    rowSum = mod(rowSum + B(k, j), 2);
                end
            end

            C(i, j) = rowSum;
        end
    end
end

% decryption of a ciphertext block
function v = decrypt(G,H,S,P,y)
% error matrix
mat_e = [zeros(1,size(G, 2)); eye(size(G, 2))];
% syndrome matrix
mat_s = binaryMatrixMultiplication(mat_e,H);

y1=binaryMatrixMultiplication(y,inv(gf(P)).x);  % .x trasforma la matrice gf in una matrice normale

% apply syndrome decoding
s=binaryMatrixMultiplication(y1,H);
rowIndex = find(ismember(mat_s, s, 'rows'));
e_cap = mat_e(rowIndex,:);
c1 = mod(y1 + e_cap, 2); 

v1t = gflineq(G',c1',2);
v1 = v1t';

v = binaryMatrixMultiplication(v1,inv(gf(S)).x);
end


% matrix G
G = [1,1,0,0,0,1,1;1,0,1,0,0,1,0;1,0,1,1,0,0,1;0,1,0,0,1,1,0];
% matrix H
H = [1,0,0;1,1,1;1,0,1;0,1,1;1,1,0;0,0,1;0,1,0];
% matrix S
S = [0,1,0,1;0,1,0,0;1,1,1,0;1,0,0,0];
% matrix P
P = [0,0,0,0,0,0,1;0,0,1,0,0,0,0;0,0,0,1,0,0,0;1,0,0,0,0,0,0;0,1,0,0,0,0,0;0,0,0,0,0,1,0;0,0,0,0,1,0,0];
% ciphertext
cipher = [0,1,1,0,0,0,1,1,0,1,0,0,0,0,1,0,1,0,0,0,0,1,1,0,1,0,0,1,0,0,1,0,1,1,0,1,1,1,0,0,0,1,1,1,0,1,0,1,0,1,0,1,0,1,0,1,1,1,0,1,1,0,1,1,0,1,1,0,0,1,1,1,1,0,0,1,0,1,1,1,1,0,0,0];

t=1;


result = [];

% decrypt blocks of 7 elements of the ciphertext
for i = 1:7:length(cipher)
    % block of n=7 elements
    block = cipher(i:min(i+6, length(cipher)));
    % decrypt the block 
    decoded_block = decrypt(G, H, S, P, block);
    % append the new decoded block to the result
    result = [result, decoded_block];
end

decoded_string = '';

for i = 1:8:length(result)
    % extract a block of 8 elements
    vett = result(i:i+7);
    % convert binary to decimal
    lett = binaryVectorToDecimal(flip(vett));
    % convert decimal to ASCII
    decoded_string = [decoded_string, char(lett)];
end

disp('The city is:');
disp(decoded_string);

