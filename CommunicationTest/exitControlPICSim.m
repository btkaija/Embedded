%exitControlPICSim.m
%closes the port com4, only if variable still exists
fclose(PICport);
delete(PICport);
clear PICport

%stop(DataFromPICTimer)