function stopSimulateDataTimer()

try
    stop(simulateDataTimer);
catch
    fprintf('Error stoping timer: simulateDataTimer does not exist\n');    
end    

end
