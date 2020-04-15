% Citation:
%      Reiss, M. A. et al. Verification of high-speed solar wind stream 
%      forecasts using operational solar wind models. Space Weather 14, 
%      2016SW001390 (2016).
%
% Authors:
%      Martin A. Reiss (NASA/Goddard)
%% Figure 6
clear
load('../results/results_WSA400.mat')
dt_swpred = tPredHitHSE - tMeasHitHSE;
dv_swpred = vPredHitHSE - vMeasHitHSE;

tMeasHitHSE_swpred = tMeasHitHSE;
tPredHitHSE_swpred = tPredHitHSE;
vMeasHitHSE_swpred = vMeasHitHSE;
vPredHitHSE_swpred = vPredHitHSE;

dt_hss = tPredHitSIR - tMeasHitSIR;
dv_hss = vPredHitSIR - vMeasHitSIR;

tMeasHitHSE_hss = tMeasHitSIR;
tPredHitHSE_hss = tPredHitSIR;
vMeasHitHSE_hss = vMeasHitSIR;
vPredHitHSE_hss = vPredHitSIR;

f6 = figure;
%%
subplot(3,2,1)
h1 = histogram(dv_swpred);
hold on
h2 = histogram(dv_hss);
h1.Normalization = 'probability';
h1.BinEdges = -325:50:325;
h2.FaceColor = [0.79 0 0];
h2.EdgeColor = [0.59 0 0];

h1.FaceColor = [0 0 0.89];
h1.EdgeColor = [0 0 0.59];

h2.Normalization = 'probability';
h2.BinEdges = -325:50:325;
xlim([-350,350])
ylim([0,0.5])
legend('HSE','SIR-HSS','Location','northoutside','Orientation','horizontal');
xlabel('\delta v = v_{pred} - v_{meas} [km/s]') 
ylabel('probability density') 
axis square

mv_swpred=mean(dv_swpred);
mv_hss=mean(dv_hss);

plot([mv_swpred,mv_swpred],[0,0.34],'b--','LineWidth',1)
plot([mv_hss,mv_hss],[0,0.34],'r--','LineWidth',1)

mnlabel  = ['\color[rgb]{0 0 0.89}Mean= ',num2str(sprintf('%.1f',mv_swpred)),'\pm',num2str(sprintf('%.1f',std(dv_swpred))), ' km/s'];
stdlabel = ['\color[rgb]{0.79 0 0}Mean= ',num2str(sprintf('%.1f',mv_hss)),'\pm',num2str(sprintf('%.1f',std(dv_hss))), ' km/s'];

h = annotation('textbox',[0.18 0.77 0.1 0.1]);
set(h,'String',{mnlabel,stdlabel},'FontSize',8);

%%
subplot(3,2,2)
h1 = histogram(dt_swpred);
hold on
h2 = histogram(dt_hss);
h1.Normalization = 'probability';
h1.BinEdges = -2.5:0.5:2.5;
h2.FaceColor = [0.79 0 0];
h2.EdgeColor = [0.59 0 0];
h1.FaceColor = [0 0 0.89];
h1.EdgeColor = [0 0 0.59];
h2.Normalization = 'probability';
h2.BinEdges = -2.5:0.5:2.5;
xlim([-2,2])
ylim([0,0.4])
legend('HSE','SIR-HSS','Location','northoutside','Orientation','horizontal');
xlabel('\delta t = t_{pred} - t_{meas} [days]') 
ylabel('probability density') 
axis square

mt_swpred=mean(dt_swpred);
mt_hss=mean(dt_hss);

plot([mt_swpred,mt_swpred],[0,0.27],'b--','LineWidth',1)
plot([mt_hss,mt_hss],[0,0.27],'r--','LineWidth',1)

mnlabel  = ['\color[rgb]{0 0 0.89}Mean= ',num2str(sprintf('%.2f',mt_swpred)),'\pm',num2str(sprintf('%.2f',std(dt_swpred))), ' days'];
stdlabel = ['\color[rgb]{0.79 0 0}Mean=  ',num2str(sprintf('%.2f',mt_hss)),'\pm',num2str(sprintf('%.2f',std(dt_hss))), ' days'];

