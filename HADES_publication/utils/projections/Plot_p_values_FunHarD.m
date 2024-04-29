function [h] = Plot_p_values_FunHarD(P_pval,rangeK,measure,cnd1,cnd2)

    semilogy(rangeK(1)-1:rangeK(end)+1,0.05*ones(1,length(rangeK)+2),'r--','LineWidth',1);
    hold on
    semilogy(rangeK(1)-1:rangeK(end)+1,0.05./(rangeK(1)-1:rangeK(end)+1).*ones(1,length(rangeK)+2),'g--','LineWidth',1);
    semilogy(rangeK(1)-1:rangeK(end)+1,0.05./sum(rangeK)*ones(1,length(rangeK)+2),'b--','LineWidth',1)
    
    P_pval(1,:) = []; % important so one can plot the full rangeK
    for k=1:length(rangeK)
        for c=1:rangeK(k)        
            if P_pval(k,c)>0.05
                semilogy(rangeK(k),P_pval(k,c),'xk');
                text(rangeK(k),P_pval(k,c),[' ' num2str(c)])
            end
            if P_pval(k,c)<0.05 && P_pval(k,c)>(0.05/rangeK(k))
                semilogy(rangeK(k),P_pval(k,c),'xr');
                text(rangeK(k),P_pval(k,c),[' ' num2str(c)])
            end
            if P_pval(k,c)<(0.05/rangeK(k)) && P_pval(k,c)>(0.05/sum(rangeK))
                semilogy(rangeK(k),P_pval(k,c),'xg');
                text(rangeK(k),P_pval(k,c),[' ' num2str(c)])
            end
            if P_pval(k,c)<=(0.05/sum(rangeK))
                semilogy(rangeK(k),P_pval(k,c),'xb');
                text(rangeK(k),P_pval(k,c),[' ' num2str(c)])
            end
        end
    end
    if nargin>4
        title([measure ' ' cnd1 ' vs ' cnd2], 'Interpreter', 'none')
    end;
    ylabel('Difference (p-value)')
    xlabel('# of Functional Harmonics (FH)')
    xlim([rangeK(1) rangeK(end)+1])
    box off;axis square
end

