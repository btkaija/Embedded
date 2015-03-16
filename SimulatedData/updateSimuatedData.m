function updateSimuatedData(nm, ns)

fprintf('updating data\n');
try
    simulatedSensorData = [simulatedSensorData ns];
    simulatedMotorData = [simulatedMotorData nm];
catch
    fprintf('Simulated data variables not defined!');
    initGlobalVars;
end

end