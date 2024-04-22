%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code by Selen Atasoy 
% adapted by Jakub Vohryzek for HADES
% projects the data to HADES basis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [P] = surfFMRI_projectFH(data, FH, functions, timepoints, type)

if ~exist('functions', 'var')|| isempty(timepoints)
    functions = 1:size(FH,2);
end

if ~exist('timepoints', 'var')|| isempty(timepoints)
    timepoints = 1:size(data,2);
end

if ~exist('type', 'var')
    type = 'cos';
end

switch type
    
    %% compute the cosine distance (this doesnt take amplitude into account)
    case 'cos'
        P = acosd(1 - pdist2(data(:, timepoints)',FH(:,functions)', 'cosine'));

        % CH can be inverted, so it is the absolute value of the distances that matters
        P = min(P, 180-P);

        % normalize
        P = (90-P)./90;
        
    %% compute the dot product
    case 'dot'
        P = zeros(length(timepoints), length(functions));
        for i=1:length(timepoints)
            tps = data(:, timepoints(i));
            P(i,:) = connProject2Basis(tps, FH(:,functions));
        end
        
end

