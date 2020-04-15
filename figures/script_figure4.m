% Citation:
%      Reiss, M. A. et al. Verification of high-speed solar wind stream 
%      forecasts using operational solar wind models. Space Weather 14, 
%      2016SW001390 (2016).
%
% Authors:
%      Martin A. Reiss (NASA/Goddard)
%% Figure 4
clear
load('../results/results_ESWF400.mat')

f1 = figure;
set(f1, 'Position',[0,0,1600,980])
input = horzcat(vMeas, vPred);
edges = 300:100:700;

xlabel('measurement'); 
ylabel('prediction');

N = hist3(input,'Ctrs',{edges edges});
sum_entr = sum(sum(N));
N_norm = N/sum_entr;

sum_col = sum(N);
sum_row = sum(N,2);

for i=1:size(N,1)
    N_xnorm(i,:) = N(i,:)/sum_row(i);
    N_ynorm(:,i) = N(:,i)/sum_col(i);
end

subplot(2,4,1);
h1 = histogram(vPred);
hold on
h2 = histogram(vMeas);
h1.Normalization = 'probability';
h1.BinWidth = 50;
h2.BinWidth = 50;
h2.FaceColor = [0.32 0.77 0.32];
h2.EdgeColor = [0 0.5 0.2];
h1.FaceColor = [0 0 0.89];
h1.EdgeColor = [0 0 0.59];
ylim([0,0.46])
h2.Normalization = 'probability';
legend('ESWF','Observation','Location','northoutside','Orientation','horizontal');
xlabel('Speed [km/s]') 
ylabel('probability [%]') 
axis square

subplot(2,4,2)
imagesc(N_norm')
axis image
axis xy
colorbar('northoutside')
set(gca,'XTickLabel',edges)
set(gca,'YTickLabel',edges)
set(gca, 'CLim', [0, 0.25]);
ylabel('Prediction [km/s]');
xlabel('Observation [km/s]');
colormap cool

subplot(2,4,3)
imagesc(N_xnorm')
set(gca,'XTickLabel',edges)
set(gca,'YTickLabel',edges)
ylabel('Prediction [km/s]');
xlabel('Observation [km/s]');
axis image
axis xy
colorbar('northoutside')
set(gca, 'CLim', [0, 0.7]);

subplot(2,4,4)
imagesc(N_ynorm')
set(gca,'XTickLabel',edges)
set(gca,'YTickLabel',edges)
axis image
axis xy
colorbar('northoutside')
ylabel('Prediction [km/s]');
xlabel('Observation [km/s]');
set(gca, 'CLim', [0, 0.7]);

clear
%% 
load('../results/results_WSA400.mat')
input = horzcat(vMeas, vPred);
edges = 300:100:700;

N = hist3(input,'Ctrs',{edges edges});
sum_entr = sum(sum(N));
N_norm = N/sum_entr;

sum_col = sum(N);
sum_row = sum(N,2);

for i=1:size(N,1)
    N_xnorm(i,:) = N(i,:)/sum_row(i);
    N_ynorm(:,i) = N(:,i)/sum_col(i);
end

subplot(2,4,5);
h1 = histogram(vPred);
hold on
h2 = histogram(vMeas);
h1.Normalization = 'probability';
h1.BinWidth = 50;
h2.BinWidth = 50;
h2.FaceColor = [0.32 0.77 0.32];
h2.EdgeColor = [0 0.5 0.2];
h1.FaceColor = [0.79 0 0];
h1.EdgeColor = [0.59 0 0];
ylim([0,0.46])
h2.Normalization = 'probability';
legend('WSA','Observation','Location','northoutside','Orientation','horizontal');
xlabel('Speed [km/s]') 
ylabel('probability [%]') 
axis square

subplot(2,4,6)
imagesc(N_norm')
axis image
axis xy
colorbar('northoutside')
set(gca,'XTickLabel',edges)
set(gca,'YTickLabel',edges)
set(gca, 'CLim', [0, 0.25]);

ylabel('Prediction [km/s]');
xlabel('Observation [km/s]');

subplot(2,4,7)
imagesc(N_xnorm')
set(gca,'XTickLabel',edges)
set(gca,'YTickLabel',edges)
ylabel('Prediction [km/s]');
xlabel('Observation [km/s]');
axis image
axis xy
colorbar('northoutside')
set(gca, 'CLim', [0, 0.7]);

subplot(2,4,8)
imagesc(N_ynorm')
set(gca,'XTickLabel',edges)
set(gca,'YTickLabel',edges)
axis image
axis xy
colorbar('northoutside')
ylabel('Prediction [km/s]');
xlabel('Observation [km/s]');
set(gca, 'CLim', [0, 0.7]);

%%
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figure4