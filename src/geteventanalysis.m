function [ contTab, skillMeasure, tPredPk, vPredPk, tMeasPk, vMeasPk,... 
    tHit, tFalseAlarm, tMiss, tPredHit, vPredHit, tMeasHit, vMeasHit ] ...
    = geteventanalysis( tPred, vPred, tMeas, vMeas, minPkHeight, refList)
%GETEVENTANALYSIS performs an event-based validation analysis.
%
% Arguments: (Input)
%      tPred, vPred    - Predicted solar wind speed time series
%      tMeas, vMeas    - Observed solar wind speed time series
%      minPkHeight     - Minimum speed threshold for event detection
%      RefList         - Select reference for validation ['HSE','SIRHSS']
%
% Arguments: (Output)
%      contTab         - Contingency table
%      skillScore      - Event-based verification measures
%      skillScore(1)   - True Positive Rate (TPR)
%      skillScore(2)   - False Negative Rate (FNR)
%      skillScore(3)   - Positive Predictive Value (PPV)
%      skillScore(4)   - False Discovery Rate (FDR)
%      skillScore(5)   - Threat Score (TS)
%      skillScore(6)   - Bias
%
% Citation:
%      Reiss, M. A. et al. Verification of high-speed solar wind stream 
%      forecasts using operational solar wind models. Space Weather 14, 
%      2016SW001390 (2016).
%
% Authors:
%      Martin A. Reiss (NASA/Goddard)
%% DEFINE SETTINGS
load('../data/measurements.mat')
load('../data/icme.mat')

rejectICMEs = 1;                                 %ICMEs (1-on/0-off)
minProm  	= 60;                                %Specify peak prominence
minDist     = 3;                                 %Specify peak distance
dt          = 2;                                 %Specify peak time window

%%
tHit = 0;                                        %Initialize variables
tFalseAlarm = 0;
tMiss = 0;
tMeasHit = 0; 
tPredHit = 0; 
vMeasHit = 0;
vPredHit = 0;
vUnlPredPk = 0;
tUnlMeasPk = 0;
vUnlPredPk = 0;
vUnlMeasPk = 0;

%% I. PEAK DETECTION
                                                 %Detect HSE in forecast
[vPredPk,tPredPk,~,~] = findpeaks(vPred,tPred,'MinPeakProminence',...
    minProm,'MinPeakDistance',minDist,'MinPeakHeight',minPkHeight,...
    'Annotate','extents','WidthReference','halfprom');

if strcmp(refList,'HSE')                         %Detect HSE in observation
    [vMeasPk,tMeasPk,~,~] = findpeaks(vMeas,tMeas,'MinPeakProminence',...
        minProm,'MinPeakDistance',minDist, 'MinPeakHeight', minPkHeight,...
        'Annotate','extents','WidthReference','halfprom');
elseif strcmp(refList,'SIRHSS')
    load('../data/sirhss.mat')                   %Load SIR-HSS list
    vMeasPk = vSIRHSS;
    tMeasPk = tSIRHSS;
else
    fprintf('ERROR: invalid reference list!\n');
end

if(rejectICMEs == 1)                             %Reject events during 
    labelPred = 0;                               %periods of detected ICMEs                            
    idx = 1;
    for i=1:numel(tPredPk)
        found = 0;
        for j=1:numel(tCMEstart)
            if (tCMEstart(j) < tPredPk(i) && tCMEend(j) > tPredPk(i))
                found = 1;
            end
        end
        if found == 1
            labelPred(idx) = 0;
            idx = idx + 1;
        else labelPred(idx) = 1;
            idx = idx + 1;
        end
    end
    labelPred = logical(labelPred);
    tPredPk = tPredPk(labelPred);
    vPredPk = vPredPk(labelPred);

    labelMeas = 0;
    idx = 1;
    for i=1:numel(tMeasPk)
        found = 0;
        for j=1:numel(tCMEstart)
            if (tCMEstart(j) < tMeasPk(i) && tCMEend(j) > tMeasPk(i))
                found = 1;
            end
        end
        if found == 1
            labelMeas(idx) = 0;
            idx = idx + 1;
        else labelMeas(idx) = 1;
            idx = idx + 1;
        end
    end
    labelMeas = logical(labelMeas);
    tMeasPk = tMeasPk(labelMeas);
    vMeasPk = vMeasPk(labelMeas);
end

%% II. EVENT ASSOCIATION
nStart = 0;
nEnd   = 1;
vPredPkIt = vPredPk;
tPredPkIt = tPredPk;
vMeasPkIt = vMeasPk;
tMeasPkIt = tMeasPk;

