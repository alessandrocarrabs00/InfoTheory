classdef app2b_exported_final < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        OptimumdistorsionLabel          matlab.ui.control.Label
        RangeofxabEditField_2           matlab.ui.control.EditField
        RangeofxabEditField_2Label      matlab.ui.control.Label
        PDFofXEditField_2               matlab.ui.control.EditField
        PDFofXEditField_2Label          matlab.ui.control.Label
        CalculateButton                 matlab.ui.control.Button
        NumofquantizationpointsSpinner  matlab.ui.control.Spinner
        NumofquantizationpointsSpinnerLabel  matlab.ui.control.Label
        UITable                         matlab.ui.control.Table
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CalculateButton
        function CalculateButtonPushed(app, event)
 
    % read the formula from the input box
    formulaStringa = app.PDFofXEditField_2.Value;
    formulaStringa = strrep(formulaStringa, '^', '.^');
    formulaStringa = strrep(formulaStringa, '*', '.*');
    formulaStringa = strrep(formulaStringa, '/', './');
    disp(['Formula: ', formulaStringa]);
    fX = str2func(['@(x)', formulaStringa]);

    % read the range from the input box
    rangeText = app.RangeofxabEditField_2.Value;
    rangeValues = split(rangeText, ',');
    nIniziale = str2double(rangeValues{1});
    nFinale = str2double(rangeValues{2});
    range = [nIniziale, nFinale];

     % normalize function fX(x)
    integralValue = integral(fX, nIniziale, nFinale);
    normalizationFactor = 1 / integralValue;
    fX_normalized = @(x) fX(x) * normalizationFactor;
    
    % now we're going to use the normalized function for the computations

    % read the # of quantization point from input
    nq = app.NumofquantizationpointsSpinner.Value;


    % initialize the quantized values
    stepSize = (nFinale - nIniziale) / (nq + 1)
    pq = nIniziale + stepSize * (1:nq)
    

    max_iter = 1000;  % max # of iterations
    toll = 1e-6;    % tolerance for convergence
    pq_prev = pq   % initial values of pq



    for iter = 1:max_iter
        % save the previous centroids values
        pq_prev = pq;
        
        % compute the thresholds t
        t = [(pq(1:end-1) + pq(2:end)) / 2];
        t = [nIniziale, t, nFinale]; 
        
        % initialize distorsion
        distorsione = 0;

        % compute the new centroids
        new_pq = zeros(1, length(pq));  % initialize the vector for new centroids
        for i = 1:length(pq)
            t0 = t(i);     % lower threshold
            t1 = t(i+1);   % upper threshold
    
            % compute the centroid
            num = integral(@(x) x .* fX_normalized(x), t0, t1); 
            den = integral(@(x) fX_normalized(x), t0, t1);     
            new_pq(i) = num / den;
            
            % compute the distorsion
            distorsione = distorsione + integral(@(x) (x - new_pq(i)).^2 .* fX_normalized(x), t0, t1)
        end
        
        
        % check convergence
        if max(abs(new_pq - pq_prev)) < toll
            break;
        end
        
        % update centroid values for next iteration
        pq = new_pq 
        disp(pq)
    end

    app.UITable.Data = pq'; 
    app.OptimumdistorsionLabel.Text = sprintf('Optimum distortion: %.5f', distorsione);



          
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 629 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Quantization Points'};
            app.UITable.RowName = {};
            app.UITable.Position = [377 187 173 197];

            % Create NumofquantizationpointsSpinnerLabel
            app.NumofquantizationpointsSpinnerLabel = uilabel(app.UIFigure);
            app.NumofquantizationpointsSpinnerLabel.HorizontalAlignment = 'right';
            app.NumofquantizationpointsSpinnerLabel.Position = [32 251 150 22];
            app.NumofquantizationpointsSpinnerLabel.Text = 'Num. of quantization points';

            % Create NumofquantizationpointsSpinner
            app.NumofquantizationpointsSpinner = uispinner(app.UIFigure);
            app.NumofquantizationpointsSpinner.Position = [197 251 100 22];

            % Create CalculateButton
            app.CalculateButton = uibutton(app.UIFigure, 'push');
            app.CalculateButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateButtonPushed, true);
            app.CalculateButton.Position = [148 108 100 22];
            app.CalculateButton.Text = 'Calculate';

            % Create PDFofXEditField_2Label
            app.PDFofXEditField_2Label = uilabel(app.UIFigure);
            app.PDFofXEditField_2Label.HorizontalAlignment = 'right';
            app.PDFofXEditField_2Label.Position = [128 353 54 22];
            app.PDFofXEditField_2Label.Text = 'PDF of X';

            % Create PDFofXEditField_2
            app.PDFofXEditField_2 = uieditfield(app.UIFigure, 'text');
            app.PDFofXEditField_2.Position = [197 353 100 22];
            app.PDFofXEditField_2.Value = 'exp(-x^2/2)';

            % Create RangeofxabEditField_2Label
            app.RangeofxabEditField_2Label = uilabel(app.UIFigure);
            app.RangeofxabEditField_2Label.HorizontalAlignment = 'right';
            app.RangeofxabEditField_2Label.Position = [94 305 88 22];
            app.RangeofxabEditField_2Label.Text = 'Range of x(a,b)';

            % Create RangeofxabEditField_2
            app.RangeofxabEditField_2 = uieditfield(app.UIFigure, 'text');
            app.RangeofxabEditField_2.Position = [197 305 100 22];
            app.RangeofxabEditField_2.Value = '-10,10';

            % Create OptimumdistorsionLabel
            app.OptimumdistorsionLabel = uilabel(app.UIFigure);
            app.OptimumdistorsionLabel.Position = [70 187 227 22];
            app.OptimumdistorsionLabel.Text = 'Optimum distorsion:';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app2b_exported_final

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