%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: p4_HADES_DMT_spatiotemporal_analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% This script calculates the spatio-temporal analysis
%
% Inputs:
%   FH projections   - DMT_Projections_denseFC_DOT
%
% Outputs:
%   mean/std.dev. relative contribution       = absolute mean/std.dev. over time of FH
%       contributions normlaised by total contribution of a given subject and condition
%   mean/std.dev. absolute contribution       = absolute mean/std.dev. over time of FH
%       contributions
%
% Author: Jakub Vohryzek, jakub.vohryzek@upf.edu, 19/04/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Decision Tree
analysisOption            = 'absolute_analysis'; % 'relative_analysis', 'absolute_analysis'
numFH                   = 11;
GS                      = 1 % 1 yes global signal (for rel. and abs. powerr), 2 no global signal (for LEiDA)

%% color template for the dataset

lcolor = [0.2147 0.4324 0.7575
          0.9058 0.0975 0.9649
          0.1570 0.3585 0.3576
          0.1034 0.2569 0.2706];

%% creating labels
cndName          = {'DMT_pre','DMT_post1','PCB_pre','PCB_post1'};
cndNameExtract   = {'DMT_pre_norm','DMT_post1_norm','PCB_pre_norm','PCB_post1_norm'};
numCnd           = size(cndName,2);
Labels           = ['Global' "FH" + (1:numFH+1)];

%% loading dmt dataset
load('/Users/jakub/Matlab/Collaboration_Kringelbach/HADES/DMT/Results/DMT_Projections_denseFC_DOT.mat')

%% data structure transformation
for m = 1:4
    projection_tmp(m,:,:,:) = abs(Projections.(cndNameExtract{m})(:,:,GS:numFH+1)); % [cnd x sbj x FH x time]
end
clear m
projections = permute(projection_tmp, [1 2 4 3]); % [cnd x sbj x time x FH] swapping time and FH dimensions for the analysis
%% calculating absolute and relative contributions
for m=1:4
    for i=1:17
        cont_rel_mean(m,i,:) = mean(squeeze(projections(m,i,:,:)),2)./sum(mean(squeeze(projections(m,i,:,:)),2));
        cont_rel_std(m,i,:) = std(squeeze(projections(m,i,:,:)),0,2)./sum(std(squeeze(projections(m,i,:,:)),0,2));

        cont_abs_standard_mean(m,i,:) = mean(squeeze(projections(m,i,:,:)),2);
        cont_abs_standard_std(m,i,:) = std(squeeze(projections(m,i,:,:)),0,2);
    end
end
clear m i
%% 
switch analysisOption
    case 'relative_analysis'

