%% Spikes, Ripple, Fast Ripple Rates
Rates_good = readtable('Sample_Rates_Good.xlsx');
Rates_poor = readtable('Sample_Rates_Poor.xlsx');
Events_good = readtable('Sample_Events_Good.xlsx');
Events_poor = readtable('Sample_Events_Poor.xlsx');
Events=[Events_good;Events_poor];
Events = table2dataset(Events);
BM1=sum(Events.BM1); BM2=sum(Events.BM2); BM3=sum(Events.BM3);
figure; subplot(1,4,1)
c = bar([BM1  BM2 BM3]);
ylabel('Events [no.]','FontWeight','Bold')
set(gca,'Fontsize',14)
text(1:length([BM1  BM2 BM3]),[BM1  BM2 BM3],num2str([BM1  BM2 BM3]'),'vert','bottom','horiz','center'); 
c.FaceColor = 'flat';
c.CData(1,:) = [1 0.75 0];
c.CData(2,:) = [0.91 0.25 0.44]; 
c.CData(3,:) = [0.13 0.45 0.65];
xticklabels({'BM1','BM2','BM3'})
stats_good = grpstats(Rates_good,"Patient","mean","DataVars",["BM1" "BM2" "BM3"]);
stats_poor = grpstats(Rates_poor,"Patient","mean","DataVars",["BM1" "BM2" "BM3"]);
stats_good = table2dataset(stats_good);
stats_poor = table2dataset(stats_poor);
subplot(1,4,2)
[v, var1, var2]=create_vector_for_boxplots(stats_good,stats_poor,{'mean_BM1'},1);
ystr= 'Rate [event/min]';
bpos=box_plot_two_groups_v2(v,2,ystr,'',[1 0.75 0; 1 0.75 0],0.5,0.1,'',30,12,1,0.5);
xticklabels({'Good','Poor'})
title('BM1')
vars_name={'Good','Poor'};
input=table(var1,var2);
input=splitvars(input);
for h=1:size(input,2)
    input.Properties.VariableNames{h} = vars_name{h};
end
stats_bar=statistical_tests(input)
set_significance_bar(v, bpos, stats_bar,3,10)
set(gca,'Fontsize',14)
subplot(1,4,3)
[v, var1, var2]=create_vector_for_boxplots(stats_good,stats_poor,{'mean_BM2'},1);
ystr= 'Rate [event/min]';
bpos=box_plot_two_groups_v2(v,2,ystr,'',[0.91 0.25 0.44; 0.91 0.25 0.44],0.5,0.1,'',30,12,1,0.5);
xticklabels({'Good','Poor'})
title('BM2')
vars_name={'Good','Poor'};
input=table(var1,var2);
input=splitvars(input);
for h=1:size(input,2)
    input.Properties.VariableNames{h} = vars_name{h};
end
stats_bar=statistical_tests(input)
set_significance_bar(v, bpos, stats_bar,3,10)
set(gca,'Fontsize',14)
subplot(1,4,4)
[v, var1, var2]=create_vector_for_boxplots(stats_good(stats_good.mean_BM3~=0,:),stats_poor(stats_poor.mean_BM3~=0,:),{'mean_BM3'},1);
ystr= 'Rate [event/min]';
bpos=box_plot_two_groups_v2(v,2,ystr,'',[0.13 0.45 0.65; 0.13 0.45 0.65],0.5,0.1,'',30,12,1,0.5);
title('BM3')
xticklabels({'Good','Poor'})
vars_name={'Good','Poor'};
input=table(var1,var2);
input=splitvars(input);
for h=1:size(input,2)
    input.Properties.VariableNames{h} = vars_name{h};
end
stats_bar=statistical_tests(input)
set_significance_bar(v, bpos, stats_bar,3,10)
set(gca,'Fontsize',14)
set(gcf, 'Position', [35,458,1473,304])

%% Piecharts
Events_good = readtable('Sample_Events_Good.xlsx');
Events_poor = readtable('Sample_Events_Poor.xlsx');
Events=[Events_good;Events_poor];
Events = table2dataset(Events);
sum([Events.BM1 Events.BM2 Events.BM3]);
sum([sum(Events.BM4) sum(Events.BM7) sum(Events.BM8) sum(Events.BM10)]);
sum([sum(Events.BM5) sum(Events.BM7) sum(Events.BM9) sum(Events.BM10)]);
sum([sum(Events.BM6) sum(Events.BM8) sum(Events.BM9) sum(Events.BM10)]);

figure; nexttile
pie([sum(Events.BM4) sum(Events.BM7) sum(Events.BM8) sum(Events.BM10)]); nexttile
pie([sum(Events.BM5) sum(Events.BM7) sum(Events.BM9) sum(Events.BM10)]); nexttile
pie([sum(Events.BM6) sum(Events.BM8) sum(Events.BM9) sum(Events.BM10)])


figure; nexttile
pie([sum(Events_good.BM4) sum(Events_good.BM7) sum(Events_good.BM8) sum(Events_good.BM10)]); nexttile
pie([sum(Events_good.BM5) sum(Events_good.BM7) sum(Events_good.BM9) sum(Events_good.BM10)]); nexttile
pie([sum(Events_good.BM6) sum(Events_good.BM8) sum(Events_good.BM9) sum(Events_good.BM10)])

figure; nexttile
pie([sum(Events_poor.BM4) sum(Events_poor.BM7) sum(Events_poor.BM8) sum(Events_poor.BM10)]); nexttile
pie([sum(Events_poor.BM5) sum(Events_poor.BM7) sum(Events_poor.BM9) sum(Events_poor.BM10)]); nexttile
pie([sum(Events_poor.BM6) sum(Events_poor.BM8) sum(Events_poor.BM9) sum(Events_poor.BM10)])

%% Circular BarPlot Patients
patients = [40 40 17 40 40 15 40 15 15 14];  
nbins = 10; 
thetaBins = linspace(-deg2rad(18),2*pi-deg2rad(18),nbins+1); 
figure
pax = polaraxes; 
hold(pax,'on')
colors = [1 1 0; 0 0 1;1 0 1;0.82 0.62 0.17;0.2 0.57 0.99;0.4 0.09 0.61;1 0 0;1 0.65 0;0 1 0;0 0.4 0.1];
faceColor = turbo(nbins);  % choose your face colors
for i = 1:numel(patients)
    polarhistogram(pax,'BinEdges',thetaBins(i:i+1),'BinCounts',patients(i), ...
        'FaceColor', colors(i,:), ...
        'FaceAlpha', 0.7) ... 
%         'EdgeColor','w')     
end
set(gca,'ThetaZeroLocation','top', 'ThetaDir','clockwise')
% polarhistogram(pax,'BinEdges',thetaBins,'BinCounts',patients)
labels = {'BM1','BM2','BM3', ...
'BM4', 'BM5', 'BM6', 'BM7', 'BM8', ...
'BM9', 'BM10'};
set(gca,'color','none','ThetaTick',0:36:360,'ThetaTickLabel',labels)
%% Part 2 - Fig. 2

Rates_good = readtable('Sample_Rates_Good.xlsx');
Rates_poor = readtable('Sample_Rates_Poor.xlsx');

stats_good = grpstats(Rates_good,"Patient","mean","DataVars",["BM4" "BM5" "BM6"]);
stats_poor = grpstats(Rates_poor,"Patient","mean","DataVars",["BM4" "BM5" "BM6"]);
stats_good = table2dataset(stats_good);
stats_poor = table2dataset(stats_poor);

figure
subplot(2,4,2)
[v, var1, var2]=create_vector_for_boxplots(stats_good,stats_poor,{'mean_BM4'},1);
ystr= 'Rate [event/min]';
bpos=box_plot_two_groups_v2(v,2,ystr,'',[1 0.75 0; 1 0.75 0],0.5,0.1,'',30,12,1,0.5);
xticklabels({'Good','Poor'})
title('BM4')
vars_name={'Good','Poor'};
input=table(var1,var2);
input=splitvars(input);
for h=1:size(input,2)
    input.Properties.VariableNames{h} = vars_name{h};
end
stats_bar=statistical_tests(input)
set_significance_bar(v, bpos, stats_bar,3,10)
set(gca,'Fontsize',14)


subplot(2,4,3)
[v, var1, var2]=create_vector_for_boxplots(stats_good,stats_poor,{'mean_BM5'},1);
ystr= 'Rate [event/min]';
bpos=box_plot_two_groups_v2(v,2,ystr,'',[0.91 0.25 0.44; 0.91 0.25 0.44],0.5,0.1,'',30,12,1,0.5);
xticklabels({'Good','Poor'})
title('BM5')
vars_name={'Good','Poor'};
input=table(var1,var2);
input=splitvars(input);
for h=1:size(input,2)
    input.Properties.VariableNames{h} = vars_name{h};
end
stats_bar=statistical_tests(input)
set_significance_bar(v, bpos, stats_bar,3,10)
set(gca,'Fontsize',14)

subplot(2,4,4)
[v, var1, var2]=create_vector_for_boxplots(stats_good(stats_good.mean_BM6~=0,:),stats_poor(stats_poor.mean_BM6~=0,:),{'mean_BM6'},1);
ystr= 'Rate [event/min]';
bpos=box_plot_two_groups_v2(v,2,ystr,'',[0.13 0.45 0.65; 0.13 0.45 0.65],0.5,0.1,'',30,12,1,0.5);
title('BM6')
xticklabels({'Good','Poor'})
vars_name={'Good','Poor'};
input=table(var1,var2);
input=splitvars(input);
for h=1:size(input,2)
    input.Properties.VariableNames{h} = vars_name{h};
end
stats_bar=statistical_tests(input)
set_significance_bar(v, bpos, stats_bar,3,10)
set(gca,'Fontsize',14)



stats_good = grpstats(Rates_good,"Patient","mean","DataVars",["BM7" "BM8" "BM9" "BM10"]);
stats_poor = grpstats(Rates_poor,"Patient","mean","DataVars",["BM7" "BM8" "BM9" "BM10"]);
stats_good = table2dataset(stats_good);
stats_poor = table2dataset(stats_poor);

subplot(2,4,5)
[v, var1, var2]=create_vector_for_boxplots(stats_good,stats_poor,{'mean_BM7'},1);
ystr= 'Rate [event/min]';
bpos=box_plot_two_groups_v2(v,2,ystr,'',[1 0.75 0; 1 0.75 0],0.5,0.1,'',30,12,1,0.5);
xticklabels({'Good','Poor'})
title('BM7')
vars_name={'Good','Poor'};
input=table(var1,var2);
input=splitvars(input);
for h=1:size(input,2)
    input.Properties.VariableNames{h} = vars_name{h};
end
stats_bar=statistical_tests(input)
set_significance_bar(v, bpos, stats_bar,3,10)
set(gca,'Fontsize',14)

subplot(2,4,6)
[v, var1, var2]=create_vector_for_boxplots(stats_good(stats_good.mean_BM8~=0,:),stats_poor(stats_poor.mean_BM8~=0,:),{'mean_BM8'},1);
ystr= 'Rate [event/min]';
bpos=box_plot_two_groups_v2(v,2,ystr,'',[1 0.75 0; 1 0.75 0],0.5,0.1,'',30,12,1,0.5);
xticklabels({'Good','Poor'})
title('BM8')
vars_name={'Good','Poor'};
input=table(var1,var2);
input=splitvars(input);
for h=1:size(input,2)
    input.Properties.VariableNames{h} = vars_name{h};
end
stats_bar=statistical_tests(input)
set_significance_bar(v, bpos, stats_bar,3,10)


subplot(2,4,7)
[v, var1, var2]=create_vector_for_boxplots(stats_good(stats_good.mean_BM9~=0,:),stats_poor(stats_poor.mean_BM9~=0,:),{'mean_BM9'},1);
ystr= 'Rate [event/min]';
bpos=box_plot_two_groups_v2(v,2,ystr,'',[0.91 0.25 0.44; 0.91 0.25 0.44],0.5,0.1,'',30,12,1,0.5);
xticklabels({'Good','Poor'})
title('BM9')
vars_name={'Good','Poor'};
input=table(var1,var2);
input=splitvars(input);
for h=1:size(input,2)
    input.Properties.VariableNames{h} = vars_name{h};
end
stats_bar=statistical_tests(input)
set_significance_bar(v, bpos, stats_bar,3,10)
set(gca,'Fontsize',14)
ylim([-0.001 0.06])

subplot(2,4,8)
[v, var1, var2]=create_vector_for_boxplots(stats_good(stats_good.mean_BM10~=0,:),stats_poor(stats_poor.mean_BM10~=0,:),{'mean_BM10'},1);
ystr= 'Rate [event/min]';
bpos=box_plot_two_groups_v2(v,2,ystr,'',[0.13 0.45 0.65; 0.13 0.45 0.65],0.5,0.1,'',30,12,1,0.5);
title('BM10')
xticklabels({'Good','Poor'})
vars_name={'Good','Poor'};
input=table(var1,var2);
input=splitvars(input);
for h=1:size(input,2)
    input.Properties.VariableNames{h} = vars_name{h};
end
stats_bar=statistical_tests(input)
set_significance_bar(v, bpos, stats_bar,3,10)
set(gca,'Fontsize',14)
set(gcf, 'Position', [85,131,1473,630])

