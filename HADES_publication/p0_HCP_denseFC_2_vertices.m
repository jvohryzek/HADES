%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: p0_HCP_denseFC_2_vertices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% After dowloading the connectivity files from the OSF repository, this
% script loads the dense functional connectivity files and combines them in
% one large dense FC matric
%
% Inputs:
%   denseSC_LL.dconn.nii - Left Intrahemispheric connectivity of dense FC
%   denseSC_LR.dconn.nii - Interhemispheric connectivity of dense FC
%   denseSC_RR.dconn.nii - Right Intrahemispheric connectivity of dense FC
%   denseSC_RL.dconn.nii - Interhemispheric connectivity of dense FC
%   ...
%
% Outputs:
%   dFC_vertex - vertex representation of dense FC
%   
%
% Author: Jakub Vohryzek, jakub.vohryzek@upf.edu, 19/04/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% loading the dense connectome
dSC_LL = ciftiopen('/Users/jakub/Matlab/Collaboration_Kringelbach/HADES/HADES_publication/data/decomposition/denseSC_LL.dconn.nii','/Applications/workbench/bin_macosx64/wb_command');
dSC_LR = ciftiopen('/Users/jakub/Matlab/Collaboration_Kringelbach/HADES/HADES_publication/data/decomposition/denseSC_LR.dconn.nii','/Applications/workbench/bin_macosx64/wb_command');
dSC_RL = ciftiopen('/Users/jakub/Matlab/Collaboration_Kringelbach/HADES/HADES_publication/data/decomposition/denseSC_RL.dconn.nii','/Applications/workbench/bin_macosx64/wb_command');
dSC_RR = ciftiopen('/Users/jakub/Matlab/Collaboration_Kringelbach/HADES/HADES_publication/data/decomposition/denseSC_RR.dconn.nii','/Applications/workbench/bin_macosx64/wb_command');

dSC_LL_RL = [dSC_LL.cdata;dSC_RL.cdata];
clear dSC_LL dSC_RL
% [LL __]
% [RL __]

dSC_LR_RR = [dSC_LR.cdata;dSC_RR.cdata];
clear dSC_LR dSC_RR
% [__ LR]
% [__ RR]

dFC_vertex = [dSC_LL_RL,dSC_LR_RR];
clear dSC_LL_RL dSC_LR_RR
% [LL LR]
% [RL RR]

outfile = '/Users/jakub/Matlab/Collaboration_Kringelbach/HADES/HADES_publication/data/results/';
save([outfile 'denseFC_vertex.mat'], 'dFC_vertex');