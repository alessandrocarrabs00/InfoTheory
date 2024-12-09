classdef app2_exported_final < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        p_infinityEditField       matlab.ui.control.EditField
        p_infinityEditFieldLabel  matlab.ui.control.Label
        ProbabilitymatrixPtobenormalizedEditField  matlab.ui.control.EditField
        ProbabilitymatrixPtobenormalizedEditFieldLabel  matlab.ui.control.Label
        RECALCULATEButton         matlab.ui.control.Button
        EXITButton                matlab.ui.control.Button
        Calculationofp_infinityfromPLabel  matlab.ui.control.Label
    end

    
    methods (Access = private)
        
        % Function that normalizes each row of the inputted matrix
        function matrix = normalizeMatrix(~, matrix)
            for i =1:1:length(matrix)
                matrix(i, :) = matrix(i,:)./sum(matrix(i,:));
            end
        end

        function matrix = modifyPMatrix(~, matrix)
            matrix = eye(length(matrix)) - matrix';
            matrix(1,:) = ones(1,length(matrix));
        end

        function matrix = calculatePInfinity(~, matrix)
            b = zeros(length(matrix), 1);
            b(1) = 1;
            matrix = pinv(matrix)*b;
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: EXITButton
        function EXITButtonPushed(app, event)
            app.delete;
        end

        % Button pushed function: RECALCULATEButton
        function RECALCULATEButtonPushed(app, event)
            matrix = str2num(app.ProbabilitymatrixPtobenormalizedEditField.Value);
           
            matrix = normalizeMatrix(app, matrix);
            
            matrix = modifyPMatrix(app, matrix);

            matrix = calculatePInfinity(app, matrix);

            result = round(matrix, 5)

            app.p_infinityEditField.Value = mat2str(result);
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

            % Create Calculationofp_infinityfromPLabel
            app.Calculationofp_infinityfromPLabel = uilabel(app.UIFigure);
            app.Calculationofp_infinityfromPLabel.FontSize = 24;
            app.Calculationofp_infinityfromPLabel.FontWeight = 'bold';
            app.Calculationofp_infinityfromPLabel.Position = [136 377 369 33];
            app.Calculationofp_infinityfromPLabel.Text = 'Calculation of p_infinity  from P';

            % Create EXITButton
            app.EXITButton = uibutton(app.UIFigure, 'push');
            app.EXITButton.ButtonPushedFcn = createCallbackFcn(app, @EXITButtonPushed, true);
            app.EXITButton.Position = [101 102 100 23];
            app.EXITButton.Text = 'EXIT';

            % Create RECALCULATEButton
            app.RECALCULATEButton = uibutton(app.UIFigure, 'push');
            app.RECALCULATEButton.ButtonPushedFcn = createCallbackFcn(app, @RECALCULATEButtonPushed, true);
            app.RECALCULATEButton.Position = [441 102 100 23];
            app.RECALCULATEButton.Text = 'RECALCULATE';

            % Create ProbabilitymatrixPtobenormalizedEditFieldLabel
            app.ProbabilitymatrixPtobenormalizedEditFieldLabel = uilabel(app.UIFigure);
            app.ProbabilitymatrixPtobenormalizedEditFieldLabel.HorizontalAlignment = 'right';
            app.ProbabilitymatrixPtobenormalizedEditFieldLabel.Position = [101 284 210 22];
            app.ProbabilitymatrixPtobenormalizedEditFieldLabel.Text = 'Probability matrix P (to be normalized)';

            % Create ProbabilitymatrixPtobenormalizedEditField
            app.ProbabilitymatrixPtobenormalizedEditField = uieditfield(app.UIFigure, 'text');
            app.ProbabilitymatrixPtobenormalizedEditField.Position = [342 284 199 22];
            app.ProbabilitymatrixPtobenormalizedEditField.Value = '[1, 3; 2, 8]';

            % Create p_infinityEditFieldLabel
            app.p_infinityEditFieldLabel = uilabel(app.UIFigure);
            app.p_infinityEditFieldLabel.HorizontalAlignment = 'right';
            app.p_infinityEditFieldLabel.Position = [258 213 53 22];
            app.p_infinityEditFieldLabel.Text = 'p_infinity';

            % Create p_infinityEditField
            app.p_infinityEditField = uieditfield(app.UIFigure, 'text');
            app.p_infinityEditField.Editable = 'off';
            app.p_infinityEditField.Position = [344 213 197 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app2_exported_final

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