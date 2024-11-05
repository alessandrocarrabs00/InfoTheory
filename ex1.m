classdef ex1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        LeftPanel                       matlab.ui.container.Panel
        RECALCULATEButton               matlab.ui.control.Button
        RangeofnEditField               matlab.ui.control.EditField
        RangeofnEditFieldLabel          matlab.ui.control.Label
        pnproportionaltoEditField       matlab.ui.control.EditField
        pnproportionaltoEditFieldLabel  matlab.ui.control.Label
        DiscreteentropycalculatorLabel  matlab.ui.control.Label
        EntropyEditField                matlab.ui.control.NumericEditField
        EntropyEditFieldLabel           matlab.ui.control.Label
        EXITButton                      matlab.ui.control.Button
        UIAxes                          matlab.ui.control.UIAxes
        RightPanel                      matlab.ui.container.Panel
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

 


    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: EXITButton
        function EXITButtonPushed(app, event)
            app.delete;
        end

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

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {480, 480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {628, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {628, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create UIAxes
            app.UIAxes = uiaxes(app.LeftPanel);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [311 148 300 185];

            % Create EXITButton
            app.EXITButton = uibutton(app.LeftPanel, 'push');
            app.EXITButton.ButtonPushedFcn = createCallbackFcn(app, @EXITButtonPushed, true);
            app.EXITButton.Position = [118 76 100 23];
            app.EXITButton.Text = 'EXIT';

            % Create EntropyEditFieldLabel
            app.EntropyEditFieldLabel = uilabel(app.LeftPanel);
            app.EntropyEditFieldLabel.HorizontalAlignment = 'right';
            app.EntropyEditFieldLabel.Position = [85 182 57 22];
            app.EntropyEditFieldLabel.Text = 'Entropy =';

            % Create EntropyEditField
            app.EntropyEditField = uieditfield(app.LeftPanel, 'numeric');
            app.EntropyEditField.Editable = 'off';
            app.EntropyEditField.Position = [157 182 100 22];

            % Create DiscreteentropycalculatorLabel
            app.DiscreteentropycalculatorLabel = uilabel(app.LeftPanel);
            app.DiscreteentropycalculatorLabel.FontSize = 36;
            app.DiscreteentropycalculatorLabel.FontWeight = 'bold';
            app.DiscreteentropycalculatorLabel.Position = [80 388 480 49];
            app.DiscreteentropycalculatorLabel.Text = 'Discrete entropy calculator';

            % Create pnproportionaltoEditFieldLabel
            app.pnproportionaltoEditFieldLabel = uilabel(app.LeftPanel);
            app.pnproportionaltoEditFieldLabel.HorizontalAlignment = 'right';
            app.pnproportionaltoEditFieldLabel.Position = [31 294 111 22];
            app.pnproportionaltoEditFieldLabel.Text = 'p(n) proportional to ';

            % Create pnproportionaltoEditField
            app.pnproportionaltoEditField = uieditfield(app.LeftPanel, 'text');
            app.pnproportionaltoEditField.Position = [157 294 100 22];

            % Create RangeofnEditFieldLabel
            app.RangeofnEditFieldLabel = uilabel(app.LeftPanel);
            app.RangeofnEditFieldLabel.HorizontalAlignment = 'right';
            app.RangeofnEditFieldLabel.Position = [78 240 64 22];
            app.RangeofnEditFieldLabel.Text = 'Range of n';

            % Create RangeofnEditField
            app.RangeofnEditField = uieditfield(app.LeftPanel, 'text');
            app.RangeofnEditField.Position = [157 240 100 22];

            % Create RECALCULATEButton
            app.RECALCULATEButton = uibutton(app.LeftPanel, 'push');
            app.RECALCULATEButton.ButtonPushedFcn = createCallbackFcn(app, @RECALCULATEButtonPushed, true);
            app.RECALCULATEButton.Position = [411 76 100 23];
            app.RECALCULATEButton.Text = 'RECALCULATE';

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ex1

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