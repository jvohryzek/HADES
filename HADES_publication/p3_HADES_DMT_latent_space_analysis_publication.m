%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: p6_HADES_DMT_latent_space_analysis_publication
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% This script calculates the latent spread measure
%
% Inputs:
%   FH projections   - DMT_Projections_denseFC_DOT
%
% Outputs:
%   cnt_std_mean - latent spread measure
%
% Author: Jakub Vohryzek, jakub.vohryzek@upf.edu, 19/04/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load dataset
% change directory here
repo_dir = '/Users/jakub/Matlab/Collaboration_Kringelbach/HADES/HADES-main/HADES_publication';
addpath(genpath(repo_dir))
load('DMT_Projections_denseFC_DOT.mat')
%% Decision Tree

numFH                   = 11;
GS                      = 1;
%% color template for the dataset

lcolor = [0.2147 0.4324 0.7575
          0.9058 0.0975 0.9649
          0.1570 0.3585 0.3576
          0.1034 0.2569 0.2706];

colB_template1 = othercolor('BuGn3');
colB = [colB_template1(15,:);colB_template1(49,:);...
        colB_template1(5,:);colB_template1(59,:);...
        colB_template1(1,:);colB_template1(64,:);...
        colB_template1(10,:);colB_template1(54,:);...
        colB_template1(20,:);colB_template1(44,:);...
        colB_template1(25,:);colB_template1(39,:)];
colB_template2 = othercolor('Oranges5');

%% load labels
cndName = {'DMT_pre','DMT_post1','PCB_pre','PCB_post1'};
cndNameExtract = {'DMT_pre_norm','DMT_post1_norm','PCB_pre_norm','PCB_post1_norm'};

numCnd = size(cndName,2);

%% data structure transformation
for m = 1:4
    projection_tmp(m,:,:,:) = Projections.(cndNameExtract{m})(:,:,GS:numFH+1); % [cnd x sbj x FH x time]
end
clear m
projections = permute(projection_tmp, [1 2 4 3]); % [cnd x sbj x time x FH] swapping time and FH dimensions for the analysis
%% latent space spread measure
for c=1:4
    for s=1:17
        cnt_std(c,s,:) = std(squeeze(projections(c,s,:,:))');
        cnt_std_mean(c,s) = mean(std(squeeze(projections(c,s,:,:))'));
    end
end
%% plot latent space measure
h1 = figure

tmp_pcb_pre = cnt_std_mean(1,:);tmp_dmt_post = cnt_std_mean(2,:);
tmp_dmt_pre = cnt_std_mean(3,:);tmp_pcb_post = cnt_std_mean(4,:);

vp = violinplot([tmp_pcb_pre;tmp_dmt_post;tmp_dmt_pre;tmp_pcb_post]',{'DMT pre','DMT post','PCB pre','PCB post'});
vp(1).ViolinColor = [0.5 0.5 0.8];vp(2).ViolinColor = [0.8 0.8 0.2];vp(3).ViolinColor = [0.5 0.5 0.8];vp(4).ViolinColor = [0.5 0.5 0.8];
ylabel('Latent Dimension Spread')
% statistics
[hh1(1,1) p1(1,1)] = ttest(tmp_pcb_pre,tmp_pcb_post);
[hh1(1,2) p1(1,2)] = ttest(tmp_dmt_pre,tmp_dmt_post);
[hh1(1,3) p1(1,3)] = ttest(tmp_pcb_post,tmp_dmt_post);


%% plot trajectories

figure,
for i=2

    for t=1:240-1
        subplot(2,2,1)

        p1t1 = squeeze(projections(1,i,3,t));
        p2t1 = squeeze(projections(1,i,1,t));
        p3t1 = squeeze(projections(1,i,2,t));

        p1t2 = squeeze(projections(1,i,3,t+1));
        p2t2 = squeeze(projections(1,i,1,t+1));
        p3t2 = squeeze(projections(1,i,2,t+1));
        plot3(p1t1,p2t1,p3t1,'.','Color',colB_template1(t,:),'MarkerSize',24)
        hold on
        plot3([p1t1 p1t2],[p2t1 p2t2],[p3t1 p3t2],'Color',[.5 .5 .5])
        axis square;zlim([-600 600]);xlim([-500 500]);ylim([-600 600]);
        box on;grid on
                xlabel('FH 2');ylabel('FH 0');zlabel('FH 1');

        subplot(2,2,2)

        p1t1 = squeeze(projections(2,i,3,t));
        p2t1 = squeeze(projections(2,i,1,t));
        p3t1 = squeeze(projections(2,i,2,t));

        p1t2 = squeeze(projections(2,i,3,t+1));
        p2t2 = squeeze(projections(2,i,1,t+1));
        p3t2 = squeeze(projections(2,i,2,t+1));
        plot3(p1t1,p2t1,p3t1,'.','Color',colB_template2(t,:),'MarkerSize',24)
        hold on
        plot3([p1t1 p1t2],[p2t1 p2t2],[p3t1 p3t2],'Color',[.5 .5 .5])
        axis square;zlim([-600 600]);xlim([-500 500]);ylim([-600 600]);
        box on;grid on
        xlabel('FH 2');ylabel('FH 0');zlabel('FH 1');

        subplot(2,2,3)

        p1t1 = squeeze(projections(3,i,3,t));
        p2t1 = squeeze(projections(3,i,1,t));
        p3t1 = squeeze(projections(3,i,2,t));

        p1t2 = squeeze(projections(3,i,3,t+1));
        p2t2 = squeeze(projections(3,i,1,t+1));
        p3t2 = squeeze(projections(3,i,2,t+1));
        plot3(p1t1,p2t1,p3t1,'.','Color',colB_template1(t,:),'MarkerSize',24)
        hold on
        plot3([p1t1 p1t2],[p2t1 p2t2],[p3t1 p3t2],'Color',[.5 .5 .5])
        axis square;zlim([-600 600]);xlim([-500 500]);ylim([-600 600]);
        box on;grid on
                xlabel('FH 2');ylabel('FH 0');zlabel('FH 1');

        subplot(2,2,4)

        p1t1 = squeeze(projections(4,i,3,t));
        p2t1 = squeeze(projections(4,i,1,t));
        p3t1 = squeeze(projections(4,i,2,t));

        p1t2 = squeeze(projections(4,i,3,t+1));
        p2t2 = squeeze(projections(4,i,1,t+1));
        p3t2 = squeeze(projections(4,i,2,t+1));
        plot3(p1t1,p2t1,p3t1,'.','Color',colB_template1(t,:),'MarkerSize',24)
        hold on
        plot3([p1t1 p1t2],[p2t1 p2t2],[p3t1 p3t2],'Color',[.5 .5 .5])
        axis square;zlim([-600 600]);xlim([-500 500]);ylim([-600 600]);
        box on;grid on
        xlabel('FH 2');ylabel('FH 0');zlabel('FH 1');

    end
end
