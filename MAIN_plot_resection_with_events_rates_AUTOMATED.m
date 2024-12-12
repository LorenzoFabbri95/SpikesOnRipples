%% selecting patient of interest

path = 'insert brainstorm anatomy folder address here';
cd(path);
patients = [dir('patient code here*')];
list = {};
for i = 1:length(patients)
    list{i,1} = patients(i).name;
end
[SELECTED,tf] = listdlg('PromptString','Choose patient of interest:',...
    'SelectionMode','multiple',...
    'ListString',list,'ListSize',[250,250],'InitialValue',[1]);

%% selecting excel file for rates, removing bad channels and reordering
% select excel file to open
workspace_path=uigetdir('Insert path here');
cd ([workspace_path]);
handles.filename=uigetfile('*.xlsx');
filename=handles.filename;
data = readtable(filename);
% go in brainstorm and  export channel file as channel_file_BS
Ch_Name = {channel_file_BS.Channel.Name}';
Ch_Type = {channel_file_BS.Channel.Type}';
Ch_Loc = {channel_file_BS.Channel.Loc}';
Ch_iEEG=Ch_Name(strcmp(Ch_Type,'ECOG')|strcmp(Ch_Type,'SEEG'));
Ch_Loc=Ch_Loc(strcmp(Ch_Type,'ECOG')|strcmp(Ch_Type,'SEEG'));
loc=[];
for i=1:size(Ch_Loc,1)
    loc(i,:)=Ch_Loc{i}';
end
% this part automatically removed bad channels or channels in the channel
% file that did not have any events
Channels = data.Channels;
prova = [];
for j = 1:1:length(Ch_iEEG)
    if sum(string(Ch_iEEG(j)) == string(Channels)) == 1
        prova(j) = 1;
    else prova(j) = 0;
    end
end
prova = prova';
Ch_iEEG(find(prova == 0)) = [];
Ch_Loc(find(prova == 0)) = [];
% reordering channels to match the list from the channel file
real_spot = []
for j = 1:1:length(Ch_iEEG)
    common_Ch = find(string(Channels(j)) == string(Ch_iEEG))
    real_spot(j) = common_Ch;
end
data_new = data
for k = 1:1:length(real_spot)
    data(real_spot(k),:) = data_new(k,:)
end
%% select cortex to open
% this part requires a cortex plot from brainstorm previosuly saved as .fig
workspace_path=uigetdir('Insert address here');
cd ([workspace_path]);
handles.filename=uigetfile('*.fig');
filename=handles.filename;

%% Need to list here all the BM for the selected patient
biomarkers = data.Properties.VariableNames;
biomarkers = biomarkers(1,2:end-2);
% set colors here
colors = {[1 1 0],[0 0 1],[0.72 0.28 1],[1 1 0],[0 0 1],[0.72 0.28 1],[1 0 0],[1 0.41 0.16],[0.6 0.95 1],[1 0 1],[1 0 0.5]};

for i=1:length(biomarkers)
    BM = biomarkers(i)
    BM1 = data(:,BM);
    BM1 = table2array(BM1);
    if sum(BM1) ~= 0
        to_use = find(strcmp(BM,string(biomarkers)) == 1);
        ind1 = find(BM1 > 0);
        BM1 = BM1(ind1);
        Ch_Loc_BM1 = Ch_Loc(ind1);
        BM1_max = max(BM1);
        BM1_norm = BM1 / BM1_max;
        for i = 1:1:length(Ch_Loc_BM1)
            Ch_Loc_BM1{i,1} = reshape(Ch_Loc_BM1{i,1},[1,3]);
        end
        x_BM1 = []; y_BM1 = []; z_BM1 = [];
        for j = 1:1:length(Ch_Loc_BM1)
            x_BM1(j,1) = Ch_Loc_BM1{j,1}(1);
            y_BM1(j,1) = Ch_Loc_BM1{j,1}(2);
            z_BM1(j,1) = Ch_Loc_BM1{j,1}(3);
        end
        cd 'Insert address of cortex file here'
        fig = openfig(filename)
        for i = 1:1:length(BM1)
            color = cell2mat(colors(to_use));
            hold on
            scatter3sph(x_BM1(i), y_BM1(i), z_BM1(i),'size',BM1_norm(i)*0.005,'color',repmat(color,size(BM1)),'transp',1)
        end
        h = split(string(filename),{'_'})
        saveas(fig,strcat(h(1),string(BM)),'fig') % saves all plots in current folder
        close all
    else
    end
end



