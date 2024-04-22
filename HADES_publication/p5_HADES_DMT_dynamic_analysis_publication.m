%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: p5_HADES_DMT_dynamic_analysis_publication
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% This scripts maps fMRI data from volume to HCP surface and projects the
% Functional Harmonics on the timeseries
%
% Inputs:
%   FH projections   - DMT_Projections_denseFC_DOT
%
% Outputs:
%   PO       = Probability of Occurence
%   LT       = Life Times
%   PM       = Probability Matrix
%
% Author: Jakub Vohryzek, jakub.vohryzek@upf.edu, 19/04/2024
% adapted LEiDA_analysis.m from Joana Cabral
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% variables
numFH                   = 11;
GS                      = 2 % 1 yes global signal (for rel. and abs. powerr), 2 no global signal (for LEiDA)
TR                      = 2;
%% color template for the dataset
lcolor = [0.2147 0.4324 0.7575
          0.9058 0.0975 0.9649
          0.1570 0.3585 0.3576
          0.1034 0.2569 0.2706];

%% loading data

load('/Users/jakub/Matlab/Collaboration_Kringelbach/HADES/DMT/Results/DMT_Projections_denseFC_DOT.mat')

%% labels
cndName = {'DMT_pre','DMT_post1','PCB_pre','PCB_post1'};
cndNameExtract = {'DMT_pre_norm','DMT_post1_norm','PCB_pre_norm','PCB_post1_norm'};

numCnd = size(cndName,2);
%%
for m = 1:4
    % two ways to run the winners takes all - either pos/neg or absolute of
    % the whole FHs signal
    % option 1
        projection_tmp(m,:,:,:) = Projections.(cndNameExtract{m})(:,:,GS:numFH+1);
    % option 2
    %   projection_tmp(m,:,:,:) = abs(Projections.(cndNameExtract{m})(:,:,GS:numFH+1));


end
projections = permute(projection_tmp, [1 2 4 3]); % [cnd x sbj x time x FH] swapping time and FH dimensions for the analysis
clear m
        
%% Dynamic Analysis

for k = 1:numFH
        
    for cnd = 1:numCnd
        for s = 1:size(projections,2)
           [~, ind_p] = max(squeeze(projections(cnd,s,1:k,:)),[],1);

            % Select the time points representing this subject and condition
            Ctime = ind_p;

            for c=1:numFH
                % Probability
                PO{cnd,k}(s,c) = mean(Ctime == c) + eps; % adding eps to avoid dividing by 0 in the porbability transition matrix

                % Mean Lifetime
                Ctime_bin      = Ctime == c;

                % Detect switches in and out of this state
                param_c1       = find(diff(Ctime_bin)==1);
                param_c2       = find(diff(Ctime_bin)==-1);

                % We discard the cases where state starts or ends ON
                if length(param_c2)>length(param_c1)
                    param_c2(1)   = [];
                elseif length(param_c1)>length(param_c2)
                    param_c1(end) = [];
                elseif  ~isempty(param_c1) && ~isempty(param_c2) && param_c1(1)>param_c2(1)
                    param_c2(1)   = [];
                    param_c1(end) = [];
                end
                if ~isempty(param_c1) && ~isempty(param_c2)
                    C_durations   = param_c2-param_c1;
                else
                    C_durations   = 0;
                end
                LT{cnd,k}(s,c) = mean(C_durations)*TR; % lifetimes
            end
            % Probability of Transition
            transferMatrix = zeros(numFH,numFH);
            for tp = 2:size(Ctime,2)
                transferMatrix(Ctime(tp-1),Ctime(tp)) = transferMatrix(Ctime(tp-1),Ctime(tp)) + 1;
            end
            PT{cnd,k}(s,:,:)     = transferMatrix./(size(Ctime,2)-1);                   % normalised by T-1
            PTnorm{cnd,k}(s,:,:) = squeeze(PT{1,k}(s,:,:))./squeeze(PO{1,k}(s,:))';     % normalised by Probability of Ocupancy
        end
    end
end
%% plotting
   
