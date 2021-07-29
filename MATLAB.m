function varargout = MATLAB(varargin)
% MATLAB MATLAB code for MATLAB.fig
%      MATLAB, by itself, creates a new MATLAB or raises the existing
%      singleton*.
%
%      H = MATLAB returns the handle to a new MATLAB or the handle to
%      the existing singleton*.
%
%      MATLAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATLAB.M with the given input arguments.
%
%      MATLAB('Property','Value',...) creates a new MATLAB or raises the
%      exi%      applied to the GUI before MATLAB_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MATLAB_OpeningFcn via varargin.
sting singleton*.  Starting from the left, property value pairs are
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MATLAB

% Last Modified by GUIDE v2.5 27-May-2020 07:14:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MATLAB_OpeningFcn, ...
                   'gui_OutputFcn',  @MATLAB_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before MATLAB is made visible.
function MATLAB_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MATLAB (see VARARGIN)

% Choose default command line output for MATLAB
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MATLAB wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global x;
global EExit;
x=serial('COM3','BAUD', 9600);
fopen(x);
EExit = 0;

% --- Outputs from this function are returned to the command line.
function varargout = MATLAB_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)      %Start BTN
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global x;
global EExit;
global Lastvalueofi; % this variable is used for storing the last value of 
                     % i in order to continue the plotting after click on
                     % stop from the place we ended in
i = 0;

% we used this condition to continue plotting after clicking on stop
if(EExit == 1)
    EExit = 0;
    fopen(x); % we reopen communication after closing it when we clicked on
              % Stop
    i = Lastvalueofi - 1; % Set i to the last value 
end

% we used these arrays to store the data and reuse it when we find the
% average
global Pulses;
global SpO2s;
global Temps;
Pulses = [60];
SpO2s = [60];
Temps = [60];

screen1 =findobj(gcbf,'Tag','text13');
screen2 =findobj(gcbf,'Tag','text14');
screen3 =findobj(gcbf,'Tag','text15');
screen4 =findobj(gcbf,'Tag','text16');
screen5 =findobj(gcbf,'Tag','text17');
screen6 =findobj(gcbf,'Tag','text18');
NoAVG = 0;

while i<60
        i = i + 1;
        
% Plot and show the readed values of PulseRate
        Pulse=fscanf(x);                    
        Pulses(i) = str2double(Pulse);
        drawnow;
        axes(handles.axes1);
        plot(Pulses,'r-','LineWidth',0.5);
        grid on;
        axis([1 60 -5 100]);
        hold on
        set(screen1,'string',Pulse);        

% Show the readed values of SpO2
        SpO2=fscanf(x);
        SpO2s(i) = str2double(SpO2);
        set(screen2,'string',SpO2);

% Plot and show the readed values of Temperature
        Temp=fscanf(x);
        Temps(i) = str2double(Temp);
        drawnow;
        axes(handles.axes2);
        plot(Temps,'b-','LineWidth',0.5);
        grid on;
        axis([1 60 -5 100]);
        hold on
        set(screen3,'string',Temp);
        
        
        if(EExit == 1)      % we used this condition to stop plotting when                     
            NoAVG = 1;       %the user click on Stop
            Lastvalueofi = i;
            break;
        end
        
end

% We used this part to take the average and show it
if(NoAVG == 0)     %this condition is used in order to not find the average
    PulseAVG = 0;  %when we click on stop
    SpO2AVG = 0;
    TempAVG = 0;
    p = 0;
    s = 0;
    t = 0;
    for i=1:1:60    %this loop is used to find the sum of the values
  
%the conditions used for make the average more accurate (the values set randomly)
        if(Pulses(i) > 50) 
            PulseAVG = PulseAVG + Pulses(i);
            p = p + 1;
        end
        
        if(SpO2s(i) > 80)
            SpO2AVG = SpO2AVG + SpO2s(i); 
            s = s + 1;
        end
        if(Temps(i) > 15)
            TempAVG = TempAVG + Temps(i);
            t = t + 1;
        end
    end
    PulseAVG = PulseAVG / p;
    Avg = num2str(PulseAVG);
    set(screen4,'string',Avg);
    
    SpO2AVG = SpO2AVG / s;
    Avg = num2str(SpO2AVG);
    set(screen5,'string',Avg);

    TempAVG = TempAVG / t;
    Avg = num2str(TempAVG);
    set(screen6,'string',Avg);
end
 fclose(x);




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)   %Stop BTN
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% we used this part to exit the loop while plotting values
global EExit;
EExit = 1;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)  %Remeasure BTN
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global x;
fclose(x);
global EExit;
EExit = 0;
fopen(x);
hold (handles.axes1,'off');
hold (handles.axes2,'off');
pushbutton2_Callback(hObject, eventdata, handles);
