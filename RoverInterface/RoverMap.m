classdef RoverMap < handle
    properties (Access = private)
        %map
        mapAxes
        %positions
        simRoverXpos
        simRoverYpos
        simRoverAngle
        
        
        simLeftIRpos
        simRightIRpos
        simLeftUSpos
        simRightUSpos
    end
    methods
        function this = RoverMap(parentPanel)
            newAxes = axes('Parent', parentPanel,...
                'Position', [.02, .02, .96, .96],...
                'XLim', [-2 8], 'YLim', [0 14],... 
                'Visible', 'off');
            this.mapAxes = newAxes;
            %init walls on map
            hold all
            drawWalls(this);
            hold off
        end
        
        %Draws the rover on the map at the specified position
        %Error checking for the limits of the map
        %the position of the rover is the center of the rover
        %the angle is in degrees
        function drawSimRover(this, xpos, ypos, angle)
            
            %error checking for limits of map
            if (xpos < 0.6 || xpos > 5.4)
                fprintf('Rover beyond wall, not possible!')
                return
            end
            
            this.simRoverXpos = xpos;
            this.simRoverYpos = ypos;
            this.simRoverAngle = angle;
            %update plot here
            
            m = 0.5*sqrt(2);
            x1 = m*cos((2*pi)*(angle/360));
            x2 = m*cos((2*pi)*((angle+90)/360));
            x3 = m*cos((2*pi)*((angle+180)/360));
            x4 = m*cos((2*pi)*((angle+270)/360));
            y1 = m*sin((2*pi)*(angle/360));
            y2 = m*sin((2*pi)*((angle+90)/360));
            y3 = m*sin((2*pi)*((angle+180)/360));
            y4 = m*sin((2*pi)*((angle+270)/360));
            
            hold all
            
            drawWalls(this)
            %plot rover body
             plot(this.mapAxes, [xpos+x1, xpos+x2, xpos+x3, xpos+x4, xpos+x1],...
                [ypos+y1, ypos+y2, ypos+y3, ypos+y4, ypos+y1], 'b')
            %plot directional arrow
            plot(this.mapAxes, [xpos, xpos+0.5*cos(2*pi*(45+angle)/360)],...
                [ypos, ypos+0.5*sin(2*pi*(45+angle)/360)], 'b')
            plot(this.mapAxes, [xpos+0.4*cos(2*pi*(55+angle)/360), xpos+0.5*cos(2*pi*(45+angle)/360)],...
                [ypos+0.4*sin(2*pi*(55+angle)/360), ypos+0.5*sin(2*pi*(45+angle)/360)], 'b')
            plot(this.mapAxes, [xpos+0.4*cos(2*pi*(35+angle)/360), xpos+0.5*cos(2*pi*(45+angle)/360)],...
                [ypos+0.4*sin(2*pi*(35+angle)/360), ypos+0.5*sin(2*pi*(45+angle)/360)], 'b')
            
            %TODO draw sensor values
            
            hold off
        end
        
        %Draws the walls on the map
        function drawWalls(this)
            %left wall
            plot(this.mapAxes, [0 0], [2 12], 'k', 'LineWidth', 5)
            %right wall
            plot(this.mapAxes, [6 6], [2 12], 'k', 'LineWidth', 5)
            %left lane
            plot(this.mapAxes, [2 2], [2 12], 'k--')
            %right lane
            plot(this.mapAxes, [4 4], [2 12], 'k--')
        end
    end
    methods(Static)
        
        
    end
end