classdef app1exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        DiscreteentropycalculatorLabel  matlab.ui.control.Label
        EXITButton                      matlab.ui.control.Button
        CALCULATEButton                 matlab.ui.control.Button
        DiffentropyEditField            matlab.ui.control.EditField
        DiffentropyEditFieldLabel       matlab.ui.control.Label
        RangeofxEditField               matlab.ui.control.EditField
        RangeofxEditFieldLabel          matlab.ui.control.Label
        f_XxproportionaltoEditField     matlab.ui.control.EditField
        f_XxproportionaltoLabel         matlab.ui.control.Label
        UIAxes                          matlab.ui.control.UIAxes
    end


    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CALCULATEButton
        function CALCULATEButtonPushed(app, event)
            
    formulaStringa = strrep(app.f_XxproportionaltoEditField.Value, '^', '.^');
    formulaStringa = strrep(formulaStringa, '*', '.*');
    formulaStringa = strrep(formulaStringa, '/', './');
    disp(formulaStringa)

    % Range values splitting
    rangeText = app.RangeofxEditField.Value;
    rangeValues = split(rangeText, ',');
    nIniziale = str2double(rangeValues{1});
    nFinale = str2double(rangeValues{2});

    try
        f = str2func(['@(x) ' formulaStringa]);
        
        % Normalizzazione 
        normalizationFactor = integral(f, nIniziale, nFinale);
        if normalizationFactor == 0
            uialert(app.UIFigure, 'La funzione non può essere normalizzata', 'Errore');
            return;
        end
        f_normalized = @(x) f(x) / normalizationFactor; % Funzione normalizzata
        
        % Differential entropy func
        entropyFunc = @(x) -f_normalized(x) .* log2(f_normalized(x));
        
        % Integral function
        integralValue = integral(entropyFunc, nIniziale, nFinale);
    catch
        %In case of errors
        uialert(app.UIFigure, 'Errore nel calcolo dell''integrale!', 'Errore');
        return;
    end

    %Result
    app.DiffentropyEditField.Value = num2str(integralValue);




    %plot
    x = linspace(nIniziale, nFinale, 1000); % 1000 punti nell'intervallo
    y = f_normalized(x); % Valori della funzione normalizzata
    
    plot(app.UIAxes, x, y, 'LineWidth', 1.5);
    title(app.UIAxes, 'Normalized probability distribution function');
    xlabel(app.UIAxes, 'x');
    ylabel(app.UIAxes, 'f_Xnorm(x)');
    grid(app.UIAxes, 'on');











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
            title(app.UIAxes, 'Normalized probability distribution function')
            xlabel(app.UIAxes, 'x')
            ylabel(app.UIAxes, 'f_Xnorm(x)')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.FontSize = 10;
            app.UIAxes.TitleFontWeight = 'normal';
            app.UIAxes.Position = [308 161 300 189];

            % Create f_XxproportionaltoLabel
            app.f_XxproportionaltoLabel = uilabel(app.UIFigure);
            app.f_XxproportionaltoLabel.HorizontalAlignment = 'right';
            app.f_XxproportionaltoLabel.Position = [23 282 124 22];
            app.f_XxproportionaltoLabel.Text = 'f_X(x) proportional to: ';

            % Create f_XxproportionaltoEditField
            app.f_XxproportionaltoEditField = uieditfield(app.UIFigure, 'text');
            app.f_XxproportionaltoEditField.Position = [162 282 100 22];
            app.f_XxproportionaltoEditField.Value = '1/(x^2+1)';

            % Create RangeofxEditFieldLabel
            app.RangeofxEditFieldLabel = uilabel(app.UIFigure);
            app.RangeofxEditFieldLabel.HorizontalAlignment = 'right';
            app.RangeofxEditFieldLabel.Position = [55 242 60 22];
            app.RangeofxEditFieldLabel.Text = 'Range of x';

            % Create RangeofxEditField
            app.RangeofxEditField = uieditfield(app.UIFigure, 'text');
            app.RangeofxEditField.Position = [162 242 100 22];
            app.RangeofxEditField.Value = '0,10';

            % Create DiffentropyEditFieldLabel
            app.DiffentropyEditFieldLabel = uilabel(app.UIFigure);
            app.DiffentropyEditFieldLabel.HorizontalAlignment = 'right';
            app.DiffentropyEditFieldLabel.Position = [43 175 83 22];
            app.DiffentropyEditFieldLabel.Text = 'Diff. entropy = ';

            % Create DiffentropyEditField
            app.DiffentropyEditField = uieditfield(app.UIFigure, 'text');
            app.DiffentropyEditField.Position = [162 175 100 22];

            % Create CALCULATEButton
            app.CALCULATEButton = uibutton(app.UIFigure, 'push');
            app.CALCULATEButton.ButtonPushedFcn = createCallbackFcn(app, @CALCULATEButtonPushed, true);
            app.CALCULATEButton.Position = [103 88 100 23];
            app.CALCULATEButton.Text = 'CALCULATE';

            % Create EXITButton
            app.EXITButton = uibutton(app.UIFigure, 'push');
            app.EXITButton.ButtonPushedFcn = createCallbackFcn(app, @EXITButtonPushed, true);
            app.EXITButton.Position = [408 88 100 23];
            app.EXITButton.Text = 'EXIT';

            % Create DiscreteentropycalculatorLabel
            app.DiscreteentropycalculatorLabel = uilabel(app.UIFigure);
            app.DiscreteentropycalculatorLabel.FontSize = 24;
            app.DiscreteentropycalculatorLabel.FontWeight = 'bold';
            app.DiscreteentropycalculatorLabel.Position = [162 385 317 59];
            app.DiscreteentropycalculatorLabel.Text = 'Discrete entropy calculator';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1exported

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