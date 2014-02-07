%% Load folder of images
dbstop if error
numOfImages = 260;
folder_path = 'C:\Users\anish\Documents\MATLAB\002C\';
file_base = 'HUNT';
file_ext = '.JPG';
file_path = strcat(folder_path, file_base);
height = 1080; width = 1920;
vidFrames = zeros(height, width, numOfImages, 'uint8');

for n=1:1:numOfImages
    file_name = strcat(file_path, sprintf('%04d',n));
    file_name = strcat(file_name, file_ext);
    vidFrames(:, :, n) = rgb2gray(imread(file_name));
end

%% Crop Video
startCol = 300;
endCol = 1712;
startRow = 1;
endRow = 990;
croppedFrames = zeros(endRow - startRow, endCol - startCol, ...
    length(vidFrames(1, 1, :)), 'uint8');

for n=1:length(vidFrames(1, 1, :))
    croppedFrames(:, :, n) = vidFrames(startRow:(endRow - 1), startCol:(endCol - 1) , n);
end

clear vidFrames;