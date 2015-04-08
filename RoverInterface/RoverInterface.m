classdef RoverInterface < handle
    properties
        simulator
        fig
        updateGUITimer
        roverMap
        port
        db
        %plots
        rightIRSensorPlot
        leftIRSensorPlot
        rightUSSensorPlot
        leftUSSensorPlot
        leftMotorPlot
        rightMotorPlot
        tiltPlot
        tiltAnglePlot
        %entry boxes
        degreeEntry 
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
            ri.fig = figure('Visible', 'off',...
                'Name', 'Rover Interface',...
                'Position', [screen_left, screen_bottom, screen_width, screen_height],...
                'CloseRequestFcn',{@RoverInterface.on_close, ri});
            
            %create databank
            ri.db = DataBank();
            
            %create instance of the simulator
            ri.simulator = Simulator(ri.db);
            
            %create serial port reciever
            %ri.port = SerialCom('Serial-COM6');

            %init GUI
            initOptionButtons(ri);
            initControlButtons(ri);
            initDataDisplay(ri);
            initMap(ri);
            
            ri.fig.Visible = 'on';
            
            %timer to update GUI
            startGUITimer(ri);
            
        end
        
        %start simulator
        function startButton_callback(ri, ~, ~)
            %fprintf('Starting simulation...\n');
            startSimulateDataTimer(ri.simulator);
        end
        %stop simulator
        function stopButton_callback(ri, ~, ~)
            %fprintf('Stopping simulation...\n');
            stopSimulateDataTimer(ri.simulator);
        end
        
        %callback for when the export button is pressed
        function exportButton_callback(ri, ~, ~)
            fprintf('Exporting current data from plots...\n')
            [file, path] = uiputfile('results.dat','Save as');
            filepath = strcat(path, file);
            allSimData = getAllData(ri.db, 'sim');
            allRealData = getAllData(ri.db, 'real');
            dlmwrite(filepath, [allSimData allRealData]);
            
        end
        
        %callback for when the import button is pressed
        function importButton_callback(ri, ~, ~)
            clearButton_callback(ri, 0, 0)
            fprintf('Importing new data to plots...\n')
            [file, path] = uigetfile('*.dat', 'Select the rover data file');
            filepath = strcat(path, file);
            allData = dlmread(filepath);
            l = length(allData);
            allSimData = allData(1:l/2);
            setAllData(ri.db, allSimData, 'sim');
            allRealData = allData(l/2 +1:l);
            setAllData(ri.db, allRealData, 'real');

        end
        
        %callback for when the clear button is pressed
        function clearButton_callback(ri, ~, ~)
            fprintf('Clearing current data from plots...\n')
            setAllData(ri.db, [0 0 0 0 0 0 0], 'sim')
            setAllData(ri.db, [0 0 0 0 0 0 0], 'real')
            cla(ri.leftIRSensorPlot)
            cla(ri.rightIRSensorPlot)
            cla(ri.leftUSSensorPlot)
            cla(ri.rightUSSensorPlot)
            cla(ri.rightMotorPlot)
            cla(ri.leftMotorPlot)
            cla(ri.tiltPlot)
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

        function updateGUI_callback(~, ~, ri)
            %fprintf('Updating GUI...\n');
            
            %Update all 6 plots with sim and real data
            hold(ri.leftIRSensorPlot, 'on')
            plot(ri.leftIRSensorPlot, getLIRSData(ri.db, 'sim'), 'b')
            plot(ri.leftIRSensorPlot, getLIRSData(ri.db, 'real'), 'r')
            ri.leftIRSensorPlot.Title.String = 'Left IR Sensor';
            hold(ri.leftIRSensorPlot, 'off')
            
            hold(ri.rightIRSensorPlot, 'on')
            plot(ri.rightIRSensorPlot, getRIRSData(ri.db, 'sim'), 'b')
            plot(ri.rightIRSensorPlot, getRIRSData(ri.db, 'real'), 'r')
            ri.rightIRSensorPlot.Title.String = 'Right IR Sensor';
            hold(ri.rightIRSensorPlot, 'off')
            
            hold(ri.leftUSSensorPlot, 'on')
            plot(ri.leftUSSensorPlot, getLUSSData(ri.db, 'sim'), 'b')
            plot(ri.leftUSSensorPlot, getLUSSData(ri.db, 'real'), 'r')
            ri.leftUSSensorPlot.Title.String = 'Left US Sensor';
            hold(ri.leftUSSensorPlot, 'off')
            
            hold(ri.rightUSSensorPlot, 'on')
            plot(ri.rightUSSensorPlot, getRUSSData(ri.db, 'sim'), 'b')
            plot(ri.rightUSSensorPlot, getRUSSData(ri.db, 'real'), 'r')
            ri.rightUSSensorPlot.Title.String = 'Right US Sensor';
            hold(ri.rightUSSensorPlot, 'off')
            
            hold(ri.rightMotorPlot, 'on')
            plot(ri.rightMotorPlot, getRMData(ri.db, 'sim'), 'b')
            plot(ri.rightMotorPlot, getRMData(ri.db, 'real'), 'r')
            ri.rightMotorPlot.Title.String = 'Right Motor Encoder';
            hold(ri.rightMotorPlot, 'off')
            
            hold(ri.leftMotorPlot, 'on')
            plot(ri.leftMotorPlot, getLMData(ri.db, 'sim'), 'b')
            plot(ri.leftMotorPlot, getLMData(ri.db, 'real'), 'r')
            ri.leftMotorPlot.Title.String = 'Left Motor Encoder';
            hold(ri.leftMotorPlot, 'off')

            
            %update tilt plots here
            simSlope = getTiltData(ri.db, 'sim');
            realSlope = getTiltData(ri.db, 'real');
            
            hold(ri.tiltPlot, 'on')
            plot(ri.tiltPlot, simSlope, 'b')
            plot(ri.tiltPlot, realSlope, 'r')
            ri.tiltPlot.Title.String = 'Tilt';
            hold(ri.tiltPlot, 'off')
            
            %most recent slopes
            ss = simSlope(length(simSlope));
            rs = realSlope(length(realSlope));
            legendNames = cell(1,2);
            legendNames{1} = strcat(num2str(ss*45), ' degrees');
            legendNames{2} = strcat(num2str(rs*45), ' degrees');
            
            cla(ri.tiltAnglePlot);
            
            hold(ri.tiltAnglePlot, 'on')
            plot(ri.tiltAnglePlot, [-1 1], [ss*-1, ss], 'b')
            plot(ri.tiltAnglePlot, [-1 1], [rs*-1, rs], 'r')
            legend(ri.tiltAnglePlot, legendNames)
            axis(ri.tiltAnglePlot, [-1 1 -1 1])
            ri.tiltAnglePlot.Title.String = 'Tilt Angle';
            hold(ri.tiltAnglePlot, 'off')
            
            %plot new rover