h1 = annotation('textbox',[0.63 0.77 0.1 0.1]);
set(h1,'String',{mnlabel,stdlabel},'FontSize',8);
%%
subplot(3,2,3)
line=1:10:1000;
hold on 
scatter(vMeasHitHSE_swpred,vPredHitHSE_swpred,'bx')
scatter(vMeasHitHSE_hss,vPredHitHSE_hss,'ro')
plot(line, line, 'k')
hold off
xlabel('v_{meas.}[km/s]') 
ylabel('v_{pred.}[km/s]') 
axis square
xlim([350,850])
ylim([350,850])
box on
grid on
legend('HSE','SIR-HSS','Location','northoutside','Orientation','horizontal');

cc_HSE = corr2(vMeasHitHSE_swpred,vPredHitHSE_swpred);
cc_HSEHSS = corr2(vMeasHitHSE_hss,vPredHitHSE_hss);

cc_HSElabel  = ['\color[rgb]{0 0 0.89}CC= ',num2str(sprintf('%.2f',cc_HSE))];
cc_HSEHSSlabel = ['\color[rgb]{0.79 0 0}CC= ',num2str(sprintf('%.2f',cc_HSEHSS))];

h1 = annotation('textbox',[0.35 0.365 0.1 0.1],'EdgeColor','none');
set(h1,'String',{cc_HSElabel,cc_HSEHSSlabel},'FontSize',8);

%%
subplot(3,2,4)
hold on 
scatter(dt_swpred,dv_swpred,'bx')
scatter(dt_hss,dv_hss,'ro')
hold off
xlabel('\delta t [days]') 
xlim([-2.5,2.5])
ylabel('\delta v [km/s]') 
ylim([-350,350])
axis square
box on
grid on
legend('HSE','SIR-HSS','Location','northoutside','Orientation','horizontal');

%%
subplot(3,2,5)
hold on 
scatter(vMeasHitHSE_swpred,dt_swpred,'bx')
scatter(vMeasHitHSE_hss,dt_hss,'ro')
hold off
ylabel('\delta t [doy]') 
xlabel('v_{meas.}[km/s]') 
axis square
box on
grid on
ylim([-2.5,2.5])
xlim([350,850])
legend('HSE','SIR-HSS','Location','northoutside','Orientation','horizontal');

%%
subplot(3,2,6)
hold on 
scatter(vMeasHitHSE_swpred,dv_swpred,'bx')
scatter(vMeasHitHSE_hss,dv_hss,'ro')

ylabel('\delta v [km/s]') 
xlabel('v_{meas.}[km/s]') 
axis square
box on
grid on
ylim([-350,350])
xlim([350,850])
legend('HSE','SIR-HSS','Location','northoutside','Orientation','horizontal');

line = 1:50:1000;
[coeff_hse] = polyfit(vMeasHitHSE_swpred,dv_swpred,1);
plot(line, (coeff_hse(2)+coeff_hse(1)*line), 'b-.','LineWidth',1)

[coeff_sir_hss] = polyfit(vMeasHitHSE_hss,dv_hss,1);
plot(line, (coeff_sir_hss(2)+coeff_sir_hss(1)*line), 'r-.','LineWidth',1)
hold off
coeff_hselabel  = ['\color[rgb]{0 0 0.89}y= ',num2str(sprintf('%.2f',coeff_hse(1))),'x+',num2str(sprintf('%.1f',coeff_hse(2)))];
coeff_sirhsslabel  = ['\color[rgb]{0.79 0 0}y= ',num2str(sprintf('%.2f',coeff_sir_hss(1))),'x+',num2str(sprintf('%.1f',coeff_sir_hss(2)))];

h1 = annotation('textbox',[0.735 0.19 0.1 0.1],'EdgeColor','none');
set(h1,'String',{coeff_hselabel,coeff_sirhsslabel},'FontSize',8);


%%
text(-475,455,'(e)','FontSize',16)
text(-475,1620,'(c)','FontSize',16)
text(-475,2780,'(a)','FontSize',16)
text(250,455,'(f)','FontSize',16)
text(250,1620,'(d)','FontSize',16)
text(250,2780,'(b)','FontSize',16)

%%
set(f6, 'Position',[0,0,600,1000])
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figure6