% Name: 
%      OSEA - Operational Solar Wind Evaluation Algorithm
%
% Purpose:
%      This script runs different evaluation methods to quantitatively 
%      assess the skill of numerical models for forecasting the evolving 
%      ambient solar wind in the near-Earth environment.
%
% Citation:
%      Reiss, M. A. et al. Verification of high-speed solar wind stream 
%      forecasts using operational solar wind models. Space Weather 14, 
%      2016SW001390 (2016).
%             
% Authors:
%      Martin A. Reiss (NASA/Goddard)
%% I. SETTINGS
clear
load('../data/measurements.mat')                 %Load data files
load('../data/predictions.mat')

tMeas = tACE;                                    %Select ACE/SWEPAM data
vMeas = vACE; 
tPred = tWSA;                                    %Select model solutions
vPred = vWSA;                                    

dateStart = '01-01-2011';                        %Set start date
dateEnd   = '01-01-2015';                        %Set end date
format    = 'dd-mm-yyyy';                        %Specify date format
minPkHeight = 400;                               %Set minimum-speed TH for
                                                 %event-based validation.

%% II. DATA PREPARATION
cond   = (tPred > datenum(dateStart,format)...   %Get predicted speed for  
    & tPred < datenum(dateEnd,format));          %a selected time period.
tPred  = tPred(cond);
vPred  = vPred(cond);
cond   = (tMeas > datenum(dateStart,format)...   %Get observed speed for 
    & tMeas < datenum(dateEnd,format));          %a selected time period.
tMeas  = tMeas(cond);
vMeas  = vMeas(cond);

tStart = datenum(dateStart,format)+1;            %Define time grid (6h)
tEnd   = datenum(dateEnd,format)-1;
tGrid  = tStart:0.25:tEnd;
vMeas  = interp1(tMeas,vMeas,tGrid)';
vPred  = interp1(tPred,vPred,tGrid)';
tPred  = tGrid;
tMeas  = tGrid;

%% III. FORECAST VALIDATION ANALYSIS
[errorMeasure] = geterroranalysis(vPred,vMeas);  %Get basic error measures.
                                 
[contTabHSE,skillMeasureHSE,~] = ...             %Apply an event-based
    geteventanalysis(tPred,vPred,tMeas,vMeas,... %validation using the                                       
    minPkHeight,'HSE');                          %detected HSE's.
                             
[contTabSIR,skillMeasureSIR,~] = ...             %Apply an event-based
    geteventanalysis(tPred,vPred,tMeas,vMeas,... %validation using the 
    minPkHeight,'SIRHSS');                       %detected SIR-HSS events.


%% NOTE: 
% To update the graphical illustrations in Reiss et al. (2016), replace the 
% event-based validation approach by the commands below, save the results 
% from the workspace, and re-run the figure scripts.
%%
% [contTabHSE,skillMeasureHSE,tPredHSE,vPredHSE,tMeasHSE,vMeasHSE,...
%     tHitHSE,tFalseAlarmHSE,tMissHSE,tPredHitHSE,vPredHitHSE,...
%     tMeasHitHSE,vMeasHitHSE] = ...
%     geteventanalysis(tPred,vPred,tMeas,vMeas,minPkHeight,'HSE');
% 
% [contTabSIR,skillMeasureSIR,tPredSIR,vPredSIR,tMeasSIR,vMeasSIR,...
%     tHitSIR,tFalseAlarmSIR,tMissSIR,tPredHitSIR,vPredHitSIR,...
%     tMeasHitSIR,vMeasHitSIR] = ...
%     geteventanalysis(tPred,vPred,tMeas,vMeas,minPkHeight,'SIRHSS');