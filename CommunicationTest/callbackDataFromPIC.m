%callback to get data from pic
function callbackDataFromPIC(obj, event)
numBytes = obj.BytesAvailable;
binaryData = fread(obj, numBytes);
string = char(binaryData);
string = string(1:numBytes-1);
fprintf('Data being recieved! Data: %s\n', string)

persistent recievedData;

%check if the data is the correct number format
%format is 4 ASCII numbers with '~' as terminator
if numBytes ~= 5
    fprintf('The num bytes %d is incorrect\n', numBytes)
    return
end
for i  = 1:numBytes-1
    if binaryData(i)<48 && binaryData(i)>57
        fprintf('Thats not valid data, dummy!\n')
        return
    end
end
%turn values into a number
%add to all the other data
newData = str2double(string)/100.0;
recievedData = [recievedData newData];
%plot the data
plot(recievedData)

