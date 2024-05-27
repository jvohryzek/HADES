%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code by Selen Atasoy, 22/01/2014
% Copyright (c) Selen Atasoy, 2014
%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [vertices, faces] =  mergeMeshes(vertices1, faces1, vertices2, faces2)

% do the checks
if size(vertices1,2)~=3
    vertices1 = vertices1';
end;

if size(vertices2,2)~=3
    vertices2 = vertices2';
end;

if size(faces1,2)~=3
    faces1 = faces1';
end;

if size(faces2,2)~=3
    faces2 = faces2';
end;

nr_vertices1 = size(vertices1,1);
vertices = [vertices1; vertices2];

faces = [faces1; faces2+nr_vertices1];

if (min(min(faces))==0)
    faces = faces +1;
end;


