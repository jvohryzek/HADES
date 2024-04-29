%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code by Selen Atasoy
%
% maps the limits of a vibration mode to a color map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code by Selen Atasoy
%
% maps the limits of a vibration mode to a color map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cMap] = connMapVibModes2CmapRainbow_v2(cmin, cmax, resolution)


%%
if cmin<0
    if abs(cmin) < cmax 

            % |--------|---------|--------------------|    
          % -cmax      cmin       0                  cmax         [cmin,cmax]


        nr_blues    = round(resolution* (abs(cmin) / (abs(cmin) + cmax))); 
        nr_reds     = round(resolution* (abs(cmax) / (abs(cmin) + cmax))); 



    elseif abs(cmin) >= cmax

         % |------------------|------|--------------|    
       %  cmin                0     cmax          -cmin         [cmin,cmax]
       %    squeeze(colormap(round((cmin+cmax)/2/cmax),size(colormap)))

        nr_blues    = round(resolution* (abs(cmin) / (abs(cmin) + cmax))); 
        nr_reds     = round(resolution* (abs(cmax) / (abs(cmin) + cmax))); 



    end
elseif (cmin==0) && (cmax==0)
        
        nr_blues        = round(resolution*0.01);
        nr_reds         = round(resolution*0.01);

        
        
else
         % |------------------|------|--------------|    
       %                      0     cmin          -cmax         [cmin,cmax]
       %    squeeze(colormap(round((cmin+cmax)/2/cmax),size(colormap)))

        nr_blues    = round(resolution* (abs(cmin) / max(cmin, cmax))); 
        nr_reds     = round(resolution* (abs(cmax) / max(cmin, cmax))); 

end




if nr_blues == 0 
    cMap = hot(nr_reds);
elseif nr_reds == 0 
    cMap = cyan2black(nr_blues); 
else
%     if nr_blues>nr_reds
%         cMap = [cyan2black(nr_blues); black2yellow(nr_reds)];
%     else
%         cMap = [flipud(black2yellow(nr_reds)); flipud(cyan2black(nr_blues))];
%     end
    cMap =[cyan2black(nr_blues); black2yellow(nr_reds)];
end

function map = cyan2black(n)

if nargin < 1
   n = size(get(gcf, 'Colormap'), 1);
end

values = [...

% '10'; 'b0'; '10';  % limegreen
% '00'; 'ff'; '00';  % green
'00'; 'ff'; 'ff';  % cyan
'00'; 'ff'; 'ff';  % cyan

% '00'; 'ff'; '00';  % green
% '00'; 'ff'; '00';  % green
% '10'; 'b0'; '10';  % limegreen
% '10'; 'b0'; '10';  % limegreen

'00'; 'cc'; 'ff'; % light blue
'00'; 'cc'; 'ff'; % light blue
'33'; '99'; 'ff'; % blue
'33'; '99'; 'ff'; % blue

% 'e2'; '51'; 'e2';  % violet
% %'ff'; '38'; '8d';  % hotpink
% '66'; '00'; '33';  % purple2
'00'; '00'; '66';  % blue
'00'; '00'; '66';  % blue
%'7f'; '7f'; 'cc';  % blue_videen7
%'4c'; '4c'; '7f';  % blue_videen9
%'33'; '33'; '4c';  % blue_videen11
%'00'; '00'; '00'];  % black
%'ff'; '00'; '00';  % red
% 'ff'; '69'; '00';  % orange
% 'ff'; '99'; '00';  % oran-yell
% 'ff'; 'ff'; '00';  % yellow
% 
% 
% 'ff'; 'ff'; 'ff';  % white
% 'dd'; 'dd'; 'dd';  % gry-dd
% 'bb'; 'bb'; 'bb';  % gry-bb
 '00'; '00'; '00']; % black
% 'ff'; 'ff'; 'ff'];  % white

values = reshape(hex2dec(values), [3 numel(values)/6])' ./ 255;

P = size(values,1);

map = interp1(1:size(values,1), values, linspace(1,P,n), 'linear');

function map = black2yellow(n)

if nargin < 1
   n = size(get(gcf, 'Colormap'), 1);
end

values = [...
%'ff'; 'ff'; 'ff';  % white
'00'; '00'; '00';  % black
%'66'; '00'; '33';  % purple2
'66'; '00'; '00' ; % dark red
'66'; '00'; '00' ; % dark red
% 'ff'; '38'; '8d';  % hotpink
% 'ff'; '00'; '00';  % red
% 'ff'; '00'; '00';  % red
'ff'; '69'; '00';  % orange
'ff'; '69'; '00';  % orange
'ff'; '99'; '00';  % oran-yell
'ff'; '99'; '00';  % oran-yell
'ff'; 'ff'; '00';  % yellow
'ff'; 'ff'; '00'];  % yellow


% values = [...
% '00'; '00'; '00';  % black
% '99'; '00'; '66';  % purple2
% '99'; '00'; '66';  % purple2
% % '66'; '00'; '00' ; % dark red
% % '66'; '00'; '00' ; % dark red
% % '99'; '33'; '66'; 
% % '99'; '33'; '66'; 
% 'cc'; '00'; '66'; 
% 'cc'; '00'; '66';
% 'ff'; '33'; '99';  % hotpink
% 'ff'; '33'; '99';  % hotpink
% 'ff'; '66'; '99';  % hotpink
% 'ff'; '66'; '99'];  % hotpink
% % 'ff'; '66'; '99';  % hotpink
% % 'ff'; '66'; '99'];

values = reshape(hex2dec(values), [3 numel(values)/6])' ./ 255;

P = size(values,1);

map = interp1(1:size(values,1), values, linspace(1,P,n), 'linear');