H_PO_pval_cnd12 = zeros(numFH,numFH);
H_PO_pval_cnd34 = zeros(numFH,numFH);
H_PO_pval_cnd24 = zeros(numFH,numFH);

H_LT_pval_cnd12 = zeros(numFH,numFH);
H_LT_pval_cnd34 = zeros(numFH,numFH);
H_LT_pval_cnd24 = zeros(numFH,numFH);

for k = 2:numFH
    disp(['Now running for ' num2str(k) ' basis'])

    for c=1:k

        % Compare Probabilities
        a=squeeze(PO{1,k}(:,c))';  % Vector containing FH probabilities in DMT pre
        b=squeeze(PO{2,k}(:,c))';  % Vector containing FH probabilities in DMT post
        [H_PO_pval_cnd12(k,c) P_PO_pval_cnd12(k,c)] = ttest(a,b);

        a=squeeze(PO{3,k}(:,c))';  % Vector containing FH probabilities in PCB pre
        b=squeeze(PO{4,k}(:,c))';  % Vector containing FH probabilities in PCB post
        [H_PO_pval_cnd34(k,c) P_PO_pval_cnd34(k,c)] = ttest(a,b);

        a=squeeze(PO{2,k}(:,c))';  % Vector containing FH probabilities in DMT post
        b=squeeze(PO{4,k}(:,c))';  % Vector containing FH probabilities in PCB post
        [H_PO_pval_cnd24(k,c) P_PO_pval_cnd24(k,c)] = ttest2(a,b);

        % Compare Life Times
        a=squeeze(LT{1,k}(:,c))';  % Vector containing FH life times in DMT pre
        b=squeeze(LT{2,k}(:,c))';  % Vector containing FH life times in DMT post
        [H_LT_pval_cnd12(k,c) P_LT_pval_cnd12(k,c)] = ttest(a,b);

        a=squeeze(LT{3,k}(:,c))';  % Vector containing FH life times in PCB pre
        b=squeeze(LT{4,k}(:,c))';   % Vector containing FH life times in PCB post
        [H_LT_pval_cnd34(k,c) P_LT_pval_cnd34(k,c)] = ttest(a,b);

        a=squeeze(LT{2,k}(:,c))';  % Vector containing FH life times in PCB post
        b=squeeze(LT{4,k}(:,c))';  % Vector containing FH life times in DMT post
        [H_LT_pval_cnd24(k,c) P_LT_pval_cnd24(k,c)] = ttest2(a,b);
    end
end

%% bar plots for probability of occurence and life times
h_results = figure
colormap(jet)    

