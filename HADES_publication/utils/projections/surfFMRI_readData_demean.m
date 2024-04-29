%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code by Selen Atasoy
%
% normalizes the data to have zero mean and unit std
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data] = surfFMRI_readData_demean(file_left, file_right, normalize)

if nargin<3
    normalize = 0;
end

temp.left   = gifti(file_left);
temp.right  = gifti(file_right);

data.left   = double(temp.left.cdata);
data.right  = double(temp.right.cdata);

if normalize
    % data.left = zscore(data.left');
    data.left = demean(data.left,2);
    data.left = data.left;
    
    % data.left = zscore(data.right');
    data.right = demean(data.right,2);
    data.right = data.right;
else
    % assing the mean value to zero voxels
    data.left(data.left ==0) = mean(mean(data.left));
    data.right(data.right ==0) = mean(mean(data.right));
end

data.all    = [data.left; data.right];

