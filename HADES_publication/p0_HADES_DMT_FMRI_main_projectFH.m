%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: p3_HADES_DMT_FMRI_main_projectFH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% This scripts maps fMRI data from volume to HCP surface and projects the
% Functional Harmonics on the timeseries
%
% Inputs:
%   basisFunction   - Functional Harmonics
%   basisEigenvalue - Functional Harmonic Eigenvalues
%   connRSM_CC      - indices for the medial wall
%   surf_left       - HCP cortical template for running the volume-to-surface
%   surf_right      - HCP cortical template for running the volume-to-surface
%
% Outputs:
%   DMT_Projections_denseFC_DOT - functional harmonics projections the specific dataset
%
% Author: Jakub Vohryzek, jakub.vohryzek@upf.edu, 19/04/2024
% adapted from FMRI_main_projectFH.m by Selen Atasoy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% folders & files
% change directory here
repo_dir = '/Users/jakub/Matlab/Collaboration_Kringelbach/HADES/HADES-main/HADES_publication';
addpath(genpath(repo_dir))

folder.dmt_pre       = 'subject_surface';
folder.dmt_post      = 'subject_surface';

folder.pcb_pre       = 'subject_surface';
folder.pcb_post      = 'subject_surface';

file.surf_left       = 'S1200.L.midthickness_MSMAll.32k_fs_LR.surf.gii';
file.surf_right      = 'S1200.R.midthickness_MSMAll.32k_fs_LR.surf.gii';
%%
in.method = 'dot'; %'cos';

%% subjects
subjects{1} = '01';
subjects{2} = '02';
subjects{3} = '03';
subjects{4} = '06';
subjects{5} = '07';
subjects{6} = '09';
subjects{7} = '10';
subjects{8} = '11';
subjects{9} = '12';
subjects{10} = '13';
subjects{11} = '15';
subjects{12} = '17';
subjects{13} = '18';
subjects{14} = '19';
subjects{15} = '22';
subjects{16} = '23';
subjects{17} = '25';

%% reading functional harmonics

load('Basis_HADES_denseFC_vertex_GlobalMode_Yes.mat')

basisFunction = flip(basisFunction,2); % reverting the order of the harmonics to start with the lower frequencies
basisEigenvalue = flip(diag(basisEigenvalue));
%% reading indices to exclude
% load indicies excluding the medial wall
load('connRSM_CC.mat')
%% for each subject to the projection
for s=1:length(subjects)
    
    tic
    subject             = subjects{s}
    
    dmt_pre_left       = ['S', subject, '_DMT_pre.cortex.L.32k_tri.func.gii'];
    dmt_pre_right      = ['S', subject, '_DMT_pre.cortex.R.32k_tri.func.gii'];

    dmt_post1_left     = ['S', subject, '_DMT_post1.cortex.L.32k_tri.func.gii'];
    dmt_post1_right    = ['S', subject, '_DMT_post1.cortex.R.32k_tri.func.gii'];
    
    pcb_pre_left       = ['S', subject, '_PCB_pre.cortex.L.32k_tri.func.gii'];
    pcb_pre_right      = ['S', subject, '_PCB_pre.cortex.R.32k_tri.func.gii'];

    pcb_post1_left     = ['S', subject, '_PCB_post1.cortex.L.32k_tri.func.gii'];
    pcb_post1_right    = ['S', subject, '_PCB_post1.cortex.R.32k_tri.func.gii'];
   
    %% read the data
    [DMT_pre_norm] = surfFMRI_readData_demean(fullfile(folder.dmt_pre, dmt_pre_left), fullfile(folder.dmt_pre, dmt_pre_right), 1);
    [DMT_post1_norm] = surfFMRI_readData_demean(fullfile(folder.dmt_post, dmt_post1_left), fullfile(folder.dmt_post, dmt_post1_right), 1);

    [PCB_pre_norm] = surfFMRI_readData_demean(fullfile(folder.pcb_pre, pcb_pre_left), fullfile(folder.pcb_pre, pcb_pre_right), 1);
    [PCB_post1_norm] = surfFMRI_readData_demean(fullfile(folder.pcb_post, pcb_post1_left), fullfile(folder.pcb_post, pcb_post1_right), 1);

    %% read the surface
    [vertices, faces] = surfFMRI_readSurface_HADES(file.surf_left, file.surf_right);

    %% project to the cortical surface
    numFH = 100;
    Projections_DMT_pre_norm(s,:,:)     = surfFMRI_projectFH(DMT_pre_norm.all(CC.RestInds, :), basisFunction(:,1:numFH), [], [], in.method);   
    Projections_DMT_post1_norm(s,:,:)   = surfFMRI_projectFH(DMT_post1_norm.all(CC.RestInds, :), basisFunction(:,1:numFH), [], [], in.method);
    Projections_PCB_pre_norm(s,:,:)     = surfFMRI_projectFH(PCB_pre_norm.all(CC.RestInds, :), basisFunction(:,1:numFH), [], [], in.method);  
    Projections_PCB_post1_norm(s,:,:)   = surfFMRI_projectFH(PCB_post1_norm.all(CC.RestInds, :), basisFunction(:,1:numFH), [], [], in.method);
    
    toc
end
Projections.DMT_pre_norm = Projections_DMT_pre_norm;
Projections.DMT_post1_norm = Projections_DMT_post1_norm;
Projections.PCB_pre_norm =  Projections_PCB_pre_norm;
Projections.PCB_post1_norm = Projections_PCB_post1_norm;
    
%% save P and labels
file.output = [repo_dir,'/results/projections/DMT_Projections_denseFC_', upper(in.method), '.mat'];
save(file.output, 'Projections','-v7.3');