for c = 1:numFH
        subplot(3,numFH,c)  
        DMTpre   = squeeze(PO{1,numFH}(:,c));
        DMTpost1 = squeeze(PO{2,numFH}(:,c));
        PCBpre   = squeeze(PO{3,numFH}(:,c));
        PCBpost1 = squeeze(PO{1,numFH}(:,c));
        bar(1,mean(DMTpre),'EdgeColor','w','FaceColor',lcolor(1,:))
        hold on
        bar(2,mean(DMTpost1),'EdgeColor','w','FaceColor',lcolor(2,:))
        hold on
        bar(3,mean(PCBpre),'EdgeColor','w','FaceColor',lcolor(3,:))
        hold on
        bar(4,mean(PCBpost1),'EdgeColor','w','FaceColor',lcolor(4,:))

        errorbar([mean(DMTpre) mean(DMTpost1) mean(PCBpre) mean(PCBpost1)],...
            [std(DMTpre)/sqrt(numel(DMTpre)) std(DMTpost1)/sqrt(numel(DMTpost1)) std(PCBpre)/sqrt(numel(PCBpre)) std(PCBpost1)/sqrt(numel(PCBpost1))],'LineStyle','none','Color','k')
        if P_PO_pval_cnd12(numFH,c)<(0.05/(numFH+1))
            plot(1.5,max([mean(DMTpre) mean(DMTpost1)])+.01,'*g')
        elseif P_PO_pval_cnd12(numFH,c)<(0.05)
            plot(1.5,max([mean(DMTpre) mean(DMTpost1)])+.01,'*r')
        end 
        if P_PO_pval_cnd34(numFH,c)<(0.05/(numFH+1))
            plot(1.5,max([mean(PCBpre) mean(PCBpost1)])+.01,'*g')
        elseif P_PO_pval_cnd34(numFH,c)<(0.05)
            plot(1.5,max([mean(PCBpre) mean(PCBpost1)])+.01,'*r')
        end
        
        if P_PO_pval_cnd24(numFH,c)<(0.05/(numFH+1))
            plot(1.5,max([mean(DMTpost1) mean(PCBpost1)])+.01,'*g')
        elseif P_PO_pval_cnd24(numFH,c)<(0.05)
            plot(1.5,max([mean(DMTpost1) mean(PCBpost1)])+.01,'*r')
        end 
        if c==1
            ylabel('Fractional Occupancy')
            set(gca,'XTick',1:4,'XTickLabel',{'Before DMT', ' After DMT','Before PCB', ' After PCB'});xtickangle(45)
        else
            set(gca,'xtick',[])
        end
        box off
        axis square
        ylim([0 0.25]);

        subplot(2,numFH,c+1*numFH)  
        DMTpre = squeeze(LT{1,numFH}(:,c));
        DMTpost1 = squeeze(LT{2,numFH}(:,c));
        PCBpre = squeeze(LT{3,numFH}(:,c));
        PCBpost1 = squeeze(LT{1,numFH}(:,c));
        bar(1,mean(DMTpre),'EdgeColor','w','FaceColor',lcolor(1,:))
        hold on
        bar(2,mean(DMTpost1),'EdgeColor','w','FaceColor',lcolor(2,:))
        hold on
        bar(3,mean(PCBpre),'EdgeColor','w','FaceColor',lcolor(3,:))
        hold on
        bar(4,mean(PCBpost1),'EdgeColor','w','FaceColor',lcolor(4,:))

        errorbar([mean(DMTpre) mean(DMTpost1) mean(PCBpre) mean(PCBpost1)],...
            [std(DMTpre)/sqrt(numel(DMTpre)) std(DMTpost1)/sqrt(numel(DMTpost1)) std(PCBpre)/sqrt(numel(PCBpre)) std(PCBpost1)/sqrt(numel(PCBpost1))],'LineStyle','none','Color','k')

        if P_LT_pval_cnd12(numFH,c)<(0.05/(numFH+1))
            plot(1.5,max([mean(DMTpre) mean(DMTpost1)])+.01,'*g')
        elseif P_LT_pval_cnd12(numFH,c)<(0.05)
            plot(1.5,max([mean(DMTpre) mean(DMTpost1)])+.01,'*r')
        end 
        if P_LT_pval_cnd34(numFH,c)<(0.05/(numFH+1))
            plot(1.5,max([mean(PCBpre) mean(PCBpost1)])+.01,'*g')
        elseif P_LT_pval_cnd34(numFH,c)<(0.05)
            plot(1.5,max([mean(PCBpre) mean(PCBpost1)])+.01,'*r')
        end
        
        if P_LT_pval_cnd24(numFH,c)<(0.05/(numFH+1))
            plot(1.5,max([mean(DMTpost1) mean(PCBpost1)])+.01,'*g')
        elseif P_LT_pval_cnd24(numFH,c)<(0.05)
            plot(1.5,max([mean(DMTpost1) mean(PCBpost1)])+.01,'*r')
        end 


        if c==1
            ylabel('Life Times')
        else
            set(gca,'xtick',[])
        end
        box off
        ylim([0 8])
        axis square

end
%% plotting the range
h1 = figure
min_PO_pval = min([nonzeros(P_PO_pval_cnd12);nonzeros(P_PO_pval_cnd24);nonzeros(P_PO_pval_cnd34)]);
subplot(1,3,1);Plot_p_values_FunHarD(P_PO_pval_cnd12,2:numFH,'Probability',cndName{1,1},cndName{1,2})
ylim([min_PO_pval,1])
subplot(1,3,2);Plot_p_values_FunHarD(P_PO_pval_cnd24,2:numFH,'Probability',cndName{1,2},cndName{1,4})
ylim([min_PO_pval,1])
subplot(1,3,3);Plot_p_values_FunHarD(P_PO_pval_cnd34,2:numFH,'Probability',cndName{1,3},cndName{1,4})
ylim([min_PO_pval,1])



