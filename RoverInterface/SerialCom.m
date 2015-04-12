classdef SerialCom < handle
    properties
        port
        portNumber
        portName
        recievedBits
        receivedData
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
        end
        
        %open the port
        function openPort(this)
            %init port
            this.port = serial(this.portNumber, 'BaudRate', 57600, 'Terminator', 126);
            this.port.BytesAvailableFcnMode = 'byte';
            this.port.BytesAvailableFcnCount = 1;
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
            else
                fprintf('No data ready')
            end
            this.dataReady = 0;
        end
        
        %send message over the port
        function sendMessage(this, msg)
            out = strcat('Sending message: "', msg, '" over port "',...
                this.portName,'.\n');
            fprintf(out);
            %any preprossing goes here
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
        
        
    end
    methods (Static)
        function bytesAvailable_callback(obj, ~, this)
            fprintf('Byte recieved\n')
            numBytes = obj.BytesAvailable;
            binaryData = [];
            if numBytes > 0
                binaryData = fread(obj, numBytes);
            else
                fprintf('No bytes! Something went wrong.\n')
            end
            this.recievedBits = [this.recievedBits binaryData];
            
            %init data to be added to DB
            %newSimData = zeros(1,10);
            newRealData = zeros(1,10);
            
            %TODO
            %complete when integration process begins
            %error checking
            
            %add correct data to receivedData matrix
            %maybe just get it from tempData?
            
            %set dataReady boolean if data is ready
            %if extra data exists that can't be sent
            %store in tempData
            
            %will trigger every time recieved data is ready to be added to DB
            if this.dataReady
                if this.sim.isOn
                    %do nothing.
                    return
                else %no sim running
                    
                    %get lastest sim data and use that as new sim value
                    newSimData = getLastDataSet(this.db, 'sim');
                    
                    %use when part above is implemented
                    %newSimData
                    %newRealData = receivedData;
                    %receivedData = tempData;
                    appendData(this.db, newSimData, newRealData);
                end
                
                %automatically decide and send next command
                if this.autoOn
                    newMsg = getNextCommand(this.auto);
                    sendMessage(this, newMsg);
                end
            end
        end

    end
    
    methods (Access = private)
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