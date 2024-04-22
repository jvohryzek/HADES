%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: p1_HADES_basis_denseFC_vertex_on_HCP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% This script runs the laplace decomposition on the dense FC
%
% Inputs:
%   dFC_vertex - vertex representation of dense FC
%
% Outputs:
%   basisFunction - Functional Harmonics
%   basisEigenvalue - Functional Harmonic Eigenvalues
%
% Author: Jakub Vohryzek, jakub.vohryzek@upf.edu, 19/04/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Decision Tree
plotFigure              = 0; % '1' or '0'
save_now                = 0; % '1' or '0'
basisNames              = {'dense FC'};
globalMode              = 'Yes';
optionLaplace           = 'original'; % 'original', 'normalised'

%% Data Preparation
% this part takes time and requires memory. Alternatively run on the
% cluster
%% BOLD data
load('/Volumes/workHD/HCPdata/Dense_Connectome/denseFC_vertex.mat','dFC_vertex');
% load('/Users/jakub/Matlab/Collaboration_Kringelbach/HADES/HADES_publication/results/decomposition/denseFC_vertex.mat');

dFC_vertex = tanh(dFC_vertex); % reverting back from fisher z to correlation values

%% Main code calculation

n_areas = size(dFC_vertex,1);

%% removing the diagonal connections (dFC_vertex(1,1) as all the diagonal value the same )
dFC_vertex(dFC_vertex == dFC_vertex(1,1)) = 0;

%% Basis function calculations
basisAdjacency = dFC_vertex;
clear dFC_vertex
%% making the matrix sparser
tmp = median(basisAdjacency,1);
for i=1:n_areas
    basisAdjacency(i,basisAdjacency(i,:)<tmp(i))=0;
end

[B_maxK, I_maxk] = maxk(basisAdjacency,300,2);   
knnAdj = sparse(n_areas,n_areas)
for i=1:n_areas
    knnAdj(i,I_maxk(i,:)) = 1;
    disp(i);
end
knnAdj = (knnAdj+knnAdj')>0;

%% This part is usually done on a cluster
if strcmp(scriptOption,'original')
   lapAdj_degree = diag(sum(knnAdj));
   lapAdj_laplace = lapAdj_degree - knnAdj;
   [lapAdjV,lapAdjD]=eigs(lapAdj_laplace,1000,'smallestabs');
elseif strcmp(scriptOption,'normalised')
    lapAdj_normlaplace = (lapAdj_degree^(-.5))*lapAdj_laplace*(lapAdj_degree^(-.5));
    [lapAdjV,lapAdjD]   = eigs(lapAdj_normlaplace,n_areas,'smallestabs');
end

%% Basis Connectivity Matrices
% basisMatrix            = lapAdj_laplace;   % matrices
basisFunction            = lapAdjV;            % eigenvectors
basisEigenvalue          = lapAdjD;            % eigenvalues

basisFunctionNames = 'Laplace';
    
%% saving the workspace
% save(['/Users/jakub/Matlab/Collaboration_Kringelbach/HADES/HADES_publication/results/decomposition/Basis_HADES_denseFC_vertex_GlobalMode_' globalMode '.mat'],...
%        'basisFunction','basisEigenvalue','-v7.3')
save(['/Volumes/workHD/HADES/Basis_HADES_denseFC_vertex_GlobalMode_' globalMode '.mat'],...
    'basisFunction','basisEigenvalue','-v7.3')
%% plotting
if plotFigure
    figure,imagesc(dFC_vertex)
    colormap(jet);colorbar;
    xlabel('Vertices');ylabel('Vertices');title('dense Functional Connectivity (dFC) from 812 subjects ')
end