%% statistics
    for fh = 1:numFH+1
        
        % Compare FH contributions averaged across time (mean)
        a = mean(squeeze(cont_rel_mean(1,:,fh)),1)';  % Vector containing mean relative contribution in DMT pre
        b = mean(squeeze(cont_rel_mean(2,:,fh)),1)';  % Vector containing mean relative contribution in DMT post
        [H_FHcont_pval_cnd12(1,fh) P_FHcont_pval_cnd12(1,fh)] = ttest(a,b);
        
        a = mean(squeeze(cont_rel_mean(3,:,fh)),1)';  % Vector containing mean relative contribution in PCB pre
        b = mean(squeeze(cont_rel_mean(4,:,fh)),1)';  % Vector containing mean relative contribution in PCB post
        [H_FHcont_pval_cnd34(1,fh) P_FHcont_pval_cnd34(1,fh)] = ttest(a,b);
        
        a = mean(squeeze(cont_rel_mean(2,:,fh)),1)';  %Vector containing mean relative contribution in DMT post
        b = mean(squeeze(cont_rel_mean(4,:,fh)),1)';  % Vector containing mean relative contribution in PCB post
        [H_FHcont_pval_cnd24(1,fh) P_FHcont_pval_cnd24(1,fh)] = ttest2(a,b);
        
        % Compare FH contributions averaged across time (std. dev.)
        a = mean(squeeze(cont_rel_std(1,:,fh)),1)';  % Vector containing std relative contribution in DMT pre
        b = mean(squeeze(cont_rel_std(2,:,fh)),1)';  % Vector containing std relative contribution in DMT post
        [H_FHcont_pval_cnd12(2,fh) P_FHcont_pval_cnd12(2,fh)] = ttest(a,b);
        
        a = mean(squeeze(cont_rel_std(3,:,fh)),1)';  % Vector containing std relative contribution in PCB pre
        b = mean(squeeze(cont_rel_std(4,:,fh)),1)';  % Vector containing std relative contribution in PCB post
        [H_FHcont_pval_cnd34(2,fh) P_FHcont_pval_cnd34(2,fh)] = ttest(a,b);
        
        a = mean(squeeze(cont_rel_std(2,:,fh)),1)';  % Vector containing std relative contribution in PCB post
        b = mean(squeeze(cont_rel_std(4,:,fh)),1)';  % Vector containing std relative contribution in DMT post
        [H_FHcont_pval_cnd24(2,fh) P_FHcont_pval_cnd24(2,fh)] = ttest2(a,b);
        
    end
    clear fh
    %% relative power distributions
    
    h_results = figure
    colormap(jet)    
    
    for c = 1:numFH+1
            subplot(2,numFH+1,c)  
            DMTpre   = squeeze(cont_rel_mean(1,:,c));
            DMTpost1 = squeeze(cont_rel_mean(2,:,c));
            PCBpre   = squeeze(cont_rel_mean(3,:,c));
            PCBpost1 = squeeze(cont_rel_mean(4,:,c));
            bar(1,mean(DMTpre)','EdgeColor','w','FaceColor',lcolor(1,:))
            hold on
            bar(2,mean(DMTpost1),'EdgeColor','w','FaceColor',lcolor(2,:))
            hold on
            bar(3,mean(PCBpre),'EdgeColor','w','FaceColor',lcolor(3,:))
            hold on
            bar(4,mean(PCBpost1),'EdgeColor','w','FaceColor',lcolor(4,:))
            errorbar([mean(DMTpre) mean(DMTpost1) mean(PCBpre) mean(PCBpost1)],...
                [std(DMTpre)/sqrt(numel(DMTpre)) std(DMTpost1)/sqrt(numel(DMTpost1)) std(PCBpre)/sqrt(numel(PCBpre)) std(PCBpost1)/sqrt(numel(PCBpost1))],'LineStyle','none','Color','k')
            if P_FHcont_pval_cnd12(1,c)<(0.05/(numFH+1))
                plot(1.5,max([mean(DMTpre) mean(DMTpost1)])+.01,'*r')
            elseif P_FHcont_pval_cnd12(1,c)<(0.05)
                plot(1.5,max([mean(DMTpre) mean(DMTpost1)])+.01,'*k')
            end 
            if P_FHcont_pval_cnd34(1,c)<(0.05/(numFH+1))
                plot(3.5,max([mean(PCBpre) mean(PCBpost1)])+.01,'*r')
            elseif P_FHcont_pval_cnd34(1,c)<(0.05)
                plot(3.5,max([mean(PCBpre) mean(PCBpost1)])+.01,'*k')
            end 
             if P_FHcont_pval_cnd24(1,c)<(0.05/(numFH+1))
                plot(3,max([mean(PCBpre) mean(PCBpost1)])+.02,'*r')
             elseif P_FHcont_pval_cnd24(1,c)<(0.05)
                plot(3,max([mean(PCBpre) mean(PCBpost1)])+.02,'*k')
            end   
            if c==1
                ylabel('Mean FH contribution')
            end
            box off
            ylim([0 0.4]);set(gca,'xtick',[]);
            subplot(2,numFH+1,c+numFH+1)  
    
            
            DMTpre   = mean(squeeze(cont_rel_std(1,:,c)),1);
            DMTpost1 = mean(squeeze(cont_rel_std(2,:,c)),1);
            PCBpre   = mean(squeeze(cont_rel_std(3,:,c)),1);
            PCBpost1 = mean(squeeze(cont_rel_std(4,:,c)),1);
            bar(1,mean(DMTpre),'EdgeColor','w','FaceColor',lcolor(1,:))
            hold on
            bar(2,mean(DMTpost1),'EdgeColor','w','FaceColor',lcolor(2,:))
            hold on
            bar(3,mean(PCBpre),'EdgeColor','w','FaceColor',lcolor(3,:))
            hold on
            bar(4,mean(PCBpost1),'EdgeColor','w','FaceColor',lcolor(4,:))
            errorbar([mean(DMTpre) mean(DMTpost1) mean(PCBpre) mean(PCBpost1)],...
                [std(DMTpre)/sqrt(numel(DMTpre)) std(DMTpost1)/sqrt(numel(DMTpost1)) std(PCBpre)/sqrt(numel(PCBpre)) std(PCBpost1)/sqrt(numel(PCBpost1))],'LineStyle','none','Color','k')
            if P_FHcont_pval_cnd12(2,c)<(0.05/(numFH+1))
                plot(1.5,max([mean(DMTpre) mean(DMTpost1)])+.01,'*r')
            elseif P_FHcont_pval_cnd12(2,c)<(0.05)
                plot(1.5,max([mean(DMTpre) mean(DMTpost1)])+.01,'*k')
            end 
            if P_FHcont_pval_cnd34(2,c)<(0.05/(numFH+1))
                plot(3.5,max([mean(PCBpre) mean(PCBpost1)])+.01,'*r')
            elseif P_FHcont_pval_cnd34(2,c)<(0.05)
                plot(3.5,max([mean(PCBpre) mean(PCBpost1)])+.01,'*k')
            end 
             if P_FHcont_pval_cnd24(2,c)<(0.05/(numFH+1))
                plot(3,max([mean(PCBpre) mean(PCBpost1)])+.02,'*r')
             elseif P_FHcont_pval_cnd24(2,c)<(0.05)
                plot(3,max([mean(PCBpre) mean(PCBpost1)])+.02,'*k')
            end   
            if c==1
                ylabel('Std.dev FH contribution')
            end
            box off
            ylim([0 0.4])
            set(gca,'XTick',1:4,'XTickLabel',{'Before DMT', ' After DMT','Before PCB', ' After PCB'});xtickangle(45)
    
    end
    
    %% FIGURE: spider plot of FH weights normalised by subject sum of # FH and averaged across timepoints
    
    import chart.Spider
    Data = squeeze(mean(cont_rel_mean,2))';
    f_mean = figure               
    
    SP = Spider( 'Parent', f_mean, ...
        'Data', Data, 'Labels', Labels(1:size(Data,1)));
    SP.TargetData = 0 * ones( numFH+1, 1 );
    
    SP.Title.FontSize           = 20;
    SP.Marker                   = '.';
    SP.MarkerSize               = 10.0;
    SP.MarkerFaceColor          = 'none';
    SP.LineWidth                = 2.0;
    SP.LineWidthMultiplier      = 4.0;
    SP.LegendText               = {'DMT pre','DMT post','PCB pre','PCB post'};
    SP.LegendLocation           = 'southoutside';
    SP.LegendNumColumns         = 2;
    SP.LabelDirection           = 'counterclockwise';
    SP.LabelFirstLocation       = 'left';
    SP.TargetVisible            = 'off';
    SP.WebLineColor             = [0 0 0];
    SP.Title.String             = 'Mean';
    SP.LineColor                = lcolor;
    
    Data = squeeze(mean(cont_rel_std,2))';
    f_std = figure               
    SP = Spider( 'Parent', f_std, ...
        'Data', Data, 'Labels', Labels(1:size(Data,1)));
    SP.TargetData = 0 * ones( numFH+1, 1 );
    
    SP.Title.FontSize           = 20;
    SP.Marker                   = '.';
    SP.MarkerSize               = 10.0;
    SP.MarkerFaceColor          = 'none';
    SP.LineWidth                = 2.0;
    SP.LineWidthMultiplier      = 4.0;
    SP.LegendText               = {'DMT pre','DMT post','PCB pre','PCB post'};
    SP.LegendLocation           = 'southoutside';
    SP.LegendNumColumns         = 2;
    SP.LabelDirection           = 'counterclockwise';
    SP.LabelFirstLocation       = 'left';
    SP.TargetVisible            = 'off';
    SP.WebLineColor             = [0 0 0];
    SP.Title.String             = 'Std. Dev.';
    SP.LineColor                = lcolor;
    
    case 'absolute_analysis'
    
    
    %% statistics
    for fh = 1:numFH+1
    
        % Compare FH contributions averaged across time (mean)
        a = mean(squeeze(cont_abs_standard_mean(1,:,fh)),1)';  % Vector containing mean relative contribution in DMT pre
        b = mean(squeeze(cont_abs_standard_mean(2,:,fh)),1)';  % Vector containing mean relative contribution in DMT post
        [H_FHcont_pval_cnd12(1,fh) P_FHcont_pval_cnd12(1,fh)] = ttest(a,b);
        
        a = mean(squeeze(cont_abs_standard_mean(3,:,fh)),1)';  % Vector containing mean relative contribution in PCB pre
        b = mean(squeeze(cont_abs_standard_mean(4,:,fh)),1)';  % Vector containing mean relative contribution in PCB post
        [H_FHcont_pval_cnd34(1,fh) P_FHcont_pval_cnd34(1,fh)] = ttest(a,b);
        
        a = mean(squeeze(cont_abs_standard_mean(2,:,fh)),1)';  %Vector containing mean relative contribution in DMT post
        b = mean(squeeze(cont_abs_standard_mean(4,:,fh)),1)';  % Vector containing mean relative contribution in PCB post
        [H_FHcont_pval_cnd24(1,fh) P_FHcont_pval_cnd24(1,fh)] = ttest2(a,b);
        
        % Compare FH contributions averaged across time (std. dev.)
        a = mean(squeeze(cont_abs_standard_std(1,:,fh)),1)';  % Vector containing std relative contribution in DMT pre
        b = mean(squeeze(cont_abs_standard_std(2,:,fh)),1)';  % Vector containing std relative contribution in DMT post
        [H_FHcont_pval_cnd12(2,fh) P_FHcont_pval_cnd12(2,fh)] = ttest(a,b);
        
        a = mean(squeeze(cont_abs_standard_std(3,:,fh)),1)';  % Vector containing std relative contribution in PCB pre
        b = mean(squeeze(cont_abs_standard_std(4,:,fh)),1)';  % Vector containing std relative contribution in PCB post
        [H_FHcont_pval_cnd34(2,fh) P_FHcont_pval_cnd34(2,fh)] = ttest(a,b);
        
        a = mean(squeeze(cont_abs_standard_std(2,:,fh)),1)';  % Vector containing std relative contribution in PCB post
        b = mean(squeeze(cont_abs_standard_std(4,:,fh)),1)';  % Vector containing std relative contribution in DMT post
        [H_FHcont_pval_cnd24(2,fh) P_FHcont_pval_cnd24(2,fh)] = ttest2(a,b);
    end
    %% bar plots
    h_results = figure
    colormap(jet)    
    
    for c = 1:numFH+1
            subplot(2,numFH+1,c)  
    
            DMTpre   = mean(squeeze(projections(1,:,c,:)),2)';
            DMTpost1 = mean(squeeze(projections(2,:,c,:)),2)';
            PCBpre   = mean(squeeze(projections(3,:,c,:)),2)';
            PCBpost1 = mean(squeeze(projections(4,:,c,:)),2)';
            bar(1,mean(DMTpre),'EdgeColor','w','FaceColor',lcolor(1,:))
            hold on
            bar(2,mean(DMTpost1),'EdgeColor','w','FaceColor',lcolor(2,:))
            hold on
            bar(3,mean(PCBpre),'EdgeColor','w','FaceColor',lcolor(3,:))
            hold on
            bar(4,mean(PCBpost1),'EdgeColor','w','FaceColor',lcolor(4,:))
    
            errorbar([mean(DMTpre) mean(DMTpost1) mean(PCBpre) mean(PCBpost1)],...
                [std(DMTpre)/sqrt(numel(DMTpre)) std(DMTpost1)/sqrt(numel(DMTpost1)) std(PCBpre)/sqrt(numel(PCBpre)) std(PCBpost1)/sqrt(numel(PCBpost1))],'LineStyle','none','Color','k')
            if P_FHcont_pval_cnd12(1,c)<(0.05/(numFH+1))
                plot(1.5,max([mean(DMTpre) mean(DMTpost1)])+.01,'*r')
            elseif P_FHcont_pval_cnd12(1,c)<(0.05)
                plot(1.5,max([mean(DMTpre) mean(DMTpost1)])+.01,'*k')
            end 
            if P_FHcont_pval_cnd34(1,c)<(0.05/(numFH+1))
                plot(3.5,max([mean(PCBpre) mean(PCBpost1)])+.01,'*r')
            elseif P_FHcont_pval_cnd34(1,c)<(0.05)
                plot(3.5,max([mean(PCBpre) mean(PCBpost1)])+.01,'*k')
            end 
             if P_FHcont_pval_cnd24(1,c)<(0.05/(numFH+1))
                plot(3,max([mean(PCBpre) mean(PCBpost1)])+.02,'*r')
             elseif P_FHcont_pval_cnd24(1,c)<(0.05)
                plot(3,max([mean(PCBpre) mean(PCBpost1)])+.02,'*k')
            end   
            if c==1
                ylabel('Mean FH contribution')
            end
            box off
            ylim([0 250]);set(gca,'xtick',[])
            subplot(2,numFH+1,c+numFH+1)  
    
            DMTpre   = std(squeeze(projections(1,:,c,:)),0,2)';
            DMTpost1 = std(squeeze(projections(2,:,c,:)),0,2)';
            PCBpre   = std(squeeze(projections(3,:,c,:)),0,2)';
            PCBpost1 = std(squeeze(projections(4,:,c,:)),0,2)';
            bar(1,mean(DMTpre),'EdgeColor','w','FaceColor',lcolor(1,:))
            hold on
            bar(2,mean(DMTpost1),'EdgeColor','w','FaceColor',lcolor(2,:))
            hold on
            bar(3,mean(PCBpre),'EdgeColor','w','FaceColor',lcolor(3,:))
            hold on
            bar(4,mean(PCBpost1),'EdgeColor','w','FaceColor',lcolor(4,:))
    
            errorbar([mean(DMTpre) mean(DMTpost1) mean(PCBpre) mean(PCBpost1)],...
                [std(DMTpre)/sqrt(numel(DMTpre)) std(DMTpost1)/sqrt(numel(DMTpost1)) std(PCBpre)/sqrt(numel(PCBpre)) std(PCBpost1)/sqrt(numel(PCBpost1))],'LineStyle','none','Color','k')
            if P_FHcont_pval_cnd12(2,c)<(0.05/(numFH+1))
                plot(1.5,max([mean(DMTpre) mean(DMTpost1)])+.01,'*r')
            elseif P_FHcont_pval_cnd12(2,c)<(0.05)
                plot(1.5,max([mean(DMTpre) mean(DMTpost1)])+.01,'*k')
            end 
            if P_FHcont_pval_cnd34(2,c)<(0.05/(numFH+1))
                plot(3.5,max([mean(PCBpre) mean(PCBpost1)])+.01,'*r')
            elseif P_FHcont_pval_cnd34(2,c)<(0.05)
                plot(3.5,max([mean(PCBpre) mean(PCBpost1)])+.01,'*k')
            end 
             if P_FHcont_pval_cnd24(2,c)<(0.05/(numFH+1))
                plot(3,max([mean(PCBpre) mean(PCBpost1)])+.02,'*r')
             elseif P_FHcont_pval_cnd24(2,c)<(0.05)
                plot(3,max([mean(PCBpre) mean(PCBpost1)])+.02,'*k')
            end   
            if c==1
                ylabel('Std.dev FH contribution')
            end
            box off
            ylim([0 200])
            set(gca,'XTick',1:4,'XTickLabel',{'Before DMT', ' After DMT','Before PCB', ' After PCB'});xtickangle(45)
    end
    %% FIGURE: spider plots
    
    import chart.Spider
    Data = squeeze(mean(cont_abs_standard_mean,2))';
    
    f_mean = figure
    
    SP = Spider( 'Parent', f_mean, ...
        'Data', Data, 'Labels', Labels(1:size(Data,1)));
    SP.TargetData = 0 * ones( numFH+1, 1 );
    
    
    SP.Title.FontSize           = 20;
    SP.Marker                   = '.';
    SP.MarkerSize               = 10.0;
    SP.MarkerFaceColor          = 'none';
    SP.LineWidth                = 2.0;
    SP.LineWidthMultiplier      = 4.0;
    SP.LegendText               = {'DMT pre','DMT post','PCB pre','PCB post'};
    SP.LegendLocation           = 'southoutside';
    SP.LegendNumColumns         = 2;
    SP.LabelDirection           = 'counterclockwise';
    SP.LabelFirstLocation       = 'left';
    SP.TargetVisible            = 'off';
    SP.WebLineColor             = [0 0 0];
    SP.Title.String             = 'Mean';
    SP.LineColor                = lcolor;
    
    Data = squeeze(mean(cont_abs_standard_std,2))';
    
    f_std=figure               
    SP = Spider( 'Parent', f_std, ...
        'Data', Data, 'Labels', Labels(1:size(Data,1)));
    SP.TargetData = 0 * ones( numFH+1, 1 );
    
    SP.Title.FontSize           = 20;
    SP.Marker                   = '.';
    SP.MarkerSize               = 10.0;
    SP.MarkerFaceColor          = 'none';
    SP.LineWidth                = 2.0;
    SP.LineWidthMultiplier      = 4.0;
    SP.LegendText               = {'DMT pre','DMT post','PCB pre','PCB post'};
    SP.LegendLocation           = 'southoutside';
    SP.LegendNumColumns         = 2;
    SP.LabelDirection           = 'counterclockwise';
    SP.LabelFirstLocation       = 'left';
    SP.TargetVisible            = 'off';
    SP.WebLineColor             = [0 0 0];
    SP.LineColor                = lcolor;
    SP.Title.String = 'Std. Dev.';
end