% Citation:
%      Reiss, M. A. et al. Verification of high-speed solar wind stream 
%      forecasts using operational solar wind models. Space Weather 14, 
%      2016SW001390 (2016).
%
% Authors:
%      Martin A. Reiss (NASA/Goddard)
%% Figure 1
clear
load('../results/results_ESWF400.mat')
load('../data/measurements.mat')
load('../data/icme.mat')

f1 = figure;
subplot(4,1,1)
hold on 
L = numel(tCMEstart);
for idx=1:L(1)
fig0 = area([tCMEstart(idx) tCMEend(idx)], [1000 1000], 'FaceColor', [0.65 1 0.65], 'LineStyle','none');
end
fig1 = plotprediction(tPred, vPred, dateStart, dateEnd);
fig2 = plotprediction(tMeas, vMeas, dateStart, dateEnd);
scatter(tPredHSE, vPredHSE, 'vb','MarkerFaceColor','b')
scatter(tMeasHSE, vMeasHSE, 'vm','MarkerFaceColor','m')
fig3 = scatter(tHitHSE,ones(size(tHitHSE))*850, 'xb');
fig4 = scatter(tFalseAlarmHSE,ones(size(tFalseAlarmHSE))*850, 'or');
fig5 = scatter(tMissHSE,ones(size(tMissHSE))*850, '+r');
hold off

legend([fig0,fig1,fig2,fig3,fig4,fig5],'ICME','Prediction','Measurement','Hit','False Alarm', 'Miss',...
    'Location',[0.4,0.9,0.25,0.1],'Orientation','horizontal')
datetick('x', 'mmm-yy', 'keepticks')
axis([datenum('01-01-2011', 'dd-mm-yyyy') datenum('01-01-2012', 'dd-mm-yyyy') 250 900])
ylabel('bulk velocity [km/s]')
xlabel('Date [month-year]')

subplot(4,1,2)
hold on 
L = numel(tCMEstart);
for idx=1:L(1)
fig0 = area([tCMEstart(idx) tCMEend(idx)], [1000 1000], 'FaceColor', [0.65 1 0.65], 'LineStyle','none');
end
plotprediction(tPred, vPred, dateStart, dateEnd);
plotprediction(tMeas, vMeas, dateStart, dateEnd);
scatter(tPredHSE, vPredHSE, 'vb','MarkerFaceColor','b')
scatter(tMeasHSE, vMeasHSE, 'vm','MarkerFaceColor','m')
scatter(tHitHSE,ones(size(tHitHSE))*850, 'xb');
scatter(tFalseAlarmHSE,ones(size(tFalseAlarmHSE))*850, 'or');
scatter(tMissHSE,ones(size(tMissHSE))*850, '+r');
hold off

datetick('x', 'mmm-yy', 'keepticks')
axis([datenum('01-01-2012', 'dd-mm-yyyy') datenum('01-01-2013', 'dd-mm-yyyy') 250 900])
ylabel('bulk velocity [km/s]')
xlabel('Date [month-year]')

subplot(4,1,3)
hold on 
L = numel(tCMEstart);
for idx=1:L(1)
fig0 = area([tCMEstart(idx) tCMEend(idx)], [1000 1000], 'FaceColor', [0.65 1 0.65], 'LineStyle','none');
end
plotprediction(tPred, vPred, dateStart, dateEnd);
plotprediction(tMeas, vMeas, dateStart, dateEnd);
scatter(tPredHSE, vPredHSE, 'vb','MarkerFaceColor','b')
scatter(tMeasHSE, vMeasHSE, 'vm','MarkerFaceColor','m')
scatter(tHitHSE,ones(size(tHitHSE))*850, 'xb');
scatter(tFalseAlarmHSE,ones(size(tFalseAlarmHSE))*850, 'or');
scatter(tMissHSE,ones(size(tMissHSE))*850, '+r');
hold off

datetick('x', 'mmm-yy', 'keepticks')
axis([datenum('01-01-2013', 'dd-mm-yyyy') datenum('01-01-2014', 'dd-mm-yyyy') 250 900])
ylabel('bulk velocity [km/s]')
xlabel('Date [month-year]')

subplot(4,1,4)
hold on 
L = numel(tCMEstart);
for idx=1:L(1)
fig0 = area([tCMEstart(idx) tCMEend(idx)], [1000 1000], 'FaceColor', [0.65 1 0.65], 'LineStyle','none');
end
plotprediction(tPred, vPred, dateStart, dateEnd);
plotprediction(tMeas, vMeas, dateStart, dateEnd);
scatter(tPredHSE, vPredHSE, 'vb','MarkerFaceColor','b')
scatter(tMeasHSE, vMeasHSE, 'vm','MarkerFaceColor','m')
scatter(tHitHSE,ones(size(tHitHSE))*850, 'xb');
scatter(tFalseAlarmHSE,ones(size(tFalseAlarmHSE))*850, 'or');
scatter(tMissHSE,ones(size(tMissHSE))*850, '+r');
hold off

datetick('x', 'mmm-yy', 'keepticks')
axis([datenum('01-01-2014', 'dd-mm-yyyy') datenum('01-01-2015', 'dd-mm-yyyy') 250 900])
ylabel('bulk velocity [km/s]')
xlabel('Date [month-year]')

%%
set(f1, 'Position',[0,0,1400,980])
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figure1