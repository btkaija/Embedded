classdef Simulator < handle
   properties
       simulateDataTimer
       leftIRSensorData
       rightIRSensorData
       leftUSSensorData
       rightUSSensorData
       leftMotorData
       rightMotorData
       tiltData
   end
   methods
        function sim = Simulator()
            sim.simulateDataTimer = timer;
            sim.simulateDataTimer.BusyMode = 'drop';
            sim.simulateDataTimer.TimerFcn = {@Simulator.simulateDataTimer_callback, sim};
            sim.simulateDataTimer.Period = 1;
            sim.simulateDataTimer.ExecutionMode = 'fixedRate';
        end
        
        
        %this function starts the timer
        function startSimulateDataTimer(obj)
            start(obj.simulateDataTimer)
        end
        
        
        %this function stops the timer
        function stopSimulateDataTimer(obj)
            try
                fprintf('Stopping sim timer...\n');
                stop(obj.simulateDataTimer);
            catch
                fprintf('Error stoping timer: simulateDataTimer does not exist\n');    
            end
        end
        
        
        function updateSimuatedData(sim)
            fprintf('Simulating data\n');
            sim.leftIRSensorData = [sim.leftIRSensorData sim.simulateRandData()];
            sim.rightIRSensorData = [sim.rightIRSensorData sim.simulateRandData()];
            sim.leftUSSensorData = [sim.leftUSSensorData sim.simulateRandData()];
            sim.rightUSSensorData = [sim.rightUSSensorData sim.simulateRandData()];
            sim.leftMotorData = [sim.leftMotorData sim.simulateRandData()];
            sim.rightMotorData = [sim.rightMotorData sim.simulateRandData()];
            sim.tiltData = [sim.tiltData sim.simulateRandTilt()];

        end
        
        %get left IR sensor data
        function LIRD = get.leftIRSensorData(obj)
            LIRD = obj.leftIRSensorData;
        end
        %get right IR sensor data
        function RIRD = get.rightIRSensorData(obj)
            RIRD = obj.rightIRSensorData;
        end
        %get left US sensor data
        function LUSD = get.leftUSSensorData(obj)
            LUSD = obj.leftUSSensorData;
        end
        %get right US sensor data
        function RUSD = get.rightUSSensorData(obj)
            RUSD = obj.rightUSSensorData;
        end
        %get left motor encoder data
        function RMD = get.rightMotorData(obj)
            RMD = obj.rightMotorData;
        end
        %get right motor encoder data
        function LMD = get.leftMotorData(obj)
            LMD = obj.leftMotorData;
        end
        
        %set left IR data
        function setLeftIRSensorData(obj, data)
            obj.leftIRSensorData = data;
        end
        %set right IR data
        function setRightIRSensorData(obj, data)
            obj.rightIRSensorData = data;
        end
        %set left US data
        function setLeftUSSensorData(obj, data)
            obj.leftUSSensorData = data;
        end
        %set right US data
        function setRightUSSensorData(obj, data)
            obj.rightUSSensorData = data;
        end
        %set right motor data
        function setRightMotorData(obj, data)
            obj.rightMotorData = data;
        end
        %set left motor data
        function setLeftMotorData(obj, data)
            obj.leftMotorData = data;
        end
        
        %get tilt data
        function t = get.tiltData(obj)
            t = obj.tiltData;
        end
        %set tilt data
        function setTiltData(obj, data)
            obj.tiltData = data;
        end
 
   end
   methods (Static)
       %callback function for the timer simulator
        function simulateDataTimer_callback(~, ~, sim)
            %TODO: implement real simulations
            updateSimuatedData(sim);
        end
        %simulates random data
        function randData = simulateRandData()
            randData = rand(1, 1)*100;
        end
        
        %generate random tilt slope
        function randTilt = simulateRandTilt()
            randTilt = rand(1,1);
            if rand(1,1) > .5
                randTilt = randTilt * -1;
            end
        end

   end
end