%% Green Intensity in Video Detector
% Stand-alone file
% This file reads a folder of images, and determines which frames were shot
% during the day and which frames were shot at night using an infrared cam

% The following are use case specific parameters
dbstop if error
numOfImages = 100;
folder_path = 'C:\Users\anish\Documents\MATLAB\002C\';
file_base = 'HUNT';
file_ext = '.JPG';
file_path = strcat(folder_path, file_base);
height = 1080; width = 1920;


rgbArray = zeros(3, numOfImages);

for n=1:1:numOfImages
    file_name = strcat(file_path, sprintf('%04d',n));
    file_name = strcat(file_name, file_ext);
    
    rgbImg = imread(file_name);
    
    rgbArray(1, n) = mean(mean(rgbImg(:, :, 1)));
    rgbArray(2, n) = mean(mean(rgbImg(:, :, 2)));
    rgbArray(3, n) = mean(mean(rgbImg(:, :, 3)));
    
end

%% Plot Data
figure; 
plot(rgbArray(2, :)', 'b*')
title('Green Intensities over time in RGB Space')
xlabel('Frame Number')
ylabel('Color Intensity from 0 to 255')
hold on;
greenMean = mean(rgbArray(2, :));
x=[0 numOfImages];
y=[greenMean greenMean];
plot(x, y, 'r')

[idx ctrs] = kmeans(rgbArray(2, :), 2);
figure; plot(idx)
ylim([0.8 2.2])
title('kmeans result')

