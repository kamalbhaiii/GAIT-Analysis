% Define the main function to simulate heart-beats, breathing, and walking rates
function simulatePhysiologicalRates()

% Initialize the figure and axes for plotting
fig = figure('Name', 'GAIT Analysis Simulation', 'Position', [100, 100, 800, 600]);
ax_heartbeat = subplot(3, 1, 1);
ax_breathing = subplot(3, 1, 2);
ax_walking = subplot(3, 1, 3);

title(ax_heartbeat, 'Heart Rate Simulation');
title(ax_breathing, 'Breathing Rate Simulation');
title(ax_walking, 'Walking Rate Simulation');

xlabel(ax_walking, 'Time (seconds)');
ylabel(ax_heartbeat, 'Heart Rate (bpm)');
ylabel(ax_breathing, 'Breathing Rate (breaths/min)');
ylabel(ax_walking, 'Walking Rate (steps/min)');

% Initialize start and stop buttons
startButton = uicontrol('Style', 'pushbutton', 'String', 'Start',...
    'Position', [20 20 60 30], 'Callback', @startSimulation);
stopButton = uicontrol('Style', 'pushbutton', 'String', 'Stop',...
    'Position', [100 20 60 30], 'Callback', @stopSimulation);

% Initialize text labels for displaying conclusions
conclusionLabel = uicontrol('Style', 'text', 'String', '',...
    'Position', [180 10 600 50]);

isRunning = false; % Flag to indicate if simulation is running

% Function to start the simulation
    function startSimulation(~, ~)
        isRunning = true;
        startTime = tic; % Start timer
        heartRateData = [];
        breathingRateData = [];
        walkingRateData = [];
        while isRunning && toc(startTime) <= 10 % Run for 10 seconds
            % Generate heart rate data (normal range: 60 - 100 bpm)
            heartRate = 60 + 40 * randn(1, 1);
            heartRateData = [heartRateData; heartRate];
            plot(ax_heartbeat, heartRateData);
            title(ax_heartbeat, 'Heart Rate Simulation');
            ylabel(ax_heartbeat, 'Heart Rate (bpm)');
            ylim(ax_heartbeat, [0 120]); % Set y-axis limit for heart rate
            % Generate breathing rate data (normal range: 12 - 20 breaths/min)
            breathingRate = 12 + 8 * randn(1, 1);
            breathingRateData = [breathingRateData; breathingRate];
            plot(ax_breathing, breathingRateData);
            title(ax_breathing, 'Breathing Rate Simulation');
            ylabel(ax_breathing, 'Breathing Rate (breaths/min)');
            ylim(ax_breathing, [0 30]); % Set y-axis limit for breathing rate
            % Generate walking rate data (normal range: 50 - 100 steps/min)
            walkingRate = 50 + 50 * randn(1, 1);
            walkingRateData = [walkingRateData; walkingRate];
            plot(ax_walking, walkingRateData);
            title(ax_walking, 'Walking Rate Simulation');
            ylabel(ax_walking, 'Walking Rate (steps/min)');
            ylim(ax_walking, [0 150]); % Set y-axis limit for walking rate
            drawnow; % Force plot to refresh immediately
            pause(0.5); % Pause for 0.5 seconds before generating the next set of data
        end
        if isRunning
            % Compute statistics
            heartRateStats = computeStats(heartRateData);
            breathingRateStats = computeStats(breathingRateData);
            walkingRateStats = computeStats(walkingRateData);
            % Display conclusions
            set(conclusionLabel, 'String', sprintf(...
                'Heart Rate: Mean=%.2f bpm, Std=%.2f bpm, Range=%.2f - %.2f bpm\nBreathing Rate: Mean=%.2f breaths/min, Std=%.2f breaths/min, Range=%.2f - %.2f breaths/min\nWalking Rate: Mean=%.2f steps/min, Std=%.2f steps/min, Range=%.2f - %.2f steps/min',...
                heartRateStats.mean, heartRateStats.std, heartRateStats.min, heartRateStats.max,...
                breathingRateStats.mean, breathingRateStats.std, breathingRateStats.min, breathingRateStats.max,...
                walkingRateStats.mean, walkingRateStats.std, walkingRateStats.min, walkingRateStats.max));
        else
            set(conclusionLabel, 'String', 'Interrupted');
        end
    end

% Function to stop the simulation
    function stopSimulation(~, ~)
        isRunning = false;
    end

% Function to compute statistics
    function stats = computeStats(data)
        stats.mean = mean(data);
        stats.std = std(data);
        stats.min = min(data);
        stats.max = max(data);
    end

end

% Call the main function to start the simulation
simulatePhysiologicalRates();