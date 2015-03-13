function my_gui
%MY_GUI creates a new test gui
screen_size = get(0, 'ScreenSize');
%used later for creating UI element spacing
screen_left = screen_size(1);
screen_bottom = screen_size(2);
screen_width = screen_size(3);
screen_height = screen_size(4);
%init window
fig = figure('Visible', 'on', 'Position', screen_size);

%create GUI elements
startButton = uicontrol('Style', 'pushbutton', 'String', 'Start',...
                        'Position', [100, 100, 30, 30],...
                        'Callback', @startButton_callback);

end