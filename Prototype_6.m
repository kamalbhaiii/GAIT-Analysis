function Prototype_6()

% Load data from file
data = readtable('data.csv');
heartRateData = data.HeartRate;
walkingRateData = data.WalkingRate;

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
conclusionLabel_activity = uicontrol('Style', 'text', 'String', 'Activity will be shown here', ...
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
        idx = 1; % Index to iterate through the data
        
        while isRunning && idx <= length(heartRateData)
            if strcmp(monitoringMode, 'Time Based Monitoring') && toc(startTime) >= simulationTime
                stopSimulation(); % Stop simulation after specified time for time-based monitoring
                break;
            end
            
            % Update the plots
            cla(ax_heartbeat);
            plot(ax_heartbeat, heartRateData(1:idx), 'r', 'LineWidth', 2);
            ylim(ax_heartbeat, [0 160]);
            grid(ax_heartbeat, 'on'); % Ensure grid remains visible
            ylabel(ax_heartbeat, 'Heart Rate (bpm)');
            title(ax_heartbeat, 'Heart Rate Simulation');
            
            cla(ax_walking);
            plot(ax_walking, walkingRateData(1:idx), 'b', 'LineWidth', 2);
            ylim(ax_walking, [0 180]);
            grid(ax_walking, 'on'); % Ensure grid remains visible
            ylabel(ax_walking, 'Walking Rate (steps/min)');
            xlabel(ax_walking, 'Time (seconds)');
            title(ax_walking, 'Walking Rate Simulation');
            
            drawnow;
            pause(0.1);
            
            % Continuously update conclusions for both monitoring modes
            drawConclusions(heartRateData(1:idx), walkingRateData(1:idx));
            
            idx = idx + 1; % Increment index to simulate real-time data
        end
        
        if isRunning
            drawConclusions(heartRateData(1:idx), walkingRateData(1:idx));
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
        currentHR = heartRateData(end);
        currentWR = walkingRateData(end);
        if currentHR < 60 && currentWR < 50
            activity = 'Resting';
        elseif currentHR >= 60 && currentHR <= 100 && currentWR >= 50 && currentWR <= 100
            activity = 'Walking';
        elseif currentHR > 100 && currentWR > 100
            activity = 'Running';
        elseif currentHR > 100 && currentWR >= 50 && currentWR <= 100
            activity = 'Jogging';
        else
            % Fallback to the closest activity based on heart rate
            if currentHR >= 60 && currentHR <= 100
                activity = 'Walking';
            elseif currentHR > 100
                if currentWR >= 50 && currentWR <= 100
                    activity = 'Jogging';
                else
                    activity = 'Running';
                end
            else
                activity = 'Resting';
            end
        end
        
        set(conclusionLabel_activity, 'String', sprintf('Activity: %s', activity));
    end

    function stats = computeStats(data)
        stats.mean = mean(data);
        stats.std = std(data);
        stats.min = min(data);
        stats.max = max(data);
    end

end
