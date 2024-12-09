classdef app3b_exported_final < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        CalculateButton                 matlab.ui.control.Button
        exitButton                      matlab.ui.control.Button
        Optinumdistortion10trialsLabel  matlab.ui.control.Label
        GlobalotimizazioniterationsEditField  matlab.ui.control.NumericEditField
        Label_2                         matlab.ui.control.Label
        SeedEditField                   matlab.ui.control.NumericEditField
        SeedEditFieldLabel              matlab.ui.control.Label
        numberofquantizationpointSpinner  matlab.ui.control.Spinner
        numberofquantizationpointSpinnerLabel  matlab.ui.control.Label
        rangeofxyEditField              matlab.ui.control.EditField
        Label                           matlab.ui.control.Label
        ResolutionEditField             matlab.ui.control.NumericEditField
        ResolutionEditFieldLabel        matlab.ui.control.Label
        PDFtonormalizedEditField        matlab.ui.control.EditField
        PDFtonormalizedEditFieldLabel   matlab.ui.control.Label
        RunningtimeLabel                matlab.ui.control.Label
        LBGalgorithmLabel               matlab.ui.control.Label
        UIAxes2                         matlab.ui.control.UIAxes
        UIAxes                          matlab.ui.control.UIAxes
    end

    
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
           app.GlobalotimizazioniterationsEditField.Value = 10; 
           app.SeedEditField.Value = 0; 
           app.numberofquantizationpointSpinner.Value = 7; 
           app.rangeofxyEditField.Value = "-2 2 -2 2"; 
           app.ResolutionEditField.Value = 100;
           app.PDFtonormalizedEditField.Value = "exp(-(x.^2 + y.^2)/2)"; 

           title(app.UIAxes, 'Distortion vs Iterations');
           xlabel(app.UIAxes, 'Iteration');
           ylabel(app.UIAxes, 'Distortion');

           title(app.UIAxes2, 'Quantization Result');
           xlabel(app.UIAxes2, 'X');
           ylabel(app.UIAxes2, 'Y');
            
           app.Optinumdistortion10trialsLabel.Text = sprintf('Optimum distortion = ');
          
           
           
 
        end

        % Button pushed function: exitButton
        function exitButtonPushed(app, event)
            app.delete; 
        end

        % Button pushed function: CalculateButton
        function CalculateButtonPushed(app, event)
% Retrieve user-defined parameters from the app interface
tic; 
pdf_formula = app.PDFtonormalizedEditField.Value; 
resolution = app.ResolutionEditField.Value;      
range = str2num(app.rangeofxyEditField.Value);   
n_c = app.numberofquantizationpointSpinner.Value; 
seed = app.SeedEditField.Value;                 
iterations = app.GlobalotimizazioniterationsEditField.Value; 


if length(range) ~= 4
    app.Optinumdistortion10trialsLabel.Text = "Error: range must have 4 values!";
    return;
end

% Extract x and y range boundaries
x0 = range(1); 
xn = range(2);
y0 = range(3); 
yn = range(4);

% Create x and y grid values based on resolution
i = 0:(resolution - 1);
j = 0:(resolution - 1);

% Generate a meshgrid for x and y
x = x0 + i / (resolution - 1) * (xn - x0); 
y = y0 + j / (resolution - 1) * (yn - y0);  
[x, y] = meshgrid(x, y);

try
    pdf = eval(pdf_formula);
    pdf = pdf / sum(pdf(:)); 
    disp(pdf);
catch ME
    app.Optinumdistortion10trialsLabel.Text = "Error: invalid PDF formula!";
    return;
end

% Flatten the PDF and grid points into vectors
pdf_v = pdf(:);
x_v = x(:);    
y_v = y(:);     

% Initialize centroids (random initial positions within the range)
c_x = rand(1, n_c) * (xn - x0) + x0; 
c_y = rand(1, n_c) * (yn - y0) + y0; 
% Initialize variables for distortion calculation
distortion_v = zeros(iterations, 1); 
best_distortion = inf; 

