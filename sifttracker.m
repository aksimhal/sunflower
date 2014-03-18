%% SIFT based tracking

dbstop if error; close all;

initialImg = single(croppedFrames(:, :, 1));

startRow = 700; endRow = 780;
startCol = 500; endCol = 570;
template1 = initialImg(startRow:endRow, startCol:endCol);

for n=2:1:(size(croppedFrames, 3)-1)
fprintf('Current Frame: %d \n', n); 

nextFrame = single(croppedFrames(:, :, n));

[ftem, da] = vl_sift(template1) ;
[fb, db] = vl_sift(nextFrame) ;

[matches, scores] = vl_ubcmatch(da, db) ;
plotMatches(matches, template1, nextFrame, ftem, fb);
title(strcat('Frame Number : ', num2str(n))); 

str = strcat('figfiles/', 'frame_', num2str(n)); 
saveas(gcf,strcat(str,'.png'));

xVals = zeros(numel(matches(1,:)), 1);
yVals = zeros(numel(matches(1,:)), 1);

for k=1:numel(matches(1,:))
    
    xVals(k) = fb(1, matches(2, k));
    yVals(k) = fb(2, matches(2, k));
    
end

outlier_idx = abs(xVals - median(xVals)) > 1*std(xVals) | ...
    abs(yVals - median(yVals)) > 1*std(yVals); 

xVals(outlier_idx) = []; 
yVals(outlier_idx) = []; 

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


%startRow = 700; endRow = 780;
%startCol = 500; endCol = 570;
template1 = nextFrame(startRow:endRow, startCol:endCol);
end 