h2 = figure
min_LT_pval = min([nonzeros(P_LT_pval_cnd12);nonzeros(P_LT_pval_cnd24);nonzeros(P_LT_pval_cnd34)]);

subplot(1,3,1);Plot_p_values_FunHarD(P_LT_pval_cnd12,2:numFH,'Life Times',cndName{1,1},cndName{1,2})
ylim([min_LT_pval,1])
subplot(1,3,2);Plot_p_values_FunHarD(P_LT_pval_cnd24,2:numFH,'Life Times',cndName{1,2},cndName{1,4})
ylim([min_LT_pval,1])
subplot(1,3,3);Plot_p_values_FunHarD(P_LT_pval_cnd34,2:numFH,'Life Times',cndName{1,3},cndName{1,4})
ylim([min_LT_pval,1])
%% transition matrix
 
stateChoice = 11;

figure
subplot(121)
tmp_TM = squeeze(nanmean(PT{1,stateChoice}));
tmp_TM = tmp_TM.*(ones(stateChoice)-eye(stateChoice));
tmp_TMnorm = tmp_TM./sum(tmp_TM,2);
imagesc(tmp_TMnorm)
for j1 = 1:stateChoice
    for j2 = 1:stateChoice
        if j1 ~= j2

            caption = sprintf('%.2f', tmp_TMnorm(j1,j2));
            text(j2-0.35, j1, caption, 'FontSize', 15, 'Color', [1, 1, 1],'FontWeight','bold');
        end
   end
end
set(gca,'FontSize',14,'FontWeight','bold')
colorbar

xticks(1:1:stateChoice); xticklabels({'FH 1','FH 2','FH 3','FH 4','FH 5','FH 6','FH 7','FH 8','FH 9','FH 10','FH 11'})
yticks(1:1:stateChoice); yticklabels({'FH 1','FH 2','FH 3','FH 4','FH 5','FH 6','FH 7','FH 8','FH 9','FH 10','FH 11'})
xtickangle(45);ytickangle(45)
axis square
ylabel('From')
xlabel('To')
%axis off
title('DMT Group Pre')

subplot(122)
tmp_TM = squeeze(mean(PT{2,stateChoice}));
tmp_TM = tmp_TM.*(ones(stateChoice)-eye(stateChoice));
tmp_TMnorm = tmp_TM./sum(tmp_TM,2);
imagesc(tmp_TMnorm)
for j1 = 1:stateChoice
    for j2 = 1:stateChoice
        if j1 ~= j2

            caption = sprintf('%.2f', tmp_TMnorm(j1,j2));
            text(j2-0.35, j1, caption, 'FontSize', 15, 'Color', [1, 1, 1],'FontWeight','bold');
        end
   end
end
set(gca,'FontSize',14,'FontWeight','bold')

xticks(1:1:stateChoice); xticklabels({'FH 1','FH 2','FH 3','FH 4','FH 5','FH 6','FH 7','FH 8','FH 9','FH 10','FH 11'})
yticks(1:1:stateChoice); yticklabels({'FH 1','FH 2','FH 3','FH 4','FH 5','FH 6','FH 7','FH 8','FH 9','FH 10','FH 11'})
xtickangle(45);ytickangle(45)
axis square
ylabel('From')
xlabel('To')
title('DMT Group Post')
colorbar
colormap(jet)
%% statistics transition matrix

stateChoice = 11;
for i = 1:stateChoice
    for j = 1:stateChoice
            
            % Compare FH contributions averaged across time
            a = squeeze(PT{1,stateChoice}(:,i,j));  % Vector containing Prob of c in DMT pre
            b = squeeze(PT{2,stateChoice}(:,i,j));  % Vector containing Prob of c in DMT post
            [H_FH(i,j) P_FH(i,j)] = ttest(a,b);
   end
end
figure
subplot(131)

