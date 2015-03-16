function startSimulateDataTimer()

simulateDataTimer = timer;
simulateDataTimer.BusyMode = 'drop';
simulateDataTimer.TimerFcn = @simulateDataTimer_callback;
simulateDataTimer.Period = 5;
simulateDataTimer.ExecutionMode = 'fixedRate';

start(DataFromPICTimer)

end