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
            this.simData = ones(1,10);
            this.realData = ones(1,10);
            this.dataLen = 1;
            this.totalLen = 10;
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
        
        %GET xpos data
        function td = getXposData(this, type)
            if strcmp(type, 'real')
                td = this.realData(this.dataLen*7+1:this.dataLen*8);
            elseif strcmp(type, 'sim')
                td = this.simData(this.dataLen*7+1:this.dataLen*8);
            else
                fprintf('Specify either real or sim data\n')
            end
                   
        end
        
        %GET ypos data
        function td = getYposData(this, type)
            if strcmp(type, 'real')
                td = this.realData(this.dataLen*8+1:this.dataLen*9);
            elseif strcmp(type, 'sim')
                td = this.simData(this.dataLen*8+1:this.dataLen*9);
            else
                fprintf('Specify either real or sim data\n')
            end
                   
        end
        
        %GET angle data
        function td = getAngleData(this, type)
            if strcmp(type, 'real')
                td = this.realData(this.dataLen*9+1:this.dataLen*10);
            elseif strcmp(type, 'sim')
                td = this.simData(this.dataLen*9+1:this.dataLen*10);
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
        
        %GET dataLen
        function dl = getDataLength(this)
            dl = this.dataLen;
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
        
        %SET xpos data
        function setXposData(this, newData, type)
            if length(newData) ~= this.dataLen
                fprintf('The data is not the correct size\n')
            end
            if strcmp(type, 'real')
                this.realData(this.dataLen*7+1:this.dataLen*8) = newData;
            elseif strcmp(type, 'sim')
                this.simData(this.dataLen*7+1:this.dataLen*8) = newData;
            else
                fprintf('Specify either real or sim data\n')
            end
        end
        
        %SET ypos data
        function setYposData(this, newData, type)
            if length(newData) ~= this.dataLen
                fprintf('The data is not the correct size\n')
            end
            if strcmp(type, 'real')
                this.realData(this.dataLen*8+1:this.dataLen*9) = newData;
            elseif strcmp(type, 'sim')
                this.simData(this.dataLen*8+1:this.dataLen*9) = newData;
            else
                fprintf('Specify either real or sim data\n')
            end
        end
        
        %SET angle data
        function setAngleData(this, newData, type)
            if length(newData) ~= this.dataLen
                fprintf('The data is not the correct size\n')
            end
            if strcmp(type, 'real')
                this.realData(this.dataLen*9+1:this.dataLen*10) = newData;
            elseif strcmp(type, 'sim')
                this.simData(this.dataLen*9+1:this.dataLen*10) = newData;
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
        %formatted as: [LIR, RIR, LUS, RUS, LM, RM, T, XP, YP, A]
        %this is the primary way to add data to the data bank
        function appendData(this, newSimData, newRealData)
            totalPoints = length(newSimData);
            numPoints = totalPoints/10;
            %check all data can be added to data bank
            if mod(totalPoints, 10) ~= 0
                fprintf('ERROR: Appended data should be multiple of seven.\n');
                return
            end
            %check sets are the same
            if length(newRealData) ~= totalPoints
                fprintf('ERROR: Simulated and Real datasets do not match in length.\n');
                return
            end
            %add that shizzle!
            for i = 1:1:10
                pos = i*(this.dataLen + 1);
                
                %insert new  real data
                this.realData = ...
                    [this.realData(1:pos-1),...
                    newRealData((i-1)*numPoints+1:numPoints*i),...
                    this.realData(pos:this.totalLen)];

                %insert new sim data
                this.simData = ...
                    [this.simData(1:pos-1),...
                    newSimData((i-1)*numPoints+1:numPoints*i),...
                    this.simData(pos:this.totalLen)];
                
                this.totalLen = this.totalLen + numPoints;
            end
            
            %update length of data collections
            this.dataLen = numPoints + this.dataLen;
        end
        
    end
    methods(Static)
        %data manip methods
        %***************
    end
end