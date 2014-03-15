function outputImg = findStemBase(inputImg, showViz)
% Function determines the stem in a daylight sunflower video frame
if nargin < 2
    showViz = false;
end

%% Edge Test
[~, threshold] = edge(inputImg, 'sobel');
fudgeFactor = .5;
BWs = edge(inputImg,'sobel', threshold * fudgeFactor);
%, 
if (showViz)
    figure, imshow(BWs), title('binary gradient mask');
    title('sobel edge detection filter');
end

se0 = strel('line', 5, 0);
se90 = strel('line', 10, 90);

BWsdil = imdilate(BWs, strel('diamond', 4));
%BWsdil = imdilate(BWsdil, strel('line', 3, 0));

if (showViz)
     figure, imshow(BWsdil), title('dilated gradient mask');
end

reverseBWsdil = ~BWsdil;

IL = bwlabel(reverseBWsdil);
R = regionprops(reverseBWsdil,'Area', 'centroid');
ind = find([R.Area] >= 1500);
Iout = ismember(IL,ind);

if (showViz)
    imshow(Iout); title('blob removed');
end

B = imclose(Iout, se0);
B = imclose(B, se90);

if (showViz)
    figure; imshow(B); title('open result');
end

outputImg = B;
end