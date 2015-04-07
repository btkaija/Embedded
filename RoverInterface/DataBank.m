classdef DataBank < handle
    properties
        simData
        realData
        dataLen
        totalLen
    end
    methods
        %Constructor
        function this = DataBank()
            this.simData = [0 0 0 0 0 0 0];
            this.realData = [0 0 0 0 0 0 0];
            this.dataLen = 1;
            this.totalLen = 7;
        end
        
        %Getter methods
        
        %GET left IR sensor data
        function td = getLIRSData(this, type)
            if strcmp(type, 'real')
                td = this.realData(this.dataLen*0+1:this.dataLen*1);
            elseif strcmp(type, 'sim')
                td = this.simData(this.dataLen*0+1:this.dataLen*1);
            else
                fprintf('Specify either real or sim data\n')
            end
                   
        end
        
        %GET right IR sensor data
        function td = getRIRSData(this, type)
            if strcmp(type, 'real')
                td = this.realData(this.dataLen*1+1:this.dataLen*2);
            elseif strcmp(type, 'sim')
                td = this.simData(this.dataLen*1+1:this.dataLen*2);
            else
                fprintf('Specify either real or sim data\n')
            end
                   
        end
        
        %GET left US sensor data
        function td = getLUSSData(this, type)
            if strcmp(type, 'real')
                td = this.realData(this.dataLen*2+1:this.dataLen*3);
            elseif strcmp(type, 'sim')
                td = this.simData(this.dataLen*2+1:this.dataLen*3);
            else
                fprintf('Specify either real or sim data\n')
            end
                   
        end
        
        %GET right US sensor data
        function td = getRUSSData(this, type)
            if strcmp(type, 'real')
                td = this.realData(this.dataLen*3+1:this.dataLen*4);
            elseif strcmp(type, 'sim')
                td = this.simData(this.dataLen*3+1:this.dataLen*4);
            else
                fprintf('Specify either real or sim data\n')
            end
                   
        end
        
        %GET left motor data
        function td = getLMData(this, type)
            if strcmp(type, 'real')
                td = this.realData(this.dataLen*4+1:this.dataLen*5);
            elseif strcmp(type, 'sim')
                td = this.simData(this.dataLen*4+1:this.dataLen*5);
            else
                fprintf('Specify either real or sim data\n')
            end
                   
        end
        
        %GET right motor data
        function td = getRMData(this, type)
            if strcmp(type, 'real')
                td = this.realData(this.dataLen*5+1:this.dataLen*6);
            elseif strcmp(type, 'sim')
                td = this.simData(this.dataLen*5+1:this.dataLen*6);
            else
                fprintf('Specify either real or sim data\n')
            end
                   
        end
        
        %GET tilt data
        function td = getTiltData(this, type)
            if strcmp(type, 'real')
                td = this.realData(this.dataLen*6+1:this.dataLen*7);
            elseif strcmp(type, 'sim')
                td = this.simData(this.dataLen*6+1:this.dataLen*7);
            else
                fprintf('Specify either real or sim data\n')
            end
                   
        end
        
        %GET all data
        function d = getAllData(this, type)
            if strcmp(type, 'real')
                d = this.allRealData;
            elseif strcmp(type, 'sim')
                d = this.allSimData;
            else
                fprintf('Specify either real or sim data\n')
            end
        end
        
        %***************
        
        %Setter methods
        
        %SET left IR sensor data
        function setLIRSData(this, newData, type)
            if length(newData) ~= this.dataLen
                fprintf('The data is not the correct size\n')
            end
            if strcmp(type, 'real')
                this.realData(this.dataLen*0+1:this.dataLen*1) = newData;
            elseif strcmp(type, 'sim')
                this.simData(this.dataLen*0+1:this.dataLen*1) = newData;
            else
                fprintf('Specify either real or sim data\n')
            end
        end
        
        %SET right IR sensor data
        function setRIRSData(this, newData, type)
            if length(newData) ~= this.dataLen
                fprintf('The data is not the correct size\n')
            end
            if strcmp(type, 'real')
                this.realData(this.dataLen*1+1:this.dataLen*2) = newData;
            elseif strcmp(type, 'sim')
                this.simData(this.dataLen*1+1:this.dataLen*2) = newData;
            else
                fprintf('Specify either real or sim data\n')
            end
        end
        
        %SET left US sensor data
        function setLUSSData(this, newData, type)
            if length(newData) ~= this.dataLen
                fprintf('The data is not the correct size\n')
            end
            if strcmp(type, 'real')
                this.realData(this.dataLen*2+1:this.dataLen*3) = newData;
            elseif strcmp(type, 'sim')
                this.simData(this.dataLen*2+1:this.dataLen*3) = newData;
            else
                fprintf('Specify either real or sim data\n')
            end
        end
        
        %SET right US sensor data
        function setRUSSData(this, newData, type)
            if length(newData) ~= this.dataLen
                fprintf('The data is not the correct size\n')
            end
            if strcmp(type, 'real')
                this.realData(this.dataLen*3+1:this.dataLen*4) = newData;
            elseif strcmp(type, 'sim')
                this.simData(this.dataLen*3+1:this.dataLen*4) = newData;
            else
                fprintf('Specify either real or sim data\n')
            end
        end
        
        %SET left motor data
        function setLMData(this, newData, type)
            if length(newData) ~= this.dataLen
                fprintf('The data is not the correct size\n')
            end
            if strcmp(type, 'real')
                this.realData(this.dataLen*4+1:this.dataLen*5) = newData;
            elseif strcmp(type, 'sim')
                this.simData(this.dataLen*4+1:this.dataLen*5) = newData;
            else
                fprintf('Specify either real or sim data\n')
            end
        end
        
        %SET right motor data
        function setRMData(this, newData, type)
            if length(newData) ~= this.dataLen
                fprintf('The data is not the correct size\n')
            end
            if strcmp(type, 'real')
                this.realData(this.dataLen*5+1:this.dataLen*6) = newData;
            elseif strcmp(type, 'sim')
                this.simData(this.dataLen*5+1:this.dataLen*6) = newData;
            else
                fprintf('Specify either real or sim data\n')
            end
        end
        
        %SET tilt sensor data
        function setTiltData(this, newData, type)
            if length(newData) ~= this.dataLen
                fprintf('The data is not the correct size\n')
            end
            if strcmp(type, 'real')
                this.realData(this.dataLen*6+1:this.dataLen*7) = newData;
            elseif strcmp(type, 'sim')
                this.simData(this.dataLen*6+1:this.dataLen*7) = newData;
            else
                fprintf('Specify either real or sim data\n')
            end
        end
        
        %SET all data
        function setAllData(this, newData, type)
            if strcmp(type, 'real')
                this.realData = newData;
            elseif strcmp(type, 'sim')
                this.simData = newData;
            else
                fprintf('Specify either real or sim data\n')
            end
        end
        
        %***************
        
        %adding single data point methods
        
        %append data for all types
        %must be an array of data that has a multiple of 7 data points
        %formatted as: [LIR, RIR, LUS, RUS, LM, RM, T]
        %this is the primary way to add data to the plots
        function appendData(this, newData, type)
            if mod(length(newData), 7) ~= 0
                fprintf('ERROR: Appended data should be multiple of 7\n');
                return
            end
            numPoints = length(newData/7);
            
            
            if strcmp(type, 'real')
                %left IR sensor
                this.realData = [this.realData(this.dataLen*0+1:this.dataLen*1),...
                    newData(numPoints*0+1:numPoints*1),...
                    this.realData(this.dataLen*1+1:this.dataLen*7)];
                %right IR sensor
                this.realData = [this.realData(this.dataLen*1+1:this.dataLen*2),...
                    newData(numPoints*1+1:numPoints*2),...
                    this.realData(this.dataLen*2+1:this.dataLen*7)];
                %left US sensor
                this.realData = [this.realData(this.dataLen*2+1:this.dataLen*3),...
                    newData(numPoints*2+1:numPoints*3),...
                    this.realData(this.dataLen*3+1:this.dataLen*7)];
                %right US sensor
                this.realData = [this.realData(this.dataLen*3+1:this.dataLen*4),...
                    newData(numPoints*3+1:numPoints*4),...
                    this.realData(this.dataLen*4+1:this.dataLen*7)];
                %left motor
                this.realData = [this.realData(this.dataLen*4+1:this.dataLen*5),...
                    newData(numPoints*4+1:numPoints*5),...
                    this.realData(this.dataLen*5+1:this.dataLen*7)];
                %right motor
                this.realData = [this.realData(this.dataLen*5+1:this.dataLen*6),...
                    newData(numPoints*5+1:numPoints*6),...
                    this.realData(this.dataLen*6+1:this.dataLen*7)];
                %tilt data
                this.realData = [this.realData(this.dataLen*6+1:this.dataLen*7),...
                    newData(numPoints*6+1:numPoints*7)];
            elseif strcmp(type, 'sim')
                %left IR sensor
                this.simData = [this.simData(this.dataLen*0+1:this.dataLen*1),...
                    newData(numPoints*0+1:numPoints*1),...
                    this.simData(this.dataLen*1+1:this.dataLen*7)];
                %right IR sensor
                this.simData = [this.simData(this.dataLen*1+1:this.dataLen*2),...
                    newData(numPoints*1+1:numPoints*2),...
                    this.simData(this.dataLen*2+1:this.dataLen*7)];
                %left US sensor
                this.simData = [this.simData(this.dataLen*2+1:this.dataLen*3),...
                    newData(numPoints*2+1:numPoints*3),...
                    this.simData(this.dataLen*3+1:this.dataLen*7)];
                %right US sensor
                this.simData = [this.simData(this.dataLen*3+1:this.dataLen*4),...
                    newData(numPoints*3+1:numPoints*4),...
                    this.simData(this.dataLen*4+1:this.dataLen*7)];
                %left motor
                this.simData = [this.simData(this.dataLen*4+1:this.dataLen*5),...
                    newData(numPoints*4+1:numPoints*5),...
                    this.simData(this.dataLen*5+1:this.dataLen*7)];
                %right motor
                this.simData = [this.simData(this.dataLen*5+1:this.dataLen*6),...
                    newData(numPoints*5+1:numPoints*6),...
                    this.simData(this.dataLen*6+1:this.dataLen*7)];
                %tilt data
                this.simData = [this.simData(this.dataLen*6+1:this.dataLen*7),...
                    newData(numPoints*6+1:numPoints*7)];
            else
                fprintf('Specify either real or sim data\n');
            end
            %update lengths of data
            this.dataLen = numPoints + this.dataLen;
            this.totalLen = this.dataLen*7;
        end
        
    end
    methods(Static)
        %data manip methods
        %***************
    end
end