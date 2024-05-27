%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code by Selen Atasoy
% updated Jakub Vohryzek
%
% normalizes the data to have zero mean and unit std
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [vertices, faces] = surfFMRI_readSurface_HADES(file_left, file_right)

temp                = gifti(fullfile(file_left));
vertices.left       = temp.vertices;
faces.left          = temp.faces;

temp                = gifti(fullfile(file_right));
vertices.right      = temp.vertices;
faces.right         = temp.faces;

[vertices.all, faces.all] = mergeMeshes(vertices.left, faces.left, vertices.right, faces.right);