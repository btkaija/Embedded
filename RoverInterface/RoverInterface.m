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
        degreeEntry
        roverMap
        port
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
            
            %create serial port reciever
            ri.port = SerialCom('Serial-COM6');
            
            %timer to update GUI
            ri.updateGUITimer = timer;
            ri.updateGUITimer.BusyMode = 'drop';
            ri.updateGUITimer.TimerFcn = {@RoverInterface.updateGUI_callback, ri};
            ri.updateGUITimer.Period = 1;
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
                ri.simulator.rightMotorData,...
                ri.simulator.tiltData];
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
            LIRSD = allData(1:len/7);
            RIRSD = allData((len/7)+1:(len/7)*2);
            LUSSD = allData((len/7)*2+1:(len/7)*3);
            RUSSD = allData((len/7)*3+1:(len/7)*4);
            LMD = allData((len/7)*4+1:(len/7)*5);
            RMD = allData((len/7)*5+1:(len/7)*6); 
            TD = allData((len/7)*6+1:len);
            %update simulator storage
            setLeftIRSensorData(ri.simulator, LIRSD)
            setRightIRSensorData(ri.simulator, RIRSD)
            setLeftUSSensorData(ri.simulator, LUSSD)
            setRightUSSensorData(ri.simulator, RUSSD)
            setLeftMotorData(ri.simulator, LMD)
            setRightMotorData(ri.simulator, RMD)
            setTiltData(ri.simulator, TD)
        end
        
        function clearButton_callback(ri, ~, ~)
            fprintf('Clearing current data from plots...\n')
            setLeftIRSensorData(ri.simulator, [])
            setRightIRSensorData(ri.simulator, [])
            setLeftUSSensorData(ri.simulator, [])
            setRightUSSensorData(ri.simulator, [])
            setLeftMotorData(ri.simulator, [])
            setRightMotorData(ri.simulator, [])
            setTiltData(ri.simulator, [])
            ri.clearPlots(ri)
        end
        
        function traverseButton_callback(ri, ~, ~)
            fprintf('traverse\n');
        end
        
        function haltButton_callback(ri, ~, ~)
            fprintf('halt\n');
        end
        
        function turnButton_callback(ri, ~, ~)
            fprintf('turn\n');
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
            cla(ri.tiltPlot)
        end
        function updateGUI_callback(~, ~, ri)
            %fprintf('Updating GUI...\n');
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
                %get most recent tilt and display
                slope = ri.simulator.tiltData(dataLen);
                plot(ri.tiltPlot, [1, -1], [slope, slope*-1], 'b')
                axis(ri.tiltPlot, [-1 1 -1 1])
                ri.tiltPlot.Title.String = 'Tilt Angle';
                %update label
                ri.tiltLabel.String = strcat('The angle of the rover is  ',...
                    num2str(slope*50), ' degrees');
            end        
            
        end
        %when the window is closed
        function on_close(~, ~, ri)
            fprintf('Getting rid of open ports and timers...\n');
            stop(ri.updateGUITimer);
            stopSimulateDataTimer(ri.simulator);
            closePort(ri.port);
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
                'Position', [.8 0 .2 .25]);

            
        end
        %init the map from the map class
        function initMap(ri)
            mapPanel = uipanel('Title', 'Rover Map', 'Position', [.6 0 .4 1]);
            
            ri.roverMap = RoverMap(mapPanel);
            drawSimRover(ri.roverMap, 1, 1, 30);
        end
        
        function initControlButtons(ri)
            controlPanel = uipanel('Title', 'Rover Controls', 'Position', [0, 0, .2, .5]);
            
            autoPanel = uipanel(controlPanel, 'Position', [0 .85 1 .15]);
            commandPanel = uipanel(controlPanel, 'Position', [0 0 1 .85]);
            
            traverseButton = uicontrol(autoPanel, 'Style', 'pushbutton',...
                'String', 'Traverse Course',...
                'Units', 'normalized',...
                'Position', [0 0 .5 1],...
                'Callback', @ri.traverseButton_callback);
            
            haltButton = uicontrol(autoPanel, 'Style', 'pushbutton',...
                'String', 'Halt',...
                'Units', 'normalized',...
                'Position', [.5 0 .5 1],...
                'Callback', @ri.haltButton_callback);
            
            turnButton = uicontrol(commandPanel, 'Style', 'pushbutton',...
                'String', 'Turn X Degrees',...
                'Units', 'normalized',...
                'Position', [0 .9 .5 .1],...
                'Callback', @ri.turnButton_callback);
            
            ri.degreeEntry = uicontrol(commandPanel, 'Style', 'edit',...
                'String', '45',...
                'Units', 'normalized',...
                'Position', [.5 .9 .5 .1]);
            %TODO: implement buttons
            %turnButton
            %ri.degreeEntry
            %forwardButton
            %ri.fdistEntry
            %reverseButton
            %ri.rdistEntry
            %uturnButton
            %ri.uturnrightToggle
            %ri.uturnleftToggle
            %uturnButtongroup
            
        end
        
        function initOptionButtons(ri)
            %create GUI elements
            optionPanel = uipanel('Title', 'Data Options', 'Position', [0 .5 .2 .5]);
            
            simGroup = uipanel(optionPanel, 'Position', [0, .85, 1, .15]);
            importExportGroup = uipanel(optionPanel, 'Position', [0, .60, 1, .25]);
            
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
                'Position', [0 .33 .6 .33],...
                'Callback', @ri.exportButton_callback);
            
            importButton = uicontrol(importExportGroup, 'Style', 'pushbutton',...
                'String', 'Import Data',...
                'Units', 'normalized',...
                'Position', [0 .66 .6 .33],...
                'Callback', @ri.importButton_callback);
            
            clearButton = uicontrol(importExportGroup, 'Style', 'pushbutton',...
                'String', 'Clear Data',...
                'Units', 'normalized',...
                'Position', [0 0 .6 .33],...
                'Callback', @ri.clearButton_callback);
            
            filenamePrompt = uicontrol(importExportGroup, 'Style', 'text',...
                'String', 'Type the name of the external data file below',...
                'Units', 'normalized',...
                'Position', [.6 .33 .4 .66]);
            ri.filenameTextbox = uicontrol(importExportGroup, 'Style', 'edit',...
                'String', 'test',...
                'Units', 'normalized',...
                'Position', [.6 0 .4 .33]);
        end
        
    end
    
end
        

        
        

        