%% SIFT based tracking

dbstop if error; close all;

%Initialize based on user inputted values 
initialImg = single(croppedFrames(:, :, 1));

%startRow = 700; endRow = 780;
%startCol = 500; endCol = 570;
startRow = 380; endRow = 480;
startCol = 500; endCol = 800;

template1 = initialImg(startRow:endRow, startCol:endCol);

averageRowDifference = zeros(size(croppedFrames, 3), 1); 
averageColDifference = zeros(size(croppedFrames, 3), 1); 

for n=2:1:(size(croppedFrames, 3)-1)
fprintf('Current Frame: %d \n', n); 

% Calculate SIFTs and matches 
nextFrame = single(croppedFrames(:, :, n));

[ftemplate, da] = vl_sift(template1) ;
[fb, db] = vl_sift(nextFrame) ;

[matches, scores] = vl_ubcmatch(da, db) ;
plotMatches(matches, template1, nextFrame, ftemplate, fb);
title(strcat('Frame Number : ', num2str(n))); 

% Save output as an image 
str = strcat('figfiles/', 'frame_', num2str(n)); 
saveas(gcf,strcat(str,'.png'));

% Aggreate matches and eliminate outliers 
xVals = zeros(numel(matches(1,:)), 1);
yVals = zeros(numel(matches(1,:)), 1);
xTVals = zeros(numel(matches(1,:)), 1);
yTVals = zeros(numel(matches(1,:)), 1);

for k=1:numel(matches(1,:))
    % X,Y values for the result of matching on the new Frame
    xVals(k) = fb(1, matches(2, k));
    yVals(k) = fb(2, matches(2, k));
    
    % Original X, Y values for the matched points on the Template
    xTVals(k) = ftemplate(1, matches(1, k)); 
    yTVals(k) = ftemplate(2, matches(1, k)); 
    
end

outlier_idx = abs(xVals - median(xVals)) > 1*std(xVals) | ...
    abs(yVals - median(yVals)) > 1*std(yVals); 

xVals(outlier_idx) = []; 
yVals(outlier_idx) = []; 

%Determine average shift 
rowShift = zeros(length(xVals), 1); 
colShift = zeros(length(xVals), 1); 

for k=1:1:length(xVals)
    translatedTemplateRow = startRow + yTVals(k); 
    translatedTemplateCol = startCol + xTVals(k); 
    
    rowShift(k) = yVals(k) - translatedTemplateRow; 
    colShift(k) = xVals(k) - translatedTemplateCol; 
end 

averageRowDifference(n) = mean(rowShift); 
averageColDifference(n) = mean(colShift); 

%Create new template 
fudgeRow = 90; fudgeCol = 100; 

if ((max(yVals) - min(yVals)) < 90)
    startRow = min(yVals) - round((fudgeRow - (max(yVals) - min(yVals)))/2); 
    endRow = max(yVals) + round((fudgeRow - (max(yVals) - min(yVals)))/2); 
end 

if ((max(xVals) - min(xVals)) < 100)
    startCol = round(min(xVals) - (fudgeCol - (max(xVals) - min(xVals)))/2); 
    endCol = round(max(xVals) + (fudgeCol - (max(xVals) - min(xVals)))/2); 
end 


template1 = nextFrame(startRow:endRow, startCol:endCol);
end 
