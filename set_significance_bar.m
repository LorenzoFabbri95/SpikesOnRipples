function set_significance_bar(v, pos, results_stats,digit,fontsize)
max_val=max(max(v));
min_val=min(min(v));
scale = 6*max_val/100;
scale2 = scale - 2*scale/3;
scale3 = 10*scale/3;
num_sign_val=1;
upper_bound=max_val+(scale3*(num_sign_val+1));
yrange=ylim;
ytickp=yticks;

for nn=1:size(results_stats,1)
    if results_stats.p_values(nn,1)<0.05
        p = results_stats.p_values(nn,1);
        connect1 = results_stats.comp1(nn,1);
        connect2 = results_stats.comp2(nn,1);
        str(1,nn)=strcat('p', num2str(connect1),num2str(connect2), {' '},'=',{' '},num2str(round(p,digit)));
        hold on
        plot([pos(connect1) pos(connect2)],[(max_val+(nn*scale)) (max_val+(nn*scale))],'LineWidth',1,'Color','k')
%         plot([pos(connect1) pos(connect1)],[(max_val+(nn*scale)) (max_val+(nn*scale))-scale2],'LineWidth',1,'Color','r')
%         plot([pos(connect2) pos(connect2)],[(max_val+(nn*scale)) (max_val+(nn*scale))-scale2],'LineWidth',1,'Color','r')
        %text((pos(b(nn))+pos(a(nn)))/2,(max_val+(nn*scale)),str(1,nn),'HorizontalAlignment','center')%,'FontSize', fontsize)
        text((pos(connect2)+pos(connect1))/2,(max_val+(2.5*scale2/2)+(nn*scale)),'*','HorizontalAlignment','center','Color','k','FontName','Times New Roman','FontSize', fontsize)
        ylim([yrange(1) upper_bound])
        yticks(ytickp)
        
    end
    p = results_stats.p_values(nn,1);
    connect1 = results_stats.comp1(nn,1);
    connect2 = results_stats.comp2(nn,1);
    str(1,nn)=strcat('p', num2str(connect1),num2str(connect2), {' '},'=',{' '},num2str(round(p,digit)));
end
% str1=str([1 2 4]);
% title(strjoin(str1,', '))%  ylabel(strjoin(str,', '))

