function Prototype_7_LR()

% Load data from file
data = readtable('./Testing Data/testing_data.csv');
heartRateData = data.HeartRate;
walkingRateData = data.WalkingRate;

% Get screen size for full-screen figure
screenSize = get(0, 'ScreenSize');

% Create figure and subplots
fig = figure('Name', 'GAIT Analysis Simulation', 'Position', screenSize, 'WindowState', 'maximized', 'Color', [0.94 0.94 0.94]);
ax_heartbeat = subplot(2, 1, 1, 'Color', [0.85 0.85 0.85]);
ax_walking = subplot(2, 1, 2, 'Color', [0.85 0.85 0.85]);

% Set properties for heart rate plot
title(ax_heartbeat, 'Heart Rate Simulation');
ylabel(ax_heartbeat, 'Heart Rate (bpm)');
grid(ax_heartbeat, 'on');

% Set properties for walking rate plot
title(ax_walking, 'Walking Rate Simulation');
xlabel(ax_walking, 'Time (seconds)');
ylabel(ax_walking, 'Walking Rate (steps/min)');
grid(ax_walking, 'on');

% Create Start button
startButton = uicontrol('Style', 'pushbutton', 'String', 'Start', ...
    'Position', [20 20 60 30], 'Callback', @startSimulation, 'BackgroundColor', 'g', 'ForegroundColor', 'w', 'FontWeight', 'bold');

% Create conclusion labels for the system
conclusionLabel_activity = uicontrol('Style', 'text', 'String', 'Activity will be shown here', ...
    'Position', [800 2 300 20], 'BackgroundColor', [0.85 0.85 0.85], 'FontSize', 10, 'HorizontalAlignment', 'left');

% Create conclusion labels for each plot
conclusionLabel_heartbeat = uicontrol('Style', 'text', 'String', 'Press start button to analyze', ...
    'Position', [1190 435 200 20], 'BackgroundColor', [0.85 0.85 0.85], 'FontSize', 10, 'HorizontalAlignment', 'left');
conclusionLabel_walking = uicontrol('Style', 'text', 'String', 'Press start button to analyze', ...
    'Position', [1190 85 200 20], 'BackgroundColor', [0.85 0.85 0.85], 'FontSize', 10, 'HorizontalAlignment', 'left');

% Initialize variables
isRunning = false; % Flag to indicate if the simulation is running
monitoringMode = ''; % Variable to store monitoring mode
simulationTime = inf; % Variable to store simulation time

    function startSimulation(~, ~)
        % Ask for monitoring mode
        monitoringMode = questdlg('Select Monitoring Mode:', 'Monitoring Mode', 'Continuous Monitoring', 'Time Based Monitoring', 'Continuous Monitoring');
        if isempty(monitoringMode)
            return; % If user cancels, do nothing
        end
        
        if strcmp(monitoringMode, 'Time Based Monitoring')
            % Ask for simulation time
            prompt = {'Enter Simulation Time (seconds):'};
            dlgtitle = 'Time Based Monitoring';
            dims = [1 50];
            definput = {'10'}; % Default simulation time is 10 seconds
            simulationTime = str2double(inputdlg(prompt, dlgtitle, dims, definput));
            if isempty(simulationTime) || isnan(simulationTime) || simulationTime <= 0
                return; % If invalid input or canceled, do nothing
            end
        else
            % Add stop button for continuous monitoring
            stopButton = uicontrol('Style', 'pushbutton', 'String', 'Stop', ...
                'Position', [100 20 60 30], 'Callback', @stopSimulation, 'BackgroundColor', 'r', 'ForegroundColor', 'w', 'FontWeight', 'bold');
        end
        
        isRunning = true; % Set running flag to true
        startTime = tic; % Start timer
        idx = 1; % Index to iterate through the data
        
        while isRunning && idx <= length(heartRateData)
            if strcmp(monitoringMode, 'Time Based Monitoring') && toc(startTime) >= simulationTime
                stopSimulation(); % Stop simulation after specified time for time-based monitoring
                break;
            end
            
            % Update the plots
            cla(ax_heartbeat);
            plot(ax_heartbeat, heartRateData(1:idx), 'r', 'LineWidth', 2);
            ylim(ax_heartbeat, [0 220]);
            grid(ax_heartbeat, 'on'); % Ensure grid remains visible
            ylabel(ax_heartbeat, 'Heart Rate (bpm)');
            title(ax_heartbeat, 'Heart Rate Simulation');
            
            cla(ax_walking);
            plot(ax_walking, walkingRateData(1:idx), 'b', 'LineWidth', 2);
            ylim(ax_walking, [0 220]);
            grid(ax_walking, 'on'); % Ensure grid remains visible
            ylabel(ax_walking, 'Walking Rate (steps/min)');
            xlabel(ax_walking, 'Time (seconds)');
            title(ax_walking, 'Walking Rate Simulation');
            
            drawnow; % Update figure window
            pause(0.1); % Pause to simulate real-time data
            
            % Continuously update conclusions for both monitoring modes
            drawConclusions(heartRateData(1:idx), walkingRateData(1:idx));
            
            idx = idx + 1; % Increment index to simulate real-time data
        end
        
        if isRunning
            drawConclusions(heartRateData(1:idx), walkingRateData(1:idx)); % Draw final conclusions
        end
    end

    function stopSimulation(~, ~)
        isRunning = false; % Set running flag to false
        drawConclusions(heartRateData, walkingRateData); % Draw final conclusions
    end

    function drawConclusions(heartRateData, walkingRateData)
        % Classify activity using the trained Logistic Regression model
        currentHR = heartRateData(end); % Get current heart rate
        currentWR = walkingRateData(end); % Get current walking rate
        
        if currentHR > 200 || currentWR > 200
            uiwait(msgbox('Warning: High physiological rates detected. Please seek medical attention if you feel unwell.', 'Alert', 'warn'));
        end
        
        % Load the Logistic Regression model using Python
        pyenv('Version','3.9'); % Set the Python version
        model = py.joblib.load('./Models/lr_activity_model.pkl');
        
        % Prepare data for prediction
        pre_data = py.numpy.array([currentHR, currentWR], dtype=py.numpy.int64);
        data = pre_data.reshape(py.tuple(int64([1,-1])));
        
        % Make the prediction
        activity = model.predict(data);
        fprintf('%s', activity);
        activity = py.list(activity);
        predictedActivityCell = cell(activity);
        predictedActivity = string(predictedActivityCell);
        
        % Update conclusion label
        set(conclusionLabel_activity, 'String', sprintf('Activity: %s', predictedActivity));
        set(conclusionLabel_heartbeat, 'String', sprintf('Heartbeat: %d beats/minute', currentHR));
        set(conclusionLabel_walking, 'String', sprintf('Walk rate: %d steps/minute', currentWR));
    end
end
