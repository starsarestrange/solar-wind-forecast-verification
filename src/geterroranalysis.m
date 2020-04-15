function [ errorMeasure ] = geterroranalysis( vPred, vMeas )
%GETERRORANALYSIS computes point-to-point comparison metrics.
%
% Arguments: (Input)
%      vPred           - Predicted solar wind speed time series
%      vMeas           - Observed solar wind speed time series
%
% Arguments: (Output)
%      errorMeasure    - Basic error measures
%      errorMeasure(1) - Mean Error (ME)
%      errorMeasure(2) - Mean Absolute Error (MAE)
%      errorMeasure(3) - Root Mean Square Error (RMSE)
%      errorMeasure(4) - Mean Measurement
%      errorMeasure(5) - Standard Deviation Measurement
%      errorMeasure(6) - Mean Prediction
%      errorMeasure(7) - Standard Deviation Prediction
%
% Citation:
%      Reiss, M. A. et al. Verification of high-speed solar wind stream 
%      forecasts using operational solar wind models. Space Weather 14, 
%      2016SW001390 (2016).
%
% Authors:
%      Martin A. Reiss (NASA/Goddard)
%% COMPUTE POINT-TO-POINT COMPARISON METRICS
ME   = mean(vMeas)-mean(vPred);
MAE  = sum(abs(vMeas(:)-vPred(:)))/numel(vPred);
RMSE = sqrt(sum((vMeas(:)-vPred(:)).^2)/numel(vPred));

meanMeas   = mean(vMeas);
stddevMeas = std(vMeas);
meanPred   = mean(vPred);
stddevPred = std(vPred);

errorMeasure(1) = ME;
errorMeasure(2) = MAE;
errorMeasure(3) = RMSE;
errorMeasure(4) = meanMeas;
errorMeasure(5) = stddevMeas;
errorMeasure(6) = meanPred;
errorMeasure(7) = stddevPred;