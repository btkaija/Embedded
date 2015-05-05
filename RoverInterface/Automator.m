classdef Automator < handle
    properties
        db
        state
    end
    methods
        %constructor
        function this = Automator(dataBank)
            this.db = dataBank;
            this.state = 'start';
        end
        
        %emulates functionality of simulator
        function setNewRoverPos(this, type, dist)
            switch this.state
                case 'start'
                    moveForward(this.db, type, dist)
                case 'in_left'
                    moveForward(this.db, type, dist)
                case 'in_right'
                    moveForward(this.db, type, dist)
                case 'out_left'
                    uturn(this.db, type, 'right')
                case 'out_middle'
                    uturn(this.db, type, 'left')
                case 'in_middle'
                    moveForward(this.db, type, dist)                    
                case 'exit'
                    %do nothing
                otherwise
                    fprintf('No state selected for real rover.\n')
                    return
            end
        end
        
        function setState(this, new)
            this.state = new;
        end
        
        function s = getState(this)
            s = this.state;
        end

    end
end