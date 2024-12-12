clc
close all
data = readtable('Sample_Area_Size.xlsx');
pat = unique(data.Patient);
summary = {};
%% Compute area size

for i=1:1:length(pat)

set = data(find(strcmp(string(data.Patient),string(pat(i,1))) ==1),:);
HFO_size = size(find(set.BM2 > 0),1);
AllS_size = size(find(set.BM1 > 0),1);
S_R_size = size(find(set.BM4 > 0),1);
FR_size = size(find(set.BM3 > 0),1);
SOZ_size = size(find(set.SOZ),1);
Res_size = size(find(set.Resected),1);
summary{i,1} = set.Patient(1,1);
summary{i,2} = HFO_size;
summary{i,3} = S_R_size;
summary{i,4} = AllS_size;
summary{i,5} = FR_size;
summary{i,6} = SOZ_size;
summary{i,7} = Res_size;
end

% save summary as a table
%%  testing here

data = readtable('Output_Area_Size.xlsx');
% each area should be normalized by dividing by the total number of
% channels implanted for that patient
[p,h,stats] = ranksum(data.ResSizeNorm,data.RippleSizeNorm)

%% comparison of all areas by kruskal wallis

[p,tbl,stats] = kruskalwallis([data.AllSSizeNorm;data.RippleSizeNorm;data.FastRippleSizeNorm;data.S_RSizeNorm;data.SOZSizeNorm;data.ResSizeNorm],[ones(size(data.AllSSizeNorm)); ...
    2*ones(size(data.RippleSizeNorm)); 3*ones(size(data.FastRippleSizeNorm)); 4*ones(size(data.S_RSizeNorm)); 5*ones(size(data.SOZSizeNorm));6*ones(size(data.ResSizeNorm))])
xticklabels({'AllS','AllR','AllFR','S_R','SOZ','Res'})
figure
c = multcompare(stats,"CriticalValueType","bonferroni")















