function [hfig] = rendersurface_Vertex(vector,rangemin,rangemax, inv,clmap,surfacetype,CC)
% script for rendering a schaefer1000vector
%   ML Kringelbach April 2020
% schaefer1000vector : the schaefer1000vector values to be rendered
%
% rangemin, rangemax : limits for colorscheme
%
% inv:
%  0 colormap, interp
%  1 flip colormap, interp
%  2 colormap, only three colours
%  4 colormap as in Glomb et al. and CH scripts
%
% clmap : from othercolor, default 'Bu_10'
%
% surfacetype: 
%  1 midthickness
%  2 inflated (default)
%  3 very inflated


if ~exist('rangemin','var')
     rangemin=min(vector);
end

if ~exist('rangemax','var')
     rangemax=max(vector);
end

if ~exist('inv','var')
     inv=max(vector);
end

if ~exist('clmap','var')
    clmap='Bu_10';
end

if ~exist('surfacetype','var')
     surfacetype=2; % default is inflated
end


% make space tight
make_it_tight = true;
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
if ~make_it_tight,  clear subplot;  end

% load the different views
% base='/Users/mortenk/Documents/MATLAB/osl/std_masks/';
% display_surf_left=gifti([base 'ParcellationPilot.L.inflated.32k_fs_LR.surf.gii']);
% display_surf_right=gifti([base 'ParcellationPilot.R.inflated.32k_fs_LR.surf.gii']);

basedir='/Users/jakub/Matlab/Toolbox/renderaal90/';
glassers_L=gifti([basedir 'Glasser360.L.mid.32k_fs_LR.surf.gii']);
glassersi_L=gifti([basedir 'Glasser360.L.inflated.32k_fs_LR.surf.gii']);
glassersvi_L=gifti([basedir 'Glasser360.L.very_inflated.32k_fs_LR.surf.gii']);
glassersf_L=gifti([basedir 'Glasser360.L.flat.32k_fs_LR.surf.gii']);
glassers_R=gifti([basedir 'Glasser360.R.mid.32k_fs_LR.surf.gii']);
glassersi_R=gifti([basedir 'Glasser360.R.inflated.32k_fs_LR.surf.gii']);
glassersvi_R=gifti([basedir 'Glasser360.R.very_inflated.32k_fs_LR.surf.gii']);
glassersf_R=gifti([basedir 'Glasser360.R.flat.32k_fs_LR.surf.gii']);

switch surfacetype
    case 1
        display_surf_left=glassers_L;
        display_surf_right=glassers_R;
    case 2
        display_surf_left=glassersi_L;
        display_surf_right=glassersi_R;
    case 3
        display_surf_left=glassersvi_L;
        display_surf_right=glassersvi_R;
end

% flatmaps
sl=glassersf_L;
sr=glassersf_R;


base='/Users/jakub/Datasets/Atlas/Schaefer2018/HCP/';

size(vector)
vboth = zeros(1,max(CC.RestInds));

for i=1:size(vector,1)
    vboth(CC.RestInds(i)) = vector(i);
end
vl = vboth(1:(max(CC.RestInds)/2));
vr = vboth(((max(CC.RestInds)/2)+1):max(CC.RestInds));

%% rendering

    % create figure
    hfig = figure;
    %set(gcf, 'Position',  [100, 100, 400, 600]);
    
    subplot(1,3,1); %left hemisphere flat
    ax2=gca;
    axis(ax2,'equal');
    axis(ax2,'off');
    s(2) = patch(ax2,'Faces',sl.faces,'vertices',sl.vertices, 'FaceVertexCData', vl', 'FaceColor','interp', 'EdgeColor', 'none');
    set(ax2,'CLim',[rangemin rangemax]);
    view(0,90)
    camlight;
    lighting gouraud;
    material dull;
    %colorbar('southoutside');

    subplot(1,3,2); %right hemisphere flat
    ax2=gca;
    axis(ax2,'equal');
    axis(ax2,'off');
    s(2) = patch(ax2,'Faces',sr.faces,'vertices',sr.vertices, 'FaceVertexCData', vr', 'FaceColor','interp', 'EdgeColor', 'none');
    set(ax2,'CLim',[rangemin rangemax]);
    view(0,90)
    camlight;
    lighting gouraud;
    material dull;
    %colorbar('southoutside');
    
    % plot the colorbar             
    subplot(1,3,3);
    hc = colorbar('West'); 
    set(hc, 'Position', [.77 .39 .02 .3150], ...
        'FontSize', 16, 'YTickMode', 'manual');
    axis off;
    if rangemin ~= rangemax
        caxis([rangemin rangemax]);
    end

    hc_tick = get(hc, 'YTick');
    if ~isempty(hc_tick)    
        set(hc, 'Ytick', hc_tick([1,round(length(hc_tick)/2), end]));
    else
        set(hc, 'Ticks', hc.Limits);
    end
        
        
    switch inv
        case 0
            % use selected colormap (interpolated to 64 values)
            c=othercolor(clmap);
            colormap(c)            
        case 1
            % flip colormap (interpolated to 64 values)
            c=flipud(othercolor(clmap));
        case 2
            % use specialised version with only three values
            c=othercolor(clmap,3);
            % this is for the second value
            c(2,1)=0.70;c(2,2)=0.70;c(2,3)=0.70; 
        case 3
            % use specialised version with only four values
            c=othercolor(clmap,4);
            c(2,1)=0.70;c(2,2)=0.70;c(2,3)=0.70;
        case 4
            % from connRSMplotOnCortex.m script
            resolution = 250;

            cmax = max(vector);
            cmin = min(vector);

            [c] = connMapVibModes2CmapRainbow_v2(cmin, cmax, resolution);
    end;
    % neutral brain colour: grey
    %cMap(1,1)=0.98;cMap(1,2)=0.98;cMap(1,3)=0.98; 
    colormap(c)

