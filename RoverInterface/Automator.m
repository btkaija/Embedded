classdef Automator < handle
    properties
        db
    end
    methods
        %constructor
        function this = Automator(dataBank)
            this.db = dataBank;
        end
        
        %emulates functionality of simulator
        function cmd = getNextCommand(this)
            cmd = 'new command';
        end
    end
end