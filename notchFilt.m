function [sf]=notchFilt(sig,fnotch,samF)
% [sf]=notchFilt(sig,fnotch,samF)
%fnotch: vector with the frequencies to eliminate through the notch filter

for i=1:numel(fnotch)
    f=fnotch(i);
    wo = f/(samF/2);
    bw = wo/35;
    [b,a] = iirnotch(wo,bw);
    
    sf=filtfilt(b,a,sig);
    sig=sf;
end