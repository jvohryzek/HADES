%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: p2_HADES_plotting_basis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% This scripts plots the functional harmonics on the cortical surface
%
% Inputs:
%   basisFunction - Functional Harmonics
%   basisEigenvalue - Functional Harmonic Eigenvalues
%
% Outputs:
%   figures
%
% Author: Jakub Vohryzek, jakub.vohryzek@upf.edu, 19/04/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Decision Tree
save_now                = 0; % '1' or '0'
globalMode              = 'Yes';

%% loading workspace with basis functions

plotDir = '/Users/jakub/Matlab/Collaboration_Kringelbach/HADES/HADES_publication/figures/'
%load(['/Users/jakub/Matlab/Collaboration_Kringelbach/HADES/HADES_publication/results/decomposition/Basis_HADES_denseFC_vertex_GlobalMode_' globalMode '.mat'],'basisFunction','basisEigenValue')   
load(['/Volumes/workHD/FunHarD/Basis_HADES_denseFC_vertex_GlobalMode_' globalMode '.mat'],'basisFunction','basisEigenValue')   

basisFunction_Parc{1,1} = basisFunction;
% load vertices and faces
basedir='/Users/jakub/Matlab/Toolbox/renderaal90/';
[vertices, faces]     = surfFMRI_readSurface(basedir,'Glasser360.L.inflated.32k_fs_LR.surf.gii','Glasser360.R.inflated.32k_fs_LR.surf.gii')
base = '/Users/jakub/Matlab/Collaboration_Kringelbach/HADES/HADES_publication/HADES_data/';
% load indicies excluding the medial wall
load([base 'connRSM_CC.mat'])
%% inflated views

for j = 1:11
    vector = basisFunction_Parc{1,1}(:,size(basisFunction_Parc{1,1},2)-j);
    
    vboth = zeros(1,max(CC.RestInds));
    
    for i = 1:size(vector,1)
            vboth(CC.RestInds(i)) = vector(i);
    end
    if j == 10 || j == 8 || j == 7 || j == 3
        [h] = connRSMplotOnCortex_FH(vertices, faces, vboth', 1)
    else
        [h] = connRSMplotOnCortex_FH(vertices, faces, -vboth', 1)
    end
    if save_now
        saveas(h,[plotDir 'FH' num2str(j) '_vertex_denseFC_inflated.png']);
    end
end

%% flat views
inv = 4;
surfacetype = 2;
for i=1:11
    % adjust signs according to Glomb et al. 2019
    if i==10 || i==8 || i==7 || i==3
        h = rendersurface_Vertex(basisFunction_Parc{1,1}(:,size(basisFunction_Parc{1,1},2)-i),min(basisFunction_Parc{1,1}(:,size(basisFunction_Parc{1,1},2)-i)),max(basisFunction_Parc{1,1}(:,size(basisFunction_Parc{1,1},2)-i)),inv,'MIndexed32',surfacetype,CC)
    else
        h = rendersurface_Vertex(-basisFunction_Parc{1,1}(:,size(basisFunction_Parc{1,1},2)-i),min(-basisFunction_Parc{1,1}(:,size(basisFunction_Parc{1,1},2)-i)),max(-basisFunction_Parc{1,1}(:,size(basisFunction_Parc{1,1},2)-i)),inv,'MIndexed32',surfacetype,CC)
    end
    if save_now
        saveas(h,[plotDir 'FH' num2str(i) '_vertex_denseFC_flat.png']);
    end
end
