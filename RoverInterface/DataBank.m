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
            this.simData(10) = 90;
            this.realData = ones(1,10);
            this.realData(10) = 90;
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
        
        %GET last data set
        function ds = getLastDataSet(this, type)
            ds = [];
            if strcmp(type, 'real')
                for i = 1:1:10
                    ds = [ds this.realData(i*this.dataLen)];
                end
            elseif strcmp(type, 'sim')
                for i = 1:1:10
                    ds = [ds this.simData(i*this.dataLen)];
                end
            else
                ds = ones(1,10);
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
        %MOVE FORWARD
        %dist in cm
        %type either sim or real
        %only updates the x and y pos
        function moveForward(this, type, dist)

            dist = dist/30.48;
            last = getLastDataSet(this, type);
            x_0 = last(8);
            y_0 = last(9);
            angle = last(10);
            
            %calculate possible new position
            x = dist*cos(2*pi*(angle/360)) + x_0;
            y = dist*sin(2*pi*(angle/360)) + y_0;
            
            %check
            outOfBounds = 0;
            if(y < 0.75)
                fprintf('Cannot move rover beyond lower limit!\n')
                outOfBounds = 1;
            end
            if(y > 11.25)
                fprintf('Cannot move rover beyond upper limit!\n')
                outOfBounds = 1;
            end
            if(x < 0.75)
                fprintf('Cannot move rover beyond left limit!\n')
                outOfBounds = 1;
            end
            if(x > 5.25)
                fprintf('Cannot move rover beyond right limit!\n')
                outOfBounds = 1;
            end
            %set new data
            newData = last;
            if outOfBounds
                %dont change the pos
                %newData = last;
            else
                newData(8) = x;
                newData(9) = y;
                newData(10) = angle;
            end
            %add the new data to the DB
            if strcmp(type, 'real')
                lastOther = getLastDataSet(this, 'sim');
                appendData(this, lastOther, newData);
            elseif strcmp(type, 'sim')
                lastOther = getLastDataSet(this, 'real');
                appendData(this, newData, lastOther);
            else
                fprintf('Specify either real or sim data\n')
                return
            end 
        end
        %MOVE REVERSE
        %dist in cm
        %type either sim or real
        %only updates the x and y pos
        function moveReverse(this, type, dist)
            
            dist = dist/30.48;
            last = getLastDataSet(this, type);
            x_0 = last(8);
            y_0 = last(9);
            angle = last(10);
            
            %calculate possible new position
            x = x_0 - dist*cos(2*pi*(angle/360));
            y = y_0 - dist*sin(2*pi*(angle/360));
            
            %check
            outOfBounds = 0;
            if(y < 0.75)
                fprintf('Cannot move rover beyond lower limit!\n')
                outOfBounds = 1;
            end
            if(y > 11.25)
                fprintf('Cannot move rover beyond upper limit!\n')
                outOfBounds = 1;
            end
            if(x < 0.75)
                fprintf('Cannot move rover beyond left limit!\n')
                outOfBounds = 1;
            end
            if(x > 5.25)
                fprintf('Cannot move rover beyond right limit!\n')
                outOfBounds = 1;
            end
            %set new data
            newData = last;
            if outOfBounds
                %dont change the pos
                %newData = last;
            else
                newData(8) = x;
                newData(9) = y;
                newData(10) = angle;
            end
            %add the new data to the DB
            if strcmp(type, 'real')
                lastOther = getLastDataSet(this, 'sim');
                appendData(this, lastOther, newData);
            elseif strcmp(type, 'sim')
                lastOther = getLastDataSet(this, 'real');
                appendData(this, newData, lastOther);
            else
                fprintf('Specify either real or sim data\n')
                return
            end
        end
        
        %Turn X Degrees
        %angle is in degrees
        %dir is either right or left
        function turnXdegrees(this, type, angle, dir)
            last = getLastDataSet(this, type);
            lastAngle = last(10);
            if strcmp(dir, 'right')
                newAngle = lastAngle - angle;
            elseif strcmp(dir, 'left')
                newAngle = lastAngle + angle;
            else
                fprintf('Incorrect direction.\n');
                return
            end
            
            newData = last;
            newData(10) = newAngle;
            
            if strcmp(type, 'real')
                lastOther = getLastDataSet(this, 'sim');
                appendData(this, lastOther, newData);
            elseif strcmp(type, 'sim')
                lastOther = getLastDataSet(this, 'real');
                appendData(this, newData, lastOther);
            else
                fprintf('Specify either real or sim data\n')
                return
            end
        end
        
        %make a u turn left or right
        %dir can be left or right
        function uturn(this, type, dir)
            last = getLastDataSet(this, type);
            x_0 = last(8);
            y_0 = last(9);
            angle_0 = last(10);
            angle_0 = mod(angle_0, 360);
            angle = angle_0 + 180;
            
            if strcmp(dir, 'right')
                x = x_0 + cos(2*pi*((angle_0-90)/360));
                y = y_0 + sin(2*pi*((angle_0-90)/360));
            elseif strcmp(dir, 'left')
                x = x_0 - cos(2*pi*((angle_0-90)/360));
                y = y_0 - sin(2*pi*((angle_0-90)/360));
            else
                fprintf('Incorrect direction.\n');
                return
            end
            %check
            outOfBounds = 0;
            if(y < 0.75)
                fprintf('Cannot move rover beyond lower limit!\n')
                outOfBounds = 1;
            end
            if(y > 11.25)
                fprintf('Cannot move rover beyond upper limit!\n')
                outOfBounds = 1;
            end
            if(x < 0.75)
                fprintf('Cannot move rover beyond left limit!\n')
                outOfBounds = 1;
            end
            if(x > 5.25)
                fprintf('Cannot move rover beyond right limit!\n')
                outOfBounds = 1;
            end
            %set new data
            newData = last;
            if outOfBounds
                %dont change the pos
                %newData = last;
            else
                newData(8) = x;
                newData(9) = y;
                newData(10) = angle;
            end
            %add the new data to the DB
            if strcmp(type, 'real')
                lastOther = getLastDataSet(this, 'sim');
                appendData(this, lastOther, newData);
            elseif strcmp(type, 'sim')
                lastOther = getLastDataSet(this, 'real');
                appendData(this, newData, lastOther);
            else
                fprintf('Specify either real or sim data\n')
                return
            end
        end
        
        function d = calcLIRData(this, type)
            all = getLIRSData(this, type);
            
        end
        
        function d = calcRIRData(this, type)
        end
        
        function d = calcLUSData(this, type)
        end
        
        function d = calcRUSData(this, type)
        end
        
        %return constant or 0 motor speed
        function d = calcLMData(this, type)
        end
        
        %return constant or 0 motor speed
        function d = calcRMData(this, type)
        end
        
        function d = calcTiltData(this, type)
        end
        
        
    end
end