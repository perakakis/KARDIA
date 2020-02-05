% KARDIA ("heart" in Greek) is a graphic user interface (GUI) designed 
% for the analysis of cardiac interbeat interval (IBI) data. KARDIA allows 
% interactive importing and visualization of both IBI data and event-related 
% information. Available functions permit the analysis of phasic heart rate
% changes in response to specific visual or auditory stimuli, using either 
% weighted averages or different interpolation methods (constant, linear,
% spline) at any user-defined sampling rate. KARDIA also provides the user 
% with functions to calculate all commonly used time-domain statistics of 
% heart rate variability and to perform spectral decomposition by using 
% either Fast Fourier Transform or auto-regressive model. Scaling properties 
% of the IBI series can also be assessed by means of Detrended Fluctuation 
% Analysis. Quantitative results can be easily exported in Excel or MATLAB 
% format for further statistical analysis.
%
% To start the GUI type "kardia" in the command window. For usage information
% launch the User's Guide from the toolbox 
%
% KARDIA is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% KARDIA is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with KARDIA. If not, see <http://www.gnu.org/licenses/>.
%
% This software is freely available at:
% www.ugr.es/~peraka/home/kardia.html
%
% Copyright (C) 2007 2008 Pandelis Perakakis, 
% University of Granada
% email: peraka@ugr.es
%
% Update v2.3 - 16/09/2008 - New GUI
%
% Update v2.4 - 30/09/2008 - Unit option in ECP
%
% Update v2.5 - 12/10/2008 - Correct HRV variable order for Excel output
%
% Update v2.6 - 30/10/2008 - Fix concatenation problem in mean algorithm of
% ECP
%
% Update v2.7 - 8/2/2009   - Compatibility with Matlab version 7,
% 'Evoked Cardiac Potentials' changed to 'Phasic Cardiac Responses',
% 'Import' changed to 'Load'
%
% Update v2.8 - 22/01/2012   - Include coefficient to compensate for
% windowing in spectral analysis, more precice number of windows included
% PCR 
% Update v2.9 - 10/06/2015   - Fix export data to mat function
%
% Update v3.1 - 12/04/2020   - Migration to GitHub. Revision history will
% now be accessible through GitHub: https://github.com/perakakis/KARDIA


function main_figure = kardia(DATA)

if nargin <1
    clearFcn
end

load gui_export.mat mat

%% ---------- GUI LAYOUT -----------

%% Main Figure
main_figure = figure(...
    'Units','characters',...
    'PaperUnits',get(0,'defaultfigurePaperUnits'),...
    'Color',[0.87843137254902 0.874509803921569 0.890196078431373],...
    'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
    'IntegerHandle','off',...
    'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
    'MenuBar','none',...
    'Name','KARDIA v3.3',...
    'NumberTitle','off',...
    'PaperPositionMode','auto',...
    'PaperSize',[20.98404194812 29.67743169791],...
    'PaperType',get(0,'defaultfigurePaperType'),...
    'Position',[1.80000000000001 1.38461538461542 201.8 53.0769230769231],...
    'HandleVisibility','callback',...
    'Tag','main_figure',...
    'UserData',[]);

%% KARDIA image
axes_kardia_image = axes(...
    'Parent',main_figure,...
    'Position',[0.0089197224975223 0.649275362318841 0.288404360753221 0.320289855072464],...
    'CameraPosition',[0.5 0.5 9.16025403784439],...
    'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
    'Color',get(0,'defaultaxesColor'),...
    'ColorOrder',get(0,'defaultaxesColorOrder'),...
    'LooseInset',[0.128882521489971 0.100454545454546 0.0941833810888252 0.0684917355371901],...
    'XColor',get(0,'defaultaxesXColor'),...
    'YColor',get(0,'defaultaxesYColor'),...
    'ZColor',get(0,'defaultaxesZColor'),...
    'Tag','axes_kardia_image',...
    'CreateFcn',@plot_kardia);

%% Load
%% ---- Load Data
panel_load_data = uipanel(...
    'Parent',main_figure,...
    'Title','Load Data',...
    'Tag','panel_load_data',...
    'UserData',[],...
    'Clipping','on',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Position',[0.00792864222001982 0.373913043478261 0.150644202180377 0.26231884057971]);

txt_channel_data = uicontrol(...
    'Parent',panel_load_data,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0273972602739726 0.872727272727273 0.321917808219178 0.0909090909090909],...
    'String','Channel',...
    'Style','text',...
    'Tag','txt_channel_data');

txt_datavar_data = uicontrol(...
    'Parent',panel_load_data,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.027027027027027 0.660606060606061 0.290540540540541 0.109090909090909],...
    'String','Data var',...
    'Style','text',...
    'Tag','txt_datavar_data');

txt_unit_data = uicontrol(...
    'Parent',panel_load_data,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0297619047619047 0.272727272727273 0.172619047619048 0.0909090909090909],...
    'String','Unit',...
    'Style','text',...
    'Tag','txt_unit_data');

txt_format_data = uicontrol(...
    'Parent',panel_load_data,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0297619047619047 0.484848484848485 0.244047619047619 0.0727272727272727],...
    'String','Format',...
    'Style','text',...
    'Tag','txt_format_data');

edit_channel_data = uicontrol(...
    'Parent',panel_load_data,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'CData',[],...
    'Position',[0.349315068493149 0.848484848484849 0.246575342465753 0.127272727272727],...
    'String','1',...
    'Style','edit',...
    'Value',1,...
    'Tag','edit_channel_data',...
    'UserData',[]);

edit_unit_data = uicontrol(...
    'Parent',panel_load_data,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'CData',[],...
    'Position',[0.349315068493151 0.266666666666667 0.513698630136986 0.121212121212121],...
    'String',{  'sec '; 'ms' },...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','edit_unit_data',...
    'UserData',[]);

edit_format_data = uicontrol(...
    'Parent',panel_load_data,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'CData',[],...
    'Position',[0.349315068493151 0.454545454545455 0.547945205479452 0.121212121212121],...
    'String',{  'R events'; 'IBIs' },...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','edit_format_data',...
    'UserData',[]);

edit_datavar_data = uicontrol(...
    'Parent',panel_load_data,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'CData',[],...
    'Position',[0.349315068493149 0.660606060606061 0.328767123287671 0.127272727272727],...
    'String',blanks(0),...
    'Style','edit',...
    'Value',[],...
    'Tag','edit_datavar_data',...
    'UserData',[]);

push_ok_data = uicontrol(...
    'Parent',panel_load_data,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Callback','loaddata_callback',...
    'Position',[0.328767123287671 0.0545454545454545 0.424657534246575 0.145454545454545],...
    'String','ok',...
    'Tag','push_ok_data',...
    'callback',@load_data_callback);

%% ---- Load Events
panel_load_events = uipanel(...
    'Parent',main_figure,...
    'Title','Load Events',...
    'Tag','panel_load_events',...
    'UserData',[],...
    'Clipping','on',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Position',[0.163528245787909 0.373913043478261 0.133795837462834 0.26231884057971]);

txt_latvar_events = uicontrol(...
    'Parent',panel_load_events,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0236220472440945 0.691306058221873 0.543307086614173 0.0914634146341464],...
    'String','Latencies var',...
    'Style','text',...
    'Tag','txt_latvar_events');

txt_condvar_events = uicontrol(...
    'Parent',panel_load_events,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0305343511450382 0.478787878787879 0.549618320610687 0.0909090909090909],...
    'String','Conditions var',...
    'Style','text',...
    'Tag','txt_condvar_events');

txt_unit_events = uicontrol(...
    'Parent',panel_load_events,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0305343511450382 0.258064516129032 0.229007633587786 0.0967741935483871],...
    'String','Unit',...
    'Style','text',...
    'Tag','txt_unit_events');

edit_latvar_events = uicontrol(...
    'Parent',panel_load_events,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'CData',[],...
    'Position',[0.595419847328244 0.666666666666667 0.381679389312977 0.127272727272727],...
    'String',blanks(0),...
    'Style','edit',...
    'Value',[],...
    'Tag','edit_latvar_events',...
    'UserData',[]);

pop_unit_events = uicontrol(...
    'Parent',panel_load_events,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.595419847328244 0.245161290322581 0.351145038167939 0.12258064516129],...
    'String',{  'sec'; 'ms' },...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','pop_unit_events');

edit_condvar_events = uicontrol(...
    'Parent',panel_load_events,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'CData',[],...
    'Position',[0.595419847328244 0.466666666666667 0.381679389312977 0.127272727272727],...
    'String',blanks(0),...
    'Style','edit',...
    'Value',[],...
    'Tag','edit_condvar_events',...
    'UserData',[]);

push_ok_events = uicontrol(...
    'Parent',panel_load_events,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Callback',@load_events_callback,...
    'Position',[0.259842519685039 0.0487804878048781 0.488188976377953 0.146341463414634],...
    'String','ok',...
    'Tag','push_ok_events');

txt_subject_events = uicontrol(...
    'Parent',panel_load_events,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0229007633587786 0.872727272727273 0.312977099236641 0.0909090909090909],...
    'String','Subject',...
    'Style','text',...
    'Tag','txt_subject_events');

pop_subject_events = uicontrol(...
    'Parent',panel_load_events,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'CData',[],...
    'Position',[0.404580152671756 0.842424242424242 0.572519083969466 0.133333333333333],...
    'String',{ blanks(0)},...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','pop_subject_events',...
    'UserData',[]);

%% PCR
panel_PCR = uipanel(...
    'Parent',main_figure,...
    'Title','Phasic Cardiac Responses',...
    'Tag','panel_PCR',...
    'Clipping','on',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Position',[0.0089197224975223 0.0130434782608696 0.288404360753221 0.347826086956522]);

push_selectconds_PCR = uicontrol(...
    'Parent',panel_PCR,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Callback',@PCR_conditions_callback,...
    'Position',[0.0313588850174216 0.834821428571428 0.331010452961672 0.102678571428571],...
    'String','Select conditions',...
    'Tag','push_selectconds_PCR');

txt_epochstart_PCR = uicontrol(...
    'Parent',panel_PCR,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'CData',[],...
    'HorizontalAlignment','left',...
    'Position',[0.0323741007194245 0.710765098722417 0.233812949640288 0.0609756097560976],...
    'String','Epoch start',...
    'Style','text',...
    'Tag','txt_epochstart_PCR',...
    'UserData',[]);

edit_epochend_PCR = uicontrol(...
    'Parent',panel_PCR,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.75 0.690439895470383 0.179856115107914 0.0934959349593497],...
    'String',[],...
    'Style','edit',...
    'Tag','edit_epochend_PCR');

txt_epochend_PCR = uicontrol(...
    'Parent',panel_PCR,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Position',[0.505030562016552 0.70786799646534 0.204828618308361 0.0646281240590184],...
    'String','Epoch end',...
    'Style','text',...
    'Tag','txt_epochend_PCR');

edit_epochstart_PCR = uicontrol(...
    'Parent',panel_PCR,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.28 0.690439895470383 0.165467625899281 0.0934959349593497],...
    'String',[],...
    'Style','edit',...
    'Tag','edit_epochstart_PCR');

txt_algorithm_PCR = uicontrol(...
    'Parent',panel_PCR,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0313588850174216 0.535 0.212543554006969 0.0669642857142857],...
    'String','Algorithm',...
    'Style','text',...
    'Tag','txt_algorithm_PCR');

pop_algorithm_PCR = uicontrol(...
    'Parent',panel_PCR,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.28 0.531957126245529 0.303402390869259 0.0917795844625113],...
    'String',{  'mean'; 'CDR'; 'constant'; 'linear'; 'spline' },...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','pop_algorithm_PCR');

txt_unit_PCR = uicontrol(...
    'Parent',panel_PCR,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.65 0.535 0.212543554006969 0.0669642857142857],...
    'String','Unit',...
    'Style','text',...
    'Tag','txt_unit_PCR');

pop_unit_PCR = uicontrol(...
    'Parent',panel_PCR,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.75 0.53 0.2 0.0917795844625113],...
    'String',{'bpm'; 'sec'},...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','pop_unit_PCR');

txt_timewindow_PCR = uicontrol(...
    'Parent',panel_PCR,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0323741007194245 0.397756968641115 0.262589928057554 0.0691056910569106],...
    'String','Time Window',...
    'Style','text',...
    'Tag','txt_timewindow_PCR');

edit_timewindow_PCR = uicontrol(...
    'Parent',panel_PCR,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.28 0.401822009291522 0.161870503597122 0.0853658536585366],...
    'String','1',...
    'Style','edit',...
    'Value',1,...
    'Tag','edit_timewindow_PCR');

check_removebsl_PCR = uicontrol(...
    'Parent',panel_PCR,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Position',[0.0313588850174216 0.241071428571428 0.40418118466899 0.0669642857142857],...
    'String','Remove baseline',...
    'Style','checkbox',...
    'Value',1,...
    'Tag','check_removebsl_PCR');

push_ok_PCR = uicontrol(...
    'Parent',panel_PCR,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Callback',@PCR_callback,...
    'Position',[0.379790940766551 0.0758928571428571 0.222996515679443 0.0982142857142857],...
    'String','ok',...
    'Tag','push_ok_PCR');

%% HRV
panel_HRV = uipanel(...
    'Parent',main_figure,...
    'Title','HRV',...
    'Tag','panel_HRV',...
    'UserData',[],...
    'Clipping','on',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Position',[0.306243805748266 0.0115942028985507 0.278493557978196 0.972463768115942]);

%% ---- Epoch Data
panel_epochdata = uipanel(...
    'Parent',panel_HRV,...
    'Title','Epoch Data',...
    'Tag','panel_epochdata_HRV',...
    'UserData',[],...
    'Clipping','on',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Position',[0.0323741007194245 0.788148148148148 0.93884892086331 0.198518518518519]);

push_selectconds_HRV = uicontrol(...
    'Parent',panel_epochdata,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Callback',@HRV_conditions_callback,...
    'Position',[0.02734375 0.728070175438596 0.40078125 0.228070175438596],...
    'String','Select conditions',...
    'Tag','push_selectconds_HRV');

txt_epochstart_HRV = uicontrol(...
    'Parent',panel_epochdata,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.02734375 0.508771929824561 0.22265625 0.12280701754386],...
    'String','Epoch start',...
    'Style','text',...
    'Tag','txt_epochstart_HRV');

edit_epochend_HRV = uicontrol(...
    'Parent',panel_epochdata,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.696528453307393 0.478870145259429 0.151750972762646 0.186440677966102],...
    'String',[],...
    'Style','edit',...
    'Tag','edit_epochend_HRV');