% Loop through the number of iterations (trials) (LBG algorithm main loop)
for i = 1:iterations
    
    % Initialize the distance matrix
    dist = zeros(numel(x), n_c);
    
    % Calculate distance between points and centroids
    for k = 1:n_c
        dist(:, k) = (x_v - c_x(k)).^2 + (y_v - c_y(k)).^2;
    end

    % Assign each point to the nearest centroid 
    [~, layers] = min(dist, [], 2); 
    
    % Update the centroids based on the assigned points
    for k = 1:n_c
        layer = (layers == k); % Logical mask for points assigned to centroid k

        if any(layer) % Check if there are any points assigned to this centroid
            tot_w = sum(pdf_v(layer)); % Total weight
            if tot_w > 0
                % Update centroid 
                c_x(k) = sum(x_v(layer) .* pdf_v(layer)) / tot_w; 
                c_y(k) = sum(y_v(layer) .* pdf_v(layer)) / tot_w; 
            end
        end
    end
    
    % Calculate the distortion 
    distortion = sum(pdf_v .* min(dist, [], 2));
    distortion_v(i) = distortion; 

    % Update the best distortion
    if distortion_v(i) < best_distortion 
        best_distortion = distortion_v(i); 
    end 
end


    plot(app.UIAxes, 1:iterations, distortion_v, '-o');
    title(app.UIAxes, 'Distortion vs Iterations');
    xlabel(app.UIAxes, 'Iteration');
    ylabel(app.UIAxes, 'Distortion');

    scatter(app.UIAxes2, c_x, c_y, resolution, 'r', 'filled');
    title(app.UIAxes2, 'Quantization Result');
    xlabel(app.UIAxes2, 'X');
    ylabel(app.UIAxes2, 'Y');


    
   app.Optinumdistortion10trialsLabel.Text = sprintf('Optimum distortion (%d trials) = %.4f',iterations, best_distortion);
    app.RunningtimeLabel.Text = sprintf('Running time: %.4f', toc);


