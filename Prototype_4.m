function Prototype_4()

screenSize = get(0, 'ScreenSize');

% Create figure and subplots
fig = figure('Name', 'Physiological Rates Simulation', 'Position', screenSize, 'WindowState', 'maximized', 'Color', [0.94 0.94 0.94]);
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

% Create conclusion labels for each plot
conclusionLabel_heartbeat = uicontrol('Style', 'text', 'String', 'Press start button to analyze', ...
    'Position', [800 370 600 20], 'BackgroundColor', [0.85 0.85 0.85], 'FontSize', 10, 'HorizontalAlignment', 'left');
conclusionLabel_walking = uicontrol('Style', 'text', 'String', 'Press start button to analyze', ...
    'Position', [800 2 600 20], 'BackgroundColor', [0.85 0.85 0.85], 'FontSize', 10, 'HorizontalAlignment', 'left');
conclusionLabel_activity = uicontrol('Style', 'text', 'String', 'Actvity will be shown here', ...
    'Position', [200 2 300 20], 'BackgroundColor', [0.85 0.85 0.85], 'FontSize', 10, 'HorizontalAlignment', 'left');

isRunning = false;
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
        
        isRunning = true;
        startTime = tic;
        heartRateData = [];
        walkingRateData = [];
        while isRunning
            if strcmp(monitoringMode, 'Time Based Monitoring') && toc(startTime) >= simulationTime
                stopSimulation(); % Stop simulation after specified time for time-based monitoring
                break;
            end
            
            heartRate = normrnd(70, 5);
            heartRateData = [heartRateData; heartRate];
            plot(ax_heartbeat, heartRateData, 'r', 'LineWidth', 2);
            ylim(ax_heartbeat, [0 120]);
            grid(ax_heartbeat, 'on'); % Ensure grid remains visible
            ylabel(ax_heartbeat, 'Heart Rate (bpm)');
            title(ax_heartbeat, 'Heart Rate Simulation');
            
            walkingRate = normrnd(70,20);
            walkingRateData = [walkingRateData; walkingRate];
            plot(ax_walking, walkingRateData, 'b', 'LineWidth', 2);
            ylim(ax_walking, [0 150]);
            grid(ax_walking, 'on'); % Ensure grid remains visible
            ylabel(ax_walking, 'Walking Rate (steps/min)');
            xlabel(ax_walking, 'Time (seconds)');
            title(ax_walking, 'Walking Rate Simulation');
            
            drawnow;
            pause(0.5);
            
            % Continuously update conclusions for both monitoring modes
            drawConclusions(heartRateData, walkingRateData);
        end
        
        if isRunning
            drawConclusions(heartRateData, walkingRateData);
        end
    end

    function stopSimulation(~, ~)
        isRunning = false;
        drawConclusions(heartRateData, walkingRateData);
    end

    function drawConclusions(heartRateData, walkingRateData)
        heartRateStats = computeStats(heartRateData);
        walkingRateStats = computeStats(walkingRateData);
        
        % Classify the current activity based on thresholds
        if heartRateStats.mean < 60 && walkingRateStats.mean < 50
            activity = 'Resting';
        elseif (heartRateStats.mean >= 60 || heartRateStats.mean <= 100) && (walkingRateStats.mean >= 50 || walkingRateStats.mean <= 100)
            activity = 'Walking';
        elseif heartRateStats.mean > 100 && walkingRateStats.mean > 100
            activity = 'Running';
        elseif heartRateStats.mean > 100 && (walkingRateStats.mean >= 50 || walkingRateStats.mean <= 100)
            activity = 'Jogging';
        else
            activity = 'Undefined';
        end
        
        fprintf('Activity Detected: %s\n', activity);
        
        set(conclusionLabel_heartbeat, 'String', sprintf(...
            'Heart Rate: Mean=%.2f bpm, Std=%.2f bpm, Range=%.2f - %.2f bpm',...
            heartRateStats.mean, heartRateStats.std, heartRateStats.min, heartRateStats.max));
        set(conclusionLabel_walking, 'String', sprintf(...
            'Walking Rate: Mean=%.2f steps/min, Std=%.2f steps/min, Range=%.2f - %.2f steps/min',...
            walkingRateStats.mean, walkingRateStats.std, walkingRateStats.min, walkingRateStats.max));
        set(conclusionLabel_activity, 'String', sprintf(...
            'Activity: %s',activity));
    end

    function stats = computeStats(data)
        stats.mean = mean(data);
        stats.std = std(data);
        stats.min = min(data);
        stats.max = max(data);
    end

end
