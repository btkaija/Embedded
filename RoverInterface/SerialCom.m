classdef SerialCom < handle
    properties
        port
    end
    methods
        %contructor
        function this = SerialCom(comPort)
            %check string passed in
            if (length(comPort) == 11)
                portnumber = comPort(8:11);
            else
                fprintf('invalid port\n')
                return
            end
            
            %check and open
            if 0 == this.portAvailable(comPort)
                fprintf('could not open port\n')
            else
                this.port = serial(portnumber, 'BaudRate', 57600, 'Terminator', 126);
                this.port.BytesAvailableFcnMode = 'byte';
                this.port.BytesAvailableFcnCount = 1;
                this.port.BytesAvailableFcn = {@SerialCom.bytesAvailable_callback};
                this.openPort(comPort, this)
            end
        end
        
        function closePort(this)
            fclose(this.port);
            delete(this.port);
        end
        
        
    end
    methods (Static)
        function bytesAvailable_callback(obj, event)
            fprintf('byte recieved\n')
%             numBytes = obj.BytesAvailable;
%             binaryData = [];
%             if numBytes > 0
%                 binaryData = fread(obj, numBytes);
%             else
%                 fprintf('No bytes! Is the PIC broken!?')
%             end
%             string = char(binaryData);
%             string = string(1:numBytes-1);
%             fprintf('Data being recieved! Data: %s\n', string)
        end
        
        %returns 1 if port is open, otherwise, returns 0
        %input should be of the format 'Serial-COM6'
        function available = portAvailable(port)
            available = 1;
            availablePorts = instrfind;
            for i = 1:length(availablePorts)
                if strcmp(availablePorts(i).Name, port)
                    fprintf('ERROR: Invalid port, possiblely in use, or the name is invalid\n')
                    available = 0;
                    return
                end
                if (strcmp(availablePorts(i).Status, 'open') && strcmp(availablePorts(i).Name, port))
                    fprintf('ERROR: That port is already open! God youre dumb...\n')
                    available = 0;
                    return
                end
            end
        end
        
        %open the port
        function openPort(port, this)
            try
                fopen(this.port);
            catch err
                availablePorts = instrfind;
                for i = 1:length(availablePorts)
                    if strcmp(availablePorts(i).Name, port)
                        fprintf('ERROR: The port needed for the Control PIC is unavailable\n')
                        delete(this.port)
                        return
                    end
                end
                fprintf('unknown error')
            end

        end
    end
end