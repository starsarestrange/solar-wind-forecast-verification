function [fig] = plotprediction(t, y, startDateStr, endDateStr)
%PLOTPREDICTION plots the solar wind speed time series
%
% Arguments: (Input)
%      t, y            - input time series 
%      startDateStr    - start date
%      endDateStr      - end date
%
% Arguments: (Output)
%      fig             - plot
%
% Citation:
%      Reiss, M. A. et al. Verification of high-speed solar wind stream 
%      forecasts using operational solar wind models. Space Weather 14, 
%      2016SW001390 (2016).
%
% Authors:
%      Martin A. Reiss (NASA/Goddard)
%% PLOT TIME SERIES
startDate = datenum(startDateStr, 'dd-mm-yyyy');
endDate   = datenum(endDateStr, 'dd-mm-yyyy');

fig = plot(t, y); 

day = 0;                                         %Compute tick locations 
for year = 1975:2050                             %from year 1975 to 2050.
dayTemp = datenum(year,1:12,ones(1,12));
day = [day dayTemp];
end

set(gca, 'XTick', day);                          %Update tick locations
datetick('x', 'dd-mmm-yy', 'keepticks')          %Update tick text
axis([startDate endDate 250 inf])                %Set axis range