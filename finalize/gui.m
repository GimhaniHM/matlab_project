function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 09-Dec-2021 09:11:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.axesImage,'Visible','off');
set(handles.txtVacc,'Visible','off');
set(handles.txtName,'Visible','off');

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnBrowes.
function btnBrowes_Callback(hObject, eventdata, handles)
[filename,pathname] = uigetfile({'*.*'},'Select file');
var = strcat(pathname,filename);

set(handles.axesImage,'Visible','on');
set(handles.txtVacc,'Visible','on');
set(handles.txtName,'Visible','on');

handles.I = imread(var);
axes(handles.axesImage);
imshow(handles.I);
title('\color{white}Vaccination Card');

%----------------------------------------------------------------
%----------resize image-------------
B = imresize(handles.I,[1180 1700]);

%----------convert to binary image-------------
handles.BW =im2bw(B, 0.7);
BW=handles.BW;

%----------- Check 1st Dose --------------------

D1_R1 = CheckBlackRow(BW,180,400,200,650);

D1_R2 = CheckBlackRow(BW,(D1_R1+10),400,200,650);

D1_C1 = CheckBlackColumn(BW,200,650,D1_R1,400);

D1_C2 = CheckBlackColumn(BW,(D1_C1+10),650,D1_R1,400);

vacc_1 = BW(D1_R1+10:D1_R2-10,D1_C1+10:D1_C2-10);

vacc_1 = ~vacc_1;

[L1, letters_1] = bwlabel(vacc_1,8);

if(letters_1 > 0)
    str = '! Only 1st Dose';
else
     str = 'Not vaccinated';
end

%----------- Check 2nd Dose --------------------

D2_R1=CheckBlackRow(BW,D1_R2,400,200,650);

D2_R2=CheckBlackRow(BW,(D1_R2+10),400,200,650);

D2_C1=CheckBlackColumn(BW,200,650,D1_R2,400);

D2_C2=CheckBlackColumn(BW,(D1_C1+10),650,D1_R2,400);

vacc_2 = BW(D2_R1+10:D2_R2-10,D2_C1+10:D2_C2-10);

vacc_2 = ~vacc_2;

[L1, letters_2] = bwlabel(vacc_2,8);

if(letters_2 > 0)
    str = 'Vaccinated';
end

set(handles.txtVacc, 'string', str);

%-----------------------------------------------------
v = detectColor(handles.I);
set(handles.txtName, 'string', v);

guidata(hObject,handles);

function txtVacc_Callback(hObject, eventdata, handles)
% hObject    handle to txtVacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtVacc as text
%        str2double(get(hObject,'String')) returns contents of txtVacc as a double

% --- Executes during object creation, after setting all properties.
function txtVacc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtVacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


