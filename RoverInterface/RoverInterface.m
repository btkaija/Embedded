classdef RoverInterface < handle
    properties
        %objects
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
        leftdegreeEntry
        rightdegreeEntry
        forwardEntry
        reverseEntry
        %radio buttons
        controlSim
        controlReal
        uturnRightToggle
        uturnLeftToggle
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
            ri.simulator = Simulator(ri.db, ri.port);
            
            %create serial port reciever
            ri.port = SerialCom('Serial-COM1', ri.simulator, ri.db);
            
            
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
            
            choice = questdlg(['Starting the simulation will reset all data.\n',...
                'Would you like to continue?'], 'Continue?', 'Yes', 'No', 'No');
            if strcmp('No', choice)
                return
            else
                resetDB(ri.db)
                clearButton_callback(ri, 0, 0)
                fprintf('Starting simulation...\n');
                startSimulateDataTimer(ri.simulator);
            end
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
            
            if file~=0 && path~=0
                filepath = strcat(path, file);
                allSimData = getAllData(ri.db, 'sim');
                allRealData = getAllData(ri.db, 'real');
                dlmwrite(filepath, [allSimData allRealData]);
            end
            
        end
        
        %callback for when the import button is pressed
        function importButton_callback(ri, ~, ~)
            clearButton_callback(ri, 0, 0)
            fprintf('Importing new data to plots...\n')
            [file, path] = uigetfile('*.dat', 'Select the rover data file');
            
            if file~=0 && path~=0
                filepath = strcat(path, file);
                allData = dlmread(filepath);
                l = length(allData);
                allSimData = allData(1:l/2);
                setAllData(ri.db, allSimData, 'sim');
                allRealData = allData(l/2 +1:l);
                setAllData(ri.db, allRealData, 'real');
            end

        end
        
        %callback for when the clear button is pressed
        function clearButton_callback(ri, ~, ~)
            fprintf('Clearing current data from plots...\n')
            resetDB(ri.db)
            cla(ri.leftIRSensorPlot)
            cla(ri.rightIRSensorPlot)
            cla(ri.leftUSSensorPlot)
            cla(ri.rightUSSensorPlot)
            cla(ri.rightMotorPlot)
            cla(ri.leftMotorPlot)
            cla(ri.tiltPlot)
        end
        
        %asks the rover to begin rover automation
        %this function also clears the databank
        function traverseButton_callback(ri, ~, ~)
            fprintf('Traverse button.\n');
            
            choice = questdlg(['Starting the rover traversal will reset all data.\n',...
                'Would you like to continue?'], 'Continue?', 'Yes', 'No', 'No');
            if strcmp('No', choice)
                return
            else
                resetDB(ri.db);
                startAutomator(ri.port);
                %send start command
                sendMessage(ri.port, 'auto-begin');
            end
        end
        
        %stops rover automation
        function haltButton_callback(ri, ~, ~)
            fprintf('Halt button.\n');
            stopAutomator(ri.port);
            %send stop command
            sendMessage(ri.port, 'auto-end');
        end
        
        %asks the rover to turn XX number of degrees
        function turnLeftButton_callback(ri, ~, ~)
            val = ri.leftdegreeEntry.String;
            angle = 0;
            try
               angle = str2double(val);
            catch
                fprintf('The angle input is not a number.\n');
            end
            fprintf(['Turn ',num2str(angle), ' degrees \n']);
            
            if ri.controlReal.Value
                %stop auto
                if ri.port.autoOn
                    stopAutomator(ri.port)
                end
                
                turnXdegrees(ri.db, 'real', angle, 'left')
                %send command
                sendMessage(ri.port, ['turn-left-',angle]);
            elseif ri.controlSim.Value
                %stop sim
                if ri.simulator.isOn
                    stopSimulateDataTimer(ri.simulator)
                end
                
                turnXdegrees(ri.db, 'sim', angle, 'left')
            else
                fprintf('Select which rover to control.\n');
            end
            
            updateRoverData(ri.db)
        end
        
        %asks the rover to turn XX number of degrees
        function turnRightButton_callback(ri, ~, ~)
            val = ri.rightdegreeEntry.String;
            angle = 0;
            try
               angle = str2double(val);
            catch
                fprintf('The angle input is not a number.\n');
            end
            fprintf(['Turn ',num2str(angle), ' degrees \n']);
            
            if ri.controlReal.Value
                %stop auto
                if ri.port.autoOn
                    stopAutomator(ri.port)
                end
                
                turnXdegrees(ri.db, 'real', angle, 'right')
                %send command
                sendMessage(ri.port, ['turn-right-',angle]);
            elseif ri.controlSim.Value
                %stop sim
                if ri.simulator.isOn
                    stopSimulateDataTimer(ri.simulator)
                end
                
                turnXdegrees(ri.db, 'sim', angle, 'right')
            else
                fprintf('Select which rover to control.\n');
            end
            
            updateRoverData(ri.db)
        end
        
        %moves forward x cm
        function forwardButton_callback(ri, ~, ~)
            val = ri.forwardEntry.String;
            dist = 0;
            try
                dist = str2double(val);
            catch
                fprintf('The distance input is not a number.\n');
            end
            fprintf(['Forward ',num2str(dist), 'cm.\n']);
            
            if ri.controlReal.Value
                %stop auto
                if ri.port.autoOn
                    stopAutomator(ri.port)
                end
                
                moveForward(ri.db, 'real', dist)
                %send command
                sendMessage(ri.port, ['forward-',dist]);
            elseif ri.controlSim.Value
                %stop sim
                if ri.simulator.isOn
                    stopSimulateDataTimer(ri.simulator)
                end
                
                moveForward(ri.db, 'sim', dist)
            else
                fprintf('Select which rover to control.\n');
            end

            updateRoverData(ri.db)
        end
        
        %moves backward x cm
        function reverseButton_callback(ri, ~, ~)
            val = ri.reverseEntry.String;
            dist = 0;
            try
                dist = str2double(val);
            catch
                fprintf('The distance input is not a number.\n');
            end
            fprintf(['Reverse ',num2str(dist), 'cm.\n']);
            
            if ri.controlReal.Value
                %stop auto
                if ri.port.autoOn
                    stopAutomator(ri.port)
                end
                
                moveReverse(ri.db, 'real', dist);
                %send command
                sendMessage(ri.port, ['reverse-',dist]);
            elseif ri.controlSim.Value
                %stop sim
                if ri.simulator.isOn
                    stopSimulateDataTimer(ri.simulator)
                end
                
                moveReverse(ri.db, 'sim', dist);
            else
                fprintf('Select which rover to control.\n');
            end
            
            updateRoverData(ri.db)
        end
        
        %makes a left or right u turn
        function uturnButton_callback(ri, ~, ~)
            if ri.uturnRightToggle.Value
                dir = 'right';
            elseif ri.uturnLeftToggle.Value
                dir = 'left';
            else
                dir = 'broken';
            end
            
            fprintf(['U-Turn ',dir, '.\n'])
            
            if ri.controlReal.Value
                %stop auto
                if ri.port.autoOn
                    stopAutomator(ri.port)
                end
                
                uturn(ri.db, 'real', dir)
                %send command
                sendMessage(ri.port, ['uturn-',dir]);
            elseif ri.controlSim.Value
                %stop sim
                if ri.simulator.isOn
                    stopSimulateDataTimer(ri.simulator)
                end
                
                uturn(ri.db, 'sim', dir)
            else
                fprintf('Select which rover to control.\n');
            end
            
            updateRoverData(ri.db)
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
            
            %plot rovers

            dl = getDataLength(ri.db);
            simXpos = getXposData(ri.db, 'sim');
            simYpos = getYposData(ri.db, 'sim');
            simAngle = getAngleData(ri.db, 'sim');
            realXpos = getXposData(ri.db, 'real');
            realYpos = getYposData(ri.db, 'real');
            realAngle = getAngleData(ri.db, 'real');
            
            hold(getAxes(ri.roverMap), 'on')
            cla(getAxes(ri.roverMap));
            drawWalls(ri.roverMap)
            drawRover(ri.roverMap, simXpos(dl), simYpos(dl), simAngle(dl), 'sim')
            drawRover(ri.roverMap, realXpos(dl), realYpos(dl), realAngle(dl), 'real')
            hold(getAxes(ri.roverMap), 'off')
        end
        
        %when the window is closed
        function on_close(~, ~, ri)
            fprintf('Getting rid of open ports and timers...\n');
            stop(ri.updateGUITimer);
            delete(ri.updateGUITimer);
            stopSimulateDataTimer(ri.simulator);
            closePort(ri.port);
            delete(gcf);
            
        end
        
    end
    
    %private init methods
    methods (Access = private)
        
        %creates all the graphs, wooo!
        function initDataDisplay(ri)
            dataPanel = uipanel('Title', 'Rover Data', 'Position', [.2 0 .4 1]);

            %init all plots
            ri.rightIRSensorPlot = axes('Parent', dataPanel,...
                'OuterPosition', [.5 .75 .5 .25], 'YLim', [0 30]);
            ri.rightIRSensorPlot.Title.String = 'Right IR Sensor';
            %axis(ri.rightIRSensorPlot, [0 dl 0 30]);
            
            ri.leftIRSensorPlot = axes('Parent', dataPanel,...
                'OuterPosition', [0 .75 .5 .25], 'YLim', [0 30]);
            ri.leftIRSensorPlot.Title.String = 'Left IR Sensor';
            %axis(ri.leftIRSensorPlot, [0 dl 0 30]);
            
            ri.rightUSSensorPlot = axes('Parent', dataPanel,...
                'OuterPosition', [.5 .5 .5 .25], 'YLim', [0 200]);
            ri.rightUSSensorPlot.Title.String = 'Right US Sensor';
            %axis(ri.rightUSSensorPlot, [0 dl 0 200]);
                        
            ri.leftUSSensorPlot = axes('Parent', dataPanel,...
                'OuterPosition', [0 .5 .5 .25], 'YLim', [0 200]);
            ri.leftUSSensorPlot.Title.String = 'Left US Sensor';
            %axis(ri.leftUSSensorPlot, [0 dl 0 200]);
            
            ri.leftMotorPlot = axes('Parent', dataPanel,...
                'OuterPosition', [0 .25 .5 .25], 'YLim', [0 5]);
            ri.leftMotorPlot.Title.String = 'Left Motor Encoder';
            %axis(ri.leftMotorPlot, [0 dl 0 5]);
            
            ri.rightMotorPlot = axes('Parent', dataPanel,...
                'OuterPosition', [.5 .25 .5 .25], 'YLim', [0 5]);
            ri.rightMotorPlot.Title.String = 'Right Motor Encoder';
            %axis(ri.rightMotorPlot, [0 dl 0 5]);
            
            ri.tiltPlot = axes('Parent', dataPanel,...
                'OuterPosition', [0 0 .5 .25], 'YLim', [-1 1]);
            ri.tiltPlot.Title.String = 'Tilt';
            %axis(ri.tiltPlot, [0 dl -1 1]);
            
            ri.tiltAnglePlot = axes('Parent', dataPanel,...
                'OuterPosition', [.5 0 .5 .25], 'YLim', [-1 1]);
            ri.tiltAnglePlot.Title.String = 'Tilt Angle';
            %axis(ri.tiltAnglePlot, [-1 1 -1 1]);
            
            
        end
        
        %init the map from the map class
        function initMap(ri)
            mapPanel = uipanel('Title', 'Rover Map', 'Position', [.6 0 .4 1]);
            
            ri.roverMap = RoverMap(mapPanel);
            %drawing da stuff
            hold(getAxes(ri.roverMap), 'on')
            drawWalls(ri.roverMap);
            drawRover(ri.roverMap, 1, 1, 90, 'sim');
            hold(getAxes(ri.roverMap), 'off')
        end
        
        %init the control buttons for the rover
        function initControlButtons(ri)
            controlPanel = uipanel('Title', 'Rover Controls', 'Position', [0, 0, .2, .5]);
            
            modePanel = uipanel(controlPanel, 'Position', [0 .85 1 .15]);
            autoPanel = uipanel(controlPanel, 'Position', [0 .7 1 .15]);
            commandPanel = uipanel(controlPanel, 'Position', [0 0 1 .7]);
            
            modeButtonGroup = uibuttongroup(modePanel,...
                'Position', [0 0 1 1]);
            
            ri.controlSim = uicontrol(modeButtonGroup,...
                'Style', 'radiobutton', 'String', 'Control Simulated Rover',...
                'Units', 'normalized',...
                'Position', [0 .5 1 .5]);
            
            ri.controlReal = uicontrol(modeButtonGroup,...
                'Style', 'radiobutton', 'String', 'Control Real Rover',...
                'Units', 'normalized',...
                'Position', [0 0 1 .5]);
            
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
            
            turnLeftButton = uicontrol(commandPanel, 'Style', 'pushbutton',...
                'String', 'Turn Left X Degrees',...
                'Units', 'normalized',...
                'Position', [0 .8 .5 .2],...
                'Callback', @ri.turnLeftButton_callback);
            
            ri.leftdegreeEntry = uicontrol(commandPanel, 'Style', 'edit',...
                'String', '45',...
                'Units', 'normalized',...
                'Position', [.5 .8 .5 .2]);
            
            turnRightButton = uicontrol(commandPanel, 'Style', 'pushbutton',...
                'String', 'Turn Right X Degrees',...
                'Units', 'normalized',...
                'Position', [0 .6 .5 .2],...
                'Callback', @ri.turnRightButton_callback);
            
            ri.rightdegreeEntry = uicontrol(commandPanel, 'Style', 'edit',...
                'String', '45',...
                'Units', 'normalized',...
                'Position', [.5 .6 .5 .2]);
            
            forwardButton = uicontrol(commandPanel, 'Style', 'pushbutton',...
                'String', 'Move Forward X cm',...
                'Units', 'normalized',...
                'Position', [0 .4 .5 .2],...
                'Callback', @ri.forwardButton_callback);
            
            ri.forwardEntry = uicontrol(commandPanel, 'Style', 'edit',...
                'String', '20',...
                'Units', 'normalized',...
                'Position', [.5 .4 .5 .2]);
            
            reverseButton = uicontrol(commandPanel, 'Style', 'pushbutton',...
                'String', 'Move Backward X cm',...
                'Units', 'normalized',...
                'Position', [0 .2 .5 .2],...
                'Callback', @ri.reverseButton_callback);
            
            ri.reverseEntry = uicontrol(commandPanel, 'Style', 'edit',...
                'String', '20',...
                'Units', 'normalized',...
                'Position', [.5 .2 .5 .2]);
            
            uturnButton = uicontrol(commandPanel, 'Style', 'pushbutton',...
                'String', 'Make U-Turn',...
                'Units', 'normalized',...
                'Position', [0 0 .5 .2],...
                'Callback', @ri.uturnButton_callback);
            
            uturnButtonGroup = uibuttongroup(commandPanel,...
                'Position', [.5 0 .5 .2]);
            
            ri.uturnRightToggle = uicontrol(uturnButtonGroup,...
                'Style', 'radiobutton', 'String', 'Right U-Turn',...
                'Units', 'normalized',...
                'Position', [0 0 1 .5]);
            
            ri.uturnLeftToggle = uicontrol(uturnButtonGroup,...
                'Style', 'radiobutton', 'String', 'Left U-Turn',...
                'Units', 'normalized',...
                'Position', [0 .5 1 .5]);
            
            
        end
        
        %init the data options buttons for simulator
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
        

        
        

        