%             hold all
%             cla(getAxes(ri.roverMap))
%             drawWalls(ri.roverMap)
%             drawSimRover(ri.roverMap, rand(1,1)*4+2, rand(1,1)*8+2, slope*50)
%             hold off
        end
        
        %when the window is closed
        function on_close(~, ~, ri)
            fprintf('Getting rid of open ports and timers...\n');
            stop(ri.updateGUITimer);
            delete(ri.updateGUITimer);
            stopSimulateDataTimer(ri.simulator);
            %closePort(ri.port);
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
                'OuterPosition', [0 0 .5 .25]);
            ri.tiltPlot.Title.String = 'Tilt';
            ri.tiltAnglePlot = axes('Parent', dataPanel,...
                'OuterPosition', [.5 0 .5 .25]);
            ri.tiltAnglePlot.Title.String = 'Tilt Angle';
            
        end
        %init the map from the map class
        function initMap(ri)
            mapPanel = uipanel('Title', 'Rover Map', 'Position', [.6 0 .4 1]);
            
            ri.roverMap = RoverMap(mapPanel);
            %drawing da stuff
            hold(getAxes(ri.roverMap), 'on')
            drawWalls(ri.roverMap);
            drawSimRover(ri.roverMap, 1, 1, 45, 'sim');
            hold(getAxes(ri.roverMap), 'off')
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
                'Position', [.25 .33 .5 .33],...
                'Callback', @ri.exportButton_callback);
            
            importButton = uicontrol(importExportGroup, 'Style', 'pushbutton',...
                'String', 'Import Data',...
                'Units', 'normalized',...
                'Position', [.25 .66 .5 .33],...
                'Callback', @ri.importButton_callback);
            
            clearButton = uicontrol(importExportGroup, 'Style', 'pushbutton',...
                'String', 'Clear Data',...
                'Units', 'normalized',...
                'Position', [.25 0 .5 .33],...
                'Callback', @ri.clearButton_callback);
        end
        
        %starts the timer for the gui update
        function startGUITimer(ri)
            ri.updateGUITimer = timer;
            ri.updateGUITimer.BusyMode = 'drop';
            ri.updateGUITimer.TimerFcn = {@RoverInterface.updateGUI_callback, ri};
            ri.updateGUITimer.Period = 1;
            ri.updateGUITimer.ExecutionMode = 'fixedRate';
            ri.updateGUITimer.Name = 'GUI-timer';
            start(ri.updateGUITimer)
        end
        
    end
    
end
        

        
        

        