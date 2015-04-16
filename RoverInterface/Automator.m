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
        function cmd = getNextCommand(this)
            cmd = 'new command';
        end
        
        function setState(this, new)
            this.state = new;
        end
        
        function s = getState(this)
            s = this.state;
        end

    end
end