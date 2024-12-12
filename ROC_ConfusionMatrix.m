function [ROC_DB] = ROC_ConfusionMatrix(n_th,real_class,score)

% n_th is number of thresholds
% real class is the true label (i.e. outcome)
% score is the predictor value (i.e. biomarker rate)

answer = questdlg('Do you want adaptive thresholds?', ...
'Adaptive threshold', ...
'Yes','No','Yes');
switch answer
case 'Yes'
[X,Y,thresholds,AUC,opt] = perfcurve(logical(real_class),score,true);
case 'No'
thresholds=linspace(0,1,n_th);
end



ROC_DB=dataset;



for i=1:length(thresholds)

ROC_DB.threshold(i,1) = thresholds(i);
ROC_DB.TP(i,1) = sum(score>=thresholds(i) & real_class==1);
ROC_DB.TN(i,1) = sum(score<thresholds(i) & real_class==0);
ROC_DB.FP(i,1) = sum(score>=thresholds(i) & real_class==0);
ROC_DB.FN(i,1) = sum(score<thresholds(i) & real_class==1);
ROC_DB.SENS(i,1) = ROC_DB.TP(i,1)/(ROC_DB.TP(i,1)+ROC_DB.FN(i,1));
ROC_DB.SPEC(i,1) = ROC_DB.TN(i,1)/(ROC_DB.TN(i,1)+ROC_DB.FP(i,1));
ROC_DB.FPR(i,1) = ROC_DB.FP(i,1)/(ROC_DB.TN(i,1)+ROC_DB.FP(i,1));
ROC_DB.PPV(i,1) = ROC_DB.TP(i,1)/(ROC_DB.TP(i,1)+ROC_DB.FP(i,1));
ROC_DB.NPV(i,1) = ROC_DB.TN(i,1)/(ROC_DB.TN(i,1)+ROC_DB.FN(i,1));
ROC_DB.ACC(i,1) = (ROC_DB.TP(i,1)+ROC_DB.TN(i,1))/(ROC_DB.TP(i,1)+ROC_DB.TN(i,1)+ROC_DB.FP(i,1)+ROC_DB.FN(i,1));
ROC_DB.J(i,1) = ROC_DB.SENS(i,1) + ROC_DB.SPEC(i,1) - 1;

end



answer = questdlg('What method do you want for selecting threshold?', ...
'Best threshold', ...
'Max J','Min Fisher','Min Fisher');
switch answer
case 'Max J'
[~, ind_opt_th]=max(ROC_DB.J);
case 'Min Fisher'
for i=1:numel(thresholds)
x_thr=score>=thresholds(i);
[tbl] = crosstab(x_thr,real_class);
if size(tbl,1)>1 && size(tbl,2)>1
[~,p_fish(i,1)] = fishertest(tbl);
else
p_fish(i,1)=nan;
end
end
ind_opt_th=find(p_fish==min(p_fish));
end



[~, ind_opt_th]=max(ROC_DB.J);
ROC_DB.threshold(ind_opt_th)
ROC_DB.AUC = trapz(ROC_DB.FPR,ROC_DB.SENS)*ones(length(ROC_DB),1);
if ROC_DB.SENS(ROC_DB.threshold==100,1) ~= 0
ROC_DB.SENS(ROC_DB.threshold==100,1)=0;
end




ft = fittype( '1-1/((1+(x*C)^B)^E)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [0 0 0];
opts.Robust = 'Bisquare';
opts.StartPoint = [1 0.5 1];
opts.Upper = [Inf 1 Inf];
rocfit = fit(ROC_DB.FPR,ROC_DB.SENS,ft,opts);
myfun=@(x,rf) -((rf(2)./x)^(-rf(1)) + 1)^(-rf(3)) - x + 1 ;
cross=fzero(@(x) myfun(x,coeffvalues(rocfit)),1);
xfit=linspace(0,1,500);
yfit=rocfit(xfit);
clear ft opt
Area=trapz(xfit,yfit); %estimate the area under the curve
Area2=Area^2; Q1=Area/(2-Area); Q2=2*Area2/(1+Area);
lu=sum(real_class==0); %number of unhealthy subjects
lh=sum(real_class==1); %number of healthy subjects
V=(Area*(1-Area)+(lu-1)*(Q1-Area2)+(lh-1)*(Q2-Area2))/(lu*lh);
Serror=realsqrt(V);
alpha=0.05; %significance level (default 0.05)
ci=Area+[-1 1].*(realsqrt(2)*erfcinv(alpha)*Serror);
SAUC=(Area-0.5)/Serror; %standardized area
p=1-0.5*erfc(-SAUC/realsqrt(2)); %p-value




figure
subplot(1,3,1)
cm = confusionchart(real_class,double(score>=ROC_DB.threshold(ind_opt_th)));

subplot(1,3,2)%(1,2,1)
plot(ROC_DB.FPR,ROC_DB.SENS,'LineWidth',1.5)
hold on
plot(linspace(0,1,n_th),linspace(0,1,n_th),'k','LineWidth',0.5)
plot(xfit,yfit,'marker','none','linestyle','-','color','k','linewidth',1.5);
plot(ROC_DB.FPR(ind_opt_th,1),ROC_DB.SENS(ind_opt_th,1),'*r');
plot([ROC_DB.FPR(ind_opt_th,1) ROC_DB.FPR(ind_opt_th,1)],[ROC_DB.FPR(ind_opt_th,1) ROC_DB.SENS(ind_opt_th,1)],'--r')
ylabel('Sensitivity (TPR)'); xlabel('1-Specificity (FPR)')
title(strcat('AUC = ',{' '}, num2str(abs(round(ROC_DB.AUC(1,1),2))), ',', {' '}, 'th =', {' '},num2str(ROC_DB.threshold(ind_opt_th,1)),'%'))



subplot(1,3,3)%(1,2,2)
bar([ROC_DB.SENS(ind_opt_th,1),ROC_DB.SPEC(ind_opt_th,1),...
ROC_DB.PPV(ind_opt_th,1),ROC_DB.NPV(ind_opt_th,1),...
ROC_DB.ACC(ind_opt_th,1),ROC_DB.J(ind_opt_th,1)])
name = {'SENS';'SPEC';'PPV';'NPV';'ACC';'J'};
ylim([0 1])
set(gca,'xticklabel',name)




scores = mdl_ieeg.Fitted.Probability;
[X,Y,T,AUC_log] = perfcurve(logical(y),scores,true,'Nboot',5000);AUC_log