while nStart ~= nEnd                             %Iterative process       
    tDetMeasPk = 0;
    for i=1:numel(tPredPkIt)
        tCandPk = 0;
        idx = 1;
        det = 0;
        for j=1:numel(tMeasPkIt)
            if ((tPredPkIt(i) - dt < tMeasPkIt(j)) &&...
            (tPredPkIt(i) + dt > tMeasPkIt(j)))
            tCandPk(idx) = tMeasPkIt(j);
            idx = idx + 1;
            det = 1;
            end 
        end
        if det == 0
        tDetMeasPk(i) = NaN;
        else
        [~,idx] = min(abs(tCandPk - tPredPkIt(i)));
        tDetMeasPk(i) = tCandPk(idx);
        end
    end
    tDetMeasPk = tDetMeasPk';

    tDetPredPkIt = 0;
    for i=1:numel(tMeasPkIt)
        tCandPk = 0;
        idx = 1;
        det = 0;
        for j=1:numel(tPredPkIt)
            if ((tMeasPkIt(i) - dt < tPredPkIt(j)) &&...
            (tMeasPkIt(i) + dt > tPredPkIt(j)))
            tCandPk(idx) = tPredPkIt(j);
            idx = idx + 1;
            det = 1;
            end 
        end
        if det == 0
        tDetPredPk(i) = NaN;
        else
        [~, idx] = min(abs(tCandPk - tMeasPkIt(i)));
        tDetPredPk(i) = tCandPk(idx);
        end
    end
    tDetPredPk = tDetPredPk';
    
    nStart = numel(tHit);
    for i = 1: numel(tPredPkIt)
        for j = 1: numel(tMeasPkIt)
            if(tPredPkIt(i) == tDetPredPk(j)... 
                    && tDetMeasPk(i) == tMeasPkIt(j)) 
                
                if tHit == 0
                    tHit     = tPredPkIt(i);
                    tPredHit = tPredPkIt(i);
                    tMeasHit = tMeasPkIt(j);
                    vPredHit = vPredPkIt(i);
                    vMeasHit = vMeasPkIt(j);
                else
                    tHit     = [tHit tPredPkIt(i)];
                    tPredHit = [tPredHit tPredPkIt(i)];
                    tMeasHit = [tMeasHit tMeasPkIt(j)];
                    vPredHit = [vPredHit vPredPkIt(i)];
                    vMeasHit = [vMeasHit vMeasPkIt(j)];
                end
            end
        end
    end
    
    tUnlPredPk=0;                                %Search for unlabeled
    idx=1;                                       %peaks in forecast.
    for i=1:numel(tPredPkIt)
        det = 0;
        for j=1:numel(tPredHit)
            if (tPredPkIt(i) == tPredHit(j))
                det = 1;
            end
        end
        if det == 0
        tUnlPredPk(idx) = tPredPkIt(i);
        vUnlPredPk(idx) = vPredPkIt(i);
        idx = idx + 1;
        end
    end
                        
    tUnlMeasPk=0;                                %Search for unlabeled
    idx=1;                                       %peaks in observation.
    for i=1:numel(tMeasPkIt)
        det = 0;
        for j=1:numel(tMeasHit)
            if (tMeasPkIt(i) == tMeasHit(j))
                det = 1;
            end
        end
        if det == 0
        tUnlMeasPk(idx) = tMeasPkIt(i);
        vUnlMeasPk(idx) = vMeasPkIt(i);
        idx = idx + 1;
        end
    end   
    tPredPkIt = tUnlPredPk;
    tMeasPkIt = tUnlMeasPk;
    vPredPkIt = vUnlPredPk;
    vMeasPkIt = vUnlMeasPk;
  
    nEnd = numel(tHit);
end

idx = 1;                                         
for i=1:numel(tUnlPredPk)                         
    det = 0;                                     
    for j=1:numel(tUnlMeasPk)                    
        if ((tUnlPredPk(i) - dt < tUnlMeasPk(j)) &&...
        (tUnlPredPk(i) + dt > tUnlMeasPk(j)))
        det = 1;
        break
        end 
    end
    if det == 1
    else
    tFalseAlarm(idx) = tUnlPredPk(i);
    idx = idx + 1;
    end  
end

idx = 1;
for i=1:numel(tUnlMeasPk)
    det = 0;
    for j=1:numel(tUnlPredPk)
        if ((tUnlMeasPk(i) - dt < tUnlPredPk(j)) &&...
        (tUnlMeasPk(i) + dt > tUnlPredPk(j)))
        det = 1;
        end 
    end
    if det == 0
    tMiss(idx) = tUnlMeasPk(i);
    idx = idx + 1;
    end  
end

if tFalseAlarm == 0
    nFP = 0;
else
    nFP = numel(tFalseAlarm);
end

if tMiss == 0
    nFN = 0;
else
    nFN = numel(tMiss); 
end

nTP = numel(tHit);

%% III. VERIFICATION MEASURES

contTab(1,1) = nTP;                        %Compute contingency table
contTab(1,2) = nFP;
contTab(2,1) = nFN;
contTab(2,2) = NaN;

                                           %Compute scalar measures:
TPR = nTP /(nTP + nFN);                    %True Positive Rate (TPR)
FNR = nFN /(nTP + nFN);                    %False Negative Rate (FNR)
PPV = nTP /(nTP + nFP);                    %Positive Predictive Value (PPV)
FDR = nFP /(nTP + nFP);                    %False Discovery Rate (FDR)
                                           %(Note: FNR=1-TPR, FDR=1-PPV)

TS   = nTP/(nTP + nFP + nFN);              %Threat Score (TS)
BIAS = (nTP + nFP)/(nTP + nFN);            %Bias

skillMeasure(1) = TPR;                     %Prepare output             
skillMeasure(2) = FNR;
skillMeasure(3) = PPV;
skillMeasure(4) = FDR;
skillMeasure(5) = TS;
skillMeasure(6) = BIAS;
end