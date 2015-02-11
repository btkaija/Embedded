%this will open the serial connection acting as the controlPIC
%with a lot of error handeling, hooray!
availablePorts = instrfind;
for i = 1:length(availablePorts)
    if strcmp(availablePorts(i).Name, 'Serial-COM4')
        fprintf('ERROR: The port is already created, idiot! Run exitControlPICSim.m \n')
        return
    end
    if and(strcmp(availablePorts(i).Status, 'open'),strcmp(availablePorts(i).Name, 'Serial-COM4'))
        fprintf('ERROR: That port is already open! God youre dumb...\n')
        return
    end
end
PICport = serial('COM4', 'BaudRate', 57600, 'Terminator', 64);
try
    fopen(PICport);
catch err
    availablePorts = instrfind;
    for i = 1:length(availablePorts)
        if strcmp(availablePorts(i).Name, 'Serial-COM4')
            fprintf('ERROR: The port needed for the Control PIC is unavailable\n')
            clear i availablePorts PICport err;
            return
        end
    end
    fprintf('unknown error')
end
%end opening of port

DataFromPICTimer = timer;
DataFromPICTimer.BusyMode = 'drop';
DataFromPICTimer.TimerFcn = @(x, y)disp('timer fired');
DataFromPICTimer.Period = 5;
DataFromPICTimer.ExecutionMode = 'fixedRate';

start(DataFromPICTimer)