% % Create Voronoi diagram for the centroids additional
% [vertices, cells] = voronoin([c_x(:), c_y(:)]);
% 
% % Plot Voronoi regions
% scatter(app.UIAxes2, c_x, c_y, resolution, 'r', 'filled'); % Plot centroids
% hold(app.UIAxes2, 'on');
% for k = 1:length(cells)
%     if all(cells{k} > 0) % Exclude cells at infinity
%         polygon = vertices(cells{k}, :);
%         fill(app.UIAxes2, polygon(:, 1), polygon(:, 2), 'cyan', 'FaceAlpha', 0.3, 'EdgeColor', 'blue');
%     end
% end
% hold(app.UIAxes2, 'off');
% 
% title(app.UIAxes2, 'Voronoi Diagram of Quantized Regions');
% xlabel(app.UIAxes2, 'X');
% ylabel(app.UIAxes2, 'Y');




        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 752 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'Trial number')
            ylabel(app.UIAxes, 'Distortion')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [317 350 412 101];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Title')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [366 68 314 262];

            % Create LBGalgorithmLabel
            app.LBGalgorithmLabel = uilabel(app.UIFigure);
            app.LBGalgorithmLabel.FontSize = 22;
            app.LBGalgorithmLabel.FontWeight = 'bold';
            app.LBGalgorithmLabel.Position = [50 407 158 44];
            app.LBGalgorithmLabel.Text = 'LBG algorithm';

            % Create RunningtimeLabel
            app.RunningtimeLabel = uilabel(app.UIFigure);
            app.RunningtimeLabel.Position = [106 367 170 22];
            app.RunningtimeLabel.Text = 'Running time:';

            % Create PDFtonormalizedEditFieldLabel
            app.PDFtonormalizedEditFieldLabel = uilabel(app.UIFigure);
            app.PDFtonormalizedEditFieldLabel.HorizontalAlignment = 'right';
            app.PDFtonormalizedEditFieldLabel.Position = [74 329 112 22];
            app.PDFtonormalizedEditFieldLabel.Text = 'PDF (to normalized)';

            % Create PDFtonormalizedEditField
            app.PDFtonormalizedEditField = uieditfield(app.UIFigure, 'text');
            app.PDFtonormalizedEditField.Position = [200 329 100 22];
            app.PDFtonormalizedEditField.Value = 'exp(-(x^2+y^2)/2';

            % Create ResolutionEditFieldLabel
            app.ResolutionEditFieldLabel = uilabel(app.UIFigure);
            app.ResolutionEditFieldLabel.HorizontalAlignment = 'right';
            app.ResolutionEditFieldLabel.Position = [123 285 62 22];
            app.ResolutionEditFieldLabel.Text = 'Resolution';

            % Create ResolutionEditField
            app.ResolutionEditField = uieditfield(app.UIFigure, 'numeric');
            app.ResolutionEditField.Position = [200 285 100 22];
            app.ResolutionEditField.Value = 100;

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'right';
            app.Label.Position = [106 242 79 22];
            app.Label.Text = 'range of (x, y)';

            % Create rangeofxyEditField
            app.rangeofxyEditField = uieditfield(app.UIFigure, 'text');
            app.rangeofxyEditField.Position = [200 242 100 22];
            app.rangeofxyEditField.Value = '-2 2 -2 2';

            % Create numberofquantizationpointSpinnerLabel
            app.numberofquantizationpointSpinnerLabel = uilabel(app.UIFigure);
            app.numberofquantizationpointSpinnerLabel.HorizontalAlignment = 'right';
            app.numberofquantizationpointSpinnerLabel.Position = [29 201 156 22];
            app.numberofquantizationpointSpinnerLabel.Text = 'number of quantization point';

            % Create numberofquantizationpointSpinner
            app.numberofquantizationpointSpinner = uispinner(app.UIFigure);
            app.numberofquantizationpointSpinner.Position = [200 201 100 22];
            app.numberofquantizationpointSpinner.Value = 7;

            % Create SeedEditFieldLabel
            app.SeedEditFieldLabel = uilabel(app.UIFigure);
            app.SeedEditFieldLabel.HorizontalAlignment = 'right';
            app.SeedEditFieldLabel.Position = [152 159 33 22];
            app.SeedEditFieldLabel.Text = 'Seed';

            % Create SeedEditField
            app.SeedEditField = uieditfield(app.UIFigure, 'numeric');
            app.SeedEditField.Position = [200 159 100 22];

            % Create Label_2
            app.Label_2 = uilabel(app.UIFigure);
            app.Label_2.HorizontalAlignment = 'right';
            app.Label_2.Position = [30 122 155 22];
            app.Label_2.Text = 'Global otimizazion iterations';

            % Create GlobalotimizazioniterationsEditField
            app.GlobalotimizazioniterationsEditField = uieditfield(app.UIFigure, 'numeric');
            app.GlobalotimizazioniterationsEditField.Position = [200 122 100 22];
            app.GlobalotimizazioniterationsEditField.Value = 10;

            % Create Optinumdistortion10trialsLabel
            app.Optinumdistortion10trialsLabel = uilabel(app.UIFigure);
            app.Optinumdistortion10trialsLabel.Position = [74 84 226 22];
            app.Optinumdistortion10trialsLabel.Text = 'Optinum distortion (10 trials) =';

            % Create exitButton
            app.exitButton = uibutton(app.UIFigure, 'push');
            app.exitButton.ButtonPushedFcn = createCallbackFcn(app, @exitButtonPushed, true);
            app.exitButton.Position = [30 23 100 23];
            app.exitButton.Text = 'exit';

            % Create CalculateButton
            app.CalculateButton = uibutton(app.UIFigure, 'push');
            app.CalculateButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateButtonPushed, true);
            app.CalculateButton.Position = [629 23 100 23];
            app.CalculateButton.Text = 'Calculate';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app3b_exported_final

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

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