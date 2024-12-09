classdef app1a_exported_final < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        EXITButton                      matlab.ui.control.Button
        RECALCULATEButton               matlab.ui.control.Button
        EntropyEditField                matlab.ui.control.NumericEditField
        EntropyEditFieldLabel           matlab.ui.control.Label
        RangeofnEditField               matlab.ui.control.EditField
        RangeofnEditFieldLabel          matlab.ui.control.Label
        pnproportionaltoEditField       matlab.ui.control.EditField
        pnproportionaltoEditFieldLabel  matlab.ui.control.Label
        DiscreteentropycalculatorLabel  matlab.ui.control.Label
        UIAxes                          matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: RECALCULATEButton
        function RECALCULATEButtonPushed(app, event)
                       
            % Ottieni e modifica la formula per p(n) per calcoli elemento per elemento
            formulaStringa = strrep(app.pnproportionaltoEditField.Value, '^', '.^');
    
            % Ottieni l'intervallo di n
            rangeText = app.RangeofnEditField.Value;
            rangeValues = split(rangeText, ',');
            nIniziale = str2double(rangeValues{1});
            nFinale = str2double(rangeValues{2});
    
            % Crea la funzione anonima con la formula modificata
            formulaVera = str2func(['@(n)', formulaStringa]);
    
            % Prealloca il vettore per le probabilità
            pvec = zeros(1, nFinale - nIniziale + 1);
    
            % Calcola ogni valore di p(n) con un ciclo
            idx = 1;
            for n = nIniziale:nFinale
                pvec(idx) = formulaVera(n);
                idx = idx + 1;
            end
    
            % Normalizza pvec per far sì che la somma sia 1
            pvec = pvec / sum(pvec);
            sum(pvec)
    
            % Calcola l'entropia
            entropia = -sum(pvec .* log2(pvec + eps));
            app.EntropyEditField.Value = entropia;
    
            % Visualizza i risultati nel grafico
            nValues = nIniziale:nFinale;
            plot(app.UIAxes, nValues, pvec, '-o');
            title(app.UIAxes, 'Probability Distribution p(n)');
            xlabel(app.UIAxes, 'n');
            ylabel(app.UIAxes, 'p(n)');

        end

        % Button pushed function: EXITButton
        function EXITButtonPushed(app, event)
            app.delete;
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

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [287 148 300 185];

            % Create DiscreteentropycalculatorLabel
            app.DiscreteentropycalculatorLabel = uilabel(app.UIFigure);
            app.DiscreteentropycalculatorLabel.HorizontalAlignment = 'center';
            app.DiscreteentropycalculatorLabel.FontSize = 24;
            app.DiscreteentropycalculatorLabel.FontWeight = 'bold';
            app.DiscreteentropycalculatorLabel.Position = [81 389 480 49];
            app.DiscreteentropycalculatorLabel.Text = 'Discrete entropy calculator';

            % Create pnproportionaltoEditFieldLabel
            app.pnproportionaltoEditFieldLabel = uilabel(app.UIFigure);
            app.pnproportionaltoEditFieldLabel.HorizontalAlignment = 'right';
            app.pnproportionaltoEditFieldLabel.Position = [7 294 111 22];
            app.pnproportionaltoEditFieldLabel.Text = 'p(n) proportional to ';

            % Create pnproportionaltoEditField
            app.pnproportionaltoEditField = uieditfield(app.UIFigure, 'text');
            app.pnproportionaltoEditField.Position = [133 294 100 22];
            app.pnproportionaltoEditField.Value = '1/(n^2+1)';

            % Create RangeofnEditFieldLabel
            app.RangeofnEditFieldLabel = uilabel(app.UIFigure);
            app.RangeofnEditFieldLabel.HorizontalAlignment = 'right';
            app.RangeofnEditFieldLabel.Position = [54 240 64 22];
            app.RangeofnEditFieldLabel.Text = 'Range of n';

            % Create RangeofnEditField
            app.RangeofnEditField = uieditfield(app.UIFigure, 'text');
            app.RangeofnEditField.Position = [133 240 100 22];
            app.RangeofnEditField.Value = '0,10';

            % Create EntropyEditFieldLabel
            app.EntropyEditFieldLabel = uilabel(app.UIFigure);
            app.EntropyEditFieldLabel.HorizontalAlignment = 'right';
            app.EntropyEditFieldLabel.Position = [61 182 57 22];
            app.EntropyEditFieldLabel.Text = 'Entropy =';

            % Create EntropyEditField
            app.EntropyEditField = uieditfield(app.UIFigure, 'numeric');
            app.EntropyEditField.Editable = 'off';
            app.EntropyEditField.Position = [133 182 100 22];

            % Create RECALCULATEButton
            app.RECALCULATEButton = uibutton(app.UIFigure, 'push');
            app.RECALCULATEButton.ButtonPushedFcn = createCallbackFcn(app, @RECALCULATEButtonPushed, true);
            app.RECALCULATEButton.Position = [387 76 100 23];
            app.RECALCULATEButton.Text = 'RECALCULATE';

            % Create EXITButton
            app.EXITButton = uibutton(app.UIFigure, 'push');
            app.EXITButton.ButtonPushedFcn = createCallbackFcn(app, @EXITButtonPushed, true);
            app.EXITButton.Position = [94 76 100 23];
            app.EXITButton.Text = 'EXIT';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1a_exported_final

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