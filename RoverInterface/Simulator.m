classdef Simulator < handle
   
   properties
       simulateDataTimer
       db
       isOn
       port
       state
   end
   
   methods
       
        %constructor
        function this = Simulator(dataBase, serial)
            this.port = serial;
            this.db = dataBase;
            this.isOn = 0;
            this.state = 'start';
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
            this.isOn = 1;
        end
        
        
        %this function stops the timer
        function stopSimulateDataTimer(obj)
            try
                fprintf('Stopping simulateDataTimer...\n');
                stop(obj.simulateDataTimer);
                delete(obj.simulateDataTimer);
                obj.isOn = 0;
            catch
                fprintf('Warning: simulateDataTimer does not exist.\n');    
            end
        end
        
        function simulateMove(this)
            ERROR = 1;%cm
            
            switch this.state
                case 'start'
                    moveForward(this.db, 'sim', 20)
                case 'left'
                    moveForward(this.db, 'sim', 10)
                case 'right'
                    moveForward(this.db, 'sim', 10)
                case 'middle'
                    moveForward(this.db, 'sim', 10)
                case 'uturn1_1'
                    moveForward(this.db, 'sim', 30)
                case 'uturn1_2'
                    uturn(this.db, 'sim', 'right')
                otherwise
                    fprintf('No state selected for Sim.\n')
                    return
            end
            ds = getLastDataSet(this.db, 'sim');
            
            if(abs(ds(1) - ds(3)) < ERROR)
                this.state = 'left';
                return
            end
            
            if(abs(ds(2) - ds(4)) < ERROR)
                this.state = 'right';
                return
            end
            
            if(abs(ds(3)-ds(4)) < 2*ERROR && ds(1) == 25 && ds(2) == 25)
                this.state = 'middle';
                return
            end
            
            %first uturn
            if((strcmp(this.state, 'left')) && ds(1) == 25)
                this.state = 'uturn1_1';
                return
            end
            ds(1)
            ds(3)
            this.state
            if(strcmp(this.state, 'uturn1_1') && ds(1) == 25 && ds(3) == 180)
                this.state = 'uturn1_2';
                return
            end
                
            fprintf('No new state found.\n')
        end
        
   end
   methods (Static)
       
       %callback function for the timer simulator
        function simulateDataTimer_callback(~, ~, this)
            %TODO: implement real simulations
            %fprintf('Simulating data...\n');
            
            updateRoverData(this.db);
            
            %make rover move here
            simulateMove(this)
            
                       
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