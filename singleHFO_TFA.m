function [output,hfo_frequency,tfa_check, tfa]= singleHFO_TFA (hfo_sig, HFmin, HFmax, min_dur,samF,side_wind,wavelet)

T=(1:size(hfo_sig,2))/samF;


if strcmp(wavelet,'morlet')
    fc=1; %1 is default
    FWHM_tc=5; %3 is default
    squared='y'; %'y' is default (=yes), otherwise 'n'
    F=1:HFmax;
    P_morlet= morlet_transform(hfo_sig,T,F,fc,FWHM_tc,squared);
    P=squeeze(P_morlet)';
    %maximum in power in the HFO frequency band (between +-50ms)
    HFOmax=max(max(P(HFmin:HFmax,side_wind:end-side_wind)));
end
if strcmp(wavelet,'morse')
    gamma=40;
    beta=4;
    [P_morse,Fout]= morse_transform(hfo_sig,1,HFmax,gamma,beta,samF);
    F=sort(Fout);
    P=P_morse';
    P=fliplr(P')';
    i_hfo= F>=HFmin & F<=HFmax;
    HFOmax=max(max(P(i_hfo,side_wind:end-side_wind)));
%     createfigureTOT(T,hfo_sig,T,sig_BP, T, F, P,min(min(P)),HFOmax);
end


P_orig=P;
P=P/HFOmax;
tfa.P=P;
tfa.T=T;
tfa.F=F;
% % %
% sig_BP=data_filt(ch,x1:x2);
% createfigureTOT(T,hfo_sig,T,sig_BP, T, Fout, P,0,1);
% subplot(3,1,2);
% hold on;
% plot([T(side_wind),T(end-side_wind)],[sig_BP(side_wind),sig_BP(end-side_wind)],'r*');
% plot(T(pk_ind),sig_BP(pk_ind),'r*');

% % %
hfo_width=numel(hfo_sig-2*side_wind);
t1=side_wind;
for j=1:hfo_width-2*side_wind
    pw=P(:,t1+j); %power for j-th time point
    pw(1)=0;
    [pk1, pk2]=findpeaks(pw); %%peaks in the PSD
    
    if ~isempty(pk2(F(pk2)>=HFmin-10)) %we also consider peaks up to HFmin minus a tollerance of 4 Hz (es. HFmin=80Hz -> 70Hz)
        ind_hf=F(pk2)>=HFmin-10;
        hf_fr=pk2(ind_hf);
        [HFPpw,fr_ind]=max(pk1(ind_hf)); %find the High Freq PEAK (HFP) (> HFmin minus a tollerance, es. 70 Hz)
        HFPfr=F(hf_fr(fr_ind));
        if round(HFPpw*10)/10>0.6
            % % Find trough before the HFP
            ind_tr=find(F<HFPfr & F>40);
            [tr1, tr2]=findpeaks(-pw(ind_tr));
            
            if ~isempty(tr1)
                tr_fr=F(ind_tr);
                [TRpw,tr_ind]=min(-tr1); %find the trough (>40 Hz)
                TRfr=tr_fr(tr2(tr_ind));
                if round(TRpw*10)/10<0.5
                    HF_peak(j,1)=1;
                    hf_frequency(j,1)=HFPfr;
                    time(j,1)=T(t1+j-1);
                    hf_power(j,1)=HFPpw;
                    tr_power(j,1)=TRpw;
                else
                    HF_peak(j,1)=0;
                    hf_frequency(j,1)=HFPfr;
                    time(j,1)=T(t1+j-1);
                    hf_power(j,1)=HFPpw;
                    tr_power(j,1)=TRpw;
                end
            else
                HF_peak(j,1)=0;
                hf_frequency(j,1)=HFPfr;
                time(j,1)=T(t1+j-1);
                hf_power(j,1)=HFPpw;
                tr_power(j,1)=NaN;
            end
        else
            HF_peak(j,1)=0;
            hf_frequency(j,1)=HFPfr;
            time(j,1)=T(t1+j-1);
            hf_power(j,1)=HFPpw;
            tr_power(j,1)=NaN;
        end
    else
        HF_peak(j,1)=0;
        hf_frequency(j,1)=NaN;
        time(j,1)=T(t1+j-1);
        hf_power(j,1)=NaN;
        tr_power(j,1)=NaN;
    end
end
min_wind=round(min_dur*samF);
mov_intervals=smooth(HF_peak,min_wind);
mov_intervals(1:round(min_wind/2)-1)=0;
mov_intervals(end-round(min_wind/2)+2:end)=0;
island1=find(round(mov_intervals*10)==10);
island_ind=[];
if ~isempty(island1)
    i=island1(1)-round(min_wind/2)+1;
    if i<1
        i=1;
    end
    while ~isempty(i)
        ind1=i;
        ind2=ind1+min_wind-1;
        if ind2>numel(HF_peak)
            ind2=numel(HF_peak);
            island_ind=[island_ind; (ind1:ind2)'];
            break;
        end
        island_ind=[island_ind; (ind1:ind2)'];
        i=island1(find(island1>ind2-round(min_wind/2)+1,1));
    end
    island_ind=unique(island_ind);
end
island=zeros(size(HF_peak));
island(island_ind)=1;
island(island==1 & HF_peak==0)=0;

if numel(nonzeros(island))>=min_wind
    output=1;
    hfo_frequency=mean(hf_frequency(island==1));
else
    output=0;
    hfo_frequency=NaN;
end

tfa_check=dataset(HF_peak,hf_frequency,hf_power,tr_power,island,time);

end

% if numel(nonzeros(HF_peak))/samF>=min_dur
