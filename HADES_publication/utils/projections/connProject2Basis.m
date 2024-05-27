%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code by Selen Atasoy
% adapted by Jakub Vohryzek for HADES
% TODO
%
% projects a given patern onto the given vibModes
% 
% INPUT: 
% pattern       ~   pattern to project on to the vibModes
% vibModes      ~   basis consisting of the vibModes, has to be orthogonal
%                   t x n matrix containing n vibModes with t dimensions
%                   each
% nr_modes      ~   if not all of the modes are used to proejct, nr_modes
%                   gives the nr of vibModes to use for the projeciton
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [alpha] = connProject2Basis(tps, mode, invert)

if nargin<3
    invert = 0;
end

%% initialise
nr_modes = size(mode, 2);
alpha = zeros(nr_modes,1);

%% project
if invert
    for i=1:nr_modes

        alpha(i) = max(dot(tps, mode(:,i)), dot(tps, -mode(:,i)));

    end
else
    for i=1:nr_modes

        alpha(i) = dot(tps, mode(:,i));

    end
end
