classdef Simulator < handle
   
   properties
       simulateDataTimer
       db
   end
   
   methods
       
        %constructor
        function this = Simulator(dataBase)
            this.db = dataBase;
        end
        
        
        %this function (re)creates and starts the timer
        function startSimulateDataTimer(this)
            fprintf('Starting simulateDataTimer...\n')
            this.simulateDataTimer = timer;
            this.simulateDataTimer.BusyMode = 'drop';
            this.simulateDataTimer.TimerFcn = {@Simulator.simulateDataTimer_callback, this};
            this.simulateDataTimer.Period = 1;
            this.simulateDataTimer.ExecutionMode = 'fixedRate';
            this.simulateDataTimer.Name = 'SIM-timer';
            
            start(this.simulateDataTimer)
        end
        
        
        %this function stops the timer
        function stopSimulateDataTimer(obj)
            try
                fprintf('Stopping simulateDataTimer...\n');
                stop(obj.simulateDataTimer);
                delete(obj.simulateDataTimer);
            catch
                fprintf('Warning: simulateDataTimer does not exist.\n');    
            end
        end
        
        
   end
   methods (Static)
       
       %callback function for the timer simulator
        function simulateDataTimer_callback(~, ~, this)
            %TODO: implement real simulations
            fprintf('Simulating data...\n');
            %TEMP: generating and adding random data
            newData = [Simulator.simulateRandData(), Simulator.simulateRandData(),...
                Simulator.simulateRandData(), Simulator.simulateRandData(),...
                Simulator.simulateRandData(), Simulator.simulateRandData(),...
                Simulator.simulateRandTilt()];
            newData1 = [Simulator.simulateRandData(), Simulator.simulateRandData(),...
                Simulator.simulateRandData(), Simulator.simulateRandData(),...
                Simulator.simulateRandData(), Simulator.simulateRandData(),...
                Simulator.simulateRandTilt()];
            appendData(this.db, newData, newData1)
            %END TEMP
                       
        end
        %simulates random data
        function randData = simulateRandData()
            randData = rand(1, 1)*100;
        end
        
        %generate random tilt slope between -1 and 1
        function randTilt = simulateRandTilt()
            randTilt = rand(1,1);
            if rand(1,1) > .5
                randTilt = randTilt * -1;
            end
        end

   end
end