classdef RoverInterface < handle
    properties
        simulator
        fig
        updateGUITimer
        filenameTextbox
        rightIRSensorPlot
        leftIRSensorPlot
        rightUSSensorPlot
        leftUSSensorPlot
        leftMotorPlot
        rightMotorPlot
        tiltPlot
        tiltLabel
    end
    methods
        %constructor
        function ri = RoverInterface()
            %get screen size
            screen_size = get(0, 'ScreenSize');
            %make window a little smaller
            screen_left = screen_size(1)+100;
            screen_bottom = screen_size(2)+100;
            screen_width = screen_size(3)-200;
            screen_height = screen_size(4)-200;
            %init window figure
            ri.fig = figure('Visible', 'on',...
                'Name', 'Rover Interface',...
                'Position', [screen_left, screen_bottom, screen_width, screen_height],...
                'CloseRequestFcn',{@RoverInterface.on_close, ri});

            %create instance of the simulator
            ri.simulator = Simulator;
            
            %timer to update GUI
            ri.updateGUITimer = timer;
            ri.updateGUITimer.BusyMode = 'drop';
            ri.updateGUITimer.TimerFcn = {@RoverInterface.updateGUI_callback, ri};
            ri.updateGUITimer.Period = 3;
            ri.updateGUITimer.ExecutionMode = 'fixedRate';
            start(ri.updateGUITimer)
            
            %init GUI
            initOptionButtons(ri);
            initControlButtons(ri);
            initDataDisplay(ri);
            initMap(ri);
            
        end
        
        %start simulator
        function startButton_callback(ri, ~, ~)
            fprintf('Starting simulation...\n');
            startSimulateDataTimer(ri.simulator);
        end
        %stop simulator
        function stopButton_callback(ri, ~, ~)
            fprintf('Stopping simulation...\n');
            stopSimulateDataTimer(ri.simulator);
        end
        
        function exportButton_callback(ri, ~, ~)
            fprintf('Exporting current data from plots...\n')
            filename = get(ri.filenameTextbox, 'String');
            filename = strcat(filename, '.dat');
            %put both sets of data together
            allData = [ri.simulator.leftIRSensorData,...
                ri.simulator.rightIRSensorData,...
                ri.simulator.leftUSSensorData,...
                ri.simulator.rightUSSensorData,...
                ri.simulator.leftMotorData,...
                ri.simulator.rightMotorData];
            dlmwrite(filename, allData);
            
        end
        
        
        function importButton_callback(ri, ~, ~)
            ri.clearPlots(ri)
            fprintf('Importing new data to plots...\n')
            filename = get(ri.filenameTextbox, 'String');
            filename = strcat(filename, '.dat');
            allData = dlmread(filename);
            len = length(allData);
            %split data from file
            LIRSD = allData(1:len/6);
            RIRSD = allData((len/6)+1:(len/6)*2);
            LUSSD = allData((len/6)*2+1:(len/6)*3);
            RUSSD = allData((len/6)*3+1:(len/6)*4);
            LMD = allData((len/6)*4+1:(len/6)*5);
            RMD = allData((len/6)*5+1:len); 
            %update simulator storage
            setLeftIRSensorData(ri.simulator, LIRSD)
            setRightIRSensorData(ri.simulator, RIRSD)
            setLeftUSSensorData(ri.simulator, LUSSD)
            setRightUSSensorData(ri.simulator, RUSSD)
            setLeftMotorData(ri.simulator, LMD)
            setRightMotorData(ri.simulator, RMD)
        end
        
        function clearButton_callback(ri, ~, ~)
            fprintf('Clearing current data from plots...\n')
            setLeftIRSensorData(ri.simulator, [])
            setRightIRSensorData(ri.simulator, [])
            setLeftUSSensorData(ri.simulator, [])
            setRightUSSensorData(ri.simulator, [])
            setLeftMotorData(ri.simulator, [])
            setRightMotorData(ri.simulator, [])
            ri.clearPlots(ri)
        end
        
        
    end
    %static callbacks
    methods (Static)
        function clearPlots(ri)
            cla(ri.leftIRSensorPlot)
            cla(ri.rightIRSensorPlot)
            cla(ri.leftUSSensorPlot)
            cla(ri.rightUSSensorPlot)
            cla(ri.rightMotorPlot)
            cla(ri.leftMotorPlot)
        end
        function updateGUI_callback(~, ~, ri)
            fprintf('Updating GUI...\n');
            %update all 6 plots
            plot(ri.leftIRSensorPlot, ri.simulator.leftIRSensorData, 'b')
            ri.leftIRSensorPlot.Title.String = 'Left IR Sensor';
            plot(ri.rightIRSensorPlot, ri.simulator.rightIRSensorData, 'b')
            ri.rightIRSensorPlot.Title.String = 'Right IR Sensor';
            plot(ri.leftUSSensorPlot, ri.simulator.leftUSSensorData, 'b')
            ri.leftUSSensorPlot.Title.String = 'Left US Sensor';
            plot(ri.rightUSSensorPlot, ri.simulator.rightUSSensorData, 'b')
            ri.rightUSSensorPlot.Title.String = 'Right US Sensor';
            plot(ri.rightMotorPlot, ri.simulator.rightMotorData, 'b')
            ri.rightMotorPlot.Title.String = 'Right Motor Encoder';
            plot(ri.leftMotorPlot, ri.simulator.leftMotorData, 'b')
            ri.leftMotorPlot.Title.String = 'Left Motor Encoder';
            
            dataLen = length(ri.simulator.tiltData);
            if dataLen ~= 0
                slope = ri.simulator.tiltData(dataLen);
                x = [0.9, -0.9];
                y = [slope, slope * -1];
                plot(x, y, 'b')
                axis([-1 1 -1 1])
                ri.tiltPlot.Title.String = 'Tilt Angle';
                ri.tiltLabel.String = strcat('The angle of the rover is  ',...
                    num2str(slope*50), ' degrees');
            end        
            
        end
        
        function on_close(~, ~, ri)
            fprintf('Stopping GUI timer...\n');
            stop(ri.updateGUITimer);
            stopSimulateDataTimer(ri.simulator);
            delete(gcf);
        end
        
    end
    %private init methods
    methods (Access = private)
        function initDataDisplay(ri)
            dataPanel = uipanel('Title', 'Rover Data', 'Position', [.2 0 .4 1]);
            %init all plots
            ri.rightIRSensorPlot = axes('Parent', dataPanel,...
                'OuterPosition', [.5 .75 .5 .25]);
            ri.rightIRSensorPlot.Title.String = 'Right IR Sensor';
            ri.leftIRSensorPlot = axes('Parent', dataPanel,...
                'OuterPosition', [0 .75 .5 .25]);
            ri.leftIRSensorPlot.Title.String = 'Left IR Sensor';
            ri.rightUSSensorPlot = axes('Parent', dataPanel,...
                'OuterPosition', [.5 .5 .5 .25]);
            ri.rightUSSensorPlot.Title.String = 'Right US Sensor';
            ri.leftUSSensorPlot = axes('Parent', dataPanel,...
                'OuterPosition', [0 .5 .5 .25]);
            ri.leftUSSensorPlot.Title.String = 'Left US Sensor';
            ri.leftMotorPlot = axes('Parent', dataPanel,...
                'OuterPosition', [0 .25 .5 .25]);
            ri.leftMotorPlot.Title.String = 'Left Motor Encoder';
            ri.rightMotorPlot = axes('Parent', dataPanel,...
                'OuterPosition', [.5 .25 .5 .25]);
            ri.rightMotorPlot.Title.String = 'Right Motor Encoder';
            
            ri.tiltPlot = axes('Parent', dataPanel,...
                'OuterPosition', [0 0 .9 .25]);
            ri.tiltPlot.Title.String = 'Tilt Angle';
            
            ri.tiltLabel = uicontrol(dataPanel, 'Style', 'text',...
                'String', 'The angle of the rover is XX degrees',...
                'Units', 'normalized',...
                'Position', [.9 .12 .1 .11]);

            
        end
        
        function initMap(ri)
            mapPanel = uipanel('Title', 'Rover Map', 'Position', [.6 0 .4 1]);
        end
        
        function initControlButtons(ri)
            controlPanel = uipanel('Title', 'Controls', 'Position', [0, 0, .2, .5]);
        end
        
        function initOptionButtons(ri)
            %create GUI elements
            optionPanel = uipanel('Title', 'Options', 'Position', [0 .5 .2 .5]);
            
            simGroup = uipanel(optionPanel, 'Position', [0, .75, 1, .25]);
            importExportGroup = uipanel(optionPanel, 'Position', [0, .5, 1, .25]);
            
            startButton = uicontrol(simGroup, 'Style', 'pushbutton',...
                'String', 'Start Sim',...
                'Units', 'normalized',...
                'Position', [0 0 .5 1],...
                'Callback', @ri.startButton_callback);
            
            stopButton = uicontrol(simGroup, 'Style', 'pushbutton',...
                'String', 'Stop Sim',...
                'Units', 'normalized',...
                'Position', [.5 0 .5 1],...
                'Callback', @ri.stopButton_callback);
            
            exportButton = uicontrol(importExportGroup, 'Style', 'pushbutton',...
                'String', 'Export Data',...
                'Units', 'normalized',...
                'Position', [0 0 .2 1],...
                'Callback', @ri.exportButton_callback);
            
            importButton = uicontrol(importExportGroup, 'Style', 'pushbutton',...
                'String', 'Import Data',...
                'Units', 'normalized',...
                'Position', [.2 0 .2 1],...
                'Callback', @ri.importButton_callback);
            
            clearButton = uicontrol(importExportGroup, 'Style', 'pushbutton',...
                'String', 'Clear Data',...
                'Units', 'normalized',...
                'Position', [.4 0 .2 1],...
                'Callback', @ri.clearButton_callback);
            
            filenamePrompt = uicontrol(importExportGroup, 'Style', 'text',...
                'String', 'Type the name of the file below',...
                'Units', 'normalized',...
                'Position', [.6 .5 .4 .5]);
            ri.filenameTextbox = uicontrol(importExportGroup, 'Style', 'edit',...
                'String', 'test',...
                'Units', 'normalized',...
                'Position', [.6 0 .4 .5]);
        end
        
    end
    
end
        

        
        

        