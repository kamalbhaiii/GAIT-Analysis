function simulatePhysiologicalRates()

    screenSize = get(0, 'ScreenSize');
    
    % Create figure and subplots
    fig = figure('Name', 'Physiological Rates Simulation', 'Position', screenSize, 'WindowState', 'maximized', 'Color', [0.94 0.94 0.94]);
    ax_heartbeat = subplot(3, 1, 1, 'Color', [0.85 0.85 0.85]);
    ax_breathing = subplot(3, 1, 2, 'Color', [0.85 0.85 0.85]);
    ax_walking = subplot(3, 1, 3, 'Color', [0.85 0.85 0.85]);
    
    % Set properties for heart rate plot
    title(ax_heartbeat, 'Heart Rate Simulation');
    ylabel(ax_heartbeat, 'Heart Rate (bpm)');
    grid(ax_heartbeat, 'on');
    
    % Set properties for breathing rate plot
    title(ax_breathing, 'Breathing Rate Simulation');
    ylabel(ax_breathing, 'Breathing Rate (breaths/min)');
    grid(ax_breathing, 'on');
    
    % Set properties for walking rate plot
    title(ax_walking, 'Walking Rate Simulation');
    xlabel(ax_walking, 'Time (seconds)');
    ylabel(ax_walking, 'Walking Rate (steps/min)');
    grid(ax_walking, 'on');
    
    % Create Start button
    startButton = uicontrol('Style', 'pushbutton', 'String', 'Start', ...
        'Position', [20 20 60 30], 'Callback', @startSimulation, 'BackgroundColor', 'g', 'ForegroundColor', 'w', 'FontWeight', 'bold');
    
    % Create conclusion label
    conclusionLabel = uicontrol('Style', 'text', 'String', '', ...
        'Position', [480 10 600 50], 'BackgroundColor', [0.94 0.94 0.94], 'FontSize', 8);
    
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
        breathingRateData = [];
        walkingRateData = [];
        while isRunning
            if strcmp(monitoringMode, 'Time Based Monitoring') && toc(startTime) >= simulationTime
                stopSimulation(); % Stop simulation after specified time for time-based monitoring
                break;
            end
            
            heartRate = 60 + 40 * randn(1, 1);
            heartRateData = [heartRateData; heartRate];
            plot(ax_heartbeat, heartRateData, 'r', 'LineWidth', 2);
            ylim(ax_heartbeat, [0 120]);
            grid(ax_heartbeat, 'on'); % Ensure grid remains visible
            
            breathingRate = 12 + 8 * randn(1, 1);
            breathingRateData = [breathingRateData; breathingRate];
            plot(ax_breathing, breathingRateData, 'g', 'LineWidth', 2);
            ylim(ax_breathing, [0 30]);
            grid(ax_breathing, 'on'); % Ensure grid remains visible
            
            walkingRate = 50 + 50 * randn(1, 1);
            walkingRateData = [walkingRateData; walkingRate];
            plot(ax_walking, walkingRateData, 'b', 'LineWidth', 2);
            ylim(ax_walking, [0 150]);
            grid(ax_walking, 'on'); % Ensure grid remains visible
            
            drawnow;
            pause(0.5);
            
            % Continuously update conclusions for both monitoring modes
            drawConclusions(heartRateData, breathingRateData, walkingRateData);
        end
        
        if isRunning
            drawConclusions(heartRateData, breathingRateData, walkingRateData);
        end
    end

    function stopSimulation(~, ~)
        isRunning = false;
        drawConclusions(heartRateData, breathingRateData, walkingRateData);
    end
    
    function drawConclusions(heartRateData, breathingRateData, walkingRateData)
        heartRateStats = computeStats(heartRateData);
        breathingRateStats = computeStats(breathingRateData);
        walkingRateStats = computeStats(walkingRateData);

        set(conclusionLabel, 'String', sprintf(...
            'Heart Rate: Mean=%.2f bpm, Std=%.2f bpm, Range=%.2f - %.2f bpm\nBreathing Rate: Mean=%.2f breaths/min, Std=%.2f breaths/min, Range=%.2f - %.2f breaths/min\nWalking Rate: Mean=%.2f steps/min, Std=%.2f steps/min, Range=%.2f - %.2f steps/min',...
            heartRateStats.mean, heartRateStats.std, heartRateStats.min, heartRateStats.max,...
            breathingRateStats.mean, breathingRateStats.std, breathingRateStats.min, breathingRateStats.max,...
            walkingRateStats.mean, walkingRateStats.std, walkingRateStats.min, walkingRateStats.max));
    end

    function stats = computeStats(data)
        stats.mean = mean(data);
        stats.std = std(data);
        stats.min = min(data);
        stats.max = max(data);
    end

end

simulatePhysiologicalRates();
