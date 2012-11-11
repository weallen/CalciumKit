%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2012, William E. Allen (we.allen@gmail.com)
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification,
% are permitted provided that the following conditions are met:
%
% - Redistributions of source code must retain the above copyright notice,
%   this list of conditions and the following disclaimer.
% 
% - Redistributions in binary form must reproduce the above copyright notice,
%   this list of conditions and the following disclaimer in the documentation
%   and/or other materials provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
% EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = stackroigui(varargin)
% STACKROIGUI MATLAB code for stackroigui.fig
%      STACKROIGUI, by itself, creates a new STACKROIGUI or raises the existing
%      singleton*.
%
%      H = STACKROIGUI returns the handle to a new STACKROIGUI or the handle to
%      the existing singleton*.
%
%      STACKROIGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STACKROIGUI.M with the given input arguments.
%
%      STACKROIGUI('Property','Value',...) creates a new STACKROIGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stackroigui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stackroigui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stackroigui

% Last Modified by GUIDE v2.5 18-Sep-2012 14:59:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stackroigui_OpeningFcn, ...
                   'gui_OutputFcn',  @stackroigui_OutputFcn, ...
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


% --- Executes just before stackroigui is made visible.
function stackroigui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stackroigui (see VARARGIN)

    % Choose default command line output for stackroigui
    currpath = pwd;

    addpath(genpath('saveastiff'));
    %addpath(genpath('vlfeat'));
    addpath(genpath('export_fig'));

    cd(currpath);


    handles.output = hObject;

    set(handles.figure1, 'CloseRequestFcn', @closeGui);
    set(handles.figure1, 'WindowButtonUpFcn', @mouseFunction);

    have_KeyPressFcn = findobj('KeyPressFcn', '');
    for i = 1:length(have_KeyPressFcn)
        set(have_KeyPressFcn(i), 'KeyPressFcn', @keyFunction);
    end    
    

    % init all variables 
    set(handles.imAxes, 'Visible', 'off');
    set(handles.folderNameText, 'String', '');    
    set(handles.maxZText, 'String', num2str(1));
    set(handles.maxTText, 'String', num2str(1));
    
    set(handles.tSlider, 'Max', 1);
    set(handles.tSlider, 'Min', 0);
    set(handles.tSlider, 'Value', 1);
    
    set(handles.currTText, 'String', '1');
    
    set(handles.dfofMinTEdit, 'String', '1');
    set(handles.minTEdit, 'String', '1');
    set(handles.maxTEdit, 'String', num2str(1));
    set(handles.dfofMaxTEdit, 'String', '1');
    set(handles.dfofWinSizeEdit, 'String', '1');
    
    set(handles.minZEdit, 'String', '1');
    set(handles.maxZEdit, 'String', num2str(1));
    
    set(handles.zSlider, 'Max', 1);    
    set(handles.zSlider, 'Min', 0);
    set(handles.zSlider, 'Value', 1);
    
    set(handles.currZText, 'String', '1');

    set(handles.loadDenoiseCheck, 'Value', 0);
    set(handles.loadDenoiseEdit, 'String', '2');
    set(handles.loadDenoiseEdit, 'Enable', 'off');

    set(handles.imAxes, 'Units', 'Normalized');
    set(handles.loadDenoiseEdit, 'String','1');
    set(handles.loadDenoiseCheck, 'Value', 0);
    
    %set(handles.icaRoiThreshEdit, 'Enable', 'off');
    set(handles.dfofBgThreshSlider, 'Enable', 'off');
    set(handles.dfofMinTEdit, 'Enable', 'off');
    set(handles.dfofMaxTEdit, 'Enable', 'off');
    set(handles.filterWinSizeEdit, 'Enable', 'off');
              
    handles.rgbcolor = [1 0 0];

    handles.analysisUseICA = true;
    handles.savepath = '';
    handles.savename = '';
    %pos = get(handles.imAxes,'Position');        
    %set(handles.imAxes, 'OuterPosition', [0 0 1 1]); %- get(handles.imAxes, 'TightInset') ...
        %* [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
    
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes stackroigui wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stackroigui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function closeGui(hObject, eventdata)
    handles = guidata(hObject);
    delete(handles.figure1);

function mouseFunction(hObject, eventdata)

function keyFunction(hObject, eventdata)
    handles = guidata(hObject);
    k = eventdata.Key;
    switch k
        case 'j' % slide z down
            if isZProj(handles)
                return;
            end
            hObject = handles.zSlider;
            sliderVal = get(handles.zSlider, 'Value');
            if (sliderVal-1) >= get(handles.zSlider, 'Min')
                set(handles.zSlider, 'Value', sliderVal-1);
                zSlider_Callback(hObject, [], handles);
            end
        case 'k' % slide z up
            if isZProj(handles)
                return;
            end
            hObject = handles.zSlider;
            sliderVal = get(handles.zSlider, 'Value');
            if (sliderVal+1) <= get(handles.zSlider, 'Max')
                set(handles.zSlider, 'Value', sliderVal+1);
                zSlider_Callback(hObject, [], handles);
            end
        case 'h' % slide t left
            hObject = handles.tSlider;
            sliderVal = get(handles.tSlider, 'Value');
            if (sliderVal-1) >= get(handles.tSlider, 'Min')
                set(handles.tSlider, 'Value', sliderVal-1);
                tSlider_Callback(hObject, [], handles);
            end
        case 'l' % slide t righ
            hObject = handles.tSlider;
            sliderVal = get(handles.tSlider, 'Value');
            if (sliderVal+1) <= get(handles.tSlider, 'Max')
                set(handles.tSlider, 'Value', sliderVal+1);
                tSlider_Callback(hObject, [], handles);
            end
        case 'q'
            closeGui = handles.figure1;
            close(closeGui);
        otherwise
    end
    
    
% --- Executes on button press in loadButton.
function loadButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    foldername = uigetdir();
    if foldername == 0
        return;
    end
    if ispc
        temp = regexp(foldername, '\', 'split');
    else
        temp = regexp(foldername, '/', 'split');
    end
    dirname = temp(end);
    handles.dirname = dirname;
    handles.foldername = foldername;
    handles.savename = '';
    
    [~, zslices, width, height, duration] = stackinfo(foldername, true);
    handles.width = width;
    handles.height = height;
    
    % set all the UI elements
    % general setup stuff
    set(handles.imAxes, 'Visible', 'on');
    set(handles.stackRadio, 'Value', 1);
    set(handles.zSlider, 'Visible', 'on');

    % setup load and save panels
    set(handles.folderNameText, 'String', foldername);    
    set(handles.outputText, 'String', '');
    
    % setup max Z and T fields (Read-Only)
    set(handles.maxZText, 'String', num2str(zslices));
    set(handles.maxTText, 'String', num2str(duration));
    
    % setup T slider and min/max T
    set(handles.tSlider, 'Max', duration);
    set(handles.tSlider, 'Min', 1);
    set(handles.tSlider, 'Value', 1);
    set(handles.currTText, 'String', '1');
    set(handles.minTEdit, 'String', '1');
    set(handles.dfofMinTEdit, 'String', '1');
    set(handles.dfofZProjectCheck, 'Enable', 'on');
    set(handles.maxTEdit, 'String', num2str(duration));
    set(handles.dfofMaxTEdit, 'String', num2str(duration));
    set(handles.plotAllZCheck, 'Enable', 'on');

    % setup Z slider and min/max Z
    set(handles.zSlider, 'Max', zslices);    
    set(handles.zSlider, 'Min', 1);
    set(handles.zSlider, 'Value', 1);
    set(handles.currZText, 'String', '1');
    set(handles.minZEdit, 'Enable', 'on');
    set(handles.maxZEdit', 'Enable', 'on');
     
    set(handles.upButton, 'Enable', 'on');
    set(handles.downButton, 'Enable', 'on');

    set(handles.minZEdit, 'String', '1');
    set(handles.maxZEdit, 'String', num2str(zslices));
    
    % setup main axes
    set(handles.imAxes, 'XLim', [1 handles.width]);
    set(handles.imAxes, 'YLim', [1 handles.height]);
   
    % load images
    fnames = dir(strcat(foldername,'/*.tiff'));
    imname = strcat(foldername,'/',fnames(1).name);   
    
    info = imfinfo(imname);

    Width = info(1).Width;
    Height = info(1).Height;
    ZSlices = numel(info);
    Duration = numel(fnames);

    Images = uint16(zeros(Width, Height, Duration, ZSlices));
    
    [check, w] = checkNumeric(handles.loadDenoiseEdit);
    w = round(w);
    if ~check
        msgbox('Denoise Size Must be an Integer','','error');
        w = 1;
        set(handles.loadDenoiseEdit, 'String', '1');
        return;
    end
    try
        for i=1:Duration    
            fprintf('Loading slice T=%d\n',i);
            fullname = strcat(foldername,'/', fnames(i).name);
            data = double(loadtiff(fullname));    
            for j=1:ZSlices
                if get(handles.loadDenoiseCheck, 'Value') == 1
                    data(:,:,j) = medfilt2(data(:,:,j), [w w]);                
                end
            end
            Images(:,:,i,:) = data;
        end
        handles.imgdata = Images;
    catch err
        error('Could not load images -- check image directory.');
        return;
    end
    
    % precompute mean stack images 
    %handles.meanstack = uint16(zeros(Width, Height, ZSlices));
    %for i=1:ZSlices
    %    handles.meanstack(:,:,i) = mean(Images{i}, 3);
    %end
    
    % initialize z projections to nothing
    handles.zproj = [];
    %handles.zproj = squeeze(max(Images,[],4));
    
    % setup mask data structure
    handles.masks = cell(ZSlices,1);
    handles.numMasks = zeros(ZSlices,1);
    handles.xPoints = cell(ZSlices,1);
    handles.yPoints = cell(ZSlices,1);
    handles.colors = cell(ZSlices,1);
    handles.showRoi = cell(ZSlices,1);
    for i=1:ZSlices
        handles.colors{i} = [];
        handles.showRoi{i} = [];
    end
    
    % precompute mean z proj
    %handles.meanzproj = mean(handles.zproj, 3);
    tSlider_Callback(hObject, [], handles);
    zSlider_Callback(hObject, [], handles);
    
    
    guidata(hObject, handles);

% checks if the string 
function [numberq, val] = checkNumeric(h)
    val = str2double(get(h, 'String'));
    if ~isnan(val)
        numberq = true;
    else
        numberq = false;
    end
    
% --- Executes on slider movement.
function tSlider_Callback(hObject, eventdata, handles)
    sliderVal = get(handles.tSlider, 'Value');
    sliderVal = round(sliderVal);
    set(handles.currTText, 'String', num2str(sliderVal));  
    
    handles = slidercallbackdrawimageslice(handles);
    handles = drawroicallback(handles);
    handles = updatedataaxis( handles );

    guidata(hObject, handles);
    
% --- Executes during object creation, after setting all properties.
function tSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function zSlider_Callback(hObject, eventdata, handles)
    sliderVal = get(handles.zSlider, 'Value');
    sliderVal = round(sliderVal);
    set(handles.currZText, 'String', num2str(sliderVal));
    
    handles = updateroitable(handles);
    handles = slidercallbackdrawimageslice(handles);
    handles = drawroicallback(handles);
    handles = updatedataaxis( handles );
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function zSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function [res, handles] = checkTZBound(handles)
     %minZ = str2double(get(handles.minZEdit, 'String'));
     %maxZ = str2double(get(handles.maxZEdit, 'String'));
     [miz, minZ] = checkNumeric(handles.minZEdit);
     [maz, maxZ] = checkNumeric(handles.maxZEdit);
     absMaxZ = str2double(get(handles.maxZText, 'String'));
     res = true;
    if minZ > absMaxZ || minZ < 1 || maxZ > absMaxZ || maxZ < 1 ...
            || ~miz || ~maz
        msgbox('Value is < 1 or > maxZ', '', 'error');
        uiwait;
        set(handles.minZEdit, 'String', '1');
        set(handles.maxZEdit, 'String', num2str(absMaxZ));
        res = false;
    end
    %minT = str2double(get(handles.minTEdit, 'String'));
    %maxT = str2double(get(handles.maxTEdit, 'String'));
    [mit, minT] = checkNumeric(handles.minTEdit);
    [mat, maxT] = checkNumeric(handles.maxTEdit);
    absMaxT = str2double(get(handles.maxTText, 'String'));
    if minT > absMaxT || minT < 1 ||  maxT > absMaxT ||maxT < 1 ...
            || ~mit || ~mat
        msgbox('Value is < 1 or > maxT', '', 'error');
        uiwait;
        set(handles.minTEdit, 'String', '1');        
        set(handles.maxTEdit, 'String', num2str(absMaxT));
        res = false;
    end
    
    
    
function minZEdit_Callback(hObject, eventdata, handles)
    [res, handles] = checkTZBound(handles);
    if res
        val = str2double(get(handles.minZEdit, 'String'));
        set(handles.zSlider, 'Min', val);
        set(handles.zSlider, 'Value', val);
        zSlider_Callback(hObject,[],handles);
    end
    guidata(hObject, handles);
    

% --- Executes during object creation, after setting all properties.
function minZEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minTEdit_Callback(hObject, eventdata, handles)
    [res, handles] = checkTZBound(handles);
    if res
        val = str2double(get(handles.minTEdit, 'String'));
        set(handles.tSlider, 'Min', val);
        set(handles.tSlider, 'Value', val);
        tSlider_Callback(hObject,[],handles);
        set(handles.dfofMinTEdit, 'String', get(handles.minTEdit, 'String'));
    end
    guidata(hObject, handles);
    
% --- Executes during object creation, after setting all properties.
function minTEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxZEdit_Callback(hObject, eventdata, handles)
    [res, handles] = checkTZBound(handles);
    if res
        val = str2double(get(handles.maxZEdit, 'String'));
        set(handles.zSlider, 'Max', val);
        set(handles.zSlider, 'Value', get(handles.zSlider, 'Min'));
        zSlider_Callback(hObject,[],handles);
    end
    guidata(hObject, handles);
    
% --- Executes during object creation, after setting all properties.
function maxZEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxTEdit_Callback(hObject, eventdata, handles)
    [res, handles] = checkTZBound(handles);
    if res
        val = str2double(get(handles.maxTEdit, 'String'));
        set(handles.tSlider, 'Max', val);
        set(handles.tSlider, 'Value', get(handles.tSlider, 'Min'));
        tSlider_Callback(hObject,[],handles);     
        
        set(handles.dfofMaxTEdit, 'String', get(handles.maxTEdit, 'String'));
    end
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxTEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addRoiButton.
function addRoiButton_Callback(hObject, eventdata, handles)
    [T Z] = getTZ(handles);
    [minZ maxZ] = getZLim(handles);
    try
        h = imfreehand(handles.imAxes, 'Closed', true);   
        pos = wait(h);
        xi = pos(:,1);
        yi = pos(:,2);
    catch error
        return;
    end
    
    BW = createMask(h);
    handles.numMasks(Z) = handles.numMasks(Z) + 1;
    i = handles.numMasks(Z);
    handles.masks{Z}(i,:,:) = BW;
    handles.xPoints{Z,i} = xi;
    handles.yPoints{Z,i} = yi;
     
    colortype = getcolortype(handles);
    if strcmp(colortype, 'random')
        handles.colors{Z} = add_random_colors(handles.colors{Z},.4);  
    elseif strcmp(colortype, 'depth')
        handles.colors{Z} = add_z_colors(handles.colors{Z}, Z, maxZ);
    elseif strcmp(colortype, 'fixed')
        handles.colors{Z} = add_fixed_colors(handles.colors{Z}, handles.rgbcolor);
    end
    handles.showRoi{Z}(i) = true;
    
    handles = updateroitable( handles );
    handles = slidercallbackdrawimageslice(handles);
    handles = drawroicallback(handles);
    handles = updatedataaxis( handles );
    guidata(hObject, handles);


% --- Executes on button press in deleteRoiButton.
function deleteRoiButton_Callback(hObject, eventdata, handles)
    [T Z] = getTZ(handles);
    handles.masks{Z} = [];
    handles.numMasks(Z) = 0;
    handles.xPoints{Z} = [];
    handles.yPoints{Z} = [];
    handles.colors{Z} = [];   
    handles.showRoi{Z} = [];
    
    handles = updateroitable(handles);
    handles = slidercallbackdrawimageslice(handles);
    handles = drawroicallback(handles);
    handles = updatedataaxis( handles );
    guidata(hObject, handles);
    
% --- Executes when selected object is changed in stackTypePanel.
function stackTypePanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in stackTypePanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
%
% Resets everything and redraws.
   [minZ maxZ] = getZLim(handles);
   switch get(eventdata.NewValue,'Tag')
       case 'stackRadio'           
           %set(handles.minZEdit, 'String', '1');
           %set(handles.maxZEdit, 'String', get(handles.maxZText, 'String'));           
           set(handles.zSlider, 'Max', maxZ);
           set(handles.zSlider, 'Min', minZ);
           set(handles.zSlider, 'Visible', 'on');
           set(handles.minZEdit, 'Enable', 'on');
           set(handles.maxZEdit', 'Enable', 'on');
           set(handles.dfofZProjectCheck, 'Enable', 'on');
           set(handles.plotAllZCheck, 'Enable', 'on');
           set(handles.upButton, 'Enable', 'on');
           set(handles.downButton, 'Enable', 'on');
           handles.zproj = [];
           zproj = false;
       case 'zprojectRadio'                                 
           %set(handles.minZEdit, 'String', '1'); % because only one z section
           %set(handles.maxZEdit, 'String', '1');
           set(handles.minZEdit, 'Enable', 'off');
           set(handles.maxZEdit, 'Enable', 'on');
           set(handles.zSlider, 'Max', 2);
           set(handles.zSlider, 'Min', 1);
           set(handles.zSlider, 'Visible', 'off');
           set(handles.minZEdit, 'Enable', 'off');
           set(handles.maxZEdit', 'Enable', 'off');
           set(handles.dfofZProjectCheck, 'Enable', 'off');
           set(handles.plotAllZCheck, 'Enable', 'off');
           set(handles.upButton, 'Enable', 'off');
           set(handles.downButton, 'Enable', 'off');

           handles.zproj = squeeze(max(handles.imgdata(:,:,:,minZ:maxZ),[],4));
           zproj = true;
       otherwise
   end
   
   % reset ROIs
   if zproj
       ZSlices = 1;
   else
       ZSlices = str2double(get(handles.maxZText,'String'));
   end
   handles.masks = cell(ZSlices,1);
   handles.numMasks = zeros(ZSlices,1);
   handles.xPoints = cell(ZSlices,1);
   handles.yPoints = cell(ZSlices,1);
   handles.colors = cell(ZSlices,1);
   handles.showRoi = cell(ZSlices,1);
   for i=1:ZSlices
       handles.colors{i} = [];
       handles.showRoi{i} = [];
   end
   
   set(handles.minTEdit, 'String', '1');
   set(handles.maxTEdit, 'String', get(handles.maxTText, 'String'));
   if zproj
        set(handles.zSlider, 'Value', 1);
   else
       set(handles.zSlider, 'Value', minZ);
   end
   zSlider_Callback(hObject, [], handles);
   set(handles.tSlider, 'Value', 1);
   tSlider_Callback(hObject, [], handles);
   
   handles = updateroitable(handles);

   guidata(hObject, handles);



% --- Executes on button press in undoRoiButton.
function undoRoiButton_Callback(hObject, eventdata, handles)
    [T Z] = getTZ(handles);    
    handles.numMasks(Z) = handles.numMasks(Z) - 1;
    
    handles = updateroitable(handles);
    handles = slidercallbackdrawimageslice(handles);
    
    handles = drawroicallback(handles);
    handles = updatedataaxis( handles );
    guidata(hObject, handles);


    
    

% --- Executes on button press in saveFigureButton.
function saveFigureButton_Callback(hObject, eventdata, handles)
if strcmp(handles.savepath, '') || isempty(get(handles.savePrefixEdit, 'String'))
    msgbox('Need to specify an output directory','','error');
    return;
end

if ispc
    sep = '\';
else
    sep = '/';
end

outname = strcat(handles.savepath, sep, get(handles.savePrefixEdit, 'String'), '.avi');
aviobj = VideoWriter(outname,'Uncompressed AVI');
aviobj.FrameRate = 6;
open(aviobj);

axes(handles.dataAxes);

[minT maxT] = getTLim(handles);
currT = str2double(get(handles.currTText, 'String'));
for i=minT:maxT
    set(handles.tSlider, 'Value', i);
    tSlider_Callback(hObject, [], handles);
    F = getframe(handles.imAxes);
    writeVideo(aviobj, F);
end
set(handles.tSlider, 'Value', currT);
tSlider_Callback(hObject, [], handles);
close(aviobj);

    
% --- Executes on button press in deltaFButton.
function deltaFButton_Callback(hObject, eventdata, handles)
    doSave = get(handles.dfofSaveCheckbox, 'Value');
    if doSave == 1 
        if strcmp(handles.savepath,'') || isempty(get(handles.savePrefixEdit, 'String'))
            msgbox('Need to specify output dir and prefix.','','error');
            return;
        end
    end
    
    currFState = get(get(handles.fOptionsPanel, 'SelectedObject'), 'Tag');
    currState = get(get(handles.stackTypePanel, 'SelectedObject'), 'Tag');  
    
    % default is z projection
    zproj = logical(strcmp(currState, 'zprojectRadio')); 
    justDF = logical(get(handles.justDfCheck, 'Value') == 1);
    
    [minZ maxZ] = getZLim(handles);
    
    if strcmp(currFState, 'dfofRollingButton')
        winSize = str2double(get(handles.dfofWinSizeEdit, 'String'));
        if winSize < 1 
            msgbox('Window Size < 1.', '', 'error');
            return;
        end
        f0Range = winSize;
    else
        minT = str2double(get(handles.dfofMinTEdit, 'String'));
        maxT = str2double(get(handles.dfofMaxTEdit, 'String'));
        f0Range = [minT maxT];
    end
    
    %dfof( imgdata, justDF, f0Range)
    fprintf('Computing DF/F...\n');
    if ~zproj
        % returns W x H x D x Z
        dfofimg = dfof(handles.imgdata, justDF, f0Range);
    else
        % returns W x H x D
        dfofimg = dfof(handles.zproj, justDF, f0Range);
    end
    
    % center dfofimg
    dfofimg = (dfofimg - mean(dfofimg(:))) / abs(std(dfofimg(:)));
    
    fgThreshold = get(handles.dfofFgThreshSlider, 'Value');

    % cutoff image above foreground threshold
    % foreground threshold in [0,1]
    minDfof = min(dfofimg(:));
    maxDfof = max(dfofimg(:));
    dfofRange = maxDfof - minDfof;
    cmin = minDfof;
    cmax = minDfof + (fgThreshold * dfofRange);
    dfofimg(dfofimg > cmax) = cmax;

    zidx = minZ:maxZ;
    if doSave
        if ispc
            sep = '\';
        else
            sep = '/';
        end
    end
    if zproj
        handles = showdfofimage(handles, dfofimg, minDfof, maxDfof);
        if doSave                
            outname = strcat(handles.savepath, sep, get(handles.savePrefixEdit, 'String'), '_DF_Zproj.tiff');
            export_fig(gca, outname, '-native');
        end
    else
        currZ = get(handles.currZText, 'String');

        makeZProj = (get(handles.dfofZProjectCheck, 'Value') == 1);
        if makeZProj
            dfofimg = max(dfofimg(:,:,:,minZ:maxZ),[],4);
            % hack to allow drawing of all ROIs
            if get(handles.showRoiCheck,'Value') == 1
                set(handles.showRoiCheck, 'Value', 0);
                showRoi = true;
            else
                showRoi = false;
            end
            handles = showdfofimage(handles, dfofimg, minDfof, maxDfof);
            
            % HACK HACK HACK This won't look good if numbers are shown
            for i=1:length(minZ:maxZ)
                set(handles.currZText, 'String', num2str(zidx(i)));
                handles = drawroicallback(handles, gca, true);
            end
            if doSave
                outname = strcat(handles.savepath, sep, get(handles.savePrefixEdit, 'String'), '_DF_Z',mat2str(minZ:maxZ),'.tiff');
                export_fig(gca, outname, '-native');
            end
            % restore showRoiCheck to it's original state
            if showRoi
                set(handles.showRoiCheck, 'Value', 1);
            end
        else
            for i=1:length(minZ:maxZ)
                % HACK HACK HACK Set currZ to trick getTZ; restore at end
                set(handles.currZText, 'String', num2str(zidx(i)));
                handles = showdfofimage(handles, squeeze(dfofimg(:,:,:,zidx(i))), minDfof, maxDfof);
                if doSave
                    outname = strcat(handles.savepath, sep, get(handles.savePrefixEdit, 'String'), '_DF_Z',num2str(zidx(i)),'.tiff');
                    export_fig(gca, outname, '-native');
                end
            end
        end
        
        set(handles.currZText, 'String', currZ);
    end
    
    %set(gca, 'CLim', [0 1]);
    
    guidata(hObject, handles);
 


function icaNumPCEdit_Callback(hObject, eventdata, handles)
    [ck, numPC] = checkNumeric(handles.icaNumPCEdit);
    if ~ck
        msgbox('Num PC Must be numeric.', '', 'error');
        set(handles.icaNumPCEdit, 'String', '10');
        guidata(hObject, handles);
        return;
    end


% --- Executes during object creation, after setting all properties.
function icaNumPCEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function icaNumICEdit_Callback(hObject, eventdata, handles)
    [ck, numIC] = checkNumeric(handles.icaNumICEdit);
    if ~ck
        msgbox('Num IC Must be numeric.', '', 'error');
        set(handles.icaNumICEdit, 'String', '10');
        guidata(hObject, handles);
        return;
    end


% --- Executes during object creation, after setting all properties.
function icaNumICEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function icaMaxPCEdit_Callback(hObject, eventdata, handles)
    [ck, maxPC] = checkNumeric(handles.icaMaxPCEdit);
    if ~ck
        msgbox('Max PC Must be numeric.', '', 'error');
        set(handles.icaMaxPCEdit, 'String', '10');
        guidata(hObject, handles);
        return;
    end


% --- Executes during object creation, after setting all properties.
function icaMaxPCEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in icaGoButton.
function icaGoButton_Callback(hObject, eventdata, handles)
    [T Z] = getTZ(handles);

    currState = get(get(handles.stackTypePanel, 'SelectedObject'), 'Tag');  
    [fnames, ZSlices, Width, Height, Duration] = stackinfo( handles.foldername, true);

    % default is z projection
    zproj = true;
    if strcmp(currState, 'stackRadio')
        zproj = false;
    end
    
    [minT maxT] = getTLim(handles);
    [minZ maxZ] = getZLim(handles);
    Duration = length(minT:maxT);
    ZSlices = length(minZ:maxZ);
       
    doROI = logical(get(handles.icaRoiCheck, 'Value'));
    
    zidx = minZ:maxZ;
    tidx = minT:maxT;

    if doROI
        roiThresh = str2double(get(handles.icaRoiThreshEdit, 'String'));
    end

    if handles.analysisUseICA 
        numPC = str2double(get(handles.icaNumPCEdit, 'String'));
        numIC = str2double(get(handles.icaNumICEdit, 'String'));
        maxPC = str2double(get(handles.icaMaxPCEdit, 'String'));

        % TODO Figure out how to get just slices in the current range
        %[mixedfilters, eigvals, mixedsig] = stackpca( foldername, numPC, true, 5:13, 5:20);

        % DO PCA
        fprintf('Reducing image to principal components\n');
        if ~zproj
            npix = Width * Height * ZSlices;
            tmpdata = zeros(npix, Duration);
            for i=1:Duration
                tmpdata(:, i) = double(reshape(squeeze(handles.imgdata(:,:,tidx(i),minZ:maxZ)), [1 npix]));
            end
            [mixedfilters, eigvals, mixedsig] = pca(tmpdata, numPC, Duration, Width, Height, ZSlices);
        else
            npix = Width * Height;
            for i=1:Duration
                tmpdata(:, i) = double(reshape(handles.zproj(:,:,tidx(i)), [1 npix]));
            end
            [mixedfilters, eigvals, mixedsig] = pca(tmpdata, numPC, Duration, Width, Height, 1);
        end
        clear tmpdata;

        % DO ICA
        fprintf('Computing Independent Components\n');

        PCuse = 1:maxPC;
        mu = 0.5;

        [ica_sig, filters, ica_A, numiter] = stackica(mixedfilters, mixedsig, eigvals, PCuse, mu, numIC);
        if zproj
            filters = reshape(filters, [numIC Width Height]);
        else
            filters = reshape(filters, [numIC Width Height ZSlices]);
        end
        
        clear mixedfilters;
        clear mixedfilters;
        clear eigvals;
        clear ica_sig;
    else
        if strcmp(get(handles.filterWinSizeEdit, 'String'), '') 
            msgbox('Need window size for filtering','','error');
            return;
        end       
        winSize = str2double(get(handles.filterWinSizeEdit, 'String'));
        if ~zproj
            filters = zeros(1, Width, Height, ZSlices);
            for i=1:ZSlices
                fprintf('Filtering Z=%d\n', zidx(i));
                filters(1,:,:,i) = double(roifilter(squeeze(handles.imgdata(:,:,:,zidx(i))), [winSize winSize]));
            end
        else
            filters = double(roifilter(handles.zproj(:,:,minT:maxT), [winSize winSize]));
            filters = reshape(filters, [1 Width Height]);
        end
    end
    
    if ~handles.analysisUseICA
        numIC = 1;
    end

    if doROI
        % FIND ROIs FROM ICs
        %deleteRoiButton_Callback(hObject, [], handles)
        if zproj
            handles = autofindroi( handles, filters, Z, roiThresh, numIC);
        else
            for i=1:ZSlices
                fprintf('Finding roi for Z=%d\n',zidx(i));
                handles = autofindroi(handles, filters(:,:,:,i), zidx(i), roiThresh, numIC);
            end
        end
        handles = updateroitable(handles);

    else
        % Show Z projections of the Independent Components, overlaid on
        % mean image
        %reshapedFilters = zeros(numIC, Width, Height);
        
        threshold = 0;

        if zproj
            figure;
            meanImg = zproject(mean(handles.zproj(:,:,minT:maxT),3));
            overlayicsproject(meanImg, filters, threshold, true);
        else
            for i=1:ZSlices
                figure;
                meanImg = squeeze(mean(handles.imgdata(:,:,minT:maxT,zidx(i)),3));
                overlayicsproject(meanImg, filters(:,:,:,i), threshold, true);
            end
        end
    end
    
    %clear ica_filters;

    handles = slidercallbackdrawimageslice(handles);
    handles = drawroicallback(handles);
    handles = updatedataaxis( handles );

    guidata(hObject, handles);

function filterWinSizeEdit_Callback(hObject, eventdata, handles)
    [ck, winSize] = checkNumeric(handles.filterWinSizeEdit);
    if ~ck 
        msgbox('Win Size Must be number.', '', 'error');
        set(handles.filterWinSizeEdit, 'String', '5');
        guidata(hObject, handles);
        return;
    end
    set(handles.filterWinSizeEdit, 'String', num2str(round(winSize)));

% --- Executes during object creation, after setting all properties.
function filterWinSizeEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in filterGoButton.
function filterGoButton_Callback(hObject, eventdata, handles)
    


function loadDenoiseEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function loadDenoiseEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadDenoiseCheck.
function loadDenoiseCheck_Callback(hObject, eventdata, handles)
    if get(handles.loadDenoiseCheck, 'Value') == 1
        set(handles.loadDenoiseEdit, 'Enable', 'on');
    else
        set(handles.loadDenoiseEdit, 'Enable', 'off');
    end

% --- Executes on button press in saveDirectoryButton.
function saveDirectoryButton_Callback(hObject, eventdata, handles)
    foldername = uigetdir();
    temp = regexp(foldername, '/', 'split');
    dirname = temp(end);
    set(handles.outputText, 'String', foldername);
    handles.savename = dirname;
    handles.savepath = foldername;
    guidata(hObject, handles);

% --- Executes on button press in icaRoiCheck.
function icaRoiCheck_Callback(hObject, eventdata, handles)
    if get(handles.icaRoiCheck, 'Value') == 1
        set(handles.icaRoiThreshEdit, 'Enable', 'on');
    else
        set(handles.icaRoiThreshEdit, 'Enable', 'off');
    end

% --- Executes on button press in justDfCheck.
function justDfCheck_Callback(hObject, eventdata, handles)



function icaRoiThreshEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function icaRoiThreshEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in plotOptionsGroup.
function plotOptionsGroup_SelectionChangeFcn(hObject, eventdata, handles)
    handles = updatedataaxis(handles);
    guidata(hObject, handles);


% --- Executes on button press in roiShowNumberCheck.
function roiShowNumberCheck_Callback(hObject, eventdata, handles)
    handles = slidercallbackdrawimageslice(handles);
    handles = drawroicallback(handles);
    handles = updatedataaxis( handles );
    guidata(hObject, handles);



function dfofWinSizeEdit_Callback(hObject, eventdata, handles)
    [ck, winSize] = checkNumeric(handles.dfofWinSizeEdit);
    if ~ck
        msgbox('Win Size Must be numeric.', '', 'error');
        set(handles.dfofWinSizeEdit, 'String', '0');
        guidata(hObject, handles);
        return;
    end
    
    [tMin tMax] = getTLim(handles);
    
    if (tMin - winSize < 1)
        msgbox('Cant have window size less than used min T','','error');
        set(handles.dfofWinSizeEdit, 'String', str2double(get(handles.minTEdit,'String'))-1);
        guidata(hObject, handles);
        return;
    end
    handles = updatedataaxis(handles);
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function dfofWinSizeEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dfofMinTEdit_Callback(hObject, eventdata, handles)
    [mit, minT] = checkNumeric(handles.dfofMinTEdit);
    minUseT = str2double(get(handles.minTEdit, 'String'));
    if ~mit 
        msgbox('Min T not numeric', '', 'error');
        set(handles.dfofMinTEdit, 'String', get(handles.minTEdit, 'String'));
        guidata(hObject, handles);
        return;
    end
    handles = updatedataaxis(handles);
    guidata(hObject, handles);
    
% --- Executes during object creation, after setting all properties.
function dfofMinTEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dfofMaxTEdit_Callback(hObject, eventdata, handles)
    [mat, maxT] = checkNumeric(handles.dfofMaxTEdit);
    maxUseT = str2double(get(handles.maxTEdit, 'String'));
    if ~mat 
        msgbox('Max T not numeric', '', 'error');
        set(handles.dfofMinTEdit, 'String', get(handles.minTEdit, 'String'));
        guidata(hObject, handles);
        return;
    end
    handles = updatedataaxis(handles);
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function dfofMaxTEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showRoiCheck.
function showRoiCheck_Callback(hObject, eventdata, handles)



% --- Executes on button press in dfofBackgroundCheck.
function dfofBackgroundCheck_Callback(hObject, eventdata, handles)
    if get(handles.dfofBackgroundCheck, 'Value') == 1
        set(handles.dfofBgThreshSlider, 'Enable', 'on');
    else
        set(handles.dfofBgThreshSlider, 'Enable', 'off');
    end



% --- Executes on button press in showScalebarCheck.
function showScalebarCheck_Callback(hObject, eventdata, handles)


% --- Executes when selected object is changed in fOptionsPanel.
function fOptionsPanel_SelectionChangeFcn(hObject, eventdata, handles)
   switch get(eventdata.NewValue,'Tag')
       case 'dfofRollingButton'           
           set(handles.dfofWinSizeEdit, 'Enable', 'on');
           set(handles.dfofMinTEdit, 'Enable', 'off');
           set(handles.dfofMaxTEdit, 'Enable', 'off');
       case 'dfofTRangeButton'                                 
           set(handles.dfofWinSizeEdit, 'Enable', 'off');
           set(handles.dfofMinTEdit, 'Enable', 'on');
           set(handles.dfofMaxTEdit, 'Enable', 'on');
       otherwise
   end

    handles = updatedataaxis(handles);
    guidata(hObject, handles);



% --- Executes when selected cell(s) is changed in roiTable.
function roiTable_CellSelectionCallback(hObject, eventdata, handles)

% --- Executes when entered data in editable cell(s) in roiTable.
function roiTable_CellEditCallback(hObject, eventdata, handles)
    [T Z] = getTZ(handles);
    idx = eventdata.Indices;
    if idx(2) == 2
        handles.showRoi{Z}(idx(1)) = ~handles.showRoi{Z}(idx(1));
    end
    guidata(hObject, handles);


% --- Executes on button press in redrawRoiButton.
function redrawRoiButton_Callback(hObject, eventdata, handles)
    handles = updateroitable( handles );
    handles = slidercallbackdrawimageslice(handles);
    handles = drawroicallback(handles);
    handles = updatedataaxis( handles );
    guidata(hObject, handles);
    


% --- Executes on slider movement.
function dfofBgThreshSlider_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function dfofBgThreshSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function dfofFgThreshSlider_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function dfofFgThreshSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function dfofBlurSlider_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function dfofBlurSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
    


% --- Executes on selection change in analysisPopup.
function analysisPopup_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
currSel = contents{get(hObject, 'Value')};
if strcmp(currSel, 'PCA/ICA')
    set(handles.icaNumPCEdit, 'Enable', 'on');
    set(handles.icaNumICEdit, 'Enable', 'on');
    set(handles.icaMaxPCEdit, 'Enable', 'on');
    set(handles.filterWinSizeEdit, 'Enable', 'off');
    handles.analysisUseICA = true;
else
    set(handles.icaNumPCEdit, 'Enable', 'off');
    set(handles.icaNumICEdit, 'Enable', 'off');
    set(handles.icaMaxPCEdit, 'Enable', 'off');
    set(handles.filterWinSizeEdit, 'Enable', 'on');
    handles.analysisUseICA = false;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function analysisPopup_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dfofSaveCheckbox.
function dfofSaveCheckbox_Callback(hObject, eventdata, handles)



function savePrefixEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function savePrefixEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in deleteAllRoiButton.
function deleteAllRoiButton_Callback(hObject, eventdata, handles)
    if isZProj(handles)
        ZSlices = 1;
    else
        ZSlices = str2double(get(handles.maxZText,'String'));
    end
    for i=1:ZSlices
        handles.masks{i} = [];
        handles.numMasks(i) = 0;
        handles.xPoints{i} = [];
        handles.yPoints{i} = [];
        handles.colors{i} = [];
        handles.showRoi{i} = [];
    end
    handles = updateroitable(handles);
    handles = slidercallbackdrawimageslice(handles);
    handles = drawroicallback(handles);
    handles = updatedataaxis( handles );
    guidata(hObject, handles);
        


% --- Executes on button press in dfofZProjectCheck.
function dfofZProjectCheck_Callback(hObject, eventdata, handles)


% --- Executes on button press in toggleRoisButton.
function toggleRoisButton_Callback(hObject, eventdata, handles)
    [T Z] = getTZ(handles);
    for i=1:handles.numMasks(Z)
        handles.showRoi{Z}(i) = ~handles.showRoi{Z}(i);
    end
    
    handles = updateroitable(handles);
    handles = slidercallbackdrawimageslice(handles);
    handles = drawroicallback(handles);
    handles = updatedataaxis( handles );
    guidata(hObject, handles);


% --- Executes when selected object is changed in colorPanel.
function colorPanel_SelectionChangeFcn(hObject, eventdata, handles)
    if isZProj(handles)
        ZSlices = 1;
    else
        ZSlices = str2double(get(handles.maxZText,'String'));
    end
   for i=1:ZSlices
       handles.colors{i} = [];
   end
   switch get(eventdata.NewValue,'Tag')
       case 'random'
           for i=1:ZSlices
               for j=1:handles.numMasks(i)
                   handles.colors{i} = add_random_colors(handles.colors{i}, 0.4);
               end
           end
       case 'depth'
           for i=1:ZSlices
               for j=1:handles.numMasks(i)
                   handles.colors{i} = add_z_colors(handles.colors{i}, i, ZSlices);
               end
           end
       case 'fixed'
           
            rgb = uisetcolor;
            if rgb == 0
                fprintf('No color chosen...setting color to red\n');
                rgb = [1 0 0];
            end
            handles.rgbcolor = rgb;
                       
           for i=1:ZSlices
               for j=1:handles.numMasks(i)
                    handles.colors{i} = add_fixed_colors(handles.colors{i}, handles.rgbcolor);
               end
           end
       otherwise
   end
   
   handles = updateroitable(handles);
   handles = slidercallbackdrawimageslice(handles);
   handles = drawroicallback(handles);
   handles = updatedataaxis( handles );
   guidata(hObject, handles);


% --- Executes on button press in showStackedPlotButton.
function showStackedPlotButton_Callback(hObject, eventdata, handles)
    [T Z] = getTZ(handles);
    [minT maxT] = getTLim(handles);
    [minZ maxZ] = getZLim(handles);

    plotAllZ = ~isZProj(handles) && (get(handles.plotAllZCheck, 'Value') == 1);
    if plotAllZ
        if sum(handles.numMasks) == 0
            return;
        end
        totalShown = 0;
        for i=minZ:maxZ
            totalShown = totalShown + sum(handles.showRoi{i} == true);
        end
        if totalShown == 0
            return;
        end
    else
        if handles.numMasks(Z) > 0
            numActiveRoi = sum(handles.showRoi{Z} == true);
            if numActiveRoi == 0
                return;
            end
        else
            return;
        end
    end
    
    plotType = getCurrentPlotType(handles);
    useDFOpts = (get(handles.useDFCheck, 'Value') == 1);    
    if ~isZProj(handles)
        if get(handles.plotAllZCheck, 'Value') == 1
            currZ = Z;
            zidx = minZ:maxZ;
            alldfof = cell(length(zidx),1);
            clrs = cell(length(zidx),1);
            usez = cell(length(zidx),1);
            for i=1:length(minZ:maxZ)
                set(handles.currZText, 'String', num2str(zidx(i)));
                [handles dfof] = computeroidfof( handles, plotType, useDFOpts);
                alldfof{i} = dfof';
                clrs{i} = handles.colors{zidx(i)}';
                usez{i} = handles.showRoi{zidx(i)}';
            end
            clrs = cell2mat(clrs);
            usez = cell2mat(usez);
            dfof = cell2mat(alldfof)';
            set(handles.currZText, 'String', num2str(currZ));
        else
            [handles dfof] = computeroidfof( handles, plotType, useDFOpts);
            % use same colors as ROIs seen on screen
            clrs = handles.colors{Z}';
            usez = handles.showRoi{Z};
        end
    else
        [handles dfof] = computeroidfof( handles, plotType, useDFOpts);
        % use same colors as ROIs seen on screen
        clrs = handles.colors{Z}';
        usez = handles.showRoi{Z};
    end
    showAll = logical(get(handles.plotAllZCheck, 'Value') == 1);
    showNums = logical(get(handles.roiShowNumberCheck, 'Value') == 1);
    sPlot(dfof,clrs,usez, showAll, showNums);
    guidata(hObject, handles);
    
% --- Executes on button press in plotAllZCheck.
function plotAllZCheck_Callback(hObject, eventdata, handles)
    handles = updatedataaxis(handles);
    guidata(hObject, handles);


% --- Executes on button press in useDFCheck.
function useDFCheck_Callback(hObject, eventdata, handles)
    handles = updatedataaxis(handles);
    guidata(hObject, handles);
    

% --- Executes on button press in upButton.
function upButton_Callback(hObject, eventdata, handles)
    eventdata.Key = 'k';
    keyFunction(hObject, eventdata)
    guidata(hObject, handles);
    
% --- Executes on button press in downButton.
function downButton_Callback(hObject, eventdata, handles)
    eventdata.Key = 'j';
    keyFunction(hObject, eventdata)
    guidata(hObject, handles);

% --- Executes on button press in leftButton.
function leftButton_Callback(hObject, eventdata, handles)
    eventdata.Key = 'h';
    keyFunction(hObject, eventdata)
    guidata(hObject, handles);

% --- Executes on button press in rightButton.
function rightButton_Callback(hObject, eventdata, handles)
    eventdata.Key = 'l';
    keyFunction(hObject, eventdata)
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function colorPanel_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in addEllipseRoiButton.
function addEllipseRoiButton_Callback(hObject, eventdata, handles)
    [T Z] = getTZ(handles);
    [minZ maxZ] = getZLim(handles);
    try
        h = imellipse(handles.imAxes);
        pos = wait(h);
        xi = pos(:,1);
        yi = pos(:,2);
    catch error
        return;
    end
    
    BW = createMask(h);
    handles.numMasks(Z) = handles.numMasks(Z) + 1;
    i = handles.numMasks(Z);
    handles.masks{Z}(i,:,:) = BW;
    handles.xPoints{Z,i} = xi;
    handles.yPoints{Z,i} = yi;
     
    colortype = getcolortype(handles);
    if strcmp(colortype, 'random')
        handles.colors{Z} = add_random_colors(handles.colors{Z},.4);  
    elseif strcmp(colortype, 'depth')
        handles.colors{Z} = add_z_colors(handles.colors{Z}, Z, maxZ);
    elseif strcmp(colortype, 'fixed')
        handles.colors{Z} = add_fixed_colors(handles.colors{Z}, handles.rgbcolor);
    end
    handles.showRoi{Z}(i) = true;
    
    handles = updateroitable( handles );
    handles = slidercallbackdrawimageslice(handles);
    handles = drawroicallback(handles);
    handles = updatedataaxis( handles );
    guidata(hObject, handles);


% --- Executes on button press in savePlotButton.
function savePlotButton_Callback(hObject, eventdata, handles)
    if strcmp(handles.savename, '') || isempty(get(handles.savePrefixEdit, 'String'))
        msgbox('Need to specify an output directory','','error');
        return;
    end

    if ispc
        sep = '\';
    else
        sep = '/';
    end
    h = figure;    
    handles = updatedataaxis( handles, gca);
    set(gca, 'Color','white');    
    set(gca,  'XColor','black');
    set(gca,'YColor', 'black');
    set(gcf, 'Color', 'white');
    set(gcf, 'Units', 'pixels');
    set(gcf, 'Position', [0 0 handles.width, round(handles.height/2)]);
    axis tight;
    %set(gca, 'Position', [0 0 handles.width round(handles.height/2)]);
    outname = strcat(handles.savepath, sep, get(handles.savePrefixEdit, 'String'), '_Plot.tiff');
    export_fig(gca, outname, '-native');
    %close(h);
    guidata(hObject, handles);