imagesc(P_FH.*(ones(stateChoice)-eye(stateChoice)))
for j1 = 1:stateChoice
    for j2 = 1:stateChoice
                if j1 ~= j2
        caption = sprintf('%.2f', P_FH(j1,j2));
        text(j2-0.35, j1, caption, 'FontSize', 8, 'Color', [1, 1, 1],'FontWeight','bold');
                end
    end
end
set(gca,'FontSize',12,'FontWeight','bold')

xticks(1:1:stateChoice); xticklabels({'FH 1','FH 2','FH 3','FH 4','FH 5','FH 6','FH 7','FH 8','FH 9','FH 10','FH 11'})
yticks(1:1:stateChoice); yticklabels({'FH 1','FH 2','FH 3','FH 4','FH 5','FH 6','FH 7','FH 8','FH 9','FH 10','FH 11'})
xtickangle(45);ytickangle(45)
axis square
ylabel('From')
xlabel('To')
title('Statistics DMTpost vs. DMTpre')
colorbar
%
subplot(132)
for i = 1:stateChoice
    for j = 1:stateChoice
            
            % Compare FH contributions averaged across time
            a = squeeze(PT{3,stateChoice}(:,i,j));  % Vector containing Prob of c in PCB pre
            b = squeeze(PT{4,stateChoice}(:,i,j));  % Vector containing Prob of c in PCB post
            [H_FH(i,j) P_FH(i,j)] = ttest(a,b);
   end
end

imagesc(P_FH.*(ones(stateChoice)-eye(stateChoice)))
for j1 = 1:stateChoice
    for j2 = 1:stateChoice
                if j1 ~= j2
        caption = sprintf('%.2f', P_FH(j1,j2));
        text(j2-0.35, j1, caption, 'FontSize', 8, 'Color', [1, 1, 1],'FontWeight','bold');
                end
    end
end
set(gca,'FontSize',12,'FontWeight','bold')

xticks(1:1:stateChoice); xticklabels({'FH 1','FH 2','FH 3','FH 4','FH 5','FH 6','FH 7','FH 8','FH 9','FH 10','FH 11'})
yticks(1:1:stateChoice); yticklabels({'FH 1','FH 2','FH 3','FH 4','FH 5','FH 6','FH 7','FH 8','FH 9','FH 10','FH 11'})
xtickangle(45);ytickangle(45)
axis square
ylabel('From')
xlabel('To')
title('Statistics PCBpost vs. PCBpre')
colorbar
colormap(bone)

        subplot(133)
for i = 1:stateChoice
    for j = 1:stateChoice
            
            % Compare FH contributions averaged across time
            a = squeeze(PT{2,stateChoice}(:,i,j)-PT{1,stateChoice}(:,i,j));  % Vector containing Prob of c in Baseline
            b = squeeze(PT{4,stateChoice}(:,i,j)-PT{2,stateChoice}(:,i,j));  % Vector containing Prob of c in Task  % Vector containing Prob of c in Task
            [H_FH(i,j) P_FH(i,j)] = ttest2(a,b);
   end
end

imagesc(P_FH.*(ones(stateChoice)-eye(stateChoice)),[0 1])
for j1 = 1:stateChoice
    for j2 = 1:stateChoice
                if j1 ~= j2
        caption = sprintf('%.2f', P_FH(j1,j2));
        text(j2-0.35, j1, caption, 'FontSize', 8, 'Color', [1, 1, 1],'FontWeight','bold');
                end
    end
end
set(gca,'FontSize',12,'FontWeight','bold')

xticks(1:1:stateChoice); xticklabels({'FH 1','FH 2','FH 3','FH 4','FH 5','FH 6','FH 7','FH 8','FH 9','FH 10','FH 11'})
yticks(1:1:stateChoice); yticklabels({'FH 1','FH 2','FH 3','FH 4','FH 5','FH 6','FH 7','FH 8','FH 9','FH 10','FH 11'})
xtickangle(45);ytickangle(45)
axis square
ylabel('From')
xlabel('To')
title('Statistics (DMTpost-DMTpre) vs. (PCBpost-PCBpre)')
colorbar
colormap(bone)
