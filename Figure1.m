% export channel file from brainstorm as "channel_file_BS" with channel
% locations, export data previously imported into database as "data".
clearvars -except data channel_file_BS
clc
%%% Channels location extraction from brainstorm file
ch_name = {channel_file_BS.Channel.Name}.';
ch_type = {channel_file_BS.Channel.Type}.';
ind=[1:1:length(ch_type)]';
ch_ind=ind(strcmp(ch_type,'ECOG')|strcmp(ch_type,'SEEG'));
channels_iEEG=dataset;
channels_iEEG.label=ch_name(strcmp(ch_type,'ECOG')|strcmp(ch_type,'SEEG'));
data.F(1,:)=[];
[ch_selected,~] = listdlg('PromptString','Select Channels to plot:',...
    'SelectionMode','multiple',...
    'ListString',channels_iEEG.label);
labels_selected=channels_iEEG(ch_selected,:);
channels = {channel_file_BS.Channel(ch_ind).Name}.';
times=data.Time;
data0=data.F(ch_selected,:);  
samF = 1/(times(2)-times(1));

%% %% Apply average montage and Signal pre-processing
av_ch=mean(data0);
data_av=data0-av_ch;
data0=data_av;
montage='Average';
clear data_av
data_filt_s=bandpassFilter(data0,samF,1,70);
data_filt_r = bandpassFilter(data0,samF,80,250);
data_filt_fr = bandpassFilter(data0,samF,250,500);
Hilbert_r=abs(hilbert(data_filt_r));
Hilbert_fr=abs(hilbert(data_filt_fr));

%% Time Frequency analysis
win=0.2;
[output_r, hfo_frequency_r, tfa_check_k_r, tfa_k_r] = ...
    singleHFO_TFA(data0,80,250,4/250,samF,round(0.05*samF),'morse');
[output_fr, hfo_frequency_fr, tfa_check_k_fr, tfa_k_fr] = ...
    singleHFO_TFA(data0,250,500,4/500,samF,round(0.05*samF),'morse');

%% Plotting separately 

figure
fig1 = plot(times,data0)
title('Raw Data')
xlim([-0.15, 0.15]);
[up2,lo2] = envelope(data_filt_r);
std2 = std(data_filt_r);
STD2 = data_filt_r;
STD2(1,:) = std2;
fig2 = figure
plot(times,data_filt_r)
title('Ripple Frequency band [80-250 Hz]')
xlim([-0.15, 0.15]);
hold on
plot(times,up2)
hold on
plot(times,STD2*2.5)
[up3,lo3] = envelope(data_filt_fr);
std3 = std(data_filt_fr)
STD3 = data_filt_fr;
STD3(1,:) = std3;
fig3 = figure
plot(times,data_filt_fr)
title('Fast Ripple Frequency band [250-500 Hz]')
xlim([-0.15, 0.15]);
hold on
plot(times,up3)
hold on
plot(times,STD3*2.5)
fig4 = figure
surf(tfa_k_r.T-win, tfa_k_r.F, tfa_k_r.P,'EdgeColor','none');
view(0,90);
set(get(gca,'ylabel'), 'Rotation',0, 'VerticalAlignment','middle','HorizontalAlignment','right')
xlim([-0.15, 0.15]);  
ylim([50,250])
colormap(jet)
colorbar
fig5 = figure
surf(tfa_k_fr.T-win, tfa_k_fr.F, tfa_k_fr.P,'EdgeColor','none');
view(0,90);
set(get(gca,'ylabel'), 'Rotation',0, 'VerticalAlignment','middle','HorizontalAlignment','right')
xlim([-0.15, 0.15]);  
ylim([250,500])
colormap(jet)
colorbar









  

