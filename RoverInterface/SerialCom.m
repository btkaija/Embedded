classdef SerialCom < handle
    properties
        port
        portNumber
        portName
        receivedBits
        receivedData
        receivedState
        tempData
        dataReady
        sim
        db
        auto
        autoOn
    end
    methods
        %contructor
        function this = SerialCom(comPort, newSim, newDB)
            %references to these objects are used to trigger certian events
            this.sim = newSim;
            this.db = newDB;
            
            %used to turn the data into a msg
            this.auto = Automator(newDB);
            this.autoOn = 0;
            
            %check name of port passed in
            if (length(comPort) == 11 && strcmp(comPort(1:6), 'Serial'))
                this.portNumber = comPort(8:11);
                this.portName = comPort;
            else
                fprintf('Invalid port name. Try: Serial-COM6\n')
                return
            end
            
            %check and open
            if this.portAvailable(this.portName)== 0
                fprintf('Could not open port.\n')
            else
                openPort(this)
            end
            
            this.receivedData = zeros(1,10);
            this.dataReady = 0;
            this.receivedState = 'start';
        end
        
        %open the port
        function openPort(this)
            %init port
            this.port = serial(this.portNumber, 'BaudRate', 57600, 'Terminator', 126);
            this.port.BytesAvailableFcnMode = 'byte';
            this.port.BytesAvailableFcnCount = 19;
            this.port.BytesAvailableFcn = {@SerialCom.bytesAvailable_callback, this};
            %try opening port. if error delete the port
            try
                fopen(this.port);
            catch
                fprintf('ERROR: The port is unavailable to open. Deleting Port.\n')
                delete(this.port)
                return
            end
        end
        
        %closes the port and makes sure no errors occur
        function closePort(this)
            try
                fclose(ri.port);
                delete(this.port);
            catch
                fprintf('ERROR: That port does not exist. Deleting all ports instead.\n');
                delete(instrfind)
            end
        end
        
        %get the data as complete 10x value matrix
        function d = getReceivedData(this)
            if this.dataReady
                d = this.receivedData;
                this.receivedData = [];
            else
                fprintf('No data ready')
            end
            this.dataReady = 0;
        end
        
        %send message over the port
        function sendMessage(this, msg)
            out = strcat('Sending message: "', msg, '" over port ',...
                this.portName,'.\n');
            fprintf(out);

            msgParts = strsplit(msg, '-');
            %any preprossing goes here
            
            if strcmp(msgParts(1), 'uturn')
                
                b1 = hex2dec('4A');
                if strcmp('right', msgParts(2))
                    b2 = hex2dec('4A');
                else
                    b2 = hex2dec('4B');
                end
            elseif strcmp(msgParts(1), 'forward')        

                b1 = hex2dec('4B');
                b2 = str2double(msgParts(2));
            elseif strcmp(msgParts(1), 'reverse')

                b1 = hex2dec('4C');
                b2 = str2double(msgParts(2));
                    
            else
                fprintf('No valid message format.\n');
            end
            %compile message and send
            msgBytes = [hex2dec('40'), b1, b2, hex2dec('40')];
            fwrite(this.port, msgBytes)
        end
        %starts the automation
        function startAutomator(this)
            fprintf('Starting Automator.\n');
            this.autoOn = 1;
        end
        %stops the automation
        function stopAutomator(this)
            fprintf('Stopping Automator.\n');
            this.autoOn = 0;
        end
        
        %gets the state of the automator
        function s = getRealState(this)
            s = getState(this.auto);
        end
        
    end
    methods (Static)
        function bytesAvailable_callback(obj, ~, this)
            fprintf('Bytes recieved.\n')
            numBytes = obj.BytesAvailable;
            
            %check recieved number of bytes
            if numBytes == 19
                binaryData = fread(obj, numBytes);
                if(binaryData(1) == 64 && binaryData(13) == 128 && binaryData(3) == 159)
                    fprintf('All sensor data present.\n')
                end
                
                if(binaryData(14) == 64 && binaryData(19) == 128 && binaryData(16) == 155)
                    fprintf('All motor data present.\n')
                end
                    
            elseif(numBytes ~= 0)
                fprintf('Trash data recieved.\n')
                return
            else
                fprintf('No bytes! Something went wrong.\n')
                return
            end
            
            this.receivedBits = binaryData;
            
            %show data
            %binaryData
            
            %get the values for newRealData 
            %[LM RM]
            %[LIR RIR LUS RUS]
            [receivedSensorData, ind] = updateReceivedSensorData(this);
            receivedMotorData = updateReceivedMotorData(this);
            
            
            %will trigger every time recieved data is ready to be added to DB
            if this.dataReady
                if this.sim.isOn
                    fprintf('Cannot add data, Sim is running.\n');
                    %do nothing.
                    return
                else %no sim running
                    newRealData = getLastDataSet(this.db, 'real');
                    %get lastest sim data and use that as new sim value
                    newSimData = getLastDataSet(this.db, 'sim');
                    
                    if(strcmp('sensor',ind))
                        newRealData(1:4) = receivedSensorData(1:4);
                    else %tilt
                        newRealData(7) = receivedSensorData(2);
                    end
                    
                    newRealData(5:6) = receivedMotorData;
                    %update sensor readings
                    appendData(this.db, newSimData, newRealData);
                    
                    %move rover to new position
                    
                end
                
                %automatically decide and send next command
                if this.autoOn
                    newMsg = getNextCommand(this.auto);
                    sendMessage(this, newMsg);
                end
                this.dataReady = 0;
            end
        end

    end
    
    methods (Access = private)
        
        function d = updateReceivedMotorData(this)

            encoderTurns = [dec2hex(this.receivedBits(18)) dec2hex(this.receivedBits(17))];
            encoderTurns = hex2dec(encoderTurns);
            dist  = encoderTurns/80;
            d = [dist dist];
            this.dataReady = 1;
        end
        
        function [d, ind] = updateReceivedSensorData(this)

            isSensor = 1;
            
            %get the indicator byte
            switch(this.receivedBits(12)) 
                case 170 %0xAA
                    fprintf('at starting position.\n')
                    %starting position
                case 218 %0xDA
                    %inside left lane
                case 220 %0xDC
                    %exit left lane
                case 187 %0xBB
                    %inside middle lane
                case 188 %0xBC
                    %exit middle lane
                case 202 %0xCA
                    %enter right lane
                case 204 %0xCC
                    %exit course
                case 250 %0xFA
                    %up ramp
                    isSensor = 0;
                    setState(this.auto, 'up_ramp')
                    tiltA = 0.3;
                case 251 %0xFB
                    %down ramp
                    isSensor = 0;
                    setState(this.auto, 'down_ramp')
                    tiltA = -0.3;
                otherwise
                    %should never reach here
                    isSensor = 0;
                    fprintf('Something is wrong, Incorrect indicator.\n')
            end
            
            if(isSensor)
                right = this.receivedBits(6);
                left = this.receivedBits(10);
                d = [left right left right];
                ind = 'sensor';
            else %is tilt
                fprintf('Need to handle tilt data receipt!\n')
                ind = 'tilt';
                d = [tiltA, 0, 0, 0];
            end
            this.dataReady = 1;
            
        end
        
        %returns 1 if port is open, otherwise, returns 0
        %input should be of the format 'Serial-COM6'
        function available = portAvailable(~, port)
            available = 1;
            availablePorts = instrfind;
            for i = 1:length(availablePorts)
                if strcmp(availablePorts(i).Name, port)
                    fprintf(strcat('ERROR: ',port ,' has already been created.\n'))
                    available = 0;
                    return
                end
                if (strcmp(availablePorts(i).Status, 'open') && strcmp(availablePorts(i).Name, port))
                    fprintf('ERROR: That port is already open. Use instrfind to double check.\n')
                    available = 0;
                    return
                end
            end
        end
        
    end
end