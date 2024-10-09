curves_csv = dir(fullfile("thrust_curves/", '*.csv'));

filename = sort({curves_csv.name});

% Read csv data into cell array of matrices (FOR DATA)
curves = cellfun(@readmatrix, filename, 'UniformOutput', false);

% Read csv data into cell array of matrices (ONLY FOR AUTO NAME EXTRACTION)
motor_names = cellfun(@(x) readtable(x, 'VariableNamingRule', 'preserve'), ...
    filename, 'UniformOutput', false);


% Iterate through all motors
for k = 1:size(curves, 2)
    % Add force = 0N @ t=0
    curves{k} = [0 0; curves{k}]; 
    
    % Reduce motor_names to just the names extracted from variables
    motor_names{k} = motor_names{1, k}.Properties.VariableNames{2};
end

% Default selection to 1
motor_selection = 1;