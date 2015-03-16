function my_gui
%MY_GUI creates a new test gui
screen_size = get(0, 'ScreenSize');
%used later for creating UI element spacing
screen_left = screen_size(1)+100;
screen_bottom = screen_size(2)+100;
screen_width = screen_size(3)-200;
screen_height = screen_size(4)-200;
%init window
fig = figure('Visible', 'on', 'Position', [screen_left, screen_bottom, screen_width, screen_height]);

%create GUI elements
startButton = uicontrol('Style', 'pushbutton', 'String', 'Start',...
                        'Position', [10, screen_height/10 * 1, 50, 25],...
                        'Callback', @startButton_callback);
stopButton = uicontrol('Style', 'pushbutton', 'String', 'Stop',...
                       'Position', [10, screen_height/10 * 2, 50, 25],...
                       'Callback', @stopButton_callback);

end

function startButton_callback(source, callbackData)
    fprintf('start button\n');
end

function stopButton_callback(source, callbackData)
    fprintf('stop button\n');
end