%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code by Selen Atasoy
%
% normalizes the data to have zero mean and unit std
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [vertices, faces] = surfFMRI_readSurface(file_path, file_left, file_right)

temp                = gifti(fullfile(file_path, file_left));
vertices.left       = temp.vertices;
faces.left          = temp.faces;

temp                = gifti(fullfile(file_path, file_right));
vertices.right      = temp.vertices;
faces.right         = temp.faces;

[vertices.all, faces.all] = mergeMeshes(vertices.left, faces.left, vertices.right, faces.right);