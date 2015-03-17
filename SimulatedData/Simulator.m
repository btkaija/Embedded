classdef Simulator < handle
   properties
       simulateDataTimer
       simulatedSensorData
       simulatedMotorData
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
            initGlobalVars
            try
                fprintf('Stopping timer...\n');
                stop(obj.simulateDataTimer);
            catch
                fprintf('Error stoping timer: simulateDataTimer does not exist\n');    
            end
        end
        
        
        function updateSimuatedData(nm, ns, sim)
            initGlobalVars
            fprintf('Recieving data\n');
            try
                sim.simulatedSensorData = [sim.simulatedSensorData ns];
                sim.simulatedMotorData = [sim.simulatedMotorData nm];
%                 figure
%                 plot(sim.simulatedSensorData)
%                 plot(sim.simulatedMotorData)
            catch
                fprintf('Simulated data variables not defined!\n');
            end

        end
        
        %simulates the sensor data and returns it
        function newSimulatedData = simulateSensorData(obj)
            newSimulatedData = rand(1, 1)*100;
        end
        
        
        %simulates the motor data and returns it
        function newSimulatedData = simulateMotorData(obj)
            newSimulatedData = rand(1, 1)*100;
        end
        
        function ssd = get.simulatedSensorData(obj)
            ssd = obj.simulatedSensorData;
        end
        
        function smd = get.simulatedMotorData(obj)
            smd = obj.simulatedMotorData;
        end
   end
   methods (Static)
       %callback function for the timer simulator
        function simulateDataTimer_callback(timerobj, event, sim)
            newMotor = simulateMotorData(sim);
            newSensor = simulateSensorData(sim);

            updateSimuatedData(newMotor, newSensor, sim);
        end
   end
end