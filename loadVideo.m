%% Read Video 
dbstop if error; 
vidObj = VideoReader('069C.mp4');

nFrames = vidObj.NumberOfFrames;
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
frameStart = 1;
frameEnd = 100; 
vidFrames = zeros(vidHeight, vidWidth, round(nFrames/4), 'uint8');
%vidFrames = zeros(vidHeight, vidWidth, round(nFrames/4), 'double');
i = 1; 
for k = 1:4:100
    
    vidFrames(:, :, i) = rgb2gray(read(vidObj,k)); 
    %tempHSV_Img = (read(vidObj,k));
    %vidFrames(:, :, i) = tempHSV_Img(:, :, 1); 
    i = i + 1; 
    if (mod(i, 10) == 0 ) 
        fprintf('Loading Frame %d\n', i); 
    end 
end

