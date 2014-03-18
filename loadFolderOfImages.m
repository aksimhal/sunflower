%% Load folder of images
dbstop if error
numOfImages = 250;
folder_path = 'C:\Users\anish\Documents\MATLAB\002C\';
file_base = 'HUNT';
file_ext = '.JPG';
file_path = strcat(folder_path, file_base);
height = 1080; width = 1920;
vidFrames = zeros(height, width, numOfImages, 'uint8');

%rgbArray = zeros(3, numOfImages);
%hsvArray = zeros(1, numOfImages);

for n=1:1:numOfImages
    file_name = strcat(file_path, sprintf('%04d',n));
    file_name = strcat(file_name, file_ext);
    
    rgbImg = imread(file_name);
    %hsvImg = rgb2hsv(rgbImg);
    
    %rgbArray(1, n) = mean(mean(rgbImg(:, :, 1)));
    %rgbArray(2, n) = mean(mean(rgbImg(:, :, 2)));
    %rgbArray(3, n) = mean(mean(rgbImg(:, :, 3)));
    
    %hsvArray(1, n) = mean(mean(hsvImg(:, :, 1))); 
    
    
    
    vidFrames(:, :, n) = rgb2gray(rgbImg);
end

%% Plot Data 
% plot(rgbArray(2, :)')
% title('Green Intensities over time in RGB Space')
% xlabel('Frame Number')
% ylabel('Color Intensity from 0 to 255')
% hold on; 
% greenMean = mean(rgbArray(2, :)); 
% x=[0 numOfImages];
% y=[greenMean greenMean];
% plot(x, y, 'r')
% 
% [idx ctrs] = kmeans(rgbArray(2, :), 2);
% figure; plot(idx)
% ylim([0.8 2.2])
% title('kmeans result')

%% Crop Video
startCol = 300+180;
endCol = 1712-200;
startRow = 1;
endRow = 990;
croppedFrames = zeros(endRow - startRow, endCol - startCol, ...
    length(vidFrames(1, 1, :)), 'uint8');

for n=1:length(vidFrames(1, 1, :))
    croppedFrames(:, :, n) = vidFrames(startRow:(endRow - 1), startCol:(endCol - 1) , n);
end

clear vidFrames;