txt_epochend_HRV = uicontrol(...
    'Parent',panel_epochdata,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.463065418287938 0.512768450344175 0.206225680933852 0.127118644067797],...
    'String','Epoch end',...
    'Style','text',...
    'Tag','txt_epochend_HRV');

edit_epochstart_HRV = uicontrol(...
    'Parent',panel_epochdata,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.287968142023346 0.478870145259429 0.147859922178988 0.177966101694915],...
    'String',[],...
    'Style','edit',...
    'Tag','edit_epochstart_HRV');

% push_rejectartifacts_HRV = uicontrol(...
%     'Parent',panel_epochdata,...
%     'Units','normalized',...
%     'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
%     'Position',[0.02734375 0.114035087719298 0.33203125 0.210526315789474],...
%     'String','Reject artifacts',...
%     'Tag','push_rejectartifacts_HRV');

push_epochdata_HRV = uicontrol(...
    'Parent',panel_epochdata,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Callback',@epochdata_callback,...
    'Position',[0.4375 0.114035087719298 0.20703125 0.201754385964912],...
    'String','ok',...
    'Tag','push_epochdata_HRV');

%% ---- Spectral Analysis
panel_spectral = uipanel(...
    'Parent',panel_HRV,...
    'Title','Spectral Analysis',...
    'Tag','panel_spectral',...
    'UserData',[],...
    'Clipping','on',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Position',[0.0324909747292419 0.270229007633588 0.942238267148015 0.493129770992366]);

txt_samplerate = uicontrol(...
    'Parent',panel_spectral,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0350194552529183 0.920634920634921 0.252918287937743 0.0476190476190476],...
    'String','Sample Rate',...
    'Style','text',...
    'Tag','txt_samplerate');

pop_samplerate = uicontrol(...
    'Parent',panel_spectral,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.385214007782101 0.898412698412699 0.21011673151751 0.073015873015873],...
    'String',{  '2'; '4' },...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','pop_samplerate');

txt_detrendmethod = uicontrol(...
    'Parent',panel_spectral,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0350194552529183 0.676190476190476 0.307392996108949 0.053968253968254],...
    'String','Detrend method',...
    'Style','text',...
    'Tag','txt_detrendmethod');

push_ok_spectral = uicontrol(...
    'Parent',panel_spectral,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Callback',@spectral_callback,...
    'Position',[0.385214007782101 0.0507936507936508 0.206225680933852 0.0761904761904762],...
    'String','ok',...
    'Tag','push_ok_spectral');

txt_points = uicontrol(...
    'Parent',panel_spectral,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0350194552529183 0.793650793650794 0.136186770428016 0.0634920634920635],...
    'String','Points',...
    'Style','text',...
    'Tag','txt_points');

txt_Filter = uicontrol(...
    'Parent',panel_spectral,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.03515625 0.557377049180328 0.21875 0.0524590163934426],...
    'String','Windowing',...
    'Style','text',...
    'Tag','txt_Filter');

txt_ARorder = uicontrol(...
    'Parent',panel_spectral,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0350194552529183 0.311111111111111 0.217898832684825 0.0476190476190476],...
    'String','AR order',...
    'Style','text',...
    'Tag','txt_ARorder');

txt_algorithm_spectral = uicontrol(...
    'Parent',panel_spectral,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0350194552529183 0.422222222222222 0.21011673151751 0.073015873015873],...
    'String','Algorithm',...
    'Style','text',...
    'Tag','txt_algorithm_spectral');

txt_scale = uicontrol(...
    'Parent',panel_spectral,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0350194552529183 0.193650793650794 0.151750972762646 0.053968253968254],...
    'String','Scale',...
    'Style','text',...
    'Tag','txt_scale');

pop_detrendmethod = uicontrol(...
    'Parent',panel_spectral,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.390625 0.668852459016393 0.3125 0.0655737704918033],...
    'String',{  'constant'; 'linear' },...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','pop_detrendmethod');

pop_points = uicontrol(...
    'Parent',panel_spectral,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.389105058365759 0.79047619047619 0.21011673151751 0.073015873015873],...
    'String',{  '512'; '1024'; 'auto' },...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','pop_points');

pop_Filter = uicontrol(...
    'Parent',panel_spectral,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.390625 0.554098360655738 0.31640625 0.0655737704918033],...
    'String',{  'Hanning'; 'Hamming'; 'Blackman'; 'Bartlett' },...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','pop_Filter');

edit_ARorder = uicontrol(...
    'Parent',panel_spectral,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.389105058365759 0.298412698412699 0.151750972762646 0.0666666666666667],...
    'String','16',...
    'Style','edit',...
    'Value',1,...
    'Tag','edit_ARorder');

pop_algorithm_spectral = uicontrol(...
    'Parent',panel_spectral,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.390625 0.429508196721312 0.30078125 0.0688524590163934],...
    'String',{  'FFT'; 'AR-Burg' },...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','pop_algorithm_spectral');

pop_scale = uicontrol(...
    'Parent',panel_spectral,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.390625 0.19016393442623 0.29296875 0.0655737704918033],...
    'String',{  'normal '; 'log'; 'semilog' },...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','pop_scale');

%% ---- DFA
panel_DFA = uipanel(...
    'Parent',panel_HRV,...
    'Title','DFA',...
    'Tag','panel_DFA',...
    'UserData',[],...
    'Clipping','on',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Position',[0.0323741007194245 0.028148148148148 0.942446043165468 0.21037037037037]);

txt_minbox = uicontrol(...
    'Parent',panel_DFA,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.0193798449612403 0.73015873015873 0.151162790697675 0.134920634920635],...
    'String','Minbox',...
    'Style','text',...
    'Tag','txt_minbox');

txt_maxbox = uicontrol(...
    'Parent',panel_DFA,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.387596899224806 0.73015873015873 0.162790697674419 0.134920634920635],...
    'String','Maxbox',...
    'Style','text',...
    'Tag','txt_maxbox');

edit_minbox = uicontrol(...
    'Parent',panel_DFA,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.178294573643411 0.706349206349206 0.131782945736434 0.19047619047619],...
    'String','4',...
    'Style','edit',...
    'Value',4,...
    'Tag','edit_minbox');

check_slidingwins = uicontrol(...
    'Parent',panel_DFA,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Position',[0.0193798449612403 0.444444444444445 0.391472868217054 0.119047619047619],...
    'String','sliding windows',...
    'Style','checkbox',...
    'Value',1,...
    'Tag','check_slidingwins');

push_ok_DFA = uicontrol(...
    'Parent',panel_DFA,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Callback',@DFA_callback,...
    'Position',[0.383720930232558 0.134920634920635 0.205426356589147 0.19047619047619],...
    'String','ok',...
    'Tag','push_ok_DFA');

edit_maxbox = uicontrol(...
    'Parent',panel_DFA,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.562015503875969 0.706349206349206 0.131782945736434 0.19047619047619],...
    'String','16',...
    'Style','edit',...
    'Value',16,...
    'Tag','edit_maxbox');

%% Graphs
panel_graphs = uipanel(...
    'Parent',main_figure,...
    'Title','Graphs',...
    'Tag','panel_graphs',...
    'Clipping','on',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Position',[0.592666005946482 0.0115942028985507 0.397423191278494 0.972463768115942]);

%% ---- IBIs
edit_subjectname_IBIs = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.71 0.933333333333333 0.27 0.0320610687022901],...
    'String',blanks(0),...
    'Style','edit',...
    'Tag','edit_subject_IBIs',...
    'CreateFcn',@update_subjectname_IBIs,...
    'Callback',@edit_subjectname_IBIs_callback);

axes_IBIs = axes(...
    'Parent',panel_graphs,...
    'Position',[0.1 0.738931297709924 0.458438287153652 0.23969465648855],...
    'CameraPosition',[0.5 0.5 9.16025403784439],...
    'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
    'Color',get(0,'defaultaxesColor'),...
    'ColorOrder',get(0,'defaultaxesColorOrder'),...
    'FontSize',7,...
    'LooseInset',[0.13569492144684 0.125485436893204 0.0991616733649981 0.0855582524271844],...
    'XColor',get(0,'defaultaxesXColor'),...
    'YColor',get(0,'defaultaxesYColor'),...
    'YLim',get(0,'defaultaxesYLim'),...
    'YLimMode','auto',...
    'XLimMode','auto',...
    'ZColor',get(0,'defaultaxesZColor'),...
    'Tag','axes_IBIs',...
    'UserData',[],...
    'NextPlot','replacechildren',...
    'CreateFcn',@plot_IBIs,...
    'ButtonDownFcn',@buttondown_IBIs);

push_dwnsub_IBIs = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Position',[0.57 0.933333333333333 0.052896725440806 0.0340740740740741],...
    'String','<',...
    'Tag','push_dwnsub_IBIs',...
    'Callback',@dwnsub_IBIs);

push_upsub_IBIs = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Position',[0.63 0.933333333333333 0.052896725440806 0.0340740740740741],...
    'String','>',...
    'Tag','push_upsub_IBIs',...
    'Callback',@upsub_IBIs);

txt_subject_IBIs = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.795 0.97 0.100755667506297 0.0222222222222222],...
    'String','Subject',...
    'Style','text',...
    'Tag','txt_subject_IBIs');

txt_info_IBIs = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.58 0.77 0.4 0.125190839694657],...
    'String',[],...
    'Style','text',...
    'Tag','txt_info_IBIs',...
    'CreateFcn',@update_info_IBIs);

%% ---- PCR
edit_subjectname_PCR = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.71 0.613333333333334 0.27 0.0320610687022901],...
    'String',blanks(0),...
    'Style','edit',...
    'Tag','edit_subject_PCR',...
    'CreateFcn',@update_subjectname_PCR,...
    'Callback',@edit_subjectname_PCR_callback);

axes_PCR = axes(...
    'Parent',panel_graphs,...
    'Position',[0.1 0.40763358778626 0.458438287153652 0.23969465648855],...
    'CameraPosition',[0.5 0.5 9.16025403784439],...
    'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
    'Color',get(0,'defaultaxesColor'),...
    'ColorOrder',get(0,'defaultaxesColorOrder'),...
    'FontSize',7,...
    'LooseInset',[0.13569492144684 0.125485436893204 0.0991616733649981 0.0855582524271844],...
    'XColor',get(0,'defaultaxesXColor'),...
    'YColor',get(0,'defaultaxesYColor'),...
    'YLim',get(0,'defaultaxesYLim'),...
    'YLimMode','auto',...
    'XLimMode','auto',...
    'ZColor',get(0,'defaultaxesZColor'),...
    'Tag','axes_PCR',...
    'UserData',[],...
    'NextPlot','replacechildren',...
    'CreateFcn',@plot_PCR,...
    'ButtondownFcn',@buttondown_PCR);

push_dwnsub_PCR = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Callback',@dwnsub_PCR,...
    'Position',[0.57 0.613333333333334 0.052896725440806 0.0340740740740741],...
    'String','<',...
    'Tag','push_dwnsub_PCR');

push_upsub_PCR = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Callback',@upsub_PCR,...
    'Position',[0.63 0.613333333333334 0.052896725440806 0.0340740740740741],...
    'String','>',...
    'Tag','push_upsub_PCR');

txt_subjectname_PCR = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.795 0.65 0.100755667506297 0.0222222222222222],...
    'String','Subject',...
    'Style','text',...
    'Tag','txt_subject_PCR');

txt_info_PCR = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.58 0.44 0.4 0.125190839694657],...
    'String',[],...
    'Style','text',...
    'Tag','txt_info_PCR',...
    'CreateFcn',@update_info_PCR);

%% ---- HRV
edit_subjectname_HRV = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.71 0.288 0.27 0.0320610687022901],...
    'String',blanks(0),...
    'Style','edit',...
    'Tag','edit_subject_HRV',...
    'CreateFcn',@update_subjectname_HRV,...
    'Callback',@edit_subjectname_HRV_callback);

edit_condname_HRV = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.71 0.22 0.27 0.0320610687022901],...
    'String',blanks(0),...
    'Style','edit',...
    'Tag','edit_condname_HRV',...
    'CreateFcn',@update_condname_HRV,...
    'Callback',@edit_condname_HRV_callback);

axes_HRV = axes(...
    'Parent',panel_graphs,...
    'Position',[0.1 0.0763358778625954 0.458438287153652 0.23969465648855],...
    'CameraPosition',[0.5 0.5 9.16025403784439],...
    'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
    'Color',get(0,'defaultaxesColor'),...
    'ColorOrder',get(0,'defaultaxesColorOrder'),...
    'FontSize',7,...
    'LooseInset',[0.13569492144684 0.125485436893204 0.0991616733649981 0.0855582524271844],...
    'XColor',get(0,'defaultaxesXColor'),...
    'YColor',get(0,'defaultaxesYColor'),...
    'YLim',get(0,'defaultaxesYLim'),...
    'YLimMode','auto',...
    'XLimMode','auto',...
    'ZColor',get(0,'defaultaxesZColor'),...
    'Tag','axes_HRV',...
    'UserData',[],...
    'NextPlot','replacechildren',...
    'CreateFcn',@plot_HRV,...
    'ButtonDownFcn',@buttondown_HRV);

txt_info2_HRV = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.78 0.065 0.2 0.14],...
    'String',[],...
    'Style','text',...
    'Tag','txt_info2_HRV');

txt_info1_HRV = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.58 0.065 0.2 0.14],...
    'String',[],...
    'Style','text',...
    'Tag','txt_info1_HRV',...
    'CreateFcn',@update_info1_HRV);

txt_condition_HRV = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.787 0.252 0.18 0.0229007633587786],...
    'String','Condition',...
    'Style','text',...
    'Tag','txt_epoh_HRV');

push_dwnsub_HRV = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Callback',@dwnsub_HRV,...
    'Position',[0.57 0.288549618320611 0.052896725440806 0.033587786259542],...
    'String','<',...
    'Tag','push_dwnsub_HRV');

push_upsub_HRV = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Callback',@upsub_HRV,...
    'Position',[0.63 0.288549618320611 0.052896725440806 0.033587786259542],...
    'String','>',...
    'Tag','push_upsub_HRV');

push_dwncond_HRV = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Callback',@dwncond_HRV,...
    'Position',[0.57 0.22 0.052896725440806 0.033587786259542],...
    'String','<',...
    'Tag','push_dwncond_HRV');

push_upcond_HRV = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'Callback',@upcond_HRV,...
    'Position',[0.63 0.22 0.052896725440806 0.033587786259542],...
    'String','>',...
    'Tag','push_upcond_HRV');

txt_subject_HRV = uicontrol(...
    'Parent',panel_graphs,...
    'Units','normalized',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'HorizontalAlignment','left',...
    'Position',[0.795 0.325 0.100755667506297 0.0222222222222222],...
    'String','Subject',...
    'Style','text',...
    'Tag','txt_subject_HRV');

%% Toolbar
toolbar = uitoolbar(...
    'Parent',main_figure,...
    'Tag','toolbar');

toolsave = uipushtool(...
    'Parent',toolbar,...
    'ClickedCallback',@saveDATA_callback,...
    'CData',mat{1},...
    'TooltipString','Save Data',...
    'BusyAction','cancel',...
    'Interruptible','off',...
    'Tag','toolsave');

toolexcel = uipushtool(...
    'Parent',toolbar,...
    'ClickedCallback',@excel_callback,...
    'CData',mat{2},...
    'TooltipString','Export to Excel',...
    'BusyAction','cancel',...
    'Interruptible','off',...
    'Tag','toolexcel');

tooltutorial = uitoggletool(...
    'Parent',toolbar,...
    'ClickedCallback',@tutorial_callback,...
    'CData',mat{3},...
    'TooltipString','User''s Guide',...
    'Tag','tooltutorial');

toolabout = uipushtool(...
    'Parent',toolbar,...
    'ClickedCallback',@about_callback,...
    'CData',mat{4},...
    'TooltipString','About',...
    'Tag','toolabout');

%% ---------- GUI CALLBACKS -----------
%% Plot KARDIA image
    function plot_kardia(src,eventdata)
        H=imread('kardia.jpg');
        image(H)
        set (gca, 'Visible','off');    
    end

%% Load Callbacks
%% ---- Load Data
    function load_data_callback(src,eventdata)
        % get variables
        datavar=get(edit_datavar_data,'String');
        chn=str2num(get(edit_channel_data,'String'));
        unit=get(edit_unit_data,'Value');
        format=get(edit_format_data,'Value');

        % error message
        if isempty(datavar)
            errordlg('Insert variable name','Load Data')
            return
        end

        % open getfile gui
        [names, path] = uigetfile...
            ('*.mat','Load matlab files',...
            'MultiSelect', 'on');

        if path==0
            return
        end

        % get data
        if ischar(names) % case 1 subject
            work=load([path names]); % load variable
            point=find(names=='.');Subjects=names(1:point-1); % remove extension
            if isfield(work,datavar)==0
                errordlg('Variable does not exist','Load Data') % error message
                return
            end
            data=eval(['work.' datavar]);
            s=size(data); % transpose data matrix (channels=columns)
            if s(1)<s(2)
                data=data';
            end
            if chn>size(data,2) % error message for wrong channel number
                errordlg('Wrong channel number','Load Data')
                return
            end
            data=data(:,chn); % get data

            if unit==2 % case unit ms
                data=data/1000;
            end
            if format==2 % case type IBIs
                data=cumsum(data); % get R events
            end
            data=data';
            Revents=data;
            subjectsNum=1;
            [IBIs,thp]=ecg_hp(data,'instantaneous'); % get heart period

        elseif iscell(names) % case more than one subjects
            l=size(names,2); % number of subjects
            for i=1:l % loop subjects
                name=names{i};
                point=find(name=='.');
                Subjects{i}=name(1:point-1); % write subject name
                work=load([path names{i}]);
                if isfield(work,datavar)==0
                    errordlg('Variable does not exist','Load Data') % error message
                    return
                end
                data=eval(['work.' datavar]);
                s=size(data); % transpose data matrix (channels=columns)
                if s(1)<s(2)
                    data=data';
                end
                if chn>size(data,2) % error message for wrong channel number
                    errordlg('Wrong channel number','Load Data')
                    return
                end
                data=data(:,chn);
                if unit==2 % case unit ms
                    data=data/1000;
                end
                if format==2 % case type IBIs
                    data=cumsum(data);
                end
                data=data'; % transpose data (1 row)
                Revents{i}=data;
                [hp,thp]=ecg_hp(data,'instantaneous'); % get heart period
                IBIs{i}=hp;
                subjectsNum=l; % number of subjects
            end
        end

        % clear old variables
        clearFcn

        % output variable
        DATA.Subjects=Subjects;
        DATA.R_events=Revents;
        DATA.IBIs=IBIs;
        DATA.GUI.SubjectsNum=subjectsNum;
        DATA.GUI.Subject2plot_IBIs=[];
        DATA.Events(subjectsNum).Conditions=[];
        DATA.Events(subjectsNum).Latencies=[];

        % set subject events
        set(pop_subject_events,'Value',1)

        % clear graphs
        update_subjectname_PCR(edit_subjectname_PCR,[]);
        plot_PCR(axes_PCR,[]);
        update_subjectname_HRV(edit_subjectname_HRV,[]);
        update_condname_HRV(edit_condname_HRV,[]);
        plot_HRV(axes_HRV,[]);

        % update plot
        plot_IBIs(axes_IBIs,[]);
        update_subjectname_IBIs(edit_subjectname_IBIs,[]);

        % update information
        update_info_IBIs(txt_info_IBIs,[]);
        update_info_PCR(txt_info_PCR,[]);

        % update event selection
        set(pop_subject_events,'String',Subjects)
    end

%% ---- Load Events
    function load_events_callback(src,eventdata)
        % get variables
        subjects=DATA.Subjects;
        subjectsNum=DATA.GUI.SubjectsNum;
        sub=get(pop_subject_events,'Value');
        latvar=get(edit_latvar_events,'String');
        codesvar=get(edit_condvar_events,'String');
        unit=get(pop_unit_events,'Value');

        if isempty(subjects) % error when no subjects imported
            errordlg('Load subject data first','Load Events')
            return
        end
        if isempty(latvar) % error when no latency variable
            errordlg('Insert latency variable','Load Events')
            return
        end
        if isempty(codesvar) % error when no conditions variable
            errordlg('Insert conditions variable','Load Events')
            return
        end

        % if we are using common eventfile
        if DATA.GUI.UseCommonEventfile==1;
            errordlg(['To load individual event files you' ...
                ' need to load subjects again'],...
                'Load Events');
            return
        end

        % load event data
        [name, path] = uigetfile...
            ('*.mat','Load matlab file containing events',...
            'MultiSelect', 'off');

        if path==0
            return
        end

        work=load([path name]);

        % error message
        if isfield(work,codesvar)==0
            errordlg('Latency variable does not exist','Load Events')
            return
        end
        if isfield(work,latvar)==0
            errordlg('Conditions variable does not exist','Load Events')
            return
        end

        % get latencies and codes
        lats=eval(['work.' latvar]);
        evs=eval(['work.' codesvar]);
        if length(lats) ~= length (evs)
            errordlg('Not same number of events and codes','Load Events');
            return
        end
        DATA.GUI.EventsNum=length(lats);

        % transpose (one row)
        if size(evs,1)>size(evs,2)
            evs=evs';
        end
        if size(lats,1)>size(lats,2)
            lats=lats';
        end

        % transform to seconds
        if unit==2
            lats=lats/1000;
        end

        % create event matrix
        N=length(evs);
        events={evs{1}}; % get first event
        % find all different events
        if N>1
            for i=2:N
                if strcmp(evs{i},evs(1:i-1))==0
                    events=[events {evs{i}}];
                end
            end
        end

        % check consistency of conditions across subjects
        events=sort(events);
        if isempty(DATA.Conditions) % first eventfile
            DATA.Conditions=events;
            DATA.Events(sub).Conditions=evs;
            DATA.Events(sub).Latencies=lats;
            DATA.GUI.Eventfiles=1;
            DATA.GUI.ConditionsNum=length(events);
        else
            if length(events)~=length(DATA.Conditions)
                errordlg('Conditions not consistent across subjects',...
                    'Load Events')
                return
            end
            % write events structure for subject
            if strcmp(events,DATA.Conditions)==1
                if isempty(DATA.Events(sub).Conditions)
                    DATA.Events(sub).Conditions=evs;
                    DATA.Events(sub).Latencies=lats;
                    DATA.GUI.Eventfiles=DATA.GUI.Eventfiles+1;
                else
                    quest = questdlg(...
                        'Eventfile already exists. Do you want to replace it?',...
                        'Load Events');
                    switch quest
                        case 'Yes'
                            DATA.Events(sub).Conditions=evs;
                            DATA.Events(sub).Latencies=lats;
                        case 'No'
                            return
                    end
                end
            else
                errordlg('Conditions not consistent across subjects',...
                    'Load Events')
                return
            end
        end

        % update information
        update_info_IBIs(txt_info_IBIs,[]);
    end

