%% Detect Stem
close all; 
inputArraySize = size(croppedFrames);
figure; 
for n = 3:1:inputArraySize(3)
    outputImg = findStemBase(croppedFrames(:, :, n), true); 
    imshow(outputImg); title(strcat('frame--', num2str(n))); 
    pause(1); 
end 