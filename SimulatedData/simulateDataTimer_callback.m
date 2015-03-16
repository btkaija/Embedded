function simulateDataTimer_callback()

newMotor = simulateMotorData();
newSensor = simulateSensorData();

updateSimuatedData(newMotor, newSensor);

end