%% Analysis Callbacks
%% ---- PCR
% -------------- Select Conditions GUI
    function PCR_conditions_callback(src,eventdata)
        % error when no imported event types are found
        if  isempty(DATA.Conditions)
            errordlg('No conditions found','PCR')
            return
        end

        % GUI
        PCR_Conditions_Figure = figure(...
            'MenuBar','none',...
            'Units','characters',...
            'Color',[0.87843137254902 0.874509803921569 0.890196078431373],...
            'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
            'Name','Select Conditions',...
            'NumberTitle','off',...
            'Position',[100 30 50 15],...
            'Resize','Off');

        list_conditions_PCR = uicontrol(...
            PCR_Conditions_Figure,...
            'Style','listbox',...
            'String',DATA.Conditions,...
            'max',2,...
            'Units','normalize',...
            'Position',[.15 .2 .7 .7],...
            'BackgroundColor','w',...
            'ForegroundColor','k',...
            'Value',1);

        push_ok_conditions_PCR = uicontrol(...
            PCR_Conditions_Figure,...
            'Style','pushbutton',...
            'String','ok',...
            'Units','normalize',...
            'Position',[.25 .03 .2 .1],...
            'callback', @select_conditions_PCR_callback);

        push_cancel_conditions_PCR = uicontrol(...
            PCR_Conditions_Figure,...
            'Style','pushbutton',...
            'String','Cancel',...
            'Units','normalize',...
            'Position',[.55 .03 .2 .1],...
            'callback', @cancel_conditions_PCR_callback);

        % Callbacks
        function select_conditions_PCR_callback(src,eventdata)
            % get condition indexes
            ind=get(list_conditions_PCR,'Value');

            % error message
            if isempty (ind)
                errordlg('No conditions selected','Select Conditions')
                return
            end

            % clear previous results
            DATA.GUI.PCRconditions=[];
            DATA.GUI.PCRconditionsNum=[];

            % update DATA structure
            DATA.GUI.PCRconditionsNum=length(ind);
            DATA.GUI.PCRconditions=DATA.Conditions(ind);

            % update information
            update_info_PCR(txt_info_PCR,[]);

            delete(PCR_Conditions_Figure)
            return
        end

        function cancel_conditions_PCR_callback(src,eventdata)
            delete(PCR_Conditions_Figure)
        end
    end

    function PCR_callback(src,eventdata)
        % get variables
        epochstart=str2num(get(edit_epochstart_PCR,'String'));
        epochend=str2num(get(edit_epochend_PCR,'String'));
        algorithm=get(pop_algorithm_PCR,'Value');
        unit=get(pop_unit_PCR,'String');
        unitvalue=get(pop_unit_PCR,'Value');
        unit=unit{unitvalue};
        window=str2num(get(edit_timewindow_PCR,'String'));
        baseline=get(check_removebsl_PCR,'Value');
        subs=DATA.GUI.SubjectsNum;
        SelectedConds=DATA.GUI.PCRconditions;

        % pass variables to DATA structure
        DATA.GUI.PCR_EpochStart=mat2str(epochstart);
        DATA.GUI.PCR_EpochEnd=mat2str(epochend);
        switch algorithm
            case 1
                DATA.GUI.PCR_Algorithm='mean';
            case 2
                DATA.GUI.PCR_Algorithm='CDR';
                DATA.GUI.PCR_EpochStart=mat2str(-15);
                DATA.GUI.PCR_EpochEnd=mat2str(80);
            case 3
                DATA.GUI.PCR_Algorithm='constant';
            case 4
                DATA.GUI.PCR_Algorithm='linear';
            case 5
                DATA.GUI.PCR_Algorithm='spline';
        end
        DATA.GUI.PCR_TimeWindow=mat2str(window);
        DATA.GUI.PCR_Unit=unit;
        
        % error messages
        if isempty (epochstart) && ...
                algorithm~=2
            errordlg('Define epoch limits','PCR')
            return
        end
        if isempty (epochend) && ...
                algorithm~=2
            errordlg('Define epoch limits','PCR')
            return
        end
        if isempty(DATA.GUI.PCRconditions)
            errordlg ('Select conditions first','PCR')
            return
        end

        % clear previous results
        DATA.PCR=[];
        DATA.PCR_GrandAverage=[];

        % use the same eventfile (first subject) for all subjects
        if DATA.GUI.SubjectsNum>1 && ...
                DATA.GUI.Eventfiles<DATA.GUI.SubjectsNum && ...
                isempty(DATA.GUI.UseCommonEventfile);
            quest = questdlg(['Do you want to use the first event file'...
                ' for all subjects?'],'PCR');
            switch quest
                case 'Yes'
                    if isempty(DATA.Events(1).Conditions)
                        errordlg('Load event file for first subject',...
                            'PCR');
                        return
                    end
                    for i=2:DATA.GUI.SubjectsNum
                        DATA.Events(i).Conditions=...
                            DATA.Events(1).Conditions;
                        DATA.Events(i).Latencies=...
                            DATA.Events(1).Latencies;
                    end
                    DATA.GUI.UseCommonEventfile=1;
                    DATA.GUI.Eventfiles=1;
                case 'No'
                    return
                case 'Cancel'
                    return
            end
        end

        for i=1:subs % get subject data
            % get necessary variables
            data=DATA.Events(i);
            if subs==1
                Rdata=DATA.R_events;
            else
                Rdata=DATA.R_events{i};
            end
            lats=data.Latencies;
            conds=data.Conditions;
            [hp,t]=ecg_hp(Rdata,'instantaneous');
            hr=60*hp.^-1;

            for j=1:DATA.GUI.PCRconditionsNum % get condition
                index=strcmp(SelectedConds(j),conds);
                analysis_lats=lats(index);

                HR=[];
                BSL=[];
                for k=1:length(analysis_lats) % get epoch
                    lat=analysis_lats(k);
                    switch algorithm
                        case 1 % mean
                                [HR_mean,HRbsl]=PCR(Rdata,...
                                    lat,lat + epochstart,...
                                    epochend,...
                                    window,unit);                                
                        case 2 % CDR
                            [HRbsl,HR_mean,values]=CDR(Rdata,...
                                lat,15);
                        case {3, 4, 5}  % constant, linear, spline
                            % baseline
                            HRbsl=ecg_stat(t,lat+epochstart,...
                                lat,'mean',unit);
                            % time vector
                            tt=lat:window:lat+epochend;
                            
                            if strcmp(unit,'bpm') % switch unit
                                xx=hr;
                            elseif strcmp(unit,'sec')
                                xx=hp;
                            end
                            
                            % case constant
                            if algorithm==3
                                HR_mean=ecg_interp(t,xx,tt,'constant');
                                % case linear
                            elseif algorithm==4
                                HR_mean=ecg_interp(t,xx,...
                                    tt,'linear');
                                % case spline
                            elseif algorithm==5
                                HR_mean=ecg_interp(t,xx,...
                                    tt,'spline');
                            end
                    end
                    HR=[HR; HR_mean];
                    BSL=[BSL HRbsl];

                    if length(analysis_lats)>1 % average only when more than
                        % one epochs
                        HR_mean=mean(HR);
                    else
                        HR_mean=HR;
                    end
                    HRbsl=mean(BSL);
                end                

                % save results structure
                DATA.PCR(i).(SelectedConds{j}).BSL=HRbsl;
                DATA.PCR(i).(SelectedConds{j}).HR=HR_mean;
                DATA.GUI.PCRepochs(i).(SelectedConds{j})=k;
            end
        end

        % create grand average and data matrix structure
        datamatrix=[];
        for j=1:DATA.GUI.PCRconditionsNum
            baseline=[];
            hr=[];
            for i=1:subs
                baseline=[baseline DATA.PCR(1,i).(SelectedConds{j}).BSL];
                hr=[hr; DATA.PCR(1,i).(SelectedConds{j}).HR];
            end
            dmatrix=[baseline; hr']; % data matrix for one condition
            datamatrix=[datamatrix dmatrix]; % data matrix for all conditions
            if subs>1
                hr=mean(hr);
            end
            baseline=mean(baseline);
            DATA.PCR_GrandAverage.(SelectedConds{j}).BSL=baseline;
            DATA.PCR_GrandAverage.(SelectedConds{j}).HR=hr;
        end
        DATA.GUI.PCRdatamatrix=datamatrix;

        % update plot
        plot_PCR(axes_PCR,[]);
        update_subjectname_PCR(edit_subjectname_PCR,[]);

        % update information
        update_info_PCR(txt_info_PCR,[]);
    end

%% ---- HRV
%% -------- Epoch Data
    function HRV_conditions_callback(src,eventdata)
        % error when no imported event types are found
        if  isempty(DATA.Conditions)
            errordlg('No conditions found','Epoch Data')
            return
        end

        % GUI
        HRV_Conditions_Figure = figure(...
            'MenuBar','none',...
            'Units','characters',...
            'Color',[0.87843137254902 0.874509803921569 0.890196078431373],...
            'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
            'Name','Select Conditions',...
            'NumberTitle','off',...
            'Position',[100 30 50 15],...
            'Resize','Off');

        list_conditions_HRV = uicontrol(...
            HRV_Conditions_Figure,...
            'Style','listbox',...
            'String',DATA.Conditions,...
            'max',2,...
            'Units','normalize',...
            'Position',[.15 .2 .7 .7],...
            'BackgroundColor','w',...
            'ForegroundColor','k',...
            'Value',1);

        push_ok_conditions_HRV = uicontrol(...
            HRV_Conditions_Figure,...
            'Style','pushbutton',...
            'String','ok',...
            'Units','normalize',...
            'Position',[.25 .03 .2 .1],...
            'callback', @select_conditions_HRV_callback);

        push_cancel_conditions_HRV = uicontrol(...
            HRV_Conditions_Figure,...
            'Style','pushbutton',...
            'String','Cancel',...
            'Units','normalize',...
            'Position',[.55 .03 .2 .1],...
            'callback', @cancel_conditions_HRV_callback);

        % Callbacks
        function select_conditions_HRV_callback(src,eventdata)
            % get condition indexes
            ind=get(list_conditions_HRV,'Value');

            % error message
            if isempty (ind)
                errordlg('No conditions selected','Select Conditions')
                return
            end

            % clear previous results
            DATA.GUI.HRVconditions=[];
            DATA.GUI.HRVconditionsNum=[];

            % update DATA structure
            DATA.GUI.HRVconditionsNum=length(ind);
            DATA.GUI.HRVconditions=DATA.Conditions(ind);

            % update information
            DATA.GUI.HRV2plot='Epochs';
            update_info1_HRV(txt_info1_HRV,[]);

            delete(HRV_Conditions_Figure)
            return
        end

        function cancel_conditions_HRV_callback(src,eventdata)
            delete(HRV_Conditions_Figure)
        end
    end

    function epochdata_callback(src,eventdata)
        % get variables
        epochstart=str2num(get(edit_epochstart_HRV,'String'));
        epochend=str2num(get(edit_epochend_HRV,'String'));
        subs=DATA.GUI.SubjectsNum;
        SelectedConds=DATA.GUI.HRVconditions;

        % pass variables to DATA structure
        DATA.GUI.HRV_EpochStart=mat2str(epochstart);
        DATA.GUI.HRV_EpochEnd=mat2str(epochend);

        % error messages
        if isempty (epochstart)
            errordlg('Define epoch limits','HRV')
            return
        end
        if isempty (epochend)
            errordlg('Define epoch limits','HRV')
            return
        end
        if isempty(DATA.GUI.HRVconditions)
            errordlg ('Select conditions first','HRV')
            return
        end

        % clear previous results
        DATA.Epochs=[];

        % use the same eventfile (first subject) for all subjects
        if DATA.GUI.SubjectsNum>1 && ...
                DATA.GUI.Eventfiles<DATA.GUI.SubjectsNum && ...
                isempty(DATA.GUI.UseCommonEventfile);
            quest = questdlg(['Do you want to use the first event file'...
                ' for all subjects?'],'HRV');
            switch quest
                case 'Yes'
                    if isempty(DATA.Events(1).Conditions)
                        errordlg('Load event file for first subject',...
                            'PCR');
                        return
                    end
                    for i=2:DATA.GUI.SubjectsNum
                        DATA.Events(i).Conditions=...
                            DATA.Events(1).Conditions;
                        DATA.Events(i).Latencies=...
                            DATA.Events(1).Latencies;
                    end
                    DATA.GUI.UseCommonEventfile=1;
                    DATA.GUI.Eventfiles=1;
                case 'No'
                    return
                case 'Cancel'
                    return
            end
        end

        for i=1:subs % get subject data
            % get necessary variables
            data=DATA.Events(i);
            if subs==1
                Rdata=DATA.R_events;
            else
                Rdata=DATA.R_events{i};
            end
            lats=data.Latencies;
            conds=data.Conditions;

            for j=1:DATA.GUI.HRVconditionsNum % get condition
                index=strcmp(SelectedConds(j),conds);
                lat=lats(index);

                if length(lat)>1
                    errordlg (['HRV conditions should not have more ' ...
                        'than 1 epoch'],'HRV');
                    DATA.GUI.HRVconditions=[];
                    DATA.GUI.HRVconditionsNum=[];
                    return
                end

                % find data within analysis window
                ind=(lat+epochstart<Rdata & Rdata<lat+epochend);

                % create structure
                [hp,t]=ecg_hp(Rdata(ind),'instantaneous');
                DATA.Epochs(i).(SelectedConds{j}).hp=hp;
                DATA.Epochs(i).(SelectedConds{j}).thp=t;
            end
        end

        % update GUI structure
        DATA.GUI.Subject2plot_HRV=[];
        DATA.GUI.Cond2plot_HRV=[];
        DATA.GUI.HRV2plot='Epochs';

        % update plot
        plot_HRV(axes_HRV,[]);
        update_subjectname_HRV(edit_subjectname_HRV,[]);
        update_condname_HRV(edit_condname_HRV,[]);

        % update information
        update_info1_HRV(txt_info1_HRV,[]);
    end

%% -------- Spectral Analysis
    function spectral_callback(src,eventdata)
        % get variables
        samplerate=get(pop_samplerate,'Value');
        points=get(pop_points,'Value');
        detrendmethod=get(pop_detrendmethod,'Value');
        Filter=get(pop_Filter,'Value');
        algorithm=get(pop_algorithm_spectral,'Value');
        ARorder=str2num(get(edit_ARorder,'String'));
        scale=get(pop_scale,'Value');
        subs=DATA.GUI.SubjectsNum;
        SelectedConds=DATA.GUI.HRVconditions;

        switch samplerate
            case 1
                fs=2;
                DATA.GUI.Spectral_SampleRate='2';
            case 2
                fs=4;
                DATA.GUI.Spectral_SampleRate='4';
        end

        switch scale
            case 1
                DATA.GUI.Spectral_Scale='normal';
            case 2
                DATA.GUI.Spectral_Scale='log';
            case 3
                DATA.GUI.Spectral_Scale='semilog';
        end

        ARorder=round(ARorder);
        if ARorder>30
            errordlg('Choose a smaller model order','Spectral Analysis')
            return
        end
        DATA.GUI.Spectral_ARorder=ARorder';

        % error messages
        if isempty (DATA.Epochs)
            errordlg('Define epochs first','Spectral Analysis')
            return
        end

        % clear previous results
        DATA.HRV.Spectral=[];

        for i=1:subs % get subject data
            % get necessary variables
            data=DATA.Epochs(i);

            for j=1:DATA.GUI.HRVconditionsNum % get condition
                hp=data.(SelectedConds{j}).hp;

                % get stats
                avIBI=mean(hp*1000);
                maxIBI=max(hp*1000);
                minIBI=min(hp*1000);
                RMS=RMSSD(hp*1000);
                SDNN=std(hp*1000);

                hp=hp*1000;
                thp=data.(SelectedConds{j}).thp;
           
                % spline interpolation
                auxtime = thp(1):1/fs:thp(end);
                hp2=(spline(thp,hp,auxtime))';
             
                % detrend hp
                switch detrendmethod
                    case 1
                        hp3=detrend(hp2,'constant');
                        DATA.GUI.Spectral_DetrendMethod='constant';
                    case 2
                        hp3=detrend(hp2,'linear');
                        DATA.GUI.Spectral_DetrendMethod='linear';
                end

                % Filter method
                switch Filter
                    case 1
                        wdw=hanning(length(hp3));
                        DATA.GUI.Spectral_Filter='hanning';
                    case 2
                        wdw=hamming(length(hp3));
                        DATA.GUI.Spectral_Filter='hamming';
                    case 3
                        wdw=blackman(length(hp3));
                        DATA.GUI.Spectral_Filter='blackman';
                    case 4
                        wdw=bartlett(length(hp3));
                        DATA.GUI.Spectral_Filter='bartlett';
                end
        
                hp4=hp3.*wdw;
                
                % Calculate FFT points
                switch points
                    case 1
                        N=512;
                        DATA.GUI.Spectral_Points='512';
                    case 2
                        N=1024;
                        DATA.GUI.Spectral_Points='1024';
                    case 3
                        N=2^nextpow2(length(hp));
                        DATA.GUI.Spectral_Points=[int2str(N) ' (auto)'];
                end

                switch algorithm
                    case 1 % FFT
                        cw = (1/N) * sum(wdw.^2); % Coefficient to remove window effect
                        PSD=(abs(fft(hp4,N)).^2)/(N*fs*cw);
                        F=(0:fs/N:fs-fs/N)';
                        PSD=2*PSD(1:ceil(length(PSD)/2));
                        F=F(1:ceil(length(F)/2));
                        DATA.GUI.Spectral_Algorithm='FFT';

                    case 2 % AR model
                        [A, variance] = arburg(hp4,ARorder);
                        [H,F] = freqz(sqrt(variance),A,N/2,fs);
                        cw = (1/length(hp4)) * sum(wdw.^2); % Coefficient to remove the window effect
                        PSD= 2*(abs(H).^2)/(fs*cw);
                        DATA.GUI.Spectral_Algorithm='AR model';
                end

                % get power in different bands
                hf=spPCRower(F,PSD,'hf');
                lf=spPCRower(F,PSD,'lf');
                vlf=spPCRower(F,PSD,'vlf');
                nhf=spPCRower(F,PSD,'nhf');
                nlf=spPCRower(F,PSD,'nlf');
                                 
                % save results structure
                DATA.HRV.Spectral(i).(SelectedConds{j}).PSD=PSD;
                DATA.HRV.Spectral(i).(SelectedConds{j}).F=F;
                DATA.HRV.Spectral(i).(SelectedConds{j}).HF=hf;
                DATA.HRV.Spectral(i).(SelectedConds{j}).LF=lf;
                DATA.HRV.Spectral(i).(SelectedConds{j}).VLF=vlf;
                DATA.HRV.Spectral(i).(SelectedConds{j}).NHF=nhf;
                DATA.HRV.Spectral(i).(SelectedConds{j}).NLF=nlf;
                DATA.HRV.Spectral(i).(SelectedConds{j}).avIBI=avIBI;
                DATA.HRV.Spectral(i).(SelectedConds{j}).maxIBI=maxIBI;
                DATA.HRV.Spectral(i).(SelectedConds{j}).minIBI=minIBI;
                DATA.HRV.Spectral(i).(SelectedConds{j}).RMSSD=RMS;
                DATA.HRV.Spectral(i).(SelectedConds{j}).SDNN=SDNN;
            end
        end

        % update GUI structure
        DATA.GUI.HRV2plot='Spectral';

        % update plot
        plot_HRV(axes_HRV,[]);
        update_subjectname_HRV(edit_subjectname_HRV,[]);
        update_condname_HRV(edit_condname_HRV,[]);

        % update information
        update_info1_HRV(txt_info1_HRV,[]);
    end

%% -------- DFA
    function DFA_callback(src,eventdata)
        % get variables
        minbox=str2num(get(edit_minbox,'String'));
        maxbox=str2num(get(edit_maxbox,'String'));
        sliding=get(check_slidingwins,'Value');
        subs=DATA.GUI.SubjectsNum;
        SelectedConds=DATA.GUI.HRVconditions;

        % error messages
        if isempty (DATA.Epochs)
            errordlg('Define epochs first','DFA')
            return
        end

        % box size restrictions
        if ~isint(minbox) || ~isint(maxbox)
            errordlg('Box sizes must be integers','DFA')
            return
        end
        
        if minbox<4
            errordlg('Minimum box size is 4','DFA')
            return
        end
             
        % clear previous results
        DATA.HRV.DFA=[];

        for i=1:subs % get subject data
            % get necessary variables
            data=DATA.Epochs(i);

            for j=1:DATA.GUI.HRVconditionsNum % get condition
                hp=data.(SelectedConds{j}).hp;

                % get stats
                avIBI=mean(hp*1000);
                maxIBI=max(hp*1000);
                minIBI=min(hp*1000);
                RMS=RMSSD(hp*1000);
                SDNN=std(hp*1000);

                switch sliding
                    case 1 % Use Sliding Windows
                        [a,n,Fn]=DFA(hp,minbox,maxbox,'s',0);
                        DATA.GUI.DFA_sliding='Yes';
                    case 0 % Non sliding windows
                        [a,n,Fn]=DFA(hp,minbox,maxbox,0,0);
                        DATA.GUI.DFA_sliding='No';
                end

                % save results structure
                DATA.HRV.DFA(i).(SelectedConds{j}).a=a;
                DATA.HRV.DFA(i).(SelectedConds{j}).n=n;
                DATA.HRV.DFA(i).(SelectedConds{j}).Fn=Fn;
                DATA.HRV.DFA(i).(SelectedConds{j}).avIBI=avIBI;
                DATA.HRV.DFA(i).(SelectedConds{j}).maxIBI=maxIBI;
                DATA.HRV.DFA(i).(SelectedConds{j}).minIBI=minIBI;
                DATA.HRV.DFA(i).(SelectedConds{j}).RMSSD=RMS;
                DATA.HRV.DFA(i).(SelectedConds{j}).SDNN=SDNN;
            end
        end

        % update GUI structure
        DATA.GUI.HRV2plot='DFA';
        DATA.GUI.DFA_minbox=mat2str(minbox);
        DATA.GUI.DFA_maxbox=mat2str(maxbox);

        % update plot
        plot_HRV(axes_HRV,[]);
        update_subjectname_HRV(edit_subjectname_HRV,[]);
        update_condname_HRV(edit_condname_HRV,[]);

        % update information
        update_info1_HRV(txt_info1_HRV,[]);
    end

%% Ploting Callbacks
%% ---- IBIs
    function plot_IBIs(src,eventdata)
        % get variables
        data=DATA.IBIs;
        sub=DATA.GUI.Subject2plot_IBIs;
        subjects=DATA.Subjects;

        % set axes
        axes(src)
        title('Interbeat Intervals','Fontsize',8)
        xlabel('Beats','Fontsize',8)
        ylabel('Time (sec)','Fontsize',8)

        % return when no data exists
        if isempty(data)
            return
        end

        % plot
        if isempty(sub) || sub==0 % plot all subjects
            s=DATA.GUI.SubjectsNum;
            if s>1 % more than 1 subject
                for i=1:s
                    plot(data{1,i})
                    hold all
                end
                set(src,'NextPlot','replacechildren')
            else % 1 subject
                plot(data)
            end
        elseif sub>0 % plot individual subjects
            s=size(data,2);
            if s>1
                plot(data{1,sub}) % more than 1 subject
            else
                plot(data) % 1 subject
            end
        end

        %update
        update_subjectname_IBIs(edit_subjectname_IBIs,[]);
    end

%% ---- PCR
    function plot_PCR(src,eventdata)
        % get variables
        data=DATA.PCR;
        sub=DATA.GUI.Subject2plot_PCR;
        check=get(check_removebsl_PCR,'Value');
        window=str2num(get(edit_timewindow_PCR,'String'));
        algorithm=get(pop_algorithm_PCR,'Value');
        unit=DATA.GUI.PCR_Unit;

        % set axes
        axes(src)
        title('Phasic Cardiac Responses','Fontsize',8)
        xlabel('Time (sec)','Fontsize',8)
        ylabel(['Cardiac Response (' unit ')'],'Fontsize',8)
       
        % return when no data exists
        if isempty(data)
            return
        end

        % plot
        if isempty(sub) || sub==0 % plot grand average
            data=DATA.PCR_GrandAverage;
            for i=1:DATA.GUI.PCRconditionsNum % get condition
                cond=DATA.GUI.PCRconditions{i};
                l=length(data.(cond).HR);

                % create axes
                yy=[data.(cond).BSL data.(cond).HR];
                switch algorithm
                    case 2
                        xx=[0 2 5 9 14 20 27 34 44 57 70]; % CDR time line
                    case 1
                        xx=[0 (1:l)];xx=xx.*window;
                    case {3,4,5}
                        yy=data.(cond).HR;
                        xx=[0 (1:l-1)];xx=xx.*window;
                end

                % remove baseline
                if check==1
                    yy=yy-data.(cond).BSL;
                end

                % plot
                plot(xx,yy)
                hold all
            end
            set(src,'NextPlot','replacechildren')

        elseif sub>0 % plot individual subjects
            data=DATA.PCR;
            s=size(data,2);
            for i=1:DATA.GUI.PCRconditionsNum % get condition
                cond=DATA.GUI.PCRconditions{i};
                l=length(data(1).(cond).HR);
                % create axes
                if s>1
                    yy=[data(1,sub).(cond).BSL data(1,sub).(cond).HR];
                else
                    yy=[data.(cond).BSL data.(cond).HR];
                end
                if algorithm==2
                    xx=[0 2 5 9 14 20 27 34 44 57 70]; % CDR time line
                else
                    xx=[0 (1:l)];xx=xx.*window;
                end

                % remove baseline
                if check==1
                    yy=yy-yy(1);
                end
                % plot
                plot(xx,yy)
                hold all
            end
            set(src,'NextPlot','replacechildren')
        end

        %update
        update_subjectname_PCR(edit_subjectname_PCR,[]);
    end

%% ---- HRV
    function plot_HRV(src,eventdata)
        % get variables
        sub=DATA.GUI.Subject2plot_HRV;
        graph=DATA.GUI.HRV2plot;
        cond=DATA.GUI.Cond2plot_HRV;
        conditions=DATA.GUI.HRVconditions;
        scale=DATA.GUI.Spectral_Scale;
        axes(src)

        % return when no data is found
        if isempty(graph)
            % set axes
            cla
            title('Heart Rate Variability','Fontsize',8)
            return
        end

        if isempty(sub)
            sub=1;
        end
        if isempty(cond)
            cond=1;
        end
        condname=conditions{cond};

        switch graph
            case 'Epochs'
                data=DATA.Epochs;

                % create axes
                yy=data(sub).(condname).hp;

                % plot
                plot(yy)

                % set axes
                title('HRV Epochs','Fontsize',8)
                ylabel('Time (sec)','Fontsize',8)
                xlabel('Beats','Fontsize',8)

            case 'Spectral'
                data=DATA.HRV.Spectral;

                % create axes
                yy=data(sub).(condname).PSD;
                xx=data(sub).(condname).F;

                % plot
                switch scale
                    case 'normal'
                        plot(xx,yy)
                    case 'log'
                        loglog(xx,yy)
                    case 'semilog'
                        semilogy(xx,yy)
                end

                % set axes
                title('Spectral Graph','Fontsize',8)
                xlabel('Frequency (Hz)','Fontsize',8)
                ylabel('PSD (ms^2/Hz)','Fontsize',8)

            case 'DFA'
                data=DATA.HRV.DFA;

                % create axes
                yy=data(sub).(condname).Fn;
                xx=data(sub).(condname).n;

                %plot
                plot(log10(xx),log10(yy))

                % create axes
                title('Detrended Fluctuation Analysis','Fontsize',8)
                xlabel('log(n)','Fontsize',8)
                ylabel('log(Fn)','Fontsize',8)
        end

        %update
        DATA.GUI.Cond2plot_HRV=cond;
        update_subjectname_HRV(edit_subjectname_HRV,[]);
        update_condname_HRV(edit_condname_HRV,[]);
    end

%% Update Graph Callbacks
%% ---- IBIs
    function dwnsub_IBIs(src,eventdata)
        % get data
        sub=DATA.GUI.Subject2plot_IBIs;

        % change subject to plot
        if ~isempty(sub) && sub>0
            sub=sub-1;
        end
        DATA.GUI.Subject2plot_IBIs=sub;

        % update plot
        plot_IBIs(axes_IBIs,[]);
        update_subjectname_IBIs(edit_subjectname_IBIs,[]);
    end

    function upsub_IBIs(src,eventdata)
        % get data
        sub=DATA.GUI.Subject2plot_IBIs;

        % change subject to plot
        if isempty(sub)
            sub=1;
        elseif sub<DATA.GUI.SubjectsNum
            sub=sub+1;
        end

        DATA.GUI.Subject2plot_IBIs=sub;

        % update plot
        plot_IBIs(axes_IBIs,[]);
        update_subjectname_IBIs(edit_subjectname_IBIs,[]);
    end

    function update_subjectname_IBIs(src,eventdata)
        % get variables
        subjects=DATA.Subjects;
        sub=DATA.GUI.Subject2plot_IBIs;
        subjectsNum=DATA.GUI.SubjectsNum;

        % update
        if isempty(subjects) % return when no data
            return
        end
        if isempty(sub) || sub==0 % plot all subjects
            if subjectsNum>1
                set (src,'String','all')
            else
                set (src,'String',subjects)
            end
        else
            if subjectsNum>1 % plot individual subjects
                set (src,'String',subjects{sub})
            else
                set (src,'String',subjects)
            end
        end
    end

    function edit_subjectname_IBIs_callback(src,eventdata)
        % get variables
        subjectsNum=DATA.GUI.SubjectsNum;
        subjects=DATA.Subjects;
        subjectname=get(edit_subjectname_IBIs,'String');

        % find subject to plot
        comp=strcmp(subjects,subjectname);
        sub=find(comp==1);
        if sub==0
            sub=[];
        end

        % update
        DATA.GUI.Subject2plot_IBIs=sub;
        plot_IBIs(axes_IBIs,[]);
    end

    function update_info_IBIs(src,eventdata)
        set(src,'String',{...
            ['Subjects: ' int2str(DATA.GUI.SubjectsNum)];...
            ['Eventfiles: ' int2str(DATA.GUI.Eventfiles)];...
            ['Conditions: ' int2str(DATA.GUI.ConditionsNum)]});
    end

%% ---- PCR
    function dwnsub_PCR(src,eventdata)
        % get data
        sub=DATA.GUI.Subject2plot_PCR;

        % change subject to plot
        if ~isempty(sub) && sub>0
            sub=sub-1;
        end
        DATA.GUI.Subject2plot_PCR=sub;

        % update plot
        plot_PCR(axes_PCR,[]);
        update_subjectname_PCR(edit_subjectname_PCR,[]);
    end

    function upsub_PCR(src,eventdata)
        % get data
        sub=DATA.GUI.Subject2plot_PCR;

        % change subject to plot
        if isempty(sub)
            sub=1;
        elseif sub<DATA.GUI.SubjectsNum
            sub=sub+1;
        end

        DATA.GUI.Subject2plot_PCR=sub;

        % update plot
        plot_PCR(axes_PCR,[]);
        update_subjectname_PCR(edit_subjectname_PCR,[]);
    end

    function update_subjectname_PCR(src,eventdata)
        % get variables
        subjects=DATA.Subjects;
        sub=DATA.GUI.Subject2plot_PCR;
        subjectsNum=DATA.GUI.SubjectsNum;

        % update
        if isempty(subjects) % return when no data
            return
        end

        if isempty(DATA.PCR)
            set (src,'String',[])
            return
        end
        if isempty(sub) || sub==0 % plot all subjects
            if subjectsNum>1
                set (src,'String','all')
            else
                set (src,'String',subjects)
            end
        else
            if subjectsNum>1 % plot individual subjects
                set (src,'String',subjects{sub})
            else
                set (src,'String',subjects)
            end
        end

    end

    function edit_subjectname_PCR_callback(src,eventdata)
        % get variables
        subjectsNum=DATA.GUI.SubjectsNum;
        subjects=DATA.Subjects;
        subjectname=get(edit_subjectname_PCR,'String');

        % find subject to plot
        comp=strcmp(subjects,subjectname);
        sub=find(comp==1);
        if sub==0
            sub=[];
        end

        % update
        DATA.GUI.Subject2plot_PCR=sub;
        plot_PCR(axes_PCR,[]);
    end

    function update_info_PCR(src,eventdata)
        set(src,'String',{...
            ['Conditions: ' int2str(DATA.GUI.PCRconditionsNum)];...
            ['Epoch Start: ' DATA.GUI.PCR_EpochStart];...
            ['Epoch End: ' DATA.GUI.PCR_EpochEnd];...
            ['Algorithm: ' DATA.GUI.PCR_Algorithm];...
            ['Time Window: ' DATA.GUI.PCR_TimeWindow]});
    end

%% ---- HRV
    function dwnsub_HRV(src,eventdata)
        % get data
        sub=DATA.GUI.Subject2plot_HRV;

        % change subject to plot
        if isempty(sub)
            sub=1;
        end
        if sub>1
            sub=sub-1;
        end
        DATA.GUI.Subject2plot_HRV=sub;

        % update
        plot_HRV(axes_HRV,[]);
        update_subjectname_HRV(edit_subjectname_HRV,[]);
        update_info1_HRV(txt_info1_HRV,[])
    end

    function upsub_HRV(src,eventdata)
        % get data
        sub=DATA.GUI.Subject2plot_HRV;

        % change subject to plot
        if isempty(sub)
            sub=1;
        end
        if sub<DATA.GUI.SubjectsNum
            sub=sub+1;
        end
        DATA.GUI.Subject2plot_HRV=sub;

        % update
        plot_HRV(axes_HRV,[]);
        update_subjectname_HRV(edit_subjectname_HRV,[]);
        update_info1_HRV(txt_info1_HRV,[])
    end

    function update_subjectname_HRV(src,eventdata)
        % get variables
        subjects=DATA.Subjects;
        sub=DATA.GUI.Subject2plot_HRV;
        subjectsNum=DATA.GUI.SubjectsNum;

        % update
        if isempty(subjects) % return when no data
            return
        end

        if isempty(DATA.Epochs)
            set (src,'String',[])
            return
        end
        if isempty(sub)
            sub=1;
        end
        if subjectsNum>1
            set (src,'String',subjects{sub})
        else
            set (src,'String',subjects)
        end
    end

    function edit_subjectname_HRV_callback(src,eventdata)
        % get variables
        subjectsNum=DATA.GUI.SubjectsNum;
        subjects=DATA.Subjects;
        subjectname=get(edit_subjectname_HRV,'String');

        % find subject to plot
        comp=strcmp(subjects,subjectname);
        sub=find(comp==1);

        % update
        DATA.GUI.Subject2plot_HRV=sub;
        plot_HRV(axes_HRV,[]);
    end

    function dwncond_HRV(src,eventdata)
        % get data
        cond=DATA.GUI.Cond2plot_HRV;

        % change condition to plot
        if isempty(cond)
            cond=1;
        end
        if cond>1
            cond=cond-1;
        end
        DATA.GUI.Cond2plot_HRV=cond;

        % update
        plot_HRV(axes_HRV,[]);
        update_condname_HRV(edit_condname_HRV,[]);
        update_info1_HRV(txt_info1_HRV,[])
    end

    function upcond_HRV(src,eventdata)
        % get data
        cond=DATA.GUI.Cond2plot_HRV;

        % change condition to plot
        if isempty(cond)
            cond=1;
        end
        if cond<DATA.GUI.HRVconditionsNum
            cond=cond+1;
        end
        DATA.GUI.Cond2plot_HRV=cond;

        % update
        plot_HRV(axes_HRV,[]);
        update_condname_HRV(edit_condname_HRV,[]);
        update_info1_HRV(txt_info1_HRV,[])
    end

    function update_condname_HRV(src,eventdata)
        % get variables
        subjects=DATA.Subjects;
        cond=DATA.GUI.Cond2plot_HRV;
        conditions=DATA.GUI.HRVconditions;
        condNum=DATA.GUI.HRVconditionsNum;

        % update
        if isempty(subjects) % return when no data
            return
        end
        if isempty(cond)
            cond=1;
        end
        if condNum>1 % plot individual conditions
            set (src,'String',conditions{cond})
        else
            set (src,'String',conditions)
        end
    end

    function edit_condname_HRV_callback(src,eventdata)
        % get variables
        condNum=DATA.GUI.HRVconditionsNum;
        conditions=DATA.GUI.HRVconditions;
        condname=get(edit_condname_HRV,'String');

        % find conditions to plot
        comp=strcmp(conditions,condname);
        cond=find(comp==1);
        if cond==0
            cond=[];
        end

        % update
        DATA.GUI.Cond2plot_HRV=cond;
        plot_HRV(axes_HRV,[]);
    end

    function update_info1_HRV(src,eventdata)
        format short
        % get variables
        sub=DATA.GUI.Subject2plot_HRV;
        if isempty(sub)
            sub=1;
        end
        cond2plot=DATA.GUI.Cond2plot_HRV;
        conditions=DATA.GUI.HRVconditions;
        graph=DATA.GUI.HRV2plot;
        conds=DATA.GUI.HRVconditionsNum;
        if isempty(conds)
            conds='';
        else
            conds=mat2str(DATA.GUI.HRVconditionsNum);
        end
        if isempty(graph)
            graph='Epochs';
        end

        switch graph
            case 'Epochs' % epochs info
                set(src,'String',{...
                    ['Conditions: ' conds];...
                    ['Epoch Start: ' DATA.GUI.HRV_EpochStart];...
                    ['Epoch End: ' DATA.GUI.HRV_EpochEnd]});

            case 'Spectral' % spectral info
                cond=conditions{cond2plot};
                data=DATA.HRV.Spectral(sub).(cond);
                HF=sprintf('%0.3f',data.HF);
                LF=sprintf('%0.3f',data.LF);
                points=DATA.GUI.Spectral_Points;
                cut=find(points=='(');
                if ~isempty(cut)
                    points=points(1:cut-1);
                end
                set(src,'String',{...
                    ['Conditions: ' mat2str(DATA.GUI.HRVconditionsNum)];...
                    ['Epoch Start: ' DATA.GUI.HRV_EpochStart];...
                    ['Epoch End: ' DATA.GUI.HRV_EpochEnd];...
                    ['Points: ' points];...
                    ['HF: ' HF];...
                    ['LF: ' LF]});
                update_info2_HRV(txt_info2_HRV,[]);

            case 'DFA' % DFA info
                cond=conditions{cond2plot};
                data=DATA.HRV.DFA(sub).(cond);
                a=sprintf('%0.3f',data.a);
                set(src,'String',{...
                    ['Conditions: ' mat2str(DATA.GUI.HRVconditionsNum)];...
                    ['Epoch Start: ' DATA.GUI.HRV_EpochStart];...
                    ['Epoch End: ' DATA.GUI.HRV_EpochEnd];...
                    ['alpha: ' a]});
                update_info2_HRV(txt_info2_HRV,[]);
        end
    end

    function update_info2_HRV(src,eventdata)
        % get variables
        sub=DATA.GUI.Subject2plot_HRV;
        if isempty(sub)
            sub=1;
        end
        cond2plot=DATA.GUI.Cond2plot_HRV;
        conditions=DATA.GUI.HRVconditions;
        graph=DATA.GUI.HRV2plot;

        switch graph
            case 'Spectral'
                cond=conditions{cond2plot};
                data=DATA.HRV.Spectral(sub).(cond);
                avIBI=sprintf('%0.2f',data.avIBI);
                maxIBI=sprintf('%0.2f',data.maxIBI);
                minIBI=sprintf('%0.2f',data.minIBI);
                RMSSD=sprintf('%0.2f',data.RMSSD);
                SDNN=sprintf('%0.2f',data.SDNN);
                set(src,'String',{...
                    ['mean IBI: ' avIBI];...
                    ['max IBI: ' maxIBI];...
                    ['min IBI: ' minIBI];...
                    ['RMSSD: ' RMSSD];...
                    ['SDNN: ' SDNN]});

            case 'DFA'
                cond=conditions{cond2plot};
                data=DATA.HRV.DFA(sub).(cond);
                avIBI=sprintf('%0.2f',data.avIBI);
                maxIBI=sprintf('%0.2f',data.maxIBI);
                minIBI=sprintf('%0.2f',data.minIBI);
                RMSSD=sprintf('%0.2f',data.RMSSD);
                SDNN=sprintf('%0.2f',data.SDNN);
                set(src,'String',{...
                    ['mean IBI: ' avIBI];...
                    ['max IBI: ' maxIBI];...
                    ['min IBI: ' minIBI];...
                    ['RMSSD: ' RMSSD];...
                    ['SDNN: ' SDNN]});
        end
    end

%% Button Down Callbacks
%% ---- IBIs
    function buttondown_IBIs(src,eventdata)
        % get variables
        subjects=DATA.Subjects;
        sub=DATA.GUI.Subject2plot_IBIs;

        % draw figure and axes
        popfigure=figure(...
            'Name','KARDIA - Interbeat Intervals',...
            'NumberTitle','off');
        axes_popfigure = axes(...
            'Parent',popfigure,...
            'CameraPosition',[0.5 0.5 9.16025403784439],...
            'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
            'Color',get(0,'defaultaxesColor'),...
            'ColorOrder',get(0,'defaultaxesColorOrder'),...
            'FontSize',7,...
            'LooseInset',[0.13569492144684 0.125485436893204 0.0991616733649981 0.0855582524271844],...
            'XColor',get(0,'defaultaxesXColor'),...
            'YColor',get(0,'defaultaxesYColor'),...
            'YLim',get(0,'defaultaxesYLim'),...
            'XLimMode','auto',...
            'YLimMode','auto',...
            'ZColor',get(0,'defaultaxesZColor'),...
            'UserData',[]);

        % plot
        plot_IBIs(axes_popfigure,[])
        title('Interbeat Intervals','Fontsize',10)
        xlabel('Beats','Fontsize',10)
        ylabel('Time (sec)','Fontsize',10)
        if isempty(sub)
            legend(subjects)
        elseif sub==0
            legend(subjects)
        else
            if DATA.GUI.SubjectsNum>1
                legend(subjects(sub))
            else
                legend(subjects)
            end
        end
    end

%% ---- PCR
    function buttondown_PCR(src,eventdata)
        % get variables
        subjects=DATA.Subjects;
        sub=DATA.GUI.Subject2plot_PCR;
        check=get(check_removebsl_PCR,'Value');
        unit=DATA.GUI.PCR_Unit;

        % draw figure and axes
        if isempty(sub) || sub==0 % subject to plot
            subject='all';
        else
            subject=subjects{sub};
        end
        popfigure=figure(...
            'Name',['KARDIA - Phasic Cardiac Responses - Subject: ',...
            subject],...
            'NumberTitle','off');
        axes_popfigure = axes(...
            'Parent',popfigure,...
            'CameraPosition',[0.5 0.5 9.16025403784439],...
            'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
            'Color',get(0,'defaultaxesColor'),...
            'ColorOrder',get(0,'defaultaxesColorOrder'),...
            'FontSize',7,...
            'LooseInset',[0.13569492144684 0.125485436893204 0.0991616733649981 0.0855582524271844],...
            'XColor',get(0,'defaultaxesXColor'),...
            'YColor',get(0,'defaultaxesYColor'),...
            'YLim',get(0,'defaultaxesYLim'),...
            'YLimMode','auto',...
            'XLimMode','auto',...
            'ZColor',get(0,'defaultaxesZColor'),...
            'UserData',[]);

        % plot
        plot_PCR(axes_popfigure,[])
        title('Phasic Cardiac Responses','Fontsize',10)
        xlabel('Time (sec)','Fontsize',10)
        ylabel(['Cardiac Response (' unit ')'],'Fontsize',10)        
        legend(DATA.GUI.PCRconditions)
    end

%% ---- HRV
    function buttondown_HRV(src,eventdata)
        % get variables
        subjects=DATA.Subjects;
        sub=DATA.GUI.Subject2plot_HRV;
        graph=DATA.GUI.HRV2plot;
        cond=DATA.GUI.Cond2plot_HRV;
        conditions=DATA.GUI.HRVconditions;

        % draw figure and axes
        condition=conditions{cond};
        popfigure=figure(...
            'Name',['KARDIA - HRV - Condition: ',...
            condition],...
            'NumberTitle','off');
        axes_popfigure = axes(...
            'Parent',popfigure,...
            'CameraPosition',[0.5 0.5 9.16025403784439],...
            'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
            'Color',get(0,'defaultaxesColor'),...
            'ColorOrder',get(0,'defaultaxesColorOrder'),...
            'FontSize',7,...
            'LooseInset',[0.13569492144684 0.125485436893204 0.0991616733649981 0.0855582524271844],...
            'XColor',get(0,'defaultaxesXColor'),...
            'YColor',get(0,'defaultaxesYColor'),...
            'YLim',get(0,'defaultaxesYLim'),...
            'YLimMode','auto',...
            'XLimMode','auto',...
            'ZColor',get(0,'defaultaxesZColor'),...
            'UserData',[]);

        if isempty(graph)
            return
        end

        % plot
        plot_HRV(axes_popfigure,[])

        switch graph
            case 'Epochs'
                title('IBI Epochs','Fontsize',10)
                ylabel('Time (sec)','Fontsize',10)
                xlabel('Beats','Fontsize',10)
            case 'Spectral'
                title('Spectral Graph','Fontsize',10)
                xlabel('Frequency (Hz)','Fontsize',10)
                ylabel('PSD (ms^2/Hz)','Fontsize',10)
        end

        if isempty(sub)
            legend(subjects)
        elseif sub==0
            legend(subjects)
        else
            if DATA.GUI.SubjectsNum>1
                legend(subjects(sub))
            else
                legend(subjects)
            end
        end
    end

%% Toolbar Callbacks
%% ---- Save Mat Variable
    function saveDATA_callback(src,evtdata)
        datafile = inputdlg('Filename','Save Data');
        if ~isempty(datafile)
            save ([datafile{1} '.mat'],'DATA')
        end
    end

%% ---- Export Data to Excel
    function excel_callback(src,evtdata)
        % set warning off
        warning off MATLAB:xlwrite:AddSheet
                
        % Add Java POI Libs to matlab javapath
        xlwrite_filepath=which('kardia.m');
        xlwrite_filepath=xlwrite_filepath(1:end-length('kardia.m'));
        xlwrite_filepath=[xlwrite_filepath 'Plugins/xlwrite/'];
       
        javaaddpath([xlwrite_filepath 'poi_library/poi-3.8-20120326.jar']);
        javaaddpath([xlwrite_filepath 'poi_library/poi-ooxml-3.8-20120326.jar']);
        javaaddpath([xlwrite_filepath 'poi_library/poi-ooxml-schemas-3.8-20120326.jar']);
        javaaddpath([xlwrite_filepath 'poi_library/xmlbeans-2.3.0.jar']);
        javaaddpath([xlwrite_filepath 'poi_library/dom4j-1.6.1.jar']);
        javaaddpath([xlwrite_filepath 'poi_library/stax-api-1.0.1.jar']);
        
        % create data structures for excel
        subNum=DATA.GUI.SubjectsNum;
        
        %% General sheet
        % subject names
        data=DATA.Subjects';
        if ischar(data)
            data=data';
        end
        SubjectsGeneral=[{'Subjects'}; data];        
        % conditions
        data=DATA.Conditions';
        allconditions=[{'Conditions'}; data];
        % eventfiles
        eventfiles=DATA.GUI.Eventfiles;
        eventfiles=[{'Event Files'}; eventfiles];
        
        %% PCR sheet
        % conditions
        PCRconds=DATA.GUI.PCRconditions;       
        % parameters
        epochstart=DATA.GUI.PCR_EpochStart;
        epochend=DATA.GUI.PCR_EpochEnd;
        algorithm=DATA.GUI.PCR_Algorithm;
        PCRunits=DATA.GUI.PCR_Unit;
        window=DATA.GUI.PCR_TimeWindow;
        PCRparameterNames={...
            'Parameters';...
            'Epoch Start';...
            'Epoch End';...
            'Algorithm';...
            'Unit';...
            'Time Window'};
        PCRparameters={...
            '';...
            epochstart;...
            epochend;...
            algorithm;...
            PCRunits;...
            window};
        % grand average
        data=DATA.PCR_GrandAverage;
        conds=PCRconds';
        condsnum=DATA.GUI.PCRconditionsNum;
        varnamesPCR={...
            'Subjects';...
            'Conditions';...
            'Baseline';...
            'Values'};        
        bsl_values=[];
        hr_values=[];
        for i=1:condsnum
            bsl_values=[bsl_values data.(conds{i}).BSL];
            hr_values=[hr_values data.(conds{i}).HR'];
        end
        
        % create empty matrixes if PCR is absent
        datamatrixPCR=DATA.GUI.PCRdatamatrix;
        count=1;
        for i=1:DATA.GUI.PCRconditionsNum % conditions header
            headerPCR(count:count+subNum-1)=PCRconds(i);
            count=count+subNum;
        end
        if isempty(DATA.GUI.PCRconditionsNum)
            headerPCR=[];
        end
        SubjectsPCR=DATA.Subjects;
        if subNum>1
            if isempty (DATA.GUI.PCRconditionsNum)                
                SubjectsPCR=repmat(SubjectsPCR,1,1);
            else
                SubjectsPCR=repmat(SubjectsPCR,1,DATA.GUI.PCRconditionsNum);
            end
        elseif subNum==1
            SubjectsPCR={SubjectsPCR};
        elseif isempty(subNum)
            SubjectsPCR={''};
        end

        %% HRV
        % parameters
        HRVparameterNames={...
            'Parameters';...
            'Epoch Start';...
            'Epoch End';...
            '';...
            'Spectral Analysis';...
            'Sample Rate';...
            'Points';...
            'Detrend Method';...
            'Filter';...
            'Algorithm';...
            'AR order';...
            '';...
            'DFA'
            'Minbox';...
            'Maxbox';...
            'Sliding Windows'};
        HRVparameters={...
            '';...
            DATA.GUI.HRV_EpochStart;...
            DATA.GUI.HRV_EpochEnd;...
            '';...
            '';...
            DATA.GUI.Spectral_SampleRate;...
            DATA.GUI.Spectral_Points;...
            DATA.GUI.Spectral_DetrendMethod;...
            DATA.GUI.Spectral_Filter;...
            DATA.GUI.Spectral_Algorithm;...
            DATA.GUI.Spectral_ARorder;...
            '';...
            '';...
            DATA.GUI.DFA_minbox;...
            DATA.GUI.DFA_maxbox;...
            DATA.GUI.DFA_sliding};
        
        % grand average
        HRVconds=DATA.GUI.HRVconditions;        
        count=1;
        for i=1:DATA.GUI.HRVconditionsNum % conditions header
            headerHRV(count:count+subNum-1)=HRVconds(i);
            count=count+subNum;
        end
        if isempty(DATA.GUI.HRVconditionsNum)
            headerHRV=[];
        end
        SubjectsHRV=DATA.Subjects;
        if subNum>1
            if isempty (DATA.GUI.HRVconditionsNum)
                SubjectsHRV=repmat(SubjectsHRV,1,1);
            else
                SubjectsHRV=repmat(SubjectsHRV,1,DATA.GUI.HRVconditionsNum);
            end
        elseif subNum==1
            SubjectsHRV={SubjectsHRV};
        elseif isempty(subNum)
            SubjectsHRV={''};
        end

        meanHF=[];
        meanLF=[];
        meanVLF=[];
        meanRMSSD=[];
        meanSDNN=[];
        meanavIBI=[];
        meanalpha=[];
        datamatrixHRV=[];
        for j=1:DATA.GUI.HRVconditionsNum
            HF=[];
            LF=[];
            VLF=[];
            RMSSD=[];
            SDNN=[];
            avIBI=[];
            alpha=[];
            for i=1:subNum
                if ~isempty(DATA.HRV.Spectral)
                    HF=[HF DATA.HRV.Spectral(1,i).(HRVconds{j}).HF];
                    LF=[LF DATA.HRV.Spectral(1,i).(HRVconds{j}).LF];
                    VLF=[VLF DATA.HRV.Spectral(1,i).(HRVconds{j}).VLF];
                    RMSSD=[RMSSD DATA.HRV.Spectral(1,i).(HRVconds{j}).RMSSD];
                    SDNN=[SDNN DATA.HRV.Spectral(1,i).(HRVconds{j}).SDNN];
                    avIBI=[avIBI DATA.HRV.Spectral(1,i).(HRVconds{j}).avIBI];
                end
                if ~isempty(DATA.HRV.DFA)
                    alpha=[alpha DATA.HRV.DFA(1,i).(HRVconds{j}).a];
                end
            end

            % all subjects
            matrix=[avIBI;SDNN;RMSSD;HF;LF;VLF;alpha];
            datamatrixHRV=[datamatrixHRV matrix];
            
            % grand average
            meanHF=[meanHF mean(HF)];
            meanLF=[meanLF mean(LF)];
            meanVLF=[meanVLF mean(VLF)];
            meanRMSSD=[meanRMSSD mean(RMSSD)];
            meanSDNN=[meanSDNN mean(SDNN)];
            meanavIBI=[meanavIBI mean(avIBI)];
            meanalpha=[meanalpha mean(alpha)];
        end
        DATA.GUI.HRVdatamatrix=datamatrixHRV;

        HRV_VariableNames={...
            'Subjects';...
            'Conditions';...
            'Average IBI';...
            'SDNN';...
            'RMSSD';...
            'HF';...
            'LF';...
            'VLF';...
            'alpha exponent'};

        HRV_Variables=[...
            meanavIBI;...
            meanSDNN;...
            meanRMSSD;...
            meanHF;...
            meanLF;...
            meanVLF;...
            meanalpha];
       
        % Write excel file
        datafile = inputdlg('Filename','Excel');
        if ~isempty(datafile)
            % check if file exists
            if exist([datafile{1} '.xls'],'file')
                quest = questdlg(['Excel file already exists. '...
                    'Do you want to overwrite?'],'Excel');
                switch quest
                    case 'No'
                        return
                    case 'Cancel'
                        return
                end
            end

            % General Sheet
            xlwrite([datafile{1} '.xls'],SubjectsGeneral,'General','A1');
            xlwrite([datafile{1} '.xls'],eventfiles,'General','B1');
            xlwrite([datafile{1} '.xls'],allconditions,'General','C1');

            % PCR Sheet
            if isempty(headerPCR)
                headerPCR={''};
            end
            if isempty(datamatrixPCR)
                datamatrixPCR={''};
            end
            xlwrite([datafile{1} '.xls'],PCRparameterNames,'PCR','A1');
            xlwrite([datafile{1} '.xls'],PCRparameters,'PCR','B1');
            xlwrite([datafile{1} '.xls'],headerPCR,'PCR','E2');
            xlwrite([datafile{1} '.xls'],SubjectsPCR,'PCR','E1');
            xlwrite([datafile{1} '.xls'],varnamesPCR,'PCR','D1');
            xlwrite([datafile{1} '.xls'],datamatrixPCR,'PCR','E3');

            % PCR Grand Average Sheet
            if isempty(PCRconds)
                PCRconds={''};
            end
            if isempty(bsl_values)
                bsl_values={''};
            end
            if isempty(hr_values)
                hr_values={''};
            end
            xlwrite([datafile{1} '.xls'],PCRparameterNames,'PCR Grand Average','A1');
            xlwrite([datafile{1} '.xls'],PCRparameters,'PCR Grand Average','B1');
            xlwrite([datafile{1} '.xls'],PCRconds,'PCR Grand Average','E1');
            xlwrite([datafile{1} '.xls'],bsl_values,'PCR Grand Average','E2');
            xlwrite([datafile{1} '.xls'],varnamesPCR(2:4,:),'PCR Grand Average','D1');
            xlwrite([datafile{1} '.xls'],hr_values,'PCR Grand Average','E3');

            % HRV Sheet
            if isempty(headerHRV)
                headerHRV={''};
            end
            if isempty(datamatrixHRV)
                datamatrixHRV={''};
            end
            xlwrite([datafile{1} '.xls'],HRVparameterNames,'HRV','A1');
            xlwrite([datafile{1} '.xls'],HRVparameters,'HRV','B1');
            xlwrite([datafile{1} '.xls'],HRV_VariableNames,'HRV','D1');
            xlwrite([datafile{1} '.xls'],SubjectsHRV,'HRV','E1');
            xlwrite([datafile{1} '.xls'],headerHRV,'HRV','E2');
            xlwrite([datafile{1} '.xls'],datamatrixHRV,'HRV','E3');            
                        
            % HRV Average Sheet
            if isempty(HRVconds)
                HRVconds={''};
            end
            if isempty(HRV_Variables)
                HRV_Variables={''};
            end
            xlwrite([datafile{1} '.xls'],HRVparameterNames,'HRV Average','A1');
            xlwrite([datafile{1} '.xls'],HRVparameters,'HRV Average','B1');
            xlwrite([datafile{1} '.xls'],HRV_VariableNames(2:end,:),'HRV Average','D1');
            xlwrite([datafile{1} '.xls'],HRVconds,'HRV Average','E1');
            xlwrite([datafile{1} '.xls'],HRV_Variables,'HRV Average','E2');
        end
    end

%% ---- User's Guide
    function tutorial_callback(src,evtdata)
        filepath=which('kardia.m');
        filepath=filepath(1:end-length('kardia.m'));
        filepath=[filepath 'Documentation/'];
        uiopen([filepath 'User''s Guide.pdf'],1);
    end

%% ---- About KARDIA
    function about_callback(src,evtdata)
        about_figure = figure(...
            'Units','characters',...
            'PaperUnits',get(0,'defaultfigurePaperUnits'),...
            'Color',[0.925490196078431 0.913725490196078 0.847058823529412],...
            'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
            'MenuBar','none',...
            'Name','About',...
            'NumberTitle','off',...
            'PaperPosition',get(0,'defaultfigurePaperPosition'),...
            'PaperSize',[20.98404194812 29.67743169791],...
            'PaperType',get(0,'defaultfigurePaperType'),...
            'Position',[90 20 109 30],...
            'Resize','off',...
            'HandleVisibility','callback',...
            'Tag','figure1',...
            'UserData',[]);

        h = uicontrol(...
            'Parent',about_figure,...
            'Units','characters',...
            'CData',[],...
            'Position',[5.2 1.46153846153846 97.4 26.0769230769231],...
            'String',{...
            'KARDIA: Matlab graphic user interface environment for the analysis';...
            'of Cardiac Interbeat Interval data. Developed for the Human Psychophysiology ';...
            'research group in the University of Granada in Spain. First released on ';...
            '11/2007 under GNU General Public License.';...
            blanks(0);...
            'Copyright (C) 2007 2008 Pandelis Perakakis';...
            blanks(0);...
            '    This program is free software: you can redistribute it and/or modify';...
            '    it under the terms of the GNU General Public License as published by';...
            '    the Free Software Foundation, either version 3 of the License, or';...
            '    (at your option) any later version.';...
            blanks(0);...
            '    This program is distributed in the hope that it will be useful,';...
            '    but WITHOUT ANY WARRANTY; without even the implied warranty of';...
            '    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the';...
            '    GNU General Public License for more details.';...
            blanks(0);...
            '    You should have received a copy of the GNU General Public License';...
            '    along with this program.  If not, see <http://www.gnu.org/licenses/>.';...
            blanks(0);...
            'To report bugs or for any other comments please contact: peraka@ugr.es ' },...
            'Style','text',...
            'Tag','text1',...
            'UserData',[]);
    end

%% ---------- AUXILARY FUNCTIONS -----------
%% ---- Clear Function
    function clearFcn
        DATA.Subjects=[];
        DATA.R_events=[];
        DATA.IBIs=[];
        DATA.Events=[];
        DATA.Conditions=[];
        DATA.Epochs=[];
        DATA.PCR=[];
        DATA.PCR_GrandAverage=[];
        DATA.HRV=[];
        DATA.HRV.Spectral=[];
        DATA.HRV.DFA=[];
        DATA.GUI.SubjectsNum=[];
        DATA.GUI.Subject2plot_IBIs=[];
        DATA.GUI.Subject2plot_PCR=[];
        DATA.GUI.Subject2plot_HRV=[];
        DATA.GUI.Cond2plot_HRV=[];
        DATA.GUI.Eventfiles=[];
        DATA.GUI.EventsNum=[];
        DATA.GUI.ConditionsNum=[];
        DATA.GUI.PCRconditions=[];
        DATA.GUI.PCRconditionsNum=[];
        DATA.GUI.PCR_EpochStart=[];
        DATA.GUI.PCR_EpochEnd=[];
        DATA.GUI.PCR_Algorithm=[];
        DATA.GUI.PCR_TimeWindow=[];
        DATA.GUI.PCR_Unit=[];
        DATA.GUI.PCRdatamatrix=[];
        DATA.GUI.UseCommonEventfile=[];
        DATA.GUI.HRVconditions=[];
        DATA.GUI.HRVconditionsNum=[];
        DATA.GUI.HRV_EpochStart=[];
        DATA.GUI.HRV_EpochEnd=[];
        DATA.GUI.HRVdatamatrix=[];
        DATA.GUI.PCRepochs=[];
        DATA.GUI.Spectral_SampleRate=[];
        DATA.GUI.Spectral_Points=[];
        DATA.GUI.Spectral_ARorder=[];
        DATA.GUI.Spectral_Filter=[];
        DATA.GUI.Spectral_Algorithm=[];
        DATA.GUI.Spectral_DetrendMethod=[];
        DATA.GUI.HRV2plot=[];
        DATA.GUI.Spectral_Scale=[];
        DATA.GUI.DFA_minbox=[];
        DATA.GUI.DFA_maxbox=[];
        DATA.GUI.DFA_sliding=[];
    end

%% ---- CDR
    function [baselineHR,medians,Vsec]=CDR(sig,TS,baseline)
        % transpose data vector
        if size(sig,1)>size(sig,2)
            sig=sig';
        end

        % create heart period vector
        [hp,t]=ecg_hp(sig,'instantaneous');

        % define T0 to calculate baseline heart rate
        T0=TS-baseline;
        baselineHR=ecg_stat(t,T0,TS,'mean','bpm'); % baseline Heart Rate

        % calculate mean heart rate sec by sec
        Vsec=[];
        count=0;
        for i=1:80
            V=ecg_stat(t,TS+count,TS+i,'mean','bpm');
            count=count+1;
            Vsec=[Vsec V];
        end

        % calculate medians
        medians=[median(Vsec(1:3)) median(Vsec(4:6)) median(Vsec(7:11)) median(Vsec(12:16))...
            median(Vsec(17:23)) median(Vsec(24:30)) median(Vsec(31:37)) median(Vsec(38:50))...
            median(Vsec(51:63)) median(Vsec(64:76))];
    end

%% ---- PCR
    function [HRmean,HRbsl]=PCR(t,TS,T0,T1,step,unit)
      
        % get heart period
        [hp,t]=ecg_hp(t,'instantaneous');

        % calculate baseline HR
        HRbsl=ecg_stat(t,T0,TS,'mean',unit); % call ecg_stat
     
        % calculate mean HR changes in variable window sizes defined by step
        nboxes=floor(T1/step); % number of boxes that fit in analysis window
        HRmean=[];
        count=0;
        for i=1:nboxes
            mhr=ecg_stat(t,TS+count*step,TS+step*i,'mean',unit);
            count=count+1;
            HRmean=[HRmean mhr];
        end
    end

%% ---- DFA
    function [alpha,n,Fn]=DFA(y,varargin)
        % set default values for input arguments
        sliding=0;
        graph=0;
        minbox=4;
        maxbox=floor(length(y)/4);

        % check input arguments
        nbIn = nargin;
        if nbIn > 1
            if ~ischar(varargin{1})
                minbox = varargin{1};
                if ~ischar(varargin{2})
                    maxbox = varargin{2};
                else
                    error('Input argument missing.');
                end
            end
            for i=1:nbIn-1
                if isequal (varargin{i},'plot'), graph='plot';end
                if isequal (varargin{i},'s'), sliding='s';end
            end
        end

        if nbIn > 5
            error('Too many input arguments.');
        end

        % initialize output variables
        alpha=[];
        n=NaN(1,maxbox-minbox+1);
        Fn=NaN(1,maxbox-minbox+1);

        % transpose data vector if necessary
        s=size(y);
        if s(1)>1
            y=y';
        end

        % substract mean
        y=y-mean(y);

        % integrate time series
        y=cumsum(y);

        N=length(y); % length of data vector

        % error message when box size exceeds permited limits
        if minbox<4 || maxbox>N/4
            disp([mfilename ': either minbox too small or maxbox too large!']);
            return
        end

        % begin loop to change box size
        count=1;
        for n=minbox:maxbox;
            i=1;
            r=N;
            m=[];
            l=[];

            % begin loop to create a new detrended time series using boxes of size n starting
            % from the beginning of the original time series
            while i+n-1<=N % create box size n
                x=y(i:i+n-1);
                x=detrend(x); % linear detrending
                m=[m x];
                if strcmp(sliding,'s')
                    i=i+1; % sliding window
                else
                    i=i+n; % non-overlapping windows
                end
            end

            % begin loop to create a new detrended time series with boxes of size n starting
            % from the end of the original time series
            while r-n+1>=1
                z=y(r:-1:r-n+1);
                z=detrend(z);
                l=[l z];
                if strcmp(sliding,'s')
                    r=r-1;
                else
                    r=r-n;
                end
            end

            % calculate the root-mean-square fluctuation of the new time series
            k=[m l]; % concatenate the two detrended time series
            k=k.^2;
            k=mean(k);
            k=sqrt(k);
            Fn(count)=k;
            count=count+1;
        end

        n=minbox:maxbox;

        % plot the DFA
        if strcmp (graph,'plot');
            figure;
            plot(log10(n),log10(Fn))
            xlabel('log(n)')
            ylabel('log(Fn)')
            title('Detrended Fluctuation Analysis')
        end

        % calculate scaling factor alpha
        coeffs    = polyfit(log10(n),log10(Fn),1);
        alpha     = coeffs(1);

    end

%% ---- RMSSD
    function y=RMSSD(sig)

        dsig=diff(sig);
        y=dsig.^2;
        y=sqrt(mean(y));
    end

%% ---- spPCRower
    function power=spPCRower(F,PSD,freq)
        % define frequency bands
        vlf=0.04; % very low frequency band
        lf=0.15; % low frequency band
        hf=0.4; % high frequency band

        % calculate number of points in the spectrum
        N=length(PSD);
        %calculate maximum frequency
        maxF=F(2)*N;

        if hf>F(end),
            hf=F(end);
            if lf>hf,
                lf=F(end-1);
                if vlf>lf,
                    vlf=F(end-2);
                end
            end
        end

        %calculate limiting points in each band
        index_vlf=round(vlf*N/maxF)+1;
        index_lf=round(lf*N/maxF)+1;
        index_hf=round(hf*N/maxF)+1;
        if index_hf>N,index_hf=N;end

        switch freq
            case {'total'}
                % calculate total energy (from 0 to hf) in ms^2
                total=F(2)*sum(PSD(1:index_hf-1));
                power=total;
            case {'vlf'}
                %calculate energy of very low frequencies (from 0 to vlf2)
                vlf=F(2)*sum(PSD(1:index_vlf-1));
                power=vlf;
            case {'lf'}
                %calculate energy of low frequencies (from vlf2 to lf2)
                lf=F(2)*sum(PSD(index_vlf:index_lf-1));
                power=lf;
            case {'hf'}
                %calculate energy of high frequencies (from lf2 to hf2)
                hf=F(2)*sum(PSD(index_lf:index_hf-1));
                power=hf;
            case {'nlf'}
                %calculate normalized low frequency
                lf=F(2)*sum(PSD(index_vlf:index_lf-1));
                hf=F(2)*sum(PSD(index_lf:index_hf-1));
                nlf=lf/(lf+hf);
                power=nlf;
            case {'nhf'}
                %calculate normalized low frequency
                lf=F(2)*sum(PSD(index_vlf:index_lf-1));
                hf=F(2)*sum(PSD(index_lf:index_hf-1));
                nhf=hf/(lf+hf);
                power=nhf;
            otherwise
                disp('Uknown frequency range selection')
                power=nan;
        end
    end

%% ---- ecg_hp
    function [hp, thp]=ecg_hp(t, method)
        % ECG_HP Calculate the 'instantaneous' or 'delayed' heart period.
        %   [hp, thp] = ECG_HP(t, method)
        %
        % Input arguments:
        %   t      - heart beats' time (at least two beats must be recorded)
        %   method - 'instantaneous': return the instantaneous HP
        %            'delayed': return the delayed HP
        %            (see description below)
        %
        % Output arguments:
        %   hp - instantaneous heart period
        %   thp - instantaneous heart period time
        %
        % Description:
        %   The instantaneous heart period is defined as f(t)=t[n+1]-t[n]
        %   for t[n]<=t<t[n+1], where t[n] is the occurance of the n-th heart beat.
        %
        %   An alternative would be to measure the delayed heart period defined
        %   as f(t)=t[n]-t[n-1] for t[n]<=t<t[n+1].
        %
        % References:
        %   Guimaraes & Santos (1998), and De-Boer, Karemaker & Strackee (1985)
        %
        % -------------------------------------------------------------------------
        % Written by Mateus Joffily - NeuroII/UFRJ & CNC/CNRS

        if length(t)>1
            hp=diff(t);
            if strcmp(method, 'instantaneous')
                thp=t(1:end-1);
            elseif strcmp(method, 'delayed')
                thp=t(2:end);
            else
                disp ([mfilename ': "' method '" method unknown.' ]);
                hp=[];
                thp=[];
            end
        else
            hp=[];
            thp=[];
        end
    end

%% ---- ecg_interp
    function yy=ecg_interp(t,y,tt,method)
        % ECG_INTERP interpolate HR series
        %   yy = ECG_INTERP(t,y,tt,method)
        %
        % Input arguments:
        %   t      - vector of HR instants
        %   y      - HR values
        %   tt     - vector of instants where HR values should be estimated
        %   method - 'constant', linear' or 'spline'
        %
        % Output arguments:
        %   yy     - HR values should at 'tt' instants
        %
        % Description:
        %   'constant' seems to be the most frequently used technique to calculate
        %   the averaged instantaneous heart period or rate in psychophysiology
        %   studies. It considers that HR is constant between two adjacent HR intervals.
        %   However, it seems to be the least effective estimate of the
        %   true espectrum. Preference should be done to 'spline' for spectral
        %   estimation.
        %
        % References:
        %   Guimaraes & Santos (1998)
        % -------------------------------------------------------------------------
        % Written by Mateus Joffily - NeuroII/UFRJ & CNC/CNRS

        if length(y) ~= length(t)
            disp ([mfilename ': "y" and "t" vectors must have the same length.']);
            yy=NaN;
            return
        end

        switch method
            case 'constant'
                yy=[];
                for i=1:numel(tt)
                    k=find((tt(i)-t)>0);
                    if isempty(k)
                        yy=[yy NaN];
                    else
                        yy=[yy y(k(end))];
                    end
                end

            case 'linear'
                yy = interp1(t,y,tt,'linear');

            case 'spline'
                yy=spline(t,y,tt);

            otherwise
                yy=NaN;
        end
    end

%% ---- ecg_stat
    function [HRstat, Ncycles] = ecg_stat(t, T0, T1, stat, unit)
        % ECG_STAT Return statistic within analysis window
        %   [HRstat, Ncycles] = ECG_STAT(t, T0, T1, stat, unit)
        %
        % Input arguments:
        %   t - vector of heartbeat instants
        %   T0 - analysis window onset
        %   T1 - analysis window offset
        %   stat - statistics output: 'mean', min' or 'max' values
        %   unit - output (HRstat) unit: 'sec', 'hz' or'bpm'.
        %          'sec' = the output will be the heart period.
        %          'hz' = the output will be the heart rate in beats/sec.
        %          'bpm' = the output will be the heart rate in beats/min.
        %
        % Output arguments:
        %   HRstat - statistic output
        %   Ncycles - cycle count
        %
        % Description:
        %   Each interval [t0;t1]; [t1;t2]; ... is considered as a cardiac cycle.
        %   For an analysis window delimited by [T0;T1], the number of cycles
        %   within the window is counted. The cycle [ti-1; ti] is counted as:
        %   1                         , if T0 <= ti-1 < ti <= T1;
        %   (ti - T0)/(ti - ti-1)     , if ti-1 < T0 < ti <= T1;
        %   (T1 - ti-1)/(ti - ti-1)   , if T0 <= ti-1 < T1 < ti;
        %   (T1 - T0)=(ti - ti-1)     , if ti-1 < T0 < T1 < ti.
        %   Having defined the cycle count within a window, the mean heart rate
        %   is defined as the ratio of this count to the total window length.
        %
        % References:
        %   Dinh et al, 1999; see also Reyes and Vila, 1998
        %--------------------------------------------------------------------------
        % Written by Mateus Joffily - NeuroII/UFRJ & CNC/CNRS

        % Initialize output variables
        HRstat=NaN;
        Ncycles=NaN;

        % transpose data vector
        if size(t,1)>size(t,2)
            t=t';
        end

        % index of beats inside analysis window [T0;T1]
        i=find(t>=T0 & t<=T1);

        if isempty(i)
            % There isn't any beat inside analysis window [T0;T1]
            % (ti-1 < T0 < T1 < ti)
            i0=find(t<T0);
            i1=find(t>T1);
            if isempty(i0) || isempty(i1)
                display('Missing heartbeat instant before T0 or after T1')
                return
            end
            tb=[t(i0(end)) t(i1(1))];   % beat time
            tc=[T0 T1];                 % cycle time

        else
            % Analysis window [T0;T1] is longer than heart periods
            tb=t(i);   % beat time
            tc=t(i);   % cycle time

            % Adjust beat and cycle times to analysis window
            if t(i(1))~=T0
                if i(1)-1<1
                    display('Missing heartbeat instant before T0')
                    return
                end
                tb=[t(i(1)-1) tb];
                tc=[T0 tc];
            end
            if t(i(end))~=T1
                if i(end)+1>length(t)
                    display('Missing heartbeat instant after T1')
                    return
                end
                tb=[tb t(i(end)+1)];
                tc=[tc T1];
            end
        end

        % Instantaneous heart period
        IBI=diff(tb);

        % Cycle count within analysis window
        Ncycles=sum(diff(tc)./IBI);

        % Analysis window length
        winlen=T1-T0;

        switch stat
            case 'mean'
                HRstat=winlen/Ncycles;
            case 'min'
                if strcmp(unit,'bpm') || strcmp(unit, 'hz')
                    HRstat=max(IBI);
                else
                    HRstat=min(IBI);
                end
            case 'max'
                if strcmp(unit,'bpm') || strcmp(unit, 'hz')
                    HRstat=min(IBI);
                else
                    HRstat=max(IBI);
                end
        end

        switch unit
            case 'hz'
                HRstat=1/HRstat;
            case 'bpm'
                HRstat=60/HRstat;
        end
    end

%% ---- isint
    function [d,ndx,varout] = isint(varargin)
        
        C = varargin;
        nIn = nargin;

        if nIn < 2
            d = C{:} == round(C{:});
        else
            d = zeros(1,nIn);
            for i = 1:nIn
                d(i) = isequal(C{i},round(C{i}));
            end
        end

        ndx = find(d);
        temp = [C{:}];
        varout = temp(ndx);
    end

end
