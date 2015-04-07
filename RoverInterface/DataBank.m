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
            this.simData = [];
            this.realData = [];
            this.dataLen = 0;
            this.totalLen = 0;
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
    end
    methods(Static)
        %data manip methods
        %***************
    end
end