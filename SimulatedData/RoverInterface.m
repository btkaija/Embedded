classdef RoverInterface < handle
    properties
        simulator
        fig
        updateGUITimer
    end
    methods
        function ri = RoverInterface()
            screen_size = get(0, 'ScreenSize');
            %used later for creating UI element spacing
            screen_left = screen_size(1)+100;
            screen_bottom = screen_size(2)+100;
            screen_width = screen_size(3)-200;
            screen_height = screen_size(4)-200;
            %init window
            ri.fig = figure('Visible', 'on', 'Name', 'Rover GUI',...
                'Position', [screen_left, screen_bottom, screen_width, screen_height]);

            %create instance of the simulator
            ri.simulator = Simulator;
            
            %timer to update GUI
            ri.updateGUITimer = timer;
            ri.updateGUITimer.BusyMode = 'drop';
            ri.updateGUITimer.TimerFcn = {@RoverInterface.updateGUI_callback, ri};
            ri.updateGUITimer.Period = 3;
            ri.updateGUITimer.ExecutionMode = 'fixedRate';

            %create GUI elements
            startButton = uicontrol('Style', 'pushbutton', 'String', 'Start Sim',...
                                'Position', [10, screen_height-50, 75, 50],...
                                'Callback', @ri.startButton_callback);
            stopButton = uicontrol('Style', 'pushbutton', 'String', 'Stop Sim',...
                               'Position', [10, screen_height-100, 75, 50],...
                               'Callback', @ri.stopButton_callback);
            %begin adding two plots

            subplot(2,1,1);
            ylabel('Sensor Distance (cm)');
            xlabel('Sample Number');
            subplot(2,1,2);
            ylabel('Motor Speed (rpm)');
            xlabel('Sample Number');

        end
        
        function startButton_callback(ri, ~, ~)
            fprintf('Starting simulation...\n');
            startSimulateDataTimer(ri.simulator);
            start(ri.updateGUITimer)
        end
        
        function stopButton_callback(ri, ~, ~)
            fprintf('Stopping simulation...\n');
            stopSimulateDataTimer(ri.simulator);
            stop(ri.updateGUITimer)
        end
        
    end
    methods (Static)
        function updateGUI_callback(~, ~, ri)
            md = ri.simulator.simulatedMotorData;
            sd = ri.simulator.simulatedSensorData;
            subplot(2,1,1);
            hold all
            plot(sd, 'r')
            plot(md, 'b')
            hold off
            ylabel('Sensor Distance (cm)');
            xlabel('Sample Number');
            subplot(2,1,2);
            hold all
            plot(md, 'r')
            plot(sd, 'b')
            hold off
            ylabel('Motor Speed (rpm)');
            xlabel('Sample Number');
        end


        
    end
end
        

        
        

        