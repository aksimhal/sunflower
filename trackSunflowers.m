%% trackSunflowers
% Anish Simhal 

dbstop if error

% These parameters can be moved to a config file if needed
% Number of images to cycle through 
numOfImages = 267;
% Folder in which images are held 
folder_path = 'C:\Users\anish\Documents\MATLAB\002C\';
file_base = 'HUNT';
file_ext = '.JPG';
file_path = strcat(folder_path, file_base);
%If true, save an image of the matches to a folder
saveImg = true; 

% Crop Parameters 
cropStartCol = 480;
cropEndCol = 1512;
cropStartRow = 1;
cropEndRow = 990;

%Contains the difference in position from Frame B to Frame A
averageRowDifference = zeros(numOfImages, 1); 
averageColDifference = zeros(numOfImages, 1); 

%Contains the Average position of the plant in each frame
averageRowPos = zeros(numOfImages, 1); 
averageColPos = zeros(numOfImages, 1); 

%Grab Initial Frame
file_name = strcat(file_path, sprintf('%04d', 1));
file_name = strcat(file_name, file_ext);
initialFrame = rgb2gray(imread(file_name));
initialFrame = initialFrame(cropStartRow:(cropEndRow - 1), ...
    cropStartCol:(cropEndCol - 1));

% Convert template to type 'single' for VL_FEAT 
initialFrame = single(initialFrame);

% Initial template parameters 
templateStartRow = 410; templateEndRow = 600;
templateStartCol = 220; templateEndCol = 670;

template = initialFrame(templateStartRow:templateEndRow, ...
    templateStartCol:templateEndCol);

for n=2:3:numOfImages
    fprintf('Current Frame: %d \n', n); 
    
    file_name = strcat(file_path, sprintf('%04d', n));
    file_name = strcat(file_name, file_ext);
    
    gImg = rgb2gray(imread(file_name));
    croppedFrame = gImg(cropStartRow:(cropEndRow - 1), ...
        cropStartCol:(cropEndCol - 1));
    
    % Calculate SIFTs and matches
    nextFrame = single(croppedFrame);
    
    [ftemplate, da] = vl_sift(template) ;
    [fb, db] = vl_sift(nextFrame) ;
    
    [matches, scores] = vl_ubcmatch(da, db) ;
    plotMatches(matches, template, nextFrame, ftemplate, fb);
    title(strcat('Frame Number : ', num2str(n)));
    
    % Save output as an image
    if (saveImg); 
    str = strcat('figfiles/', 'frame_', num2str(n));
    saveas(gcf,strcat(str,'.png'));
    end 
    
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

    xTVals(outlier_idx) = [];
    yTVals(outlier_idx) = [];
    
    
    
    %Determine average shift
    rowShift = zeros(length(xVals), 1);
    colShift = zeros(length(xVals), 1);
    
    for k=1:1:length(xVals)
        translatedTemplateRow = templateStartRow + yTVals(k);
        translatedTemplateCol = templateStartCol + xTVals(k);
        
        rowShift(k) = yVals(k) - translatedTemplateRow;
        colShift(k) = xVals(k) - translatedTemplateCol;
    end
    
    averageRowDifference(n) = mean(rowShift);
    averageColDifference(n) = mean(colShift);
    
    %Slightly inaccurate method of defining position 
    averageColPos(n) = mean(xVals); 
    averageRowPos(n) = mean(yVals); 
   
    %Create new template
    fudgeRow = 150; fudgeCol = 150;
    
    if ((max(yVals) - min(yVals)) < 150)
        templateStartRow = min(yVals) - round((fudgeRow - (max(yVals) - min(yVals)))/2);
        templateEndRow = max(yVals) + round((fudgeRow - (max(yVals) - min(yVals)))/2);
        templateStartRow = round(templateStartRow); 
        templateEndRow = round(templateEndRow); 
    end
    
    if ((max(xVals) - min(xVals)) < 150)
        templateStartCol = round(min(xVals) - (fudgeCol - (max(xVals) - min(xVals)))/2);
        templateEndCol = round(max(xVals) + (fudgeCol - (max(xVals) - min(xVals)))/2);
    end
    
    
    template = nextFrame(templateStartRow:templateEndRow,...
        templateStartCol:templateEndCol);

    
end

%% Save displacement to file
csvwrite('output_displacement.csv', ...
    [averageRowDifference averageColDifference averageRowPos averageColPos]); 


