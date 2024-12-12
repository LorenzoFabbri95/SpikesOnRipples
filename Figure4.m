%% created by Lorenzo Fabbri

clc
clear
close all
cd('insert address here')
data_Res = readtable('insert name here');
data_SOZ = readtable('insert name here');

% pAUC values should be normalized (0-1) 
%% Kruskal wallis for resection

close all
[pi,tbl,stats]=kruskalwallis(table2array(data_Res(:,2:12)));
ylabel('pAUC')
title(['p = ',num2str(pi)]);
set(gca,'Xtick',[1,2,3,4,5,6,7,8,9,10,11],'XTickLabels',{'BM1','BM2','BM3', 'BM4','BM5','BM6','BM7','BM8','BM9','BM10','BM11'});
figure 
[c,m,h] = multcompare(stats)

%% Kruskal wallis for SOZ

close all
[pi,tbl,stats]=kruskalwallis(table2array(data_SOZ(:,2:12)));
ylabel('pAUC')
title(['p = ',num2str(pi)]);
set(gca,'Xtick',[1,2,3,4,5,6,7,8,9,10,11],'XTickLabels',{'BM1','BM2','BM3', 'BM4','BM5','BM6','BM7','BM8','BM9','BM10','BM11'});
figure 
[c,m,~] = multcompare(stats)


%% create graph here plotting all bm (or just a couple) for all good outcome patients 

close all
data_Res = sortrows(data_Res,2,'descend');   % sorting data in descending order according to the second biomarker in data_Res
data_SOZ = sortrows(data_SOZ,2,'descend');   % sorting data in descending order according to the second biomarker in data_SOZ
groups = [1:size(data_Res,1)]';

% pAUC for each patient and each biomarker in decreasing order for Res

c = [1 1 0;0 0 1;1 0 1;0.82 0.62 0.17;0.2 0.57 0.99;0.4 0.09 0.61;1 0 0;1 0.65 0;0 1 0;0 0.4 0.1;0 0.9 0.9];

for i = 2:1:size(data_Res,2)-1
s = scatter(groups,table2array(data_Res(:,i)),100,c(i-1,:),'filled')
ylabel('pAUC')
title('pAUC value for each patient (Res)')
set(gcf,'Position',[800 300 1200 700])
set(gca,'Xtick',[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]);
legend('All Spikes','All Ripples','All Fast Ripples','Spikes only','Ripples only','Fast Ripples only','Spike + Ripple','Spike + Fast Ripple','Ripple + Fast Ripple','Spike + Ripple + Fast Ripple','Spike + HFO')
s.LineWidth = 0.75;
s.MarkerEdgeColor = 'k'
hold on
end

% plotting dashed line connecting all dots for the 2nd biomarkers
hold on
line(groups,table2array(data_Res(:,2)),'Color','yellow','LineStyle','-','LineWidth',2);

%% pAUC for each patient and each biomarker in decreasing order of all spikes pAUC for SOZ

close all

for i = 2:1:size(data_SOZ,2)-1
s = scatter(groups,table2array(data_SOZ(:,i)),100,c(i-1,:),'filled')
ylabel('pAUC')
title('pAUC value for each patient (SOZ)')
set(gcf,'Position',[800 300 1200 700])
set(gca,'Xtick',[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]);
legend('All Spikes','All Ripples','All Fast Ripples','Spikes only','Ripples only','Fast Ripples only','Spike + Ripple','Spike + Fast Ripple','Ripple + Fast Ripple','Spike + Ripple + Fast Ripple','Spike + HFO')
s.LineWidth = 0.75;
s.MarkerEdgeColor = 'k'
hold on
end

% plotting dashed line connecting all dots for the 2nd biomarkers
hold on
line(groups,table2array(data_SOZ(:,2)),'Color','yellow','LineStyle','-','LineWidth',2);

%%  spearman correaltion between median spike rate and pAUC for Res
   
clear
cd('insert address here');
data = readtable('insert name here');

[rho_allS,pval_allS] = corr(data.AllS,data.median_s_rate,'Type','Spearman','Rows','all');
[rho_S_R,pval_S_R] = corr(data.S_R,data.median_s_rate,'Type','Spearman','Rows','all');

%plotting here. pAUC values should be normalized (0-1)
figure
scatter(data.AllS,data.median_s_rate,"filled","MarkerFaceColor",[1 0.8118 0.2784],"MarkerEdgeColor",[0.9290 0.6940 0.1250])
xlabel('pAUC')
ylabel('Median Spike Rate [spikes/min]')
title('EZ')
hold on
scatter(data.S_R,data.median_s_rate,"filled","MarkerFaceColor","red","MarkerEdgeColor",[0.6350 0.0780 0.1840])
lsline
message = sprintf('All S R2=%.4f p=%.4f\n S+R R2=%.4f p=%.4f',rho_allS,pval_allS,rho_S_R,pval_S_R);
lgd = legend(message);
lgd.Location = 'north east';

%%  spearman correaltion between median spike rate and pAUC for SOZ
   
clear
cd('insert address here');
data = readtable('insert name here');

[rho_allS,pval_allS] = corr(data.AllS,data.median_s_rate,'Type','Spearman','Rows','all');
[rho_S_R,pval_S_R] = corr(data.S_R,data.median_s_rate,'Type','Spearman','Rows','all');

%plotting here. pAUC values should be normalized (0-1)
figure
scatter(data.AllS,data.median_s_rate,"filled","MarkerFaceColor",[1 0.8118 0.2784],"MarkerEdgeColor",[0.9290 0.6940 0.1250])
xlabel('pAUC')
ylabel('Median Spike Rate [spikes/min]')
title('SOZ')
hold on
scatter(data.S_R,data.median_s_rate,"filled","MarkerFaceColor","red","MarkerEdgeColor",[0.6350 0.0780 0.1840])
lsline
message = sprintf('All S R2=%.4f p=%.4f\n S+R R2=%.4f p=%.4f',rho_allS,pval_allS,rho_S_R,pval_S_R);
lgd = legend(message);
lgd.Location = 'north east';