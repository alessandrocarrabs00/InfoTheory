classdef app3a_exported_final < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        UITable                         matlab.ui.control.Table
        HuffmanRateEditField            matlab.ui.control.EditField
        HuffmanRateEditFieldLabel       matlab.ui.control.Label
        EntropyRateEditField            matlab.ui.control.EditField
        EntropyRateEditFieldLabel       matlab.ui.control.Label
        RECALCULATEButton               matlab.ui.control.Button
        EXITButton                      matlab.ui.control.Button
        GroupingorderSpinner            matlab.ui.control.Spinner
        GroupingorderSpinnerLabel       matlab.ui.control.Label
        TextTextArea                    matlab.ui.control.TextArea
        TextTextAreaLabel               matlab.ui.control.Label
        TextentropyratecalculatorLabel  matlab.ui.control.Label
    end

    
    methods (Access = private)
        
        % Conta il numero di caratteri
        function numberChar = countChar(~, text)
            numberChar = strlength(text);
        end

        % Aggiunge gli spazi vuoti
        function textFinal = addSpace(app, text, numberChar, groupingOrder)
            if mod(numberChar, groupingOrder) ~= 0
                spaceToAdd = 0;
                spaceToAdd = groupingOrder - mod(numberChar, groupingOrder);
                textFinal = strcat(text, repmat('@', 1, spaceToAdd));
                numberChar = numberChar + spaceToAdd;
                textFinal = strrep(textFinal, '@', ' ');
                app.TextTextArea.Value = textFinal;
                textFinal = replace(textFinal, newline, ' ');
            else 
                textFinal = text;
                textFinal = replace(textFinal, newline, ' ');
            end
        end

        % Forma i gruppi 
        function [groupForChar, numGroups] = groupCostruction (~, textFinal, numberChar, groupingOrder)
            
            % Calcola il numero di gruppi
            numGroups = ceil(numberChar/groupingOrder);
            % Inizializza un array di celle per contenere i gruppi di caratteri
            groupForChar = cell(1, numGroups);
            % Popola l'array con gruppi di caratteri consecutivi
            for i = 1:1:numGroups
                start_index = (i - 1) * groupingOrder + 1;
                end_index = min(i * groupingOrder, strlength(textFinal));
                groupForChar{i} = extractBetween(textFinal, start_index, end_index);
            end
            for i = 1:1:numGroups
                disp(groupForChar{i});
            end
        end

        % Conta le frequenze di ciascun gruppo di caratteri
        function frequency = arrayOfChar(~, groupForChar)
            frequency = zeros(1, length(groupForChar));
            for i = 1:length(groupForChar)
                for m = 1:length(groupForChar)
                    if isequal(groupForChar{i}, groupForChar{m})
                        frequency(i) = frequency(i) + 1; 
                    end
                end
            end

        end

        % Calcola la probabilita che ci sia un certo gruppo di caratteri 
        function probability = probOfGroup(~, frequency, numGroups)
            %repetition = sum(frequency);
            for i = 1: length(frequency)
                probability(i) = frequency(i)/numGroups;
            end
        end

        % Calcolo entropia
        function entropyRate = entropyCalculate(~, probability)
            %entropyRate = 0;
            %for i = 1:length(probability)
            entropyRate = -sum(probability .* log2(probability));
            %entropyRate = entropyRate - (probability(i) * log(probability(i)));
            %end
        end

        % Presentazione nella tabella dei caratteri più frequenti
        function [topCombinations, topProbabilities] = calculateOfMostFrequency(~, probability, groupForChar)
            groupForChar = cellfun(@char, groupForChar, 'UniformOutput', false);
            [uniqueCombinations, uniqueIdx] = unique(groupForChar, 'stable'); 
            uniqueProbabilities = probability(uniqueIdx);

            [sortedProbabilities, sortIdx] = sort(uniqueProbabilities, 'descend');
            sortedCombinations = uniqueCombinations(sortIdx);
            topProbabilities = sortedProbabilities(1:4);
            topCombinations = sortedCombinations(1:4);

        end

        function displayTopProbabilities(app, groups, probabilities)
            % Ordinare le probabilità in ordine decrescente e ottenere gli indici
            [sortedProbabilities, sortIdx] = sort(probabilities, 'descend');
            sortedGroups = groups(sortIdx);  % Ordinare anche i gruppi in base agli indici
        
            % Determinare quanti gruppi mostrare (fino a 4, o meno se ce ne sono meno)
            numElementsToDisplay = min(4, length(groups));
        
            % Creare i gruppi e le probabilità da visualizzare
            topGroups = sortedGroups(1:numElementsToDisplay);
            topProbabilities = sortedProbabilities(1:numElementsToDisplay);

            % Aggiungi le virgolette ai gruppi
            topGroupsWithQuotes = cellfun(@(x) ['"' x '"'], topGroups, 'UniformOutput', false);
            % Format probabilità con 8 cifre decimali
            topProbabilitiesFormatted = arrayfun(@(x) sprintf('%.8f', x), topProbabilities, 'UniformOutput', false);

            % Aggiornare la tabella della GUI con i dati ordinati
            app.UITable.Data = [topGroupsWithQuotes', topProbabilitiesFormatted'];
        end

   function huffmanRate = calculateHuffmanRate(app, probabilities)
    % Funzione ricorsiva per calcolare il Huffman rate
    % Input: un vettore di probabilità
    % Output: il valore del Huffman rate

    % Caso base: se c'è solo una probabilità, ritorna 0 (nessun codice)
    if length(probabilities) == 1
        huffmanRate = 0;
        return;
    end
    
    % Passo 1: Ordinare le probabilità in ordine crescente
    probabilities = sort(probabilities);
    
    % Passo 2: Prendere le due probabilità più basse
    p1 = probabilities(1);
    p2 = probabilities(2);
    
    % Passo 3: Creare un nuovo nodo con la somma delle probabilità più basse
    newProb = p1 + p2;
    
    % Passo 4: Rimuovere le probabilità utilizzate e aggiungere il nuovo nodo
    probabilities = probabilities(3:end);  % Rimuove i primi due elementi
    probabilities = [probabilities, newProb];  % Aggiungi la somma
    
    % Passo 5: Chiamata ricorsiva con il nuovo vettore di probabilità
    huffmanRate = calculateHuffmanRate(app, probabilities);
    
    % Aggiungere la lunghezza dei codici per p1 e p2 (1 bit ciascuno)
    huffmanRate = huffmanRate + (p1 * 1) + (p2 * 1); % Lunghezza del codice per p1 e p2
end




    end
    



    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: EXITButton
        function EXITButtonPushed(app, event)
            app.delete
        end

        % Button pushed function: RECALCULATEButton
        function RECALCULATEButtonPushed(app, event)
            text = app.TextTextArea.Value;
            groupingOrder = app.GroupingorderSpinner.Value;

            % Conta il numero di caratteri
            numberChar = countChar(app, text);

            % Aggiungo spazi
            textFinal = addSpace(app, text, numberChar, groupingOrder);

            % Vengono formati i gruppi
            [groupForChar, numGroups] = groupCostruction(app, textFinal, numberChar, groupingOrder);

            % Per calcolare la frequenza
            frequency = arrayOfChar(app, groupForChar);
            disp(frequency);


            %trovo i gruppi unici
            groupForChar = cellfun(@char, groupForChar, 'UniformOutput', false);
            [uniqueGroups, idx] = unique(groupForChar, 'stable');
            %trovo le frequenze corrispondenti
            uniqueFrequencies = frequency(idx);
            % Visualizza i risultati
            disp('Gruppi unici:');
            disp(uniqueGroups);
            disp('Frequenze associate:');
            disp(uniqueFrequencies);


            % Calcolo probabilità che ci sia ciascun gruppo di caratteri
            probability = probOfGroup(app, uniqueFrequencies, numGroups);
            disp(probability);
            
            sumProbabilities = sum(probability);
            disp(['La somma delle probabilità è: ', num2str(sumProbabilities)]);

        
            % Calcolo Entropy Rate
            entropyRate = entropyCalculate(app, probability);
            app.EntropyRateEditField.Value = char(string(entropyRate/groupingOrder));
            
            displayTopProbabilities(app, uniqueGroups, probability);
        
            disp('Tipo di probabilità:');
            disp(class(probability));
            disp('Dimensione delle probabilità:');
            disp(size(probability));

            huffRate = calculateHuffmanRate(app, probability);
            disp('Huff rate:');
            disp(huffRate/groupingOrder);
            app.HuffmanRateEditField.Value = char(string(huffRate/groupingOrder));
           
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create TextentropyratecalculatorLabel
            app.TextentropyratecalculatorLabel = uilabel(app.UIFigure);
            app.TextentropyratecalculatorLabel.FontSize = 24;
            app.TextentropyratecalculatorLabel.FontWeight = 'bold';
            app.TextentropyratecalculatorLabel.Position = [159 398 323 33];
            app.TextentropyratecalculatorLabel.Text = 'Text entropy rate calculator';

            % Create TextTextAreaLabel
            app.TextTextAreaLabel = uilabel(app.UIFigure);
            app.TextTextAreaLabel.HorizontalAlignment = 'right';
            app.TextTextAreaLabel.Position = [40 365 27 22];
            app.TextTextAreaLabel.Text = 'Text';

            % Create TextTextArea
            app.TextTextArea = uitextarea(app.UIFigure);
            app.TextTextArea.Position = [112 235 502 152];
            app.TextTextArea.Value = {'Sir Isaac Newton (1642–1727) was an English mathematician, physicist, astronomer, and key figure in the scientific revolution. Born in Woolsthorpe, Lincolnshire, Newton is best known for formulating the laws of motion and universal gravitation, which laid the foundation for classical mechanics. His book *Philosophiæ Naturalis Principia Mathematica* (1687), often referred to as the *Principia*, is considered one of the most important works in the history of science. Newton also made significant contributions to mathematics, including the development of calculus (independently of Leibniz), and optics, where he studied the nature of light and color. He served as the president of the Royal Society and held a position as Master of the Royal Mint. Newton’s work transformed the understanding of the physical world and deeply influenced later scientific inquiry.'};

            % Create GroupingorderSpinnerLabel
            app.GroupingorderSpinnerLabel = uilabel(app.UIFigure);
            app.GroupingorderSpinnerLabel.HorizontalAlignment = 'right';
            app.GroupingorderSpinnerLabel.Position = [42 183 90 22];
            app.GroupingorderSpinnerLabel.Text = 'Grouping order ';

            % Create GroupingorderSpinner
            app.GroupingorderSpinner = uispinner(app.UIFigure);
            app.GroupingorderSpinner.Position = [147 183 100 22];
            app.GroupingorderSpinner.Value = 3;

            % Create EXITButton
            app.EXITButton = uibutton(app.UIFigure, 'push');
            app.EXITButton.ButtonPushedFcn = createCallbackFcn(app, @EXITButtonPushed, true);
            app.EXITButton.Position = [40 31 100 23];
            app.EXITButton.Text = 'EXIT';

            % Create RECALCULATEButton
            app.RECALCULATEButton = uibutton(app.UIFigure, 'push');
            app.RECALCULATEButton.ButtonPushedFcn = createCallbackFcn(app, @RECALCULATEButtonPushed, true);
            app.RECALCULATEButton.Position = [184 31 100 23];
            app.RECALCULATEButton.Text = 'RECALCULATE';

            % Create EntropyRateEditFieldLabel
            app.EntropyRateEditFieldLabel = uilabel(app.UIFigure);
            app.EntropyRateEditFieldLabel.HorizontalAlignment = 'right';
            app.EntropyRateEditFieldLabel.Position = [57 131 75 22];
            app.EntropyRateEditFieldLabel.Text = 'Entropy Rate';

            % Create EntropyRateEditField
            app.EntropyRateEditField = uieditfield(app.UIFigure, 'text');
            app.EntropyRateEditField.Position = [147 131 100 22];

            % Create HuffmanRateEditFieldLabel
            app.HuffmanRateEditFieldLabel = uilabel(app.UIFigure);
            app.HuffmanRateEditFieldLabel.HorizontalAlignment = 'right';
            app.HuffmanRateEditFieldLabel.Position = [53 83 79 22];
            app.HuffmanRateEditFieldLabel.Text = 'Huffman Rate';

            % Create HuffmanRateEditField
            app.HuffmanRateEditField = uieditfield(app.UIFigure, 'text');
            app.HuffmanRateEditField.Position = [147 83 100 22];

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Word'; 'Probability'};
            app.UITable.RowName = {};
            app.UITable.Position = [312 83 302 122];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app3a_exported_final

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end