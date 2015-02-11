% SensorSim
%
% I will run this driver as a script so that you can use the 
% command window to interact with the simulation as it 
% is running. Ultimately this would probably a function 
% with some other interface (e.g., a GUI).
%
% This script does three things:
%    1. Create a sensor object (instance of the Sensor Class)
%    2. Start a timer that queries this sensor (think PIC A/D)
%    3. Open the serial connection to the WiFly 
%

% Create a Sensor object, paramter is the initial distance to 
% the wall
obj = Sensor(5.0);

% Create and start the sensorSimTimer object
sensorSimTimer = timer;
sensorSimTimer.Period         = obj.getTimerPeriod();
sensorSimTimer.ExecutionMode  = 'fixedRate';
sensorSimTimer.TimerFcn       = {@callbackSensorSimTimer,obj};
sensorSimTimer.BusyMode       = 'drop';
start(sensorSimTimer);

% Connect to WiFly and setup serial callback
% You will have to change this to agree with your WiFly
% Note that I have set up the WiFly to have a baud rate of 57600
ioSensorSimWiFly=serial('COM4','BaudRate',57600);

% Note that we will pass the Sensor object to the callback
ioSensorSimWiFly.BytesAvailableFcn = {@callbackSensorSimWiFly,obj};

%io2.terminator = uint8(255);
ioSensorSimWiFly.terminator = 'o';
fopen(ioSensorSimWiFly);


