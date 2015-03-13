function varargout = testButtons(varargin)
%TESTBUTTONS M-file for testButtons.fig
%      TESTBUTTONS, by itself, creates a new TESTBUTTONS or raises the existing
%      singleton*.
%
%      H = TESTBUTTONS returns the handle to a new TESTBUTTONS or the handle to
%      the existing singleton*.
%
%      TESTBUTTONS('Property','Value',...) creates a new TESTBUTTONS using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to testButtons_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      TESTBUTTONS('CALLBACK') and TESTBUTTONS('CALLBACK',hObject,...) call the
%      local function named CALLBACK in TESTBUTTONS.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testButtons

% Last Modified by GUIDE v2.5 02-Mar-2015 16:29:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testButtons_OpeningFcn, ...
                   'gui_OutputFcn',  @testButtons_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before testButtons is made visible.
function testButtons_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for testButtons
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testButtons wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testButtons_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf('start pressed\n')

% --- Executes on key press with focus on startButton and none of its controls.
function startButton_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf('stop pressed\n')

% --- Executes on key press with focus on stopButton and none of its controls.
function stopButton_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
