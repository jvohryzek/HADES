%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code by Selen Atasoy
%
% 24/01/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [h] = connRSMplotOnCortex_FH(vertices, faces, U, dims, color_min, color_max)

alpha_val = 0.99;

if ~exist('color_min', 'var')
    color_min = 'steelblue';
end;

if ~exist('color_max', 'var')
    color_max = 'orangered';
end;

if isstruct(vertices) && isstruct(faces)
    
    display('Displaying two hemispheres separately!');

    %subplot = @(m,n,p) subtightplot (m, n, p, [0 0.01], [0 0], [0.06 0.01]); 
    subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.06], [0.1 0.01], [0.05 0.05]);
    %subplot = @(m,n,p) subtightplot (m, n, p, [0.035 0.035], [0 0], [0.06 0.01]);

    inds.left = 1:length(vertices.left);
    inds.right = length(vertices.left)+1:length(vertices.all);  

    h = figure('Units','inches','Position',[0 0 4.2*5 4.2],'PaperPositionMode','auto');
        
    for d=1:length(dims)    
        
        %% colormap
        if max(max(U))==inf
        
            resolution = length(unique(U(:,1)))+1;
            resolution = resolution + mod(resolution,2);
            
            U_current = U(:,dims(d));
            cmax = max(U_current(isfinite(U_current)));
            cmin = min(U_current(isfinite(U_current)));

            [cMap] = connMapVibModes2CmapRainbow(cmin, cmax, resolution);

        else
            resolution = 250;
            
            U_current = U(:,dims(d));
            cmax = max(U_current);
            cmin = min(U_current);

            % [cMap] = connMapVibModes2CmapRainbow(cmin, cmax, resolution);
            [cMap] = connMapVibModes2CmapRainbow_v2(cmin, cmax, resolution);
            
            
        end
        

        % both
        options.face_vertex_color = U(:, dims(d));

        subplot(length(dims),6,((d-1)*6)+3);
        plot_mesh(vertices.all, faces.all, options); %view([-90 0])
        material dull; shading interp; colormap jet; alpha(alpha_val); %colorbar('location', 'West'); 
        camlight('headspot');
        caxis([cmin cmax]);
        colormap(cMap);

        % LH
        options.face_vertex_color = U(inds.left,dims(d));%rescale(U(inds.left,dims(d)), min(U(:, dims(d))), max(U(:, dims(d))));

        subplot(length(dims),6,((d-1)*6)+1);
        plot_mesh(vertices.left, faces.left, options); view([-90 0])
        material dull; shading interp; colormap jet; alpha(alpha_val); 
        camlight('left');
        caxis([cmin cmax]);
        colormap(cMap);

        % RH
        options.face_vertex_color = U(inds.right,dims(d)); %rescale(U(inds.right,dims(d)), min(U(:, dims(d))), max(U(:, dims(d))));

        subplot(length(dims),6,((d-1)*6)+2);
        plot_mesh(vertices.right, faces.right, options); view([90 0])
        material dull; shading interp; colormap jet; alpha(alpha_val); 
        camlight('right'); 
        caxis([cmin cmax]);
        colormap(cMap);

        % RH
        options.face_vertex_color = U(inds.right,dims(d)); %rescale(U(inds.right,dims(d)), min(U(:, dims(d))), max(U(:, dims(d))));

        subplot(length(dims),6,((d-1)*6)+4);
        plot_mesh(vertices.right, faces.right, options); view([-90 0])
        material dull; shading interp; colormap jet; alpha(alpha_val); 
        camlight('right');
        caxis([cmin cmax]);
        colormap(cMap);

        % LH      
        options.face_vertex_color = U(inds.left,dims(d)); %rescale(U(inds.left,dims(d)), min(U(:, dims(d))), max(U(:, dims(d))));

        subplot(length(dims),6,((d-1)*6)+5);
        plot_mesh(vertices.left, faces.left, options); view([90 0])
        material dull; shading interp; colormap jet; alpha(alpha_val); 
        camlight('left'); 
        caxis([cmin cmax]);
        colormap(cMap);
        
        
        % plot the colorbar             
        subplot(length(dims),6,((d-1)*6)+6);
        hc = colorbar('East'); 
        set(hc, 'Position', [.89 .11 .02 .8150], ...
            'FontSize', 16, 'YTickMode', 'manual');
        axis off;
        if cmin~=cmax
            caxis([cmin cmax]);
        end
        colormap(cMap);
             
        hc_tick = get(hc, 'YTick');
        if ~isempty(hc_tick)    
            set(hc, 'Ytick', hc_tick([1,round(length(hc_tick)/2), end]));
        else
            set(hc, 'Ticks', hc.Limits);
        end
        
    end            
            
    %max_figure(h, [1400, length(dims)*250]);
        
  
