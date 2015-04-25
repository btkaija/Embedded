classdef RoverMap < handle
    properties (Access = private)
        %map
        mapAxes
        %positions
        simRoverXpos
        simRoverYpos
        simRoverAngle
        
        realRoverXpos
        realRoverYpos
        realRoverAngle
        
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
        %and sets the x, y and angle values at the same time
        %Error checking for the limits of the map
        %the position of the rover is the center of the rover
        %the angle is in degrees and relative to the x and y axis
        function drawRover(this, xpos, ypos, angle, type)
            
            %error checking for limits of map
            if (xpos < 0.75 || xpos > 5.25)
                fprintf('Rover beyond wall, not possible!\n')
                return
            end
            %offset to make input angles understandable
            origAngle = angle;
            angle = angle-45;
            %store
            if strcmp(type, 'sim')
                this.simRoverXpos = xpos;
                this.simRoverYpos = ypos;
                this.simRoverAngle = angle;
                color = 'b';
            elseif strcmp(type, 'real')
                this.realRoverXpos = xpos;
                this.realRoverYpos = ypos;
                this.realRoverAngle = angle;
                color = 'r';
            else
                fprintf('Specify which type of rover should be drawn!\n')
                return
            end
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
            
            hold (this.mapAxes, 'on')
            
            drawWalls(this)
            %plot rover body
             plot(this.mapAxes, [xpos+x1, xpos+x2, xpos+x3, xpos+x4, xpos+x1],...
                [ypos+y1, ypos+y2, ypos+y3, ypos+y4, ypos+y1], color)
            %plot directional arrow
            plot(this.mapAxes, [xpos, xpos+0.5*cos(2*pi*(45+angle)/360)],...
                [ypos, ypos+0.5*sin(2*pi*(45+angle)/360)], color)
            plot(this.mapAxes, [xpos+0.4*cos(2*pi*(55+angle)/360), xpos+0.5*cos(2*pi*(45+angle)/360)],...
                [ypos+0.4*sin(2*pi*(55+angle)/360), ypos+0.5*sin(2*pi*(45+angle)/360)], color)
            plot(this.mapAxes, [xpos+0.4*cos(2*pi*(35+angle)/360), xpos+0.5*cos(2*pi*(45+angle)/360)],...
                [ypos+0.4*sin(2*pi*(35+angle)/360), ypos+0.5*sin(2*pi*(45+angle)/360)], color)
            
            %draw sensor lines
            
            %plot right IR sensor
            xs1 = 0.6124*cos(2*pi*(origAngle - 60)/360)+xpos;
            ys1 = 0.6124*sin(2*pi*(origAngle - 60)/360)+ypos;
            xs2 = 0.8202*cos(2*pi*(origAngle - 90)/360)+xs1;
            ys2 = 0.8202*sin(2*pi*(origAngle - 90)/360)+ys1;
            plot(this.mapAxes, [xs1 xs2], [ys1 ys2], 'g--')
            
            %plot left IR sensor
            xs1 = 0.6124*cos(2*pi*(origAngle + 60)/360)+xpos;
            ys1 = 0.6124*sin(2*pi*(origAngle + 60)/360)+ypos;
            xs2 = 0.8202*cos(2*pi*(origAngle + 90)/360)+xs1;
            ys2 = 0.8202*sin(2*pi*(origAngle + 90)/360)+ys1;
            plot(this.mapAxes, [xs1 xs2], [ys1 ys2], 'g--')
            
            %plot right US sensor
            xs1 = 0.6124*cos(2*pi*(origAngle - 120)/360)+xpos;
            ys1 = 0.6124*sin(2*pi*(origAngle - 120)/360)+ypos;
            xs2 = 5.9055*cos(2*pi*(origAngle - 90)/360)+xs1;
            ys2 = 5.9055*sin(2*pi*(origAngle - 90)/360)+ys1;
            plot(this.mapAxes, [xs1 xs2], [ys1 ys2], 'g--')
            
            %plot left US sensor
            xs1 = 0.6124*cos(2*pi*(origAngle + 120)/360)+xpos;
            ys1 = 0.6124*sin(2*pi*(origAngle + 120)/360)+ypos;
            xs2 = 5.9055*cos(2*pi*(origAngle + 90)/360)+xs1;
            ys2 = 5.9055*sin(2*pi*(origAngle + 90)/360)+ys1;
            plot(this.mapAxes, [xs1 xs2], [ys1 ys2], 'g--')
            
            hold (this.mapAxes, 'off')
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
            %tile lines
            plot(this.mapAxes, [0 6], [12 12], 'k--')
            plot(this.mapAxes, [0 6], [10 10], 'k--')
            plot(this.mapAxes, [0 6], [8 8], 'k--')
            plot(this.mapAxes, [0 6], [6 6], 'k--')
            plot(this.mapAxes, [0 6], [4 4], 'k--')
            plot(this.mapAxes, [0 6], [2 2], 'k--')
            
        end
        
        
        function drawPath(this, simXpos, simYpos, realXpos, realYpos, simAngle, realAngle, dl)
            hold (this.mapAxes, 'on')
            for i  = 1:1:dl
                if(abs(simAngle(i)) > 1)
                    plot(this.mapAxes, simXpos(i), simYpos(i), 'bx')
                else
                    plot(this.mapAxes, simXpos(i), simYpos(i), 'bo')
                end
                if(abs(realAngle(i)) > 1)
                    plot(this.mapAxes, realXpos(i), realYpos(i), 'rx')
                else
                    plot(this.mapAxes, realXpos(i), realYpos(i), 'ro')
                end
            end
            hold (this.mapAxes, 'off')
        end
        %get axes
        function axes = getAxes(this)
            axes = this.mapAxes;
        end
    end
    methods(Static)
        
        
    end
end