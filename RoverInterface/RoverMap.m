classdef RoverMap < handle
    properties
        mapAxes
        roverXpos
        roverYpos
    end
    methods
        function this = RoverMap(parentPanel)
            newAxes = axes('Parent', parentPanel,...
                'OuterPosition', [0, 0, 1, 1],...
                'XLim', [0 7], 'YLim', [0 11]);
            this.mapAxes = newAxes;
            %init walls on map
            hold all
            drawWalls(this);
            hold off
        end
        
        %Draws the rover on the map at the specified position
        %Error checking for the limits of the map
        function drawRover(this, xpos, ypos)
            %error checking for limits of map
            this.roverXpos = xpos;
            this.roverYpos = ypos;
            %update plot here
        end
        
        %Draws the walls on the map
        function drawWalls(this)
            %left wall
            plot(this.mapAxes, [1 1], [1 10], 'k', 'LineWidth', 5)
            %right wall
            plot(this.mapAxes, [6 6], [1 10], 'k', 'LineWidth', 5)
        end
    end
    methods(Static)
        
        
    end
end