else

    for d=1:length(dims)

        options.face_vertex_color = U(:,dims(d)); %rescale(U(:,dims(d)), 0,255);

        h = figure;
        plot_mesh(vertices, faces, options); 
        material dull; camlight; shading interp; colormap jet; colorbar('location', 'SouthOutside'); 
        
    end;

end;

% % change the colourmap
% if min(U(:, dims(1)))<0
%     
%     if max(max(U))==inf
%         
%         resolution = length(unique(U(:,1)))+1;
%         resolution = resolution + mod(resolution,2);
%         
%         [cMap] = connMapVibModes2Cmap(c_min, c_max, c_min_ult, c_max_ult, resolution);
%         
%         colormap(cMap);
%         
%     else
%         scale_factor = 100/max(U(:, dims(1)));
%         nr_reds     = ceil(max(U(:, dims(1)))*scale_factor);
%         nr_blues    = round(abs(min(U(:, dims(1))))*scale_factor);
%         colormap([(cmap('steelblue',nr_blues,30,30));cmap('gray',10,90,5);flipud(cmap('orangered',nr_reds,30,30))]);
%     end;
% 
% else
%     
%     if max(max(U))==inf
% 
%         resolution = length(unique(U(:,1)))+1;
%         %scale_factor = 10000/cmax;
%         cmax = max(max(U(isfinite(U))));
%         cmin = min(min(U(isfinite(U))));
%         
%         nr_reds     = round(resolution/20);
%         nr_blues    = nr_reds;
%         nr_white    = round(nr_blues/40);
%         
%     else
%         
%         scale_factor = length(unique(U(:,1)))*2+10;
%         nr_reds     = ceil(1*scale_factor);
%         nr_blues    = nr_reds;
%         nr_white    = round(nr_blues/10);
%     end;
%         
%     
%     colormap([(cmap('steelblue',nr_blues,30,30));cmap('gray',nr_white,90,5);flipud(cmap('orangered',nr_reds,30,30));cmap('gray',1,25,65)]);
% 
% end;


cbar_handle = findobj(gcf,'tag','Colorbar');
hc_tick = get(cbar_handle, 'YTick');

if ~isempty(hc_tick)
    if min(hc_tick)<0
        set(cbar_handle, ...
            'Box'         , 'off'     , ...
            'TickDir'     , 'in', ...
            'FontSize',     42, ...
            'FontName', 'Helvetica', ...
            'YAxisLocation', 'right', ...
            'YColor', [.3 .3 .3]);

    if (hc_tick(1)<0) && (hc_tick(end)>0)
        set(cbar_handle, 'Ytick', [hc_tick(1), 0, hc_tick(end)], ...
            'YtickLabel', {num2str(hc_tick(1), '%2.3f'), '0', num2str(hc_tick(end),'%2.3f')});
    else
        set(cbar_handle, 'Ytick', [hc_tick(1), hc_tick(end)], ...
            'YtickLabel', {num2str(hc_tick(1), '%2.3f'),  num2str(hc_tick(end),'%2.3f')});
    end;
        
    else
        set(cbar_handle, ...
            'YAxisLocation', 'right', ...
            'Ytick', [cmin cmax], ...
            'YtickLabel', {num2str(cmin, '%2.2f'), num2str(cmax, '%2.2f')}, ...
            'Box'         , 'off'     , ...
            'TickDir'     , 'in', ...
            'FontSize',     42, ...
            'FontName', 'Helvetica', ...
            'YAxisLocation', 'right', ...
            'YColor', [.3 .3 .3]);
    end;
end;
% box(cbar_handle, 'off');

function map = hcp_fmri_colormap(n)

if nargin < 1
   n = size(get(gcf, 'Colormap'), 1);
end

values = [...
'ff'; '00'; '00';  % red
'ff'; '69'; '00';  % orange
'ff'; '99'; '00';  % oran-yell
'ff'; 'ff'; '00';  % yellow
'10'; 'b0'; '10';  % limegreen
'00'; 'ff'; '00';  % green
'7f'; '7f'; 'cc';  % blue_videen7
'4c'; '4c'; '7f';  % blue_videen9
'33'; '33'; '4c';  % blue_videen11
'66'; '00'; '33';  % purple2
'00'; '00'; '00';  % black
'00'; 'ff'; 'ff';  % cyan
'00'; 'ff'; '00';  % green
'10'; 'b0'; '10';  % limegreen
'e2'; '51'; 'e2';  % violet
'ff'; '38'; '8d';  % hotpink
'ff'; 'ff'; 'ff';  % white
'dd'; 'dd'; 'dd';  % gry-dd
'bb'; 'bb'; 'bb';  % gry-bb
'00'; '00'; '00']; % black

values = reshape(hex2dec(values), [3 numel(values)/6])' ./ 255;

P = size(values,1);

map = interp1(1:size(values,1), values, linspace(1,P,n), 'linear');
