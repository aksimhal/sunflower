function outputImg = findStemTop(inputImg, showViz)
% Function determines the stem in a daylight sunflower video frame
if nargin < 2
    showViz = false;
end

%% Edge Test
[~, threshold] = edge(inputImg, 'prewitt');
fudgeFactor = .5;
BWs = edge(inputImg,'sobel');
%, threshold * fudgeFactor
if (showViz)
    figure, imshow(BWs), title('binary gradient mask');
    title('sobel edge detection filter');
end
outputImg = BWs;
% se0 = strel('line', 5, 0);
% se90 = strel('line', 10, 90);
BWsdil = imdilate(BWs, strel('line', 15, 90));
BWsdil = imdilate(BWsdil, strel('line', 3, 0));

% if (showViz)
     figure, imshow(BWsdil), title('dilated gradient mask');
% end

IL = bwlabel(BWsdil);
R = regionprops(BWsdil,'Area', 'centroid');
ind = find([R.Area] >= 100);
Iout = ismember(IL,ind);

if (showViz)
    imagesc(Iout); title('blobs removed');
    hold on; 
end

%% Go up the stem 
colPos = 571; 
rowPos = 987; 

while (Iout(rowPos, colPos) ~= true)
    rightDelta = 0; leftDelta = 0; 
    while (Iout(rowPos, colPos + rightDelta) ~= true)
        rightDelta = rightDelta + 1; 
    end 
    
    while (Iout(rowPos, colPos - leftDelta) ~= true)
        leftDelta = leftDelta + 1; 
    end 
    plot(colPos, rowPos, 'g*'); 
    width = leftDelta + rightDelta; 
    if (width > 45)
        rowPos = rowPos - 5; %bring cursor up by five 
    else 
        xDisplacement = round((rightDelta - leftDelta)/2); 
        colPos = colPos + xDisplacement; 
        rowPos = rowPos - 5; 
    end 
    if (Iout(rowPos, colPos) == true) 
        plot(colPos, rowPos, 'r*'); 
        %colPos
        %rowPos
    end 